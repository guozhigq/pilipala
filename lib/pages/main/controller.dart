import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/home/view.dart';
import 'package:pilipala/pages/hot/view.dart';
import 'package:pilipala/pages/media/index.dart';
import 'package:pilipala/pages/mine/index.dart';
import 'package:pilipala/utils/storage.dart';

class MainController extends GetxController {
  List<Widget> pages = <Widget>[
    const HomePage(),
    const HotPage(),
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
        Icons.eco,
        size: 20,
      ),
      'label': "热门",
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
}
