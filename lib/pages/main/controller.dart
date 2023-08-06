import 'dart:async';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/home/view.dart';
import 'package:pilipala/pages/media/index.dart';

class MainController extends GetxController {
  List<Widget> pages = <Widget>[
    const HomePage(),
    const DynamicsPage(),
    const MediaPage(),
  ];
  RxList navigationBars = [
    {
      'icon': const Icon(
        Icons.motion_photos_on_outlined,
        size: 21,
      ),
      'label': "推荐",
    },
    {
      'icon': const Icon(
        Icons.bolt,
        size: 21,
      ),
      'label': "动态",
    },
    {
      'icon': const Icon(
        Icons.folder_open_outlined,
        size: 20,
      ),
      'label': "媒体库",
    }
  ].obs;
  final StreamController<bool> bottomBarStream = StreamController<bool>();
}
