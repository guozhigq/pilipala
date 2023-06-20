import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/search/hot.dart';
import 'package:pilipala/utils/storage.dart';

class SearchController extends GetxController {
  final FocusNode searchFocusNode = FocusNode();
  RxString searchKeyWord = ''.obs;
  Rx<TextEditingController> controller = TextEditingController().obs;
  List tabs = [
    {'label': '综合', 'id': ''},
    {'label': '视频', 'id': ''},
    {'label': '番剧', 'id': ''},
    {'label': '直播', 'id': ''},
    {'label': '专栏', 'id': ''},
    {'label': '用户', 'id': ''}
  ];
  List<HotSearchItem> hotSearchList = [];
  Box hotKeyword = GStrorage.hotKeyword;

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
      onClickKeyword(Get.parameters['keyword']!);
    }
  }

  void onChange(value) {
    searchKeyWord.value = value;
  }

  void onClear() {
    controller.value.clear();
    searchKeyWord.value = '';
  }

  void submit(value) {
    searchKeyWord.value = value;
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
    print(keyword);
    searchKeyWord.value = keyword;
    controller.value.text = keyword;
    // 移动光标
    controller.value.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.value.text.length),
    );
  }
}
