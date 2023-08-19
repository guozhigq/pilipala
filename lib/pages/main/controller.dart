import 'dart:async';

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

  @override
  void onInit() {
    super.onInit();
    if (setting.get(SettingBoxKey.autoUpdate, defaultValue: false)) {
      Utils.checkUpdata();
    }
  }
}
