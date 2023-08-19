import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/common/theme_type.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/mine/controller.dart';
import 'package:pilipala/utils/event_bus.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';

class SettingController extends GetxController {
  Box user = GStrorage.user;
  Box setting = GStrorage.setting;
  Box userInfoCache = GStrorage.userInfo;

  RxBool userLogin = false.obs;
  RxBool feedBackEnable = false.obs;
  RxInt picQuality = 10.obs;
  Rx<ThemeType> themeType = ThemeType.system.obs;

  @override
  void onInit() {
    super.onInit();
    userLogin.value = user.get(UserBoxKey.userLogin) ?? false;
    feedBackEnable.value =
        setting.get(SettingBoxKey.feedBackEnable, defaultValue: false);
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
                user.put(UserBoxKey.accessKey, {'mid': -1, 'value': ''});

                // 更改我的页面登录状态
                await Get.find<MineController>().resetUserInfo();

                // 更改主页登录状态
                HomeController homeCtr = Get.find<HomeController>();
                homeCtr.updateLoginStatus(false);

                // 事件通知
                EventBus eventBus = EventBus();
                eventBus.emit(EventName.loginEvent, {'status': false});

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
