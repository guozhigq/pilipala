import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/model_hot_video_item.dart';

class HotController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final int _count = 20;
  int _currentPage = 1;
  RxList<HotVideoItemModel> videoList = [HotVideoItemModel()].obs;
  bool isLoadingMore = false;
  bool flag = false;

  @override
  void onInit() {
    super.onInit();
    queryHotFeed('init');
  }

  // 获取推荐
  Future queryHotFeed(type) async {
    var res = await VideoHttp.hotVideoList({
      'pn': _currentPage,
      'ps': _count,
    });
    if (res['status']) {
      if (type == 'init') {
        videoList.value = res['data'];
      } else if (type == 'onRefresh') {
        videoList.insertAll(0, res['data']);
      } else if (type == 'onLoad') {
        videoList.addAll(res['data']);
      }
      _currentPage += 1;
    }
    isLoadingMore = false;
  }

  // 下拉刷新
  Future onRefresh() async {
    queryHotFeed('onRefresh');
  }

  // 上拉加载
  Future onLoad() async {
    queryHotFeed('onLoad');
  }

  // 返回顶部并刷新
  void animateToTop() async {
    if (scrollController.offset >=
        MediaQuery.of(Get.context!).size.height * 5) {
      scrollController.jumpTo(0);
    } else {
      await scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }
}
