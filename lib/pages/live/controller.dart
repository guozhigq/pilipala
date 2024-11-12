import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/live.dart';
import 'package:pilipala/models/live/follow.dart';
import 'package:pilipala/models/live/item.dart';
import 'package:pilipala/utils/storage.dart';

class LiveController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int count = 12;
  int _currentPage = 1;
  RxInt crossAxisCount = 2.obs;
  RxList<LiveItemModel> liveList = <LiveItemModel>[].obs;
  RxList<LiveFollowingItemModel> liveFollowingList =
      <LiveFollowingItemModel>[].obs;
  RxInt liveFollowingCount = 0.obs;
  bool flag = false;
  OverlayEntry? popupDialog;
  Box setting = GStorage.setting;

  @override
  void onInit() {
    super.onInit();
    crossAxisCount.value =
        setting.get(SettingBoxKey.customRows, defaultValue: 2);
  }

  // 获取推荐
  Future queryLiveList(type) async {
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
    return res;
  }

  // 下拉刷新
  Future onRefresh() async {
    queryLiveList('init');
    fetchLiveFollowing();
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

  //
  Future fetchLiveFollowing() async {
    var res = await LiveHttp.liveFollowing(pn: 1, ps: 10);
    if (res['status']) {
      liveFollowingList.value =
          (res['data'].list as List<LiveFollowingItemModel>)
              .where((LiveFollowingItemModel item) =>
                  item.liveStatus == 1 && item.recordLiveTime == 0) // 根据条件过滤
              .toList();
      liveFollowingCount.value = res['data'].liveCount;
    }
    return res;
  }
}
