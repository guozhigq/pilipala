import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/common/theme_type.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/models/user/stat.dart';
import 'package:pilipala/utils/storage.dart';

class MineController extends GetxController {
  RxBool userLogin = false.obs;
  // 用户状态 动态、关注、粉丝
  Rx<UserStat> userStat = UserStat().obs;
  // 用户信息 头像、昵称、lv
  Rx<UserInfoData> userInfo = UserInfoData().obs;
  Rx<ThemeType> themeType = ThemeType.system.obs;
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  Box setting = GStorage.setting;
  Box userInfoCache = GStorage.userInfo;
  List menuList = [
    {
      'icon': Icons.history,
      'title': '观看记录',
      'onTap': () => Get.toNamed('/history'),
    },
    {
      'icon': Icons.star_border,
      'title': '我的收藏',
      'onTap': () => Get.toNamed('/fav'),
    },
    {
      'icon': Icons.subscriptions_outlined,
      'title': '我的订阅',
      'onTap': () => Get.toNamed('/subscription'),
    },
    {
      'icon': Icons.watch_later_outlined,
      'title': '稍后再看',
      'onTap': () => Get.toNamed('/later'),
    },
  ];
  @override
  void onInit() {
    super.onInit();

    if (userInfoCache.get('userInfoCache') != null) {
      userInfo.value = userInfoCache.get('userInfoCache');
      userLogin.value = true;
    }

    themeType.value = ThemeType.values[setting.get(SettingBoxKey.themeMode,
        defaultValue: ThemeType.system.code)];
  }

  onLogin() async {
    if (!userLogin.value) {
      Get.toNamed('/loginPage', preventDuplicates: false);
    } else {
      int mid = userInfo.value.mid!;
      String face = userInfo.value.face!;
      Get.toNamed(
        '/member?mid=$mid',
        arguments: {'face': face},
      );
    }
  }

  Future queryUserInfo() async {
    if (!userLogin.value) {
      return {'status': false};
    }
    var res = await UserHttp.userInfo();
    if (res['status']) {
      if (res['data'].isLogin) {
        userInfo.value = res['data'];
        userInfoCache.put('userInfoCache', res['data']);
        userLogin.value = true;
      } else {
        resetUserInfo();
      }
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
    userInfoCache.delete('userInfoCache');
    userLogin.value = false;
  }

  onChangeTheme() {
    Brightness currentBrightness =
        MediaQuery.of(Get.context!).platformBrightness;
    ThemeType currentTheme = themeType.value;
    switch (currentTheme) {
      case ThemeType.dark:
        setting.put(SettingBoxKey.themeMode, ThemeType.light.code);
        themeType.value = ThemeType.light;
        break;
      case ThemeType.light:
        setting.put(SettingBoxKey.themeMode, ThemeType.dark.code);
        themeType.value = ThemeType.dark;
        break;
      case ThemeType.system:
        // 判断当前的颜色模式
        if (currentBrightness == Brightness.light) {
          setting.put(SettingBoxKey.themeMode, ThemeType.dark.code);
          themeType.value = ThemeType.dark;
        } else {
          setting.put(SettingBoxKey.themeMode, ThemeType.light.code);
          themeType.value = ThemeType.light;
        }
        break;
    }
    Get.forceAppUpdate();
  }

  pushFollow() {
    if (!userLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    Get.toNamed(
      '/follow?mid=${userInfo.value.mid}',
      preventDuplicates: false,
    );
  }

  pushFans() {
    if (!userLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    Get.toNamed(
      '/fan?mid=${userInfo.value.mid}',
      preventDuplicates: false,
    );
  }

  pushDynamic() {
    if (!userLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    Get.toNamed(
      '/memberDynamics?mid=${userInfo.value.mid}',
      preventDuplicates: false,
    );
  }

  Future<dynamic> queryFavFolder() async {
    if (!userLogin.value) {
      return {'status': false, 'data': [], 'msg': '未登录'};
    }
    var res = await await UserHttp.userfavFolder(
      pn: 1,
      ps: 5,
      mid: userInfo.value.mid!,
    );
    favFolderData.value = res['data'];
    return res;
  }
}
