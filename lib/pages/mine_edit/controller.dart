import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/utils/storage.dart';

class MineEditController extends GetxController {
  Box userInfoCache = GStorage.userInfo;
  final formKey = GlobalKey<FormState>();
  final TextEditingController unameCtr = TextEditingController();
  final TextEditingController useridCtr = TextEditingController();
  final TextEditingController signCtr = TextEditingController();
  final TextEditingController birthdayCtr = TextEditingController();
  String? sex;
  UserInfoData? userInfo;

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
  }

  Future getAccountInfo() async {
    var res = await UserHttp.getAccountInfo();
    if (res['status']) {
      unameCtr.text = res['data']['uname'];
      useridCtr.text = res['data']['userid'];
      signCtr.text = res['data']['sign'];
      birthdayCtr.text = res['data']['birthday'];
      sex = res['data']['sex'];
    }
    return res;
  }

  Future updateAccountInfo() async {
    var res = await UserHttp.updateAccountInfo(
      uname: unameCtr.text,
      sign: signCtr.text,
      sex: sex!,
      birthday: birthdayCtr.text,
    );
    SmartDialog.showToast(res['status'] ? res['msg'] : "更新失败：${res['msg']}");
  }
}
