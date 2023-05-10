import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/home/view.dart';
import 'package:pilipala/pages/hot/view.dart';
import 'package:pilipala/pages/media/index.dart';
import 'package:pilipala/utils/storage.dart';

class MainController extends GetxController {
  List<Widget> pages = <Widget>[
    const HomePage(),
    const HotPage(),
    const MediaPage(),
  ];
  RxList navigationBars = [
    {
      // 'icon': const Icon(Icons.home_outlined),
      // 'selectedIcon': const Icon(Icons.home),
      'icon': const Icon(
        CupertinoIcons.square_favorites_alt,
        size: 21,
      ),
      'selectedIcon': const Icon(
        CupertinoIcons.square_favorites_alt_fill,
        size: 21,
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
    // {
    //   'icon': const Icon(
    //     CupertinoIcons.person,
    //     size: 21,
    //   ),
    //   'selectedIcon': const Icon(
    //     CupertinoIcons.person_fill,
    //     size: 21,
    //   ),
    //   'label': "我的",
    // },
    {
      // 'icon': const Icon(Icons.person_outline),
      // 'selectedIcon': const Icon(Icons.person),
      'icon': const Icon(
        CupertinoIcons.tray_full,
        size: 21,
      ),
      'selectedIcon': const Icon(
        CupertinoIcons.tray_full_fill,
        size: 21,
      ),
      'label': "媒体库",
    }
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // readuUserFace();
  }

  // 设置头像
  // readuUserFace() async {
  //   Box user = GStrorage.user;
  //   if (user.get(UserBoxKey.userFace) != null) {
  //     navigationBars.last['icon'] =
  //         navigationBars.last['selectedIcon'] = NetworkImgLayer(
  //       width: 25,
  //       height: 25,
  //       type: 'avatar',
  //       src: user.get(UserBoxKey.userFace),
  //     );
  //     navigationBars.last['label'] = '我';
  //   }
  // }

  // 重置
  // resetLast() {
  //   navigationBars.last['icon'] = const Icon(Icons.person_outline);
  //   navigationBars.last['selectedIcon'] = const Icon(Icons.person);
  //   navigationBars.last['label'] = '我的';
  // }
}
