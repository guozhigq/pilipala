import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/search/hot.dart';
import 'package:pilipala/models/search/suggest.dart';
import 'package:pilipala/utils/storage.dart';

class SSearchController extends GetxController {
  final FocusNode searchFocusNode = FocusNode();
  RxString searchKeyWord = ''.obs;
  Rx<TextEditingController> controller = TextEditingController().obs;
  List<HotSearchItem> hotSearchList = [];
  Box hotKeyword = GStrorage.hotKeyword;
  Box histiryWord = GStrorage.historyword;
  List historyCacheList = [];
  RxList historyList = [].obs;
  RxList<SearchSuggestItem> searchSuggestList = [SearchSuggestItem()].obs;
  final _debouncer =
      Debouncer(delay: const Duration(milliseconds: 200)); // 设置延迟时间
  String hintText = '搜索';

  @override
  void onInit() {
    super.onInit();
    if (hotKeyword.get('cacheList') != null &&
        hotKeyword.get('cacheList').isNotEmpty) {
      List<HotSearchItem> list = [];
      for (var i in hotKeyword.get('cacheList')) {
        list.add(i);
      }
      hotSearchList = list;
    }
    // 其他页面跳转过来
    if (Get.parameters.keys.isNotEmpty) {
      if (Get.parameters['keyword'] != null) {
        onClickKeyword(Get.parameters['keyword']!);
      }
      if (Get.parameters['hintText'] != null) {
        hintText = Get.parameters['hintText']!;
        searchKeyWord.value = hintText;
      }
    }
    historyCacheList = histiryWord.get('cacheList') ?? [];
    historyList.value = historyCacheList;
  }

  void onChange(value) {
    searchKeyWord.value = value;
    if (value == '') {
      searchSuggestList.value = [];
      return;
    }
    _debouncer.call(() => querySearchSuggest(value));
  }

  void onClear() {
    if (searchKeyWord.value.isNotEmpty) {
      controller.value.clear();
      searchKeyWord.value = '';
      searchSuggestList.value = [];
    } else {
      Get.back();
    }
  }

  // 搜索
  void submit() {
    // ignore: unrelated_type_equality_checks
    if (searchKeyWord == '') {
      return;
    }
    List arr = historyCacheList.where((e) => e != searchKeyWord.value).toList();
    arr.insert(0, searchKeyWord.value);
    historyCacheList = arr;

    historyList.value = historyCacheList;
    // 手动刷新
    historyList.refresh();
    histiryWord.put('cacheList', historyCacheList);
    searchFocusNode.unfocus();
    Get.toNamed('/searchResult', parameters: {'keyword': searchKeyWord.value});
  }

  // 获取热搜关键词
  Future queryHotSearchList() async {
    var result = await SearchHttp.hotSearchList();
    hotSearchList = result['data'].list;
    hotKeyword.put('cacheList', result['data'].list);
    return result;
  }

  // 点击热搜关键词
  void onClickKeyword(String keyword) {
    searchKeyWord.value = keyword;
    controller.value.text = keyword;
    // 移动光标
    controller.value.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.value.text.length),
    );
    submit();
  }

  Future querySearchSuggest(String value) async {
    var result = await SearchHttp.searchSuggest(term: value);
    if (result['status']) {
      searchSuggestList.value = result['data'].tag;
    }
  }

  onSelect(word) {
    searchKeyWord.value = word;
    controller.value.text = word;
    submit();
  }

  onClearHis() {
    historyList.value = [];
    historyCacheList = [];
    historyList.refresh();
    histiryWord.put('cacheList', []);
  }
}
