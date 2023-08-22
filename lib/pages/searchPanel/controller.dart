import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/utils.dart';

class SearchPanelController extends GetxController {
  SearchPanelController({this.keyword, this.searchType});
  ScrollController scrollController = ScrollController();
  String? keyword;
  SearchType? searchType;
  RxInt page = 1.obs;
  RxList resultList = [].obs;
  // 结果排序方式 搜索类型为视频、专栏及相簿时
  RxString order = ''.obs;
  // 视频时长筛选 仅用于搜索视频
  RxInt duration = 0.obs;

  Future onSearch({type = 'init'}) async {
    var result = await SearchHttp.searchByType(
        searchType: searchType!,
        keyword: keyword!,
        page: page.value,
        order: searchType!.type != 'video' ? null : order.value,
        duration: searchType!.type != 'video' ? null : duration.value);
    if (result['status']) {
      if (type == 'onRefresh') {
        resultList.value = result['data'].list;
      } else {
        resultList.addAll(result['data'].list);
      }
      page.value++;
      onPushDetail(keyword, resultList);
    }
    return result;
  }

  Future onRefresh() async {
    page.value = 1;
    await onSearch(type: 'onRefresh');
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

  void onPushDetail(keyword, resultList) async {
    // 匹配输入内容，如果是AV、BV号且有结果 直接跳转详情页
    Map matchRes = IdUtils.matchAvorBv(input: keyword);
    List matchKeys = matchRes.keys.toList();
    if (matchKeys.isNotEmpty && searchType == SearchType.video) {
      String bvid = resultList.first.bvid;
      int aid = resultList.first.aid;
      String heroTag = Utils.makeHeroTag(bvid);

      int cid = await SearchHttp.ab2c(aid: aid, bvid: bvid);
      if (matchKeys.first == 'BV' && matchRes[matchKeys.first] == bvid ||
          matchKeys.first == 'AV' && matchRes[matchKeys.first] == aid) {
        Get.toNamed(
          '/video?bvid=$bvid&cid=$cid',
          arguments: {'videoItem': resultList.first, 'heroTag': heroTag},
        );
      }
    }
  }
}
