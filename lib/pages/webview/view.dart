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
        title: Text(
          _webviewController.pageTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: WebViewWidget(controller: _webviewController.controller),
    );
  }
}
