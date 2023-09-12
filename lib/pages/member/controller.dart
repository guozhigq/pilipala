import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/member/archive.dart';
import 'package:pilipala/models/member/info.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:share_plus/share_plus.dart';

class MemberController extends GetxController {
  late int mid;
  Rx<MemberInfoModel> memberInfo = MemberInfoModel().obs;
  Map? userStat;
  String? face;
  String? heroTag;
  Box userInfoCache = GStrorage.userInfo;
  late int ownerMid;
  // 投稿列表
  RxList<VListItemModel>? archiveList = [VListItemModel()].obs;
  var userInfo;
  RxInt attribute = (-1).obs;
  RxString attributeText = '关注'.obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    userInfo = userInfoCache.get('userInfoCache');
    ownerMid = userInfo != null ? userInfo.mid : -1;
    face = Get.arguments['face'] ?? '';
    heroTag = Get.arguments['heroTag'] ?? '';
    relationSearch();
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
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    if (attribute.value == 128) {
      blockUser();
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
              child: Text(
                '点错了',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                await VideoHttp.relationMod(
                  mid: mid,
                  act: memberInfo.value.isFollowed! ? 2 : 1,
                  reSrc: 11,
                );
                memberInfo.value.isFollowed = !memberInfo.value.isFollowed!;
                relationSearch();
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

  // 关系查询
  Future relationSearch() async {
    if (userInfo == null) return;
    var res = await UserHttp.relationSearch(mid);
    if (res['status']) {
      attribute.value = res['data']['relation']['attribute'];
      attributeText.value = attribute.value == 0
          ? '关注'
          : attribute.value == 2
              ? '已关注'
              : attribute.value == 2
                  ? '已互粉'
                  : '已拉黑';
    }
  }

  // 拉黑用户
  Future blockUser() async {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text(attribute.value != 128 ? '确定拉黑UP主?' : '从黑名单移除UP主'),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: Text(
                '点错了',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                var res = await VideoHttp.relationMod(
                  mid: mid,
                  act: attribute.value != 128 ? 5 : 6,
                  reSrc: 11,
                );
                SmartDialog.dismiss();
                if (res['status']) {
                  attribute.value = attribute.value != 128 ? 128 : 0;
                  attributeText.value = attribute.value == 128 ? '已拉黑' : '关注';
                  memberInfo.value.isFollowed = false;
                  relationSearch();
                  memberInfo.update((val) {});
                }
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  void shareUser() {
    Share.share('${memberInfo.value.name} - https://space.bilibili.com/$mid');
  }
}
