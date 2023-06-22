import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/pages/mine/controller.dart';
import 'package:pilipala/utils/storage.dart';

class SettingController extends GetxController {
  Box user = GStrorage.user;
  RxBool userLogin = false.obs;
  Box userInfoCache = GStrorage.userInfo;

  @override
  void onInit() {
    super.onInit();
    userLogin.value = user.get(UserBoxKey.userLogin) ?? false;
  }

  loginOut() async {
    await Request.removeCookie();
    await Get.find<MineController>().resetUserInfo();
    userLogin.value = user.get(UserBoxKey.userLogin) ?? false;
    userInfoCache.put('userInfoCache', null);
  }
}
