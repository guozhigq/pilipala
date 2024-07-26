import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/member/archive.dart';

class MemberArchiveController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late int mid;
  int pn = 1;
  int count = 0;
  RxMap<String, String> currentOrder = <String, String>{}.obs;
  RxList<Map<String, String>> orderList = [
    {'type': 'pubdate', 'label': '最新发布'},
    {'type': 'click', 'label': '最多播放'},
    {'type': 'stow', 'label': '最多收藏'},
    {'type': 'charge', 'label': '充电专属'},
  ].obs;
  RxList<VListItemModel> archivesList = <VListItemModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    currentOrder.value = orderList.first;
  }

  // 获取用户投稿
  Future getMemberArchive(type) async {
    if (type == 'init') {
      pn = 1;
      archivesList.clear();
      isLoading.value = true;
    }
    var res = await MemberHttp.memberArchive(
      mid: mid,
      pn: pn,
      order: currentOrder['type']!,
    );
    if (res['status']) {
      if (type == 'init') {
        archivesList.value = res['data'].list.vlist;
      }
      if (type == 'onLoad') {
        archivesList.addAll(res['data'].list.vlist);
      }
      count = res['data'].page['count'];
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
}
