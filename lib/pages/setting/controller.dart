import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/common/theme_type.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/login.dart';
import 'package:pilipala/utils/storage.dart';
import '../../models/common/dynamic_badge_mode.dart';
import '../main/index.dart';
import 'widgets/select_dialog.dart';

class SettingController extends GetxController {
  Box userInfoCache = GStrorage.userInfo;
  Box setting = GStrorage.setting;
  Box localCache = GStrorage.localCache;

  RxBool userLogin = false.obs;
  RxBool feedBackEnable = false.obs;
  RxDouble toastOpacity = (1.0).obs;
  RxInt picQuality = 10.obs;
  Rx<ThemeType> themeType = ThemeType.system.obs;
  var userInfo;
  Rx<DynamicBadgeMode> dynamicBadgeType = DynamicBadgeMode.number.obs;

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfo != null;
    feedBackEnable.value =
        setting.get(SettingBoxKey.feedBackEnable, defaultValue: false);
    toastOpacity.value =
        setting.get(SettingBoxKey.defaultToastOp, defaultValue: 1.0);
    picQuality.value =
        setting.get(SettingBoxKey.defaultPicQa, defaultValue: 10);
    themeType.value = ThemeType.values[setting.get(SettingBoxKey.themeMode,
        defaultValue: ThemeType.system.code)];
    dynamicBadgeType.value = DynamicBadgeMode.values[setting.get(
        SettingBoxKey.dynamicBadgeMode,
        defaultValue: DynamicBadgeMode.number.code)];
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

  // 设置动态未读标记
  setDynamicBadgeMode(BuildContext context) async {
    DynamicBadgeMode? result = await showDialog(
      context: context,
      builder: (context) {
        return SelectDialog<DynamicBadgeMode>(
          title: '动态未读标记',
          value: dynamicBadgeType.value,
          values: DynamicBadgeMode.values.map((e) {
            return {'title': e.description, 'value': e};
          }).toList(),
        );
      },
    );
    if (result != null) {
      dynamicBadgeType.value = result;
      setting.put(SettingBoxKey.dynamicBadgeMode, result.code);
      MainController mainController = Get.put(MainController());
      mainController.dynamicBadgeType.value =
          DynamicBadgeMode.values[result.code];
      if (mainController.dynamicBadgeType.value != DynamicBadgeMode.hidden) {
        mainController.getUnreadDynamic();
      }
      SmartDialog.showToast('设置成功');
    }
  }
}
