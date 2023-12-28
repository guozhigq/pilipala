import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/common/theme_type.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/login.dart';
import 'package:pilipala/utils/storage.dart';

class SettingController extends GetxController {
  Box userInfoCache = GStrorage.userInfo;
  Box setting = GStrorage.setting;
  Box localCache = GStrorage.localCache;

  RxBool userLogin = false.obs;
  RxBool feedBackEnable = false.obs;
  RxDouble toastOpacity = (0.8).obs;
  RxInt picQuality = 10.obs;
  Rx<ThemeType> themeType = ThemeType.system.obs;
  var userInfo;

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfo != null;
    feedBackEnable.value =
        setting.get(SettingBoxKey.feedBackEnable, defaultValue: false);
    toastOpacity.value =
        setting.get(SettingBoxKey.defaultToastOp, defaultValue: 0.8);
    picQuality.value =
        setting.get(SettingBoxKey.defaultPicQa, defaultValue: 10);
    themeType.value = ThemeType.values[setting.get(SettingBoxKey.themeMode,
        defaultValue: ThemeType.system.code)];
  }

  loginOut() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确认要退出登录吗'),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: const Text('点错了'),
            ),
            TextButton(
              onPressed: () async {
                // 清空cookie
                await Request.cookieManager.cookieJar.deleteAll();
                Request.dio.options.headers['cookie'] = '';

                // 清空本地存储的用户标识
                userInfoCache.put('userInfoCache', null);
                localCache
                    .put(LocalCacheKey.accessKey, {'mid': -1, 'value': ''});

                await LoginUtils.refreshLoginStatus(false);
                SmartDialog.dismiss().then((value) => Get.back());
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  // 开启关闭震动反馈
  onOpenFeedBack() {
    feedBack();
    feedBackEnable.value = !feedBackEnable.value;
    setting.put(SettingBoxKey.feedBackEnable, feedBackEnable.value);
  }
}
