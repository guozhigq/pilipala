import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/member/archive.dart';
import 'package:pilipala/models/member/coin.dart';
import 'package:pilipala/models/member/info.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:share_plus/share_plus.dart';

class MemberController extends GetxController {
  late int mid;
  Rx<MemberInfoModel> memberInfo = MemberInfoModel().obs;
  late Map userStat;
  RxString face = ''.obs;
  String? heroTag;
  Box userInfoCache = GStrorage.userInfo;
  late int ownerMid;
  // 投稿列表
  RxList<VListItemModel>? archiveList = [VListItemModel()].obs;
  dynamic userInfo;
  RxInt attribute = (-1).obs;
  RxString attributeText = '关注'.obs;
  RxList<MemberCoinsDataModel> recentCoinsList = <MemberCoinsDataModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    userInfo = userInfoCache.get('userInfoCache');
    ownerMid = userInfo != null ? userInfo.mid : -1;
    face.value = Get.arguments['face'] ?? '';
    heroTag = Get.arguments['heroTag'] ?? '';
    relationSearch();
  }

  // 获取用户信息
  Future<Map<String, dynamic>> getInfo() async {
    await getMemberStat();
    await getMemberView();
    var res = await MemberHttp.memberInfo(mid: mid);
    if (res['status']) {
      memberInfo.value = res['data'];
      face.value = res['data'].face;
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

  // 获取用户播放数 获赞数
  Future<Map<String, dynamic>> getMemberView() async {
    var res = await MemberHttp.memberView(mid: mid);
    if (res['status']) {
      userStat.addAll(res['data']);
    }
    return res;
  }

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
    if (mid == ownerMid) return;
    var res = await UserHttp.hasFollow(mid);
    if (res['status']) {
      attribute.value = res['data']['attribute'];
      switch (attribute.value) {
        case 1:
          attributeText.value = '悄悄关注';
          break;
        case 2:
          attributeText.value = '已关注';
          break;
        case 6:
          attributeText.value = '已互关';
          break;
        case 128:
          attributeText.value = '已拉黑';
          break;
        default:
          attributeText.value = '关注';
      }
      if (res['data']['special'] == 1) {
        attributeText.value += 'SP';
      }
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

  // 请求专栏
  Future getMemberSeasons() async {
    if (userInfo == null) return;
    var res = await MemberHttp.getMemberSeasons(mid, 1, 10);
    if (!res['status']) {
      SmartDialog.showToast("用户专栏请求异常：${res['msg']}");
    }
    return res;
  }

  // 请求投币视频
  Future getRecentCoinVideo() async {
    if (userInfo == null) return;
    var res = await MemberHttp.getRecentCoinVideo(mid: mid);
    recentCoinsList.value = res['data'];
    return res;
  }

  // 跳转查看动态
  void pushDynamicsPage() => Get.toNamed('/memberDynamics?mid=$mid');

  // 跳转查看投稿
  void pushArchivesPage() => Get.toNamed('/memberArchive?mid=$mid');

  // 跳转查看专栏
  void pushSeasonsPage() {}
  // 跳转查看最近投币
  void pushRecentCoinsPage() async {
    if (recentCoinsList.isNotEmpty) {}
  }
}
