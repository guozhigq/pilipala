import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/pages/home/view.dart';
import 'package:pilipala/pages/hot/view.dart';
import 'package:pilipala/pages/mine/view.dart';

class MainController extends GetxController {
  List<Widget> pages = <Widget>[
    const HomePage(),
    const HotPage(),
    const MinePage(),
  ];
  List navigationBars = [
    {
      // 'icon': const Icon(Icons.home_outlined),
      // 'selectedIcon': const Icon(Icons.home),
      'icon': const Icon(
        CupertinoIcons.house,
        size: 18,
      ),
      'selectedIcon': const Icon(
        CupertinoIcons.house_fill,
        size: 18,
      ),
      'label': "推荐",
    },
    {
      // 'icon': const Icon(Icons.whatshot_outlined),
      // 'selectedIcon': const Icon(Icons.whatshot_rounded),
      'icon': const Icon(
        CupertinoIcons.flame,
        size: 20,
      ),
      'selectedIcon': const Icon(
        CupertinoIcons.flame_fill,
        size: 20,
      ),
      'label': "热门",
    },
    {
      // 'icon': const Icon(Icons.person_outline),
      // 'selectedIcon': const Icon(Icons.person),
      'icon': const Icon(
        CupertinoIcons.person,
        size: 21,
      ),
      'selectedIcon': const Icon(
        CupertinoIcons.person_fill,
        size: 21,
      ),
      'label': "我的",
    }
  ];
}
