import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/bangumi.dart';
import 'package:pilipala/models/bangumi/list.dart';

class BangumiController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxList<BangumiListItemModel> bangumiList = [BangumiListItemModel()].obs;
  int _currentPage = 1;
  bool isLoadingMore = true;

  Future queryBangumiListFeed({type = 'init'}) async {
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
}
