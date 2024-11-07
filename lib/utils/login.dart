import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/index.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/mine/index.dart';
import 'package:pilipala/utils/cookie.dart';
import 'package:pilipala/utils/global_data_cache.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:uuid/uuid.dart';

class LoginUtils {
  static Box userInfoCache = GStrorage.userInfo;
  static Box localCache = GStrorage.localCache;

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

  static confirmLogin(url, controller) async {
    var content = '';
    if (url != null) {
      content = '${content + url}; \n';
    }
    try {
      await SetCookie.onSet();
      final result = await UserHttp.userInfo();
      if (result['status'] && result['data'].isLogin) {
        SmartDialog.showToast('登录成功');
        try {
          Box userInfoCache = GStrorage.userInfo;
          if (!userInfoCache.isOpen) {
            userInfoCache = await Hive.openBox('userInfo');
          }
          await userInfoCache.put('userInfoCache', result['data']);

          final HomeController homeCtr = Get.find<HomeController>();
          homeCtr.updateLoginStatus(true);
          homeCtr.userFace.value = result['data'].face;
          await LoginUtils.refreshLoginStatus(true);
        } catch (err) {
          SmartDialog.show(builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('登录遇到问题'),
              content: Text(err.toString()),
              actions: [
                TextButton(
                  onPressed: controller != null
                      ? () => controller.reload()
                      : SmartDialog.dismiss,
                  child: const Text('确认'),
                )
              ],
            );
          });
        }
        Get.back();
      } else {
        // 获取用户信息失败
        SmartDialog.showToast(result['msg']);
        Clipboard.setData(ClipboardData(text: result['msg']));
      }
    } catch (e) {
      SmartDialog.showNotify(msg: e.toString(), notifyType: NotifyType.warning);
      content = content + e.toString();
      Clipboard.setData(ClipboardData(text: content));
    }
  }

  // 退出登录
  static loginOut() async {
    await Request.cookieManager.cookieJar.deleteAll();
    Request.dio.options.headers['cookie'] = '';
    userInfoCache.put('userInfoCache', null);
    localCache.put(LocalCacheKey.accessKey, {'mid': -1, 'value': ''});
    GlobalDataCache().userInfo = null;
    await refreshLoginStatus(false);
  }
}
