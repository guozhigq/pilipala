import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/member/archive.dart';
import 'package:pilipala/utils/global_data_cache.dart';
import 'package:pilipala/utils/utils.dart';

class MemberArchiveController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late int mid;
  int pn = 1;
  RxInt count = 0.obs;
  RxMap<String, String> currentOrder = <String, String>{}.obs;
  RxList<Map<String, String>> orderList = [
    {'type': 'pubdate', 'label': '最新发布'},
    {'type': 'click', 'label': '最多播放'},
    {'type': 'stow', 'label': '最多收藏'},
    {'type': 'charge', 'label': '充电专属'},
  ].obs;
  RxList<VListItemModel> archivesList = <VListItemModel>[].obs;
  RxBool isLoading = false.obs;
  late int ownerMid;
  RxBool isOwner = false.obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    currentOrder.value = orderList.first;
    ownerMid =
        GlobalDataCache.userInfo != null ? GlobalDataCache.userInfo!.mid! : -1;
    isOwner.value = mid == -1 || mid == ownerMid;
  }

  // 获取用户投稿
  Future getMemberArchive(type) async {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    if (type == 'init') {
      pn = 1;
      archivesList.clear();
    }
    var res = await MemberHttp.memberArchive(
      mid: mid,
      pn: pn,
      order: currentOrder['type']!,
    );
    if (res['status']) {
      if (type == 'init') {
        archivesList.value = res['data'].list.vlist;
        count.value = res['data'].page['count'];
      }
      if (type == 'onLoad') {
        archivesList.addAll(res['data'].list.vlist);
      }
      pn += 1;
    }
    isLoading.value = false;
    return res;
  }

  toggleSort() async {
    List<String> typeList = orderList.map((e) => e['type']!).toList();
    int index = typeList.indexOf(currentOrder['type']!);
    if (index == orderList.length - 1) {
      currentOrder.value = orderList.first;
    } else {
      currentOrder.value = orderList[index + 1];
    }
    getMemberArchive('init');
  }

  // 上拉加载
  Future onLoad() async {
    getMemberArchive('onLoad');
  }

  Future toViewPlayAll() async {
    final VListItemModel firstItem = archivesList.first;
    final String bvid = firstItem.bvid!;
    final int cid = await SearchHttp.ab2c(bvid: bvid);
    final String heroTag = Utils.makeHeroTag(bvid);
    late Map sortFieldMap = {
      'pubdate': 'pubtime',
      'click': 'play',
      'fav': 'fav',
    };
    Get.toNamed(
      '/video?bvid=${firstItem.bvid}&cid=$cid',
      arguments: {
        'videoItem': firstItem,
        'heroTag': heroTag,
        'sourceType': 'up_archive',
        'oid': firstItem.aid,
        'favTitle': '${firstItem.owner!.name!} - ${currentOrder['label']!}',
        'favInfo': firstItem,
        'count': count.value,
        'sortField': sortFieldMap[currentOrder['type']],
      },
    );
  }
}
