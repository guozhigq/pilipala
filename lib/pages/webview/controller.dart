import 'package:get/get.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/utils/event_bus.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/login.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewController extends GetxController {
  String url = '';
  RxString type = ''.obs;
  String pageTitle = '';
  final WebViewController controller = WebViewController();
  RxInt loadProgress = 0.obs;
  RxBool loadShow = true.obs;
  EventBus eventBus = EventBus();

  @override
  void onInit() {
    super.onInit();
    url = Get.parameters['url']!;
    type.value = Get.parameters['type']!;
    pageTitle = Get.parameters['pageTitle']!;

    if (type.value == 'login') {
      controller.clearCache();
      controller.clearLocalStorage();
      WebViewCookieManager().clearCookies();
    }
    webviewInit();
  }

  webviewInit() {
    controller
      ..setUserAgent(Request().headerUa())
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // 页面加载
          onProgress: (int progress) {
            // Update loading bar.
            loadProgress.value = progress;
          },
          onPageStarted: (String url) {
            final List pathSegments = Uri.parse(url).pathSegments;
            if (pathSegments.isNotEmpty &&
                url != 'https://passport.bilibili.com/h5-app/passport/login') {
              final String str = pathSegments[0];
              final Map matchRes = IdUtils.matchAvorBv(input: str);
              final List matchKeys = matchRes.keys.toList();
              if (matchKeys.isNotEmpty) {
                if (matchKeys.first == 'BV') {
                  Get.offAndToNamed(
                    '/searchResult',
                    parameters: {'keyword': matchRes['BV']},
                  );
                }
              }
            }
          },
          // 加载完成
          onUrlChange: (UrlChange urlChange) async {
            loadShow.value = false;
            String url = urlChange.url ?? '';
            if (type.value == 'login' &&
                (url.startsWith(
                        'https://passport.bilibili.com/web/sso/exchange_cookie') ||
                    url.startsWith('https://m.bilibili.com/'))) {
              LoginUtils.confirmLogin(url, controller);
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('bilibili://')) {
              if (request.url.startsWith('bilibili://video/')) {
                String str = Uri.parse(request.url).pathSegments[0];
                Get.offAndToNamed(
                  '/searchResult',
                  parameters: {'keyword': str},
                );
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }
}
