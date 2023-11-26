import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/dynamics/result.dart';

class MemberDynamicsController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late int mid;
  String offset = '';
  int count = 0;
  bool hasMore = true;
  RxList<DynamicItemModel> dynamicsList = <DynamicItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
  }

  Future getMemberDynamic(type) async {
    if (type == 'onRefresh') {
      offset = '';
      dynamicsList.clear();
    }
    var res = await MemberHttp.memberDynamic(
      offset: offset,
      mid: mid,
    );
    if (res['status']) {
      dynamicsList.addAll(res['data'].items);
      offset = res['data'].offset;
      hasMore = res['data'].hasMore;
    }
    return res;
  }

  // 上拉加载
  Future onLoad() async {
    getMemberDynamic('onLoad');
  }
}
