import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/common/theme_type.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/mine/controller.dart';
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
    await Request.cookieManager.cookieJar.deleteAll();
    await Get.find<MineController>().resetUserInfo();
    userLogin.value = user.get(UserBoxKey.userLogin) ?? false;
    userInfoCache.put('userInfoCache', null);
    HomeController homeCtr = Get.find<HomeController>();
    homeCtr.updateLoginStatus(false);
  }

  // 开启关闭震动反馈
  onOpenFeedBack() {
    feedBack();
    feedBackEnable.value = !feedBackEnable.value;
    setting.put(SettingBoxKey.feedBackEnable, feedBackEnable.value);
  }
}
