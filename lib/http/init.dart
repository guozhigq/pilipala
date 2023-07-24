// ignore_for_file: avoid_print
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/interceptor.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class Request {
  static final Request _instance = Request._internal();
  static late CookieManager cookieManager;

  factory Request() => _instance;

  static Dio dio = Dio()
    ..httpClientAdapter = Http2Adapter(
      ConnectionManager(
        idleTimeout: const Duration(milliseconds: 10000),
        // Ignore bad certificate
        onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
      ),
    );

  /// 设置cookie
  static setCookie() async {
    var cookiePath = await Utils.getCookiePath();
    var cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(cookiePath),
    );
    cookieManager = CookieManager(cookieJar);
    dio.interceptors.add(cookieManager);
    var cookie = await cookieManager.cookieJar
        .loadForRequest(Uri.parse(HttpString.baseUrl));
    var cookie2 = await cookieManager.cookieJar
        .loadForRequest(Uri.parse(HttpString.tUrl));
    if (cookie.isEmpty) {
      try {
        await Request().get(HttpString.baseUrl);
      } catch (e) {
        log("setCookie, ${e.toString()}");
      }
    }
    if (cookie2.isEmpty) {
      try {
        await Request().get(HttpString.tUrl);
      } catch (e) {
        log("setCookie, ${e.toString()}");
      }
    }
  }

  // 移除cookie
  static removeCookie() async {
    await cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.baseUrl), []);
    await cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.baseApiUrl), []);
    cookieManager.cookieJar.deleteAll();
    dio.interceptors.add(cookieManager);
  }

  // 从cookie中获取 csrf token
  static Future<String> getCsrf() async {
    var cookies = await cookieManager.cookieJar
        .loadForRequest(Uri.parse(HttpString.baseApiUrl));
    // for (var i in cookies) {
    //   print(i);
    // }
    String token = '';
    if (cookies.where((e) => e.name == 'bili_jct').isNotEmpty) {
      token = cookies.firstWhere((e) => e.name == 'bili_jct').value;
    }
    return token;
  }

  /*
   * config it and create
   */
  Request._internal() {
    //BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = BaseOptions(
      //请求基地址,可以包含子路径
      baseUrl: HttpString.baseApiUrl,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: const Duration(milliseconds: 12000),
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: const Duration(milliseconds: 12000),
      //Http请求头.
      headers: {
        // 'cookie': '',
        "env": 'prod',
        "app-key": 'android',
        "x-bili-aurora-eid": 'UlMFQVcABlAH',
        "x-bili-aurora-zone": 'sh001',
        'referer': 'https://www.bilibili.com/',
      },
    );

    Box user = GStrorage.user;
    if (user.get(UserBoxKey.userMid) != null) {
      options.headers['x-bili-mid'] = user.get(UserBoxKey.userMid).toString();
    }
    dio.options = options;
    //添加拦截器
    dio.interceptors
      ..add(ApiInterceptor())
      // 日志拦截器 输出请求、响应内容
      ..add(LogInterceptor(
        request: false,
        requestHeader: false,
        responseHeader: false,
      ));
    dio.transformer = BackgroundTransformer();
    dio.options.validateStatus = (status) {
      return status! >= 200 && status < 300 || status == 304 || status == 302;
    };
  }

  /*
   * get请求
   */
  get(url, {data, cacheOptions, options, cancelToken, extra}) async {
    Response response;
    Options options;
    String ua = 'pc';
    ResponseType resType = ResponseType.json;
    if (extra != null) {
      ua = extra!['ua'] ?? 'pc';
      resType = extra!['resType'] ?? ResponseType.json;
    }
    if (cacheOptions != null) {
      cacheOptions.headers = {'user-agent': headerUa(ua)};
      options = cacheOptions;
    } else {
      options = Options();
      options.headers = {'user-agent': headerUa(ua)};
      options.responseType = resType;
    }
    try {
      response = await dio.get(
        url,
        queryParameters: data,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (e) {
      print('get error: $e');
      return Future.error(await ApiInterceptor.dioError(e));
    }
  }

  /*
   * post请求
   */
  post(url, {data, queryParameters, options, cancelToken, extra}) async {
    print('post-data: $data');
    Response response;
    try {
      response = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      print('post success: ${response.data}');
      return response;
    } on DioError catch (e) {
      print('post error: $e');
      return Future.error(await ApiInterceptor.dioError(e));
    }
  }

  /*
   * 下载文件
   */
  downloadFile(urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
        //进度
        // print("$count $total");
      });
      print('downloadFile success: ${response.data}');

      return response.data;
    } on DioError catch (e) {
      print('downloadFile error: $e');
      return Future.error(ApiInterceptor.dioError(e));
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  String headerUa(ua) {
    String headerUa = '';
    if (ua == 'mob') {
      headerUa = Platform.isIOS
          ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1'
          : 'Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.91 Mobile Safari/537.36';
    } else {
      headerUa =
          'Mozilla/5.0 (MaciMozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36';
    }
    return headerUa;
  }
}
