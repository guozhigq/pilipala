import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/common/tab_type.dart';
import 'package:pilipala/utils/storage.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  bool flag = false;
  late List tabs;
  int initialIndex = 1;
  late TabController tabController;
  late List tabsCtrList;
  late List<Widget> tabsPageList;
  RxString defaultSearch = '输入关键词搜索'.obs;
  Box user = GStrorage.user;
  RxBool userLogin = false.obs;
  RxString userFace = ''.obs;

  @override
  void onInit() {
    super.onInit();

    searchDefault();
    userLogin.value = user.get(UserBoxKey.userLogin) ?? false;
    userFace.value = user.get(UserBoxKey.userFace) ?? '';

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

  void searchDefault() async {
    var res = await Request().get(Api.searchDefault);
    if (res.data['code'] == 0) {
      defaultSearch.value = res.data['data']['name'];
    }
  }

  // 更新登录状态
  void updateLoginStatus(val) {
    userLogin.value = val ?? false;
    userFace.value = user.get(UserBoxKey.userFace) ?? '';
  }
}
