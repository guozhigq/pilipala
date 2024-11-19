import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/member/article.dart';
import 'package:pilipala/utils/global_data_cache.dart';

class MemberArticleController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late int mid;
  int pn = 1;
  String? offset;
  bool hasMore = true;
  RxBool isLoading = false.obs;
  RxList<MemberArticleItemModel> articleList = <MemberArticleItemModel>[].obs;
  late int ownerMid;
  RxBool isOwner = false.obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    ownerMid = GlobalDataCache().userInfo != null
        ? GlobalDataCache().userInfo!.mid!
        : -1;
    isOwner.value = mid == -1 || mid == ownerMid;
  }

  Future getMemberArticle(type) async {
    if (isLoading.value || !hasMore) {
      return;
    }
    isLoading.value = true;
    if (type == 'init') {
      pn = 1;
      articleList.clear();
    }
    var res = await MemberHttp.getMemberArticle(
      mid: mid,
      pn: pn,
      offset: offset,
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
