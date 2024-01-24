import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/member/archive.dart';

class MemberArchiveController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late int mid;
  int pn = 1;
  int count = 0;
  RxMap<String, String> currentOrder = <String, String>{}.obs;
  List<Map<String, String>> orderList = [
    {'type': 'pubdate', 'label': '最新发布'},
    {'type': 'click', 'label': '最多播放'},
    {'type': 'stow', 'label': '最多收藏'},
  ];
  RxList<VListItemModel> archivesList = <VListItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    currentOrder.value = orderList.first;
  }

  // 获取用户投稿
  Future getMemberArchive(type) async {
    if (type == 'onRefresh') {
      pn = 1;
    }
    var res = await MemberHttp.memberArchive(
      mid: mid,
      pn: pn,
      order: currentOrder['type']!,
    );
    if (res['status']) {
      archivesList.addAll(res['data'].list.vlist);
      count = res['data'].page['count'];
      pn += 1;
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }

  toggleSort() async {
    pn = 1;
    int index = orderList.indexOf(currentOrder);
    if (index == orderList.length - 1) {
      currentOrder.value = orderList.first;
    } else {
      currentOrder.value = orderList[index + 1];
    }
  }

  // 上拉加载
  Future onLoad() async {
    getMemberArchive('onLoad');
  }
}
