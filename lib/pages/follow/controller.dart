import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/follow.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/follow/result.dart';
import 'package:pilipala/models/member/tags.dart';
import 'package:pilipala/utils/storage.dart';

/// 查看自己的关注时，可以查看分类
/// 查看其他人的关注时，只可以看全部
class FollowController extends GetxController with GetTickerProviderStateMixin {
  Box userInfoCache = GStrorage.userInfo;
  int pn = 1;
  int ps = 20;
  int total = 0;
  RxList<FollowItemModel> followList = <FollowItemModel>[].obs;
  late int mid;
  late String name;
  var userInfo;
  RxString loadingText = '加载中...'.obs;
  RxBool isOwner = false.obs;
  late List<MemberTagItemModel> followTags;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    mid = Get.parameters['mid'] != null
        ? int.parse(Get.parameters['mid']!)
        : userInfo.mid;
    isOwner.value = mid == userInfo.mid;
    name = Get.parameters['name'] ?? userInfo.uname;
  }

  Future queryFollowings(type) async {
    if (type == 'init') {
      pn = 1;
      loadingText.value == '加载中...';
    }
    if (loadingText.value == '没有更多了') {
      return;
    }
    var res = await FollowHttp.followings(
      vmid: mid,
      pn: pn,
      ps: ps,
      orderType: 'attention',
    );
    if (res['status']) {
      if (type == 'init') {
        followList.value = res['data'].list;
        total = res['data'].total;
      } else if (type == 'onLoad') {
        followList.addAll(res['data'].list);
      }
      if ((pn == 1 && total < ps) || res['data'].list.isEmpty) {
        loadingText.value = '没有更多了';
      }
      pn += 1;
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }

  // 当查看当前用户的关注时，请求关注分组
  Future followUpTags() async {
    if (userInfo != null && mid == userInfo.mid) {
      var res = await MemberHttp.followUpTags();
      if (res['status']) {
        followTags = res['data'];
        tabController = TabController(
          initialIndex: 0,
          length: res['data'].length,
          vsync: this,
        );
      }
      return res;
    }
  }
}
