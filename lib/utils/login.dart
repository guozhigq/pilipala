import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/media/index.dart';
import 'package:pilipala/pages/mine/index.dart';
import 'package:uuid/uuid.dart';

class LoginUtils {
  static Future refreshLoginStatus(bool status) async {
    try {
      // 更改我的页面登录状态
      await Get.find<MineController>().resetUserInfo();

      // 更改主页登录状态
      HomeController homeCtr = Get.find<HomeController>();
      homeCtr.updateLoginStatus(status);

      MineController mineCtr = Get.find<MineController>();
      mineCtr.userLogin.value = status;

      DynamicsController dynamicsCtr = Get.find<DynamicsController>();
      dynamicsCtr.userLogin.value = status;

      MediaController mediaCtr = Get.find<MediaController>();
      mediaCtr.userLogin.value = status;
    } catch (err) {
      SmartDialog.showToast('refreshLoginStatus error: ${err.toString()}');
    }
  }

  static String buvid() {
    var mac = <String>[];
    var random = Random();

    for (var i = 0; i < 6; i++) {
      var min = 0;
      var max = 0xff;
      var num = (random.nextInt(max - min + 1) + min).toRadixString(16);
      mac.add(num);
    }

    var md5Str = md5.convert(utf8.encode(mac.join(':'))).toString();
    var md5Arr = md5Str.split('');
    return 'XY${md5Arr[2]}${md5Arr[12]}${md5Arr[22]}$md5Str';
  }

  static String getUUID() {
    return const Uuid().v4().replaceAll('-', '');
  }

  static String generateBuvid() {
    String uuid = getUUID() + getUUID();
    return 'XY${uuid.substring(0, 35).toUpperCase()}';
  }
}
