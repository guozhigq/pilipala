import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/live.dart';
import 'package:pilipala/models/live/item.dart';

class LiveController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int count = 12;
  int _currentPage = 1;
  int crossAxisCount = 2;
  RxList<LiveItemModel> liveList = [LiveItemModel()].obs;
  bool isLoadingMore = false;
  bool flag = false;
  OverlayEntry? popupDialog;

  // 获取推荐
  Future queryLiveList(type) async {
    if (type == 'init') {
      _currentPage = 1;
    }
    var res = await LiveHttp.liveList(
      pn: _currentPage,
    );
    if (res['status']) {
      if (type == 'init') {
        liveList.value = res['data'];
      } else if (type == 'onLoad') {
        liveList.addAll(res['data']);
      }
      _currentPage += 1;
    }
    isLoadingMore = false;
    return res;
  }

  // 下拉刷新
  Future onRefresh() async {
    queryLiveList('init');
  }

  // 上拉加载
  Future onLoad() async {
    queryLiveList('onLoad');
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
