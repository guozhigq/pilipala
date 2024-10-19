import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/search/hot.dart';
import 'package:pilipala/models/search/suggest.dart';
import 'package:pilipala/utils/global_data_cache.dart';
import 'package:pilipala/utils/storage.dart';

class SSearchController extends GetxController {
  final FocusNode searchFocusNode = FocusNode();
  RxString searchKeyWord = ''.obs;
  Rx<TextEditingController> controller = TextEditingController().obs;
  RxList<HotSearchItem> hotSearchList = <HotSearchItem>[].obs;
  Box localCache = GStrorage.localCache;
  List historyCacheList = [];
  RxList historyList = [].obs;
  RxList<SearchSuggestItem> searchSuggestList = <SearchSuggestItem>[].obs;
  final _debouncer =
      Debouncer(delay: const Duration(milliseconds: 200)); // 设置延迟时间
  String hintText = '搜索';
  RxString defaultSearch = ''.obs;
  Box setting = GStrorage.setting;
  bool enableHotKey = true;
  late StreamController<bool> clearStream = StreamController<bool>.broadcast();

  @override
  void onInit() {
    super.onInit();
    // 其他页面跳转过来
    final parameters = Get.parameters;
    if (parameters.keys.isNotEmpty) {
      final keyword = parameters['keyword'];
      if (keyword != null) {
        onClickKeyword(keyword);
      }

      final hint = parameters['hintText'];
      if (hint != null) {
        hintText = hint;
        searchKeyWord.value = hintText;
      }
    }
    historyCacheList = GlobalDataCache().historyCacheList;
    historyList.value = historyCacheList;
    enableHotKey = setting.get(SettingBoxKey.enableHotKey, defaultValue: true);
  }

  void onChange(value) {
    searchKeyWord.value = value;
    if (value == '') {
      searchSuggestList.value = [];
      clearStream.add(false);
      return;
    }
    clearStream.add(true);
    _debouncer.call(() => querySearchSuggest(value));
  }

  void onClear() {
    if (searchKeyWord.value.isNotEmpty && controller.value.text != '') {
      controller.value.clear();
      searchKeyWord.value = '';
      searchSuggestList.value = [];
      clearStream.add(false);
    } else {
      Get.back();
    }
  }

  // 搜索
  void submit() {
    if (searchKeyWord.value == '') {
      return;
    }
    List arr = historyCacheList.where((e) => e != searchKeyWord.value).toList();
    arr.insert(0, searchKeyWord.value);
    historyCacheList = arr;

    historyList.value = historyCacheList;
    // 手动刷新
    historyList.refresh();
    localCache.put('cacheList', historyCacheList);
    searchFocusNode.unfocus();
    Get.toNamed('/searchResult', parameters: {'keyword': searchKeyWord.value});
  }

  // 获取热搜关键词
  Future queryHotSearchList() async {
    var result = await SearchHttp.hotSearchList();
    if (result['status']) {
      hotSearchList.value = result['data'].list;
    }
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
      if (result['data'] is SearchSuggestModel) {
        searchSuggestList.value = result['data'].tag;
      }
    }
  }

  onSelect(word) {
    searchKeyWord.value = word;
    controller.value.text = word;
    submit();
  }

  onLongSelect(word) {
    int index = historyList.indexOf(word);
    historyList.removeAt(index);
    historyList.refresh();
    localCache.put('cacheList', historyList);
  }

  onClearHis() {
    historyList.value = [];
    historyCacheList = [];
    historyList.refresh();
    localCache.put('cacheList', []);
    SmartDialog.showToast('搜索历史已清空');
  }
}
