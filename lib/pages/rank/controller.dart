import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/rank_type.dart';
import 'package:pilipala/pages/rank/zone/index.dart';
import 'package:pilipala/utils/storage.dart';

class RankController extends GetxController with GetTickerProviderStateMixin {
  bool flag = false;
  late RxList tabs = [].obs;
  RxInt initialIndex = 0.obs;
  late TabController tabController;
  late List tabsCtrList;
  late List<Widget> tabsPageList;
  Box setting = GStorage.setting;
  late final StreamController<bool> searchBarStream =
      StreamController<bool>.broadcast();

  @override
  void onInit() {
    super.onInit();
    // 进行tabs配置
    setTabConfig();
  }

  void onRefresh() {
    int index = tabController.index;
    final ZoneController ctr = tabsCtrList[index];
    ctr.onRefresh();
  }

  void animateToTop() {
    int index = tabController.index;
    final ZoneController ctr = tabsCtrList[index];
    ctr.animateToTop();
  }

  void setTabConfig() async {
    tabs.value = tabsConfig;
    initialIndex.value = 0;
    tabsCtrList = tabs
        .map((e) => Get.put(ZoneController(), tag: e['rid'].toString()))
        .toList();
    tabsPageList = tabs.map<Widget>((e) => e['page']).toList();

    tabController = TabController(
      initialIndex: initialIndex.value,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void onClose() {
    searchBarStream.close();
    super.onClose();
  }
}
