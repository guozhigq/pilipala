import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/common/search_type.dart';

class SearchPanelController extends GetxController {
  SearchPanelController({this.keyword, this.searchType});
  ScrollController scrollController = ScrollController();
  String? keyword;
  SearchType? searchType;
  RxInt page = 1.obs;
  RxList resultList = [].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future onSearch({type = 'init'}) async {
    var result = await SearchHttp.searchByType(
        searchType: searchType!, keyword: keyword!, page: page.value);
    if (result['status']) {
      if (type == 'init') {
        page.value++;
        resultList.addAll(result['data'].list);
      } else {
        resultList.value = result['data'].list;
      }
    }
    return result;
  }

  Future onRefresh() async {
    page.value = 1;
    onSearch(type: 'refresh');
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
