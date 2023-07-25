import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/member/archive.dart';
import 'package:pilipala/models/member/info.dart';
import 'package:pilipala/utils/storage.dart';

class MemberController extends GetxController {
  late int mid;
  Rx<MemberInfoModel> memberInfo = MemberInfoModel().obs;
  Map? userStat;
  String? face;
  String? heroTag;
  Box user = GStrorage.user;
  late int ownerMid;
  // 投稿列表
  RxList<VListItemModel>? archiveList = [VListItemModel()].obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    ownerMid = user.get(UserBoxKey.userMid) ?? -1;
    face = Get.arguments['face'] ?? '';
    heroTag = Get.arguments['heroTag'] ?? '';
  }

  // 获取用户信息
  Future<Map<String, dynamic>> getInfo() async {
    await getMemberStat();
    var res = await MemberHttp.memberInfo(mid: mid);
    if (res['status']) {
      memberInfo.value = res['data'];
    }
    return res;
  }

  // 获取用户状态
  Future<Map<String, dynamic>> getMemberStat() async {
    var res = await MemberHttp.memberStat(mid: mid);
    if (res['status']) {
      userStat = res['data'];
    }
    return res;
  }

  // Future getMemberCardInfo() async {
  //   var res = await MemberHttp.memberCardInfo(mid: mid);
  //   if (res['status']) {
  //     print(userStat);
  //   }
  //   return res;
  // }

  // 关注/取关up
  Future actionRelationMod() async {
    if (user.get(UserBoxKey.userMid) == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }

    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text(memberInfo.value.isFollowed! ? '取消关注UP主?' : '关注UP主?'),
          actions: [
            TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: const Text('点错了')),
            TextButton(
              onPressed: () async {
                await VideoHttp.relationMod(
                  mid: mid,
                  act: memberInfo.value.isFollowed! ? 2 : 1,
                  reSrc: 11,
                );
                memberInfo.value.isFollowed = !memberInfo.value.isFollowed!;
                SmartDialog.dismiss();
                SmartDialog.showLoading();
                SmartDialog.dismiss();
                memberInfo.update((val) {});
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }
}
