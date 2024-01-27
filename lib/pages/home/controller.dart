import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/tab_type.dart';
import 'package:pilipala/utils/storage.dart';
import '../../http/index.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  bool flag = false;
  late RxList tabs = [].obs;
  RxInt initialIndex = 1.obs;
  late TabController tabController;
  late List tabsCtrList;
  late List<Widget> tabsPageList;
  Box userInfoCache = GStrorage.userInfo;
  Box settingStorage = GStrorage.setting;
  RxBool userLogin = false.obs;
  RxString userFace = ''.obs;
  var userInfo;
  Box setting = GStrorage.setting;
  late final StreamController<bool> searchBarStream =
      StreamController<bool>.broadcast();
  late bool hideSearchBar;
  late List defaultTabs;
  late List<String> tabbarSort;
  RxString defaultSearch = ''.obs;

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfo != null;
    userFace.value = userInfo != null ? userInfo.face : '';
    // 进行tabs配置
    setTabConfig();
    hideSearchBar =
        setting.get(SettingBoxKey.hideSearchBar, defaultValue: true);
    if (setting.get(SettingBoxKey.enableSearchWord, defaultValue: true)) {
      searchDefault();
    }
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

  void setTabConfig() async {
    defaultTabs = tabsConfig;
    tabbarSort = settingStorage.get(SettingBoxKey.tabbarSort,
        defaultValue: ['live', 'rcmd', 'hot', 'bangumi']);

    tabs.value = defaultTabs
        .where((i) => tabbarSort.contains((i['type'] as TabType).id))
        .toList();

    if (tabbarSort.contains(TabType.rcmd.id)) {
      initialIndex.value = tabbarSort.indexOf(TabType.rcmd.id);
    } else {
      initialIndex.value = 0;
    }
    tabsCtrList = tabs.map((e) => e['ctr']).toList();
    tabsPageList = tabs.map<Widget>((e) => e['page']).toList();

    tabController = TabController(
      initialIndex: initialIndex.value,
      length: tabs.length,
      vsync: this,
    );
    // 监听 tabController 切换
    tabController.animation!.addListener(() {
      if (tabController.indexIsChanging) {
        if (initialIndex.value != tabController.index) {
          initialIndex.value = tabController.index;
        }
      } else {
        final int temp = tabController.animation!.value.round();
        if (initialIndex.value != temp) {
          initialIndex.value = temp;
          tabController.index = initialIndex.value;
        }
      }
    });
  }

  void searchDefault() async {
    var res = await Request().get(Api.searchDefault);
    if (res.data['code'] == 0) {
      defaultSearch.value = res.data['data']['name'];
    }
  }
}
