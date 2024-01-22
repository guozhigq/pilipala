import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/common.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/home/view.dart';
import 'package:pilipala/pages/media/index.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/utils.dart';

class MainController extends GetxController {
  List<Widget> pages = <Widget>[
    const HomePage(),
    const DynamicsPage(),
    const MediaPage(),
  ];
  RxList navigationBars = [
    {
      'icon': const Icon(
        Icons.home_outlined,
        size: 21,
      ),
      'selectIcon': const Icon(
        Icons.home,
        size: 21,
      ),
      'label': "首页",
      'count': 0,
    },
    {
      'icon': const Icon(
        Icons.motion_photos_on_outlined,
        size: 21,
      ),
      'selectIcon': const Icon(
        Icons.motion_photos_on,
        size: 21,
      ),
      'label': "动态",
      'count': 0,
    },
    {
      'icon': const Icon(
        Icons.video_collection_outlined,
        size: 20,
      ),
      'selectIcon': const Icon(
        Icons.video_collection,
        size: 21,
      ),
      'label': "媒体库",
      'count': 0,
    }
  ].obs;
  final StreamController<bool> bottomBarStream =
      StreamController<bool>.broadcast();
  Box setting = GStrorage.setting;
  DateTime? _lastPressedAt;
  late bool hideTabBar;
  late PageController pageController;
  int selectedIndex = 0;
  Box userInfoCache = GStrorage.userInfo;
  RxBool userLogin = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (setting.get(SettingBoxKey.autoUpdate, defaultValue: false)) {
      Utils.checkUpdata();
    }
    hideTabBar = setting.get(SettingBoxKey.hideTabBar, defaultValue: true);
    var userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfo != null;
    getUnreadDynamic();
  }

  void onBackPressed(BuildContext context) {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) >
            const Duration(seconds: 2)) {
      // 两次点击时间间隔超过2秒，重新记录时间戳
      _lastPressedAt = DateTime.now();
      if (selectedIndex != 0) {
        pageController.jumpTo(0);
      }
      SmartDialog.showToast("再按一次退出Pili");
      return; // 不退出应用
    }
    SystemNavigator.pop(); // 退出应用
  }

  void getUnreadDynamic() async {
    if (!userLogin.value) {
      return;
    }
    int dynamicItemIndex =
        navigationBars.indexWhere((item) => item['label'] == "动态");
    var res = await CommonHttp.unReadDynamic();
    var data = res['data'];
    if (dynamicItemIndex != -1) {
      navigationBars[dynamicItemIndex]['count'] =
          data == null ? 0 : data.length; // 修改 count 属性为新的值
    }
    navigationBars.refresh();
  }

  void clearUnread() async {
    int dynamicItemIndex =
        navigationBars.indexWhere((item) => item['label'] == "动态");
    if (dynamicItemIndex != -1) {
      navigationBars[dynamicItemIndex]['count'] = 0; // 修改 count 属性为新的值
    }
    navigationBars.refresh();
  }
}
