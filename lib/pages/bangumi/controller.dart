import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/bangumi.dart';
import 'package:pilipala/models/bangumi/list.dart';
import 'package:pilipala/utils/storage.dart';

class BangumiController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxList<BangumiListItemModel> bangumiList = [BangumiListItemModel()].obs;
  RxList<BangumiListItemModel> bangumiFollowList = [BangumiListItemModel()].obs;
  int _currentPage = 1;
  bool isLoadingMore = true;
  Box userInfoCache = GStrorage.userInfo;
  RxBool userLogin = false.obs;
  late int mid;
  var userInfo;

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    if (userInfo != null) {
      mid = userInfo.mid;
    }
    userLogin.value = userInfo != null;
  }

  Future queryBangumiListFeed({type = 'init'}) async {
    if (type == 'init') {
      _currentPage = 1;
    }
    var result = await BangumiHttp.bangumiList(page: _currentPage);
    if (result['status']) {
      if (type == 'init') {
        bangumiList.value = result['data'].list;
      } else {
        bangumiList.addAll(result['data'].list);
      }
      _currentPage += 1;
    } else {}
    isLoadingMore = false;
    return result;
  }

  // 上拉加载
  Future onLoad() async {
    queryBangumiListFeed(type: 'onLoad');
  }

  // 我的订阅
  Future queryBangumiFollow() async {
    var result = await BangumiHttp.bangumiFollow(mid: 17340771);
    if (result['status']) {
      bangumiFollowList.value = result['data'].list;
    } else {}
    return result;
  }

  // 返回顶部并刷新
  void animateToTop() async {
    if (scrollController.offset >=
        MediaQuery.of(Get.context!).size.height * 5) {
      scrollController.jumpTo(0);
    } else {
      await scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }
}
