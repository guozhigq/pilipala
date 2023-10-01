import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/history.dart';

class HistorySearchController extends GetxController {
  final ScrollController scrollController = ScrollController();
  Rx<TextEditingController> controller = TextEditingController().obs;
  final FocusNode searchFocusNode = FocusNode();
  RxString searchKeyWord = ''.obs;
  String hintText = '搜索';
  RxString loadingStatus = 'init'.obs;
  RxString loadingText = '加载中...'.obs;
  bool hasRequest = false;
  late int mid;
  RxString uname = ''.obs;
  int pn = 1;
  int count = 0;
  RxList<HisListItem> historyList = <HisListItem>[].obs;
  RxBool enableMultiple = false.obs;

  // 清空搜索
  void onClear() {
    if (searchKeyWord.value.isNotEmpty && controller.value.text != '') {
      controller.value.clear();
      searchKeyWord.value = '';
    } else {
      Get.back();
    }
  }

  void onChange(value) {
    searchKeyWord.value = value;
  }

  //  提交搜索内容
  void submit() {
    loadingStatus.value = 'loading';
    if (hasRequest) {
      pn = 1;
      searchHistories();
    }
  }

  // 搜索视频
  Future searchHistories({type = 'init'}) async {
    if (type == 'onLoad' && loadingText.value == '没有更多了') {
      return;
    }
    var res = await UserHttp.searchHistory(
      pn: pn,
      keyword: controller.value.text,
    );
    if (res['status']) {
      if (type == 'init' && pn == 1) {
        historyList.value = res['data'].list;
      } else {
        historyList.addAll(res['data'].list);
      }
      count = res['data'].page['total'];
      if (historyList.length == count) {
        loadingText.value = '没有更多了';
      }
      pn += 1;
      hasRequest = true;
    }
    loadingStatus.value = 'finish';
    return res;
  }

  onLoad() {
    searchHistories(type: 'onLoad');
  }

  Future delHistory(kid, business) async {
    String resKid = 'archive_$kid';
    if (business == 'live') {
      resKid = 'live_$kid';
    } else if (business.contains('article')) {
      resKid = 'article_$kid';
    }

    var res = await UserHttp.delHistory(resKid);
    if (res['status']) {
      historyList.removeWhere((e) => e.kid == kid);
      SmartDialog.showToast(res['msg']);
    }
    loadingStatus.value = 'finish';
  }
}
