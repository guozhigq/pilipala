import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/main/index.dart';
import 'package:pilipala/pages/mine/controller.dart';
import 'package:pilipala/utils/data.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';

class SettingController extends GetxController {
  Box user = GStrorage.user;
  RxBool userLogin = false.obs;
  Box userInfoCache = GStrorage.userInfo;
  Box setting = GStrorage.setting;
  RxBool feedBackEnable = false.obs;

  @override
  void onInit() {
    super.onInit();
    userLogin.value = user.get(UserBoxKey.userLogin) ?? false;
    feedBackEnable.value =
        setting.get(SettingBoxKey.feedBackEnable, defaultValue: false);
  }

  loginOut() async {
    await Request.removeCookie();
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
