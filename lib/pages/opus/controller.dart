import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/read.dart';
import 'package:pilipala/models/read/opus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pilipala/plugin/pl_gallery/hero_dialog_route.dart';
import 'package:pilipala/plugin/pl_gallery/interactiveviewer_gallery.dart';

class OpusController extends GetxController {
  late String url;
  RxString title = ''.obs;
  late String id;
  late String articleType;
  Rx<OpusDataModel> opusData = OpusDataModel().obs;
  final ScrollController scrollController = ScrollController();
  late StreamController<bool> appbarStream = StreamController<bool>.broadcast();

  @override
  void onInit() {
    super.onInit();
    title.value = Get.parameters['title'] ?? '';
    id = Get.parameters['id']!;
    articleType = Get.parameters['articleType']!;
    if (articleType == 'opus') {
      url = 'https://www.bilibili.com/opus/$id';
    }
    scrollController.addListener(_scrollListener);
  }

  Future fetchOpusData() async {
    var res = await ReadHttp.parseArticleOpus(id: id);
    if (res['status']) {
      List<String> keys = res.keys.toList();
      if (keys.contains('isCv') && res['isCv']) {
        Get.offNamed('/read', parameters: {
          'id': res['cvId'],
          'title': title.value,
          'articleType': 'cv',
        });
      } else {
        title.value = res['data'].detail!.basic!.title!;
        opusData.value = res['data'];
      }
    }
    return res;
  }

  void _scrollListener() {
    final double offset = scrollController.position.pixels;
    if (offset > 100) {
      appbarStream.add(true);
    } else {
      appbarStream.add(false);
    }
  }

  void onPreviewImg(picList, initIndex, context) {
    Navigator.of(context).push(
      HeroDialogRoute<void>(
        builder: (BuildContext context) => InteractiveviewerGallery(
          sources: picList,
          initIndex: initIndex,
          itemBuilder: (
            BuildContext context,
            int index,
            bool isFocus,
            bool enablePageView,
          ) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (enablePageView) {
                  Navigator.of(context).pop();
                }
              },
              child: Center(
                child: Hero(
                  tag: picList[index],
                  child: CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 0),
                    imageUrl: picList[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
          onPageChanged: (int pageIndex) {},
        ),
      ),
    );
  }

  // 跳转webview
  void onJumpWebview() {
    Get.toNamed('/webview', parameters: {
      'url': url,
      'type': 'webview',
      'pageTitle': title.value,
    });
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    appbarStream.close();
    super.onClose();
  }
}
