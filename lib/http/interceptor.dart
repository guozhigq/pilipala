// ignore_for_file: avoid_print

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import '../utils/storage.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // print("请求之前");
    // 在请求之前添加头部或认证信息
    // options.headers['Authorization'] = 'Bearer token';
    // options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      if (response.statusCode == 302) {
        final List<String> locations = response.headers['location']!;
        if (locations.isNotEmpty) {
          if (locations.first.startsWith('https://www.mcbbs.net')) {
            final Uri uri = Uri.parse(locations.first);
            final String? accessKey = uri.queryParameters['access_key'];
            final String? mid = uri.queryParameters['mid'];
            try {
              Box localCache = GStrorage.localCache;
              localCache.put(LocalCacheKey.accessKey,
                  <String, String?>{'mid': mid, 'value': accessKey});
            } catch (_) {}
          }
        }
      }
    } catch (err) {
      print('ApiInterceptor: $err');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理网络请求错误
    // handler.next(err);
    String url = err.requestOptions.uri.toString();
    print('🌹🌹ApiInterceptor: $url');
    if (!url.contains('heartBeat')) {
      SmartDialog.showToast(
        await dioError(err),
        displayType: SmartToastType.onlyRefresh,
      );
    }
    super.onError(err, handler);
  }

  static Future<String> dioError(DioException error) async {
    switch (error.type) {
      case DioExceptionType.badCertificate:
        return '证书有误！';
      case DioExceptionType.badResponse:
        return '服务器异常，请稍后重试！';
      case DioExceptionType.cancel:
        return '请求已被取消，请重新请求';
      case DioExceptionType.connectionError:
        return '连接错误，请检查网络设置';
      case DioExceptionType.connectionTimeout:
        return '网络连接超时，请检查网络设置';
      case DioExceptionType.receiveTimeout:
        return '响应超时，请稍后重试！';
      case DioExceptionType.sendTimeout:
        return '发送请求超时，请检查网络设置';
      case DioExceptionType.unknown:
        final String res = await checkConnect();
        return '$res，网络异常！';
    }
  }

  static Future<String> checkConnect() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        return '正在使用移动流量';
      case ConnectivityResult.wifi:
        return '正在使用wifi';
      case ConnectivityResult.ethernet:
        return '正在使用局域网';
      case ConnectivityResult.vpn:
        return '正在使用代理网络';
      case ConnectivityResult.other:
        return '正在使用其他网络';
      case ConnectivityResult.none:
        return '未连接到任何网络';
      default:
        return '';
    }
  }
}
