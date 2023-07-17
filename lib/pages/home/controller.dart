import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/hot/index.dart';
import 'package:pilipala/pages/live/index.dart';
import 'package:pilipala/pages/rcmd/index.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  bool flag = false;
  List tabs = [
    {
      'icon': const Icon(
        Icons.live_tv_outlined,
        size: 15,
      ),
      'label': '直播',
      'type': 'live'
    },
    {
      'icon': const Icon(
        Icons.thumb_up_off_alt_outlined,
        size: 15,
      ),
      'label': '推荐',
      'type': 'rcm'
    },
    {
      'icon': const Icon(
        Icons.whatshot_outlined,
        size: 15,
      ),
      'label': '热门',
      'type': 'hot'
    },
  ];
  int initialIndex = 1;
  late TabController tabController;
  List ctrList = [
    Get.find<LiveController>,
    Get.find<RcmdController>,
    Get.find<HotController>,
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      initialIndex: initialIndex,
      length: tabs.length,
      vsync: this,
    );
  }

  void onRefresh() {
    int index = tabController.index;
    var ctr = ctrList[index];
    ctr().onRefresh();
  }

  void animateToTop() {
    int index = tabController.index;
    var ctr = ctrList[index];
    ctr().animateToTop();
  }
}
