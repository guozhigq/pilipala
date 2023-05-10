import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/models/user/stat.dart';
import 'package:pilipala/pages/main/controller.dart';
import 'package:pilipala/utils/storage.dart';

class MineController extends GetxController {
  // 用户信息 头像、昵称、lv
  Rx<UserInfoData> userInfo = UserInfoData().obs;
  // 用户状态 动态、关注、粉丝
  Rx<UserStat> userStat = UserStat().obs;
  Box user = GStrorage.user;
  RxBool userLogin = false.obs;

  onLogin() {
    Get.toNamed(
      '/webview',
      parameters: {
        'url': 'https://passport.bilibili.com/h5-app/passport/login',
        'type': 'login',
        'pageTitle': '登录bilibili',
      },
    );
  }

  Future queryUserInfo() async {
    var res = await UserHttp.userInfo();
    if (res['status']) {
      if (res['data'].isLogin) {
        userInfo.value = res['data'];
        user.put(UserBoxKey.userName, res['data'].uname);
        user.put(UserBoxKey.userFace, res['data'].face);
        user.put(UserBoxKey.userMid, res['data'].mid);
        user.put(UserBoxKey.userLogin, true);
        userLogin.value = true;
        // Get.find<MainController>().readuUserFace();
      } else {
        resetUserInfo();
      }
    } else {
      resetUserInfo();
      // SmartDialog.showToast(res['msg']);
    }
    await queryUserStatOwner();
    return res;
  }

  Future queryUserStatOwner() async {
    var res = await UserHttp.userStatOwner();
    if (res['status']) {
      userStat.value = res['data'];
    }
    return res;
  }

  Future resetUserInfo() async {
    userInfo.value = UserInfoData();
    userStat.value = UserStat();
    await user.delete(UserBoxKey.userName);
    await user.delete(UserBoxKey.userFace);
    await user.delete(UserBoxKey.userMid);
    await user.delete(UserBoxKey.userLogin);
    userLogin.value = false;
    // Get.find<MainController>().resetLast();
  }
}
