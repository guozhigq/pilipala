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
      'icon': const Icon(Icons.home_outlined),
      'selectedIcon': const Icon(Icons.home),
      'label': "推荐",
    },
    {
      'icon': const Icon(Icons.whatshot_outlined),
      'selectedIcon': const Icon(Icons.whatshot_rounded),
      'label': "热门",
    },
    {
      'icon': const Icon(Icons.person_outline),
      'selectedIcon': const Icon(Icons.person),
      'label': "我的",
    }
  ];
}
