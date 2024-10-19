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
import 'package:pilipala/models/member/like.dart';
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
  RxList<VListItemModel>? archiveList = <VListItemModel>[].obs;
  dynamic userInfo;
  RxInt attribute = (-1).obs;
  RxString attributeText = '关注'.obs;
  RxList<MemberCoinsDataModel> recentCoinsList = <MemberCoinsDataModel>[].obs;
  RxList<MemberLikeDataModel> recentLikeList = <MemberLikeDataModel>[].obs;
  RxBool isOwner = false.obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.tryParse(Get.parameters['mid']!) ?? -2;
    userInfo = userInfoCache.get('userInfoCache');
    ownerMid = userInfo != null ? userInfo.mid : -1;
    isOwner.value = mid == ownerMid;
    face.value = Get.arguments['face'] ?? '';
    heroTag = Get.arguments['heroTag'] ?? '';
    relationSearch();
  }

  // 获取用户信息
  Future<Map<String, dynamic>> getInfo() async {
    if (mid == -2) {
      SmartDialog.showToast('用户ID获取异常');
      return {'status': false, 'msg': '用户ID获取异常'};
    }

    await getMemberStat();
    await getMemberView();
    var res = await MemberHttp.memberInfo(mid: mid);
    if (res['status']) {
      memberInfo.value = res['data'];
      face.value = res['data'].face;
    } else {
      SmartDialog.showToast('用户信息请求异常：${res['msg']}');
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
      modifyRelation('block');
    } else {
      modifyRelation('follow');
    }
  }

  // 关系查询
  Future relationSearch() async {
    if (userInfo == null) return;
    if (mid == ownerMid) return;
    var res = await UserHttp.hasFollow(mid);
    if (res['status']) {
      attribute.value = res['data']['attribute'];
      final Map<int, String> attributeTextMap = {
        1: '悄悄关注',
        2: '已关注',
        6: '已互关',
        128: '已拉黑',
      };
      attributeText.value = attributeTextMap[attribute.value] ?? '关注';
      if (res['data']['special'] == 1) {
        attributeText.value = '特别关注';
      }
    }
  }

  // 拉黑用户
  Future blockUser() async {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    modifyRelation('block');
  }

// 合并关注/取关和拉黑逻辑
  Future modifyRelation(String actionType) async {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }

    String contentText;
    int act;
    if (actionType == 'follow') {
      contentText = memberInfo.value.isFollowed! ? '确定取消关注UP主?' : '确定关注UP主?';
      act = memberInfo.value.isFollowed! ? 2 : 1;
    } else if (actionType == 'block') {
      contentText = attribute.value != 128 ? '确定拉黑UP主?' : '确定从黑名单移除UP主？';
      act = attribute.value != 128 ? 5 : 6;
    } else {
      return;
    }

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text(contentText),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '点错了',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                var res = await VideoHttp.relationMod(
                  mid: mid,
                  act: act,
                  reSrc: 11,
                );
                SmartDialog.dismiss();
                if (res['status']) {
                  if (actionType == 'follow') {
                    memberInfo.value.isFollowed = !memberInfo.value.isFollowed!;
                  } else if (actionType == 'block') {
                    attribute.value = attribute.value != 128 ? 128 : 0;
                    attributeText.value = attribute.value == 128 ? '已拉黑' : '关注';
                    memberInfo.value.isFollowed = false;
                  }
                  relationSearch();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  memberInfo.update((val) {});
                }
              },
              child: const Text('确定'),
            )
          ],
        );
      },
    );
  }

  void shareUser() {
    Share.share('${memberInfo.value.name} - https://space.bilibili.com/$mid');
  }

  // 请求合集
  Future getMemberSeasons() async {
    if (userInfo == null) return;
    var res = await MemberHttp.getMemberSeasons(mid, 1, 10);
    if (!res['status']) {
      SmartDialog.showToast("用户合集请求异常：${res['msg']}");
    } else {
      // 只取前四个专栏
      res['data'].seasonsList.map((e) {
        e.archives =
            e.archives!.length > 4 ? e.archives!.sublist(0, 4) : e.archives!;
      }).toList();
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

  // 请求点赞视频
  Future getRecentLikeVideo() async {
    if (userInfo == null) return;
    var res = await MemberHttp.getRecentLikeVideo(mid: mid);
    recentLikeList.value = res['data'];
    return res;
  }

  // 跳转查看动态
  void pushDynamicsPage() => Get.toNamed('/memberDynamics?mid=$mid');
  // 跳转查看投稿
  void pushArchivesPage() => Get.toNamed('/memberArchive?mid=$mid');
  // 跳转查看最近投币
  void pushRecentCoinsPage() async {
    if (recentCoinsList.isNotEmpty) {}
  }

  // 跳转查看收藏夹
  void pushfavPage() => Get.toNamed('/fav?mid=$mid');
  // 跳转图文专栏
  void pushArticlePage() => Get.toNamed('/memberArticle?mid=$mid');
}
