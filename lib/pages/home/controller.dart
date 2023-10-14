import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/black.dart';
import 'package:pilipala/models/common/tab_type.dart';
import 'package:pilipala/models/user/black.dart';
import 'package:pilipala/utils/storage.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  bool flag = false;
  late List tabs;
  int initialIndex = 1;
  late TabController tabController;
  late List tabsCtrList;
  late List<Widget> tabsPageList;
  Box userInfoCache = GStrorage.userInfo;
  RxBool userLogin = false.obs;
  RxString userFace = ''.obs;
  var userInfo;
  static Box setting = GStrorage.setting;
  late List<int> blackMidsList;

  int currentPage = 1;
  int pageSize = 50;
  int total = 0;
  List<BlackListItem> blackList = [BlackListItem()];

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
      initialIndex: initialIndex,
      length: tabs.length,
      vsync: this,
    );
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
    if (val) {
      // 获取黑名单
      await queryBlacklist();
      blackMidsList = blackList.map<int>((e) => e.mid!).toList();
      setting.put(SettingBoxKey.blackMidsList, blackMidsList);
      return;
    }
    userFace.value = userInfo != null ? userInfo.face : '';
  }

  Future queryBlacklist({type = 'init'}) async {
    if (type == 'init') {
      currentPage = 1;
    }
    var result = await BlackHttp.blackList(pn: currentPage, ps: pageSize);
    if (result['status']) {
      if (type == 'init') {
        blackList = result['data'].list;
        total = result['data'].total;
      } else {
        blackList.addAll(result['data'].list);
      }
      currentPage += 1;
      if (blackList.length < total) {
        await queryBlacklist(type: 'onLoad');
      }
    }
    return result;
  }
}
