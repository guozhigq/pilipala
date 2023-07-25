import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// import 'package:get/get.dart' hide Response;

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
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理网络请求错误
    // handler.next(err);
    SmartDialog.showToast(await dioError(err));
    super.onError(err, handler);
  }

  static Future dioError(DioException error) async {
    switch (error.type) {
      case DioExceptionType.badCertificate:
        return '证书有误！';
      case DioExceptionType.badResponse:
        return '服务器异常，请稍后重试！';
      case DioExceptionType.cancel:
        return "请求已被取消，请重新请求";
      case DioExceptionType.connectionError:
        return '连接错误，请检查网络设置';
      case DioExceptionType.connectionTimeout:
        return "网络连接超时，请检查网络设置";
      case DioExceptionType.receiveTimeout:
        return "响应超时，请稍后重试！";
      case DioExceptionType.sendTimeout:
        return "发送请求超时，请检查网络设置";
      case DioExceptionType.unknown:
        var res = await checkConect();
        return res + " \n 网络异常，请稍后重试！";
      default:
        return "Dio异常";
    }
  }

  static Future<dynamic> checkConect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return 'connected with mobile network';
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return 'connected with wifi network';
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
    } else if (connectivityResult == ConnectivityResult.vpn) {
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult == ConnectivityResult.other) {
      // I am connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult == ConnectivityResult.none) {
      return 'not connected to any network';
    }
  }
}
