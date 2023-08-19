// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/utils/cookie.dart';
import 'package:pilipala/utils/event_bus.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewController extends GetxController {
  String url = '';
  String type = '';
  String pageTitle = '';
  final WebViewController controller = WebViewController();
  RxInt loadProgress = 0.obs;
  RxBool loadShow = true.obs;
  EventBus eventBus = EventBus();

  @override
  void onInit() {
    super.onInit();
    url = Get.parameters['url']!;
    type = Get.parameters['type']!;
    pageTitle = Get.parameters['pageTitle']!;

    if (type == 'login') {
      controller.clearCache();
      controller.clearLocalStorage();
      WebViewCookieManager().clearCookies();
    }
    webviewInit();
  }

  webviewInit() {
    controller
      ..setUserAgent(Request().headerUa('mob'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // 页面加载
          onProgress: (int progress) {
            // Update loading bar.
            loadProgress.value = progress;
          },
          onPageStarted: (String url) {},
          // 加载完成
          onUrlChange: (UrlChange urlChange) async {
            loadShow.value = false;
            String url = urlChange.url ?? '';
            if (type == 'login' &&
                (url.startsWith(
                        'https://passport.bilibili.com/web/sso/exchange_cookie') ||
                    url.startsWith('https://m.bilibili.com/'))) {
              try {
                await SetCookie.onSet();
                var result = await UserHttp.userInfo();
                UserHttp.thirdLogin();
                print('网页登录： $result');
                if (result['status'] && result['data'].isLogin) {
                  SmartDialog.showToast('登录成功');
                  try {
                    Box user = GStrorage.user;
                    user.put(UserBoxKey.userLogin, true);
                    user.put(UserBoxKey.userName, result['data'].uname);
                    user.put(UserBoxKey.userFace, result['data'].face);
                    user.put(UserBoxKey.userMid, result['data'].mid);

                    Box userInfoCache = GStrorage.userInfo;
                    userInfoCache.put('userInfoCache', result['data']);

                    // 通知更新
                    eventBus.emit(EventName.loginEvent, {'status': true});

                    HomeController homeCtr = Get.find<HomeController>();
                    homeCtr.updateLoginStatus(true);
                  } catch (err) {
                    SmartDialog.show(builder: (context) {
                      return AlertDialog(
                        title: const Text('登录遇到问题'),
                        content: Text(err.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => controller.reload(),
                            child: const Text('确认'),
                          )
                        ],
                      );
                    });
                  }
                  Get.back();
                } else {
                  // 获取用户信息失败
                  SmartDialog.showToast(result.msg);
                }
              } catch (e) {
                print(e);
              }
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('bilibili://')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}
