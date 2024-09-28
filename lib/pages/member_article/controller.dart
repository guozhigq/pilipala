import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/member/article.dart';

class MemberArticleController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late int mid;
  int pn = 1;
  String? offset;
  bool hasMore = true;
  String? wWebid;
  RxBool isLoading = false.obs;
  RxList<MemberArticleItemModel> articleList = <MemberArticleItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
  }

  // 获取wWebid
  Future getWWebid() async {
    var res = await MemberHttp.getWWebid(mid: mid);
    if (res['status']) {
      wWebid = res['data'];
    } else {
      wWebid = '-1';
      SmartDialog.showToast(res['msg']);
    }
  }

  Future getMemberArticle(type) async {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    if (wWebid == null) {
      await getWWebid();
    }
    if (type == 'init') {
      pn = 1;
      articleList.clear();
    }
    var res = await MemberHttp.getMemberArticle(
      mid: mid,
      pn: pn,
      offset: offset,
      wWebid: wWebid!,
    );
    if (res['status']) {
      offset = res['data'].offset;
      hasMore = res['data'].hasMore!;
      if (type == 'init') {
        articleList.value = res['data'].items;
      }
      if (type == 'onLoad') {
        articleList.addAll(res['data'].items);
      }
      pn += 1;
    } else {
      SmartDialog.showToast(res['msg']);
    }
    isLoading.value = false;
    return res;
  }
}
