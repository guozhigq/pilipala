import 'dart:async';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
        Icons.favorite_outline,
        size: 21,
      ),
      'selectIcon': const Icon(
        Icons.favorite,
        size: 21,
      ),
      'label': "首页",
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
    },
    {
      'icon': const Icon(
        Icons.folder_outlined,
        size: 20,
      ),
      'selectIcon': const Icon(
        Icons.folder,
        size: 21,
      ),
      'label': "媒体库",
    }
  ].obs;
  final StreamController<bool> bottomBarStream =
      StreamController<bool>.broadcast();
  Box setting = GStrorage.setting;
  DateTime? _lastPressedAt;
  late bool hideTabBar;

  @override
  void onInit() {
    super.onInit();
    if (setting.get(SettingBoxKey.autoUpdate, defaultValue: false)) {
      Utils.checkUpdata();
    }
    hideTabBar = setting.get(SettingBoxKey.hideTabBar, defaultValue: true);
  }

  Future<bool> onBackPressed(BuildContext context) {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) >
            const Duration(seconds: 2)) {
      // 两次点击时间间隔超过2秒，重新记录时间戳
      _lastPressedAt = DateTime.now();
      SmartDialog.showToast("再按一次退出Pili");
      return Future.value(false); // 不退出应用
    }
    return Future.value(true); // 退出应用
  }
}
