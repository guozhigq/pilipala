import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  final WebviewController _webviewController = Get.put(WebviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          title: Text(
            _webviewController.pageTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _webviewController.controller.reload();
              },
              child: const Text('刷新'),
            ),
            Obx(
              () => _webviewController.type.value == 'login'
                  ? TextButton(
                      onPressed: () => _webviewController.confirmLogin(null),
                      child: const Text('刷新登录状态'),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(width: 10)
          ],
        ),
        body: Column(
          children: [
            Obx(
              () => AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 350),
                height: _webviewController.loadShow.value ? 4 : 0,
                child: LinearProgressIndicator(
                  key: ValueKey(_webviewController.loadProgress),
                  value: _webviewController.loadProgress / 100,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.onInverseSurface,
              padding:
                  const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
              child: const Text('登录成功未自动跳转?  请点击右上角「刷新登录状态」'),
            ),
            Expanded(
              child: WebViewWidget(controller: _webviewController.controller),
            ),
          ],
        ));
  }
}
