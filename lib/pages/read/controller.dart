import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/read.dart';
import 'package:pilipala/models/read/read.dart';
import 'package:pilipala/plugin/pl_gallery/hero_dialog_route.dart';
import 'package:pilipala/plugin/pl_gallery/interactiveviewer_gallery.dart';

class ReadPageController extends GetxController {
  late String url;
  RxString title = ''.obs;
  late String id;
  late String articleType;
  Rx<ReadDataModel> cvData = ReadDataModel().obs;
  final ScrollController scrollController = ScrollController();
  late StreamController<bool> appbarStream = StreamController<bool>.broadcast();

  @override
  void onInit() {
    super.onInit();
    title.value = Get.parameters['title'] ?? '';
    id = Get.parameters['id']!;
    articleType = Get.parameters['articleType']!;
    scrollController.addListener(_scrollListener);
  }

  Future fetchCvData() async {
    var res = await ReadHttp.parseArticleCv(id: id);
    if (res['status']) {
      cvData.value = res['data'];
      title.value = cvData.value.readInfo!.title!;
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

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    appbarStream.close();
    super.onClose();
  }
}
