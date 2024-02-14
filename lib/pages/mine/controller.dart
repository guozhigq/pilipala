import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/common/theme_type.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/models/user/stat.dart';
import 'package:pilipala/utils/storage.dart';

class MineController extends GetxController {
  // 用户信息 头像、昵称、lv
  Rx<UserInfoData> userInfo = UserInfoData().obs;
  // 用户状态 动态、关注、粉丝
  Rx<UserStat> userStat = UserStat().obs;
  RxBool userLogin = false.obs;
  Box userInfoCache = GStrorage.userInfo;
  Box setting = GStrorage.setting;
  Rx<ThemeType> themeType = ThemeType.system.obs;
  static bool anonymity =
      GStrorage.setting.get(SettingBoxKey.anonymity, defaultValue: false);

  @override
  onInit() {
    super.onInit();

    if (userInfoCache.get('userInfoCache') != null) {
      userInfo.value = userInfoCache.get('userInfoCache');
      userLogin.value = true;
    }

    themeType.value = ThemeType.values[setting.get(SettingBoxKey.themeMode,
        defaultValue: ThemeType.system.code)];
    // anonymity = setting.get(SettingBoxKey.anonymity, defaultValue: false);
  }

  onLogin() async {
    if (!userLogin.value) {
      Get.toNamed(
        '/webview',
        parameters: {
          'url': 'https://passport.bilibili.com/h5-app/passport/login',
          'type': 'login',
          'pageTitle': '登录bilibili',
        },
      );
      // Get.toNamed('/loginPage');
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
    } else {
      resetUserInfo();
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
    anonymity = false;
  }

  static onChangeAnonymity(BuildContext context) {
    anonymity = !anonymity;
    if (anonymity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(children: <Widget>[
            const Row(
              children: <Widget>[
                Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Text('已进入无痕模式', style: TextStyle(fontSize: 15, height: 1.5))
              ],
            ),
            const SizedBox(height: 10),
            const Text(
                '搜索、观看视频/直播不携带Cookie与CSRF\n'
                '不产生查询或播放记录\n'
                '点赞等其它操作不受影响\n'
                '（前往隐私设置了解详情）',
                style: TextStyle(fontSize: 12.5, height: 1.5)),
            Row(children: [
              TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith((states) {
                      return Theme.of(context).snackBarTheme.actionTextColor;
                    }),
                  ),
                  onPressed: () {
                    GStrorage.setting.put(SettingBoxKey.anonymity, true);
                    anonymity = true;
                    SmartDialog.showToast('已设为永久无痕模式');
                  },
                  child: const Text('保存为永久')),
              const SizedBox(width: 10),
              TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith((states) {
                      return Theme.of(context).snackBarTheme.actionTextColor;
                    }),
                  ),
                  onPressed: () {
                    GStrorage.setting.put(SettingBoxKey.anonymity, false);
                    anonymity = true;
                    SmartDialog.showToast('已设为临时无痕模式');
                  },
                  child: const Text('仅本次（默认）'))
            ])
          ]),
          duration: const Duration(seconds: 2),
          showCloseIcon: true,
        ),
      );
    } else {
      GStrorage.setting.put(SettingBoxKey.anonymity, false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已退出无痕模式'),
          duration: Duration(seconds: 1),
          // action: SnackBarAction(
          //   label: '确认',
          //   onPressed: () {},
          // ),
          showCloseIcon: true,
        ),
      );
    }
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
    Get.toNamed('/follow?mid=${userInfo.value.mid}', preventDuplicates: false);
  }

  pushFans() {
    if (!userLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    Get.toNamed('/fan?mid=${userInfo.value.mid}', preventDuplicates: false);
  }

  pushDynamic() {
    if (!userLogin.value) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    Get.toNamed('/memberDynamics?mid=${userInfo.value.mid}',
        preventDuplicates: false);
  }
}
