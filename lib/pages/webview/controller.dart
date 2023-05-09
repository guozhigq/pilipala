import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/pages/mine/index.dart';
import 'package:pilipala/utils/cookie.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewController extends GetxController {
  String url = '';
  String type = '';
  String pageTitle = '';
  final WebViewController controller = WebViewController();

  @override
  void onInit() {
    super.onInit();
    url = Get.parameters['url']!;
    type = Get.parameters['type']!;
    pageTitle = Get.parameters['pageTitle']!;

    webviewInit();
  }

  webviewInit() {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // 页面加载
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          // 加载完成
          onPageFinished: (String url) async {
            if (url.startsWith(
                    'https://passport.bilibili.com/web/sso/exchange_cookie') ||
                url.startsWith('https://m.bilibili.com/')) {
              try {
                var cookies =
                    await WebviewCookieManager().getCookies(HttpString.baseUrl);
                var apiCookies =
                    await WebviewCookieManager().getCookies(HttpString.baseUrl);
                await SetCookie.onSet(cookies, HttpString.baseUrl);
                await SetCookie.onSet(apiCookies, HttpString.baseApiUrl);
                var result = await UserHttp.userInfo();
                if (result['status'] && result['data'].isLogin) {
                  SmartDialog.showToast('登录成功');
                  Get.find<MineController>().userInfo = result['data'];
                  // Get.back();
                }
              } catch (e) {
                print(e);
              }
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}
