import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/tab_type.dart';
import 'package:pilipala/utils/storage.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  bool flag = false;
  late List tabs;
  RxInt initialIndex = 1.obs;
  late TabController tabController;
  late List tabsCtrList;
  late List<Widget> tabsPageList;
  Box userInfoCache = GStrorage.userInfo;
  RxBool userLogin = false.obs;
  RxString userFace = ''.obs;
  var userInfo;
  Box setting = GStrorage.setting;
  late final StreamController<bool> searchBarStream =
      StreamController<bool>.broadcast();
  late bool hideSearchBar;

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfo != null;
    userFace.value = userInfo != null ? userInfo.face : '';

    // 进行tabs配置
    tabs = tabsConfig;
    tabsCtrList = tabsConfig.map((e) => e['ctr']).toList();
    tabsPageList = tabsConfig.map<Widget>((e) => e['page']).toList();

    tabController = TabController(
      initialIndex: initialIndex.value,
      length: tabs.length,
      vsync: this,
    );
    hideSearchBar =
        setting.get(SettingBoxKey.hideSearchBar, defaultValue: true);
  }

  void onRefresh() {
    int index = tabController.index;
    var ctr = tabsCtrList[index];
    ctr().onRefresh();
  }

  void animateToTop() {
    int index = tabController.index;
    var ctr = tabsCtrList[index];
    ctr().animateToTop();
  }

  // 更新登录状态
  void updateLoginStatus(val) async {
    userInfo = await userInfoCache.get('userInfoCache');
    userLogin.value = val ?? false;
    if (val) return;
    userFace.value = userInfo != null ? userInfo.face : '';
  }
}
