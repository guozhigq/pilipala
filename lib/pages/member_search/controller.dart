import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/member/archive.dart';

class MemberSearchController extends GetxController {
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
  int archivePn = 1;
  int archiveCount = 0;
  RxList<VListItemModel> archiveList = <VListItemModel>[].obs;
  int dynamic_pn = 1;
  RxList<VListItemModel> dynamicList = <VListItemModel>[].obs;

  int ps = 30;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    uname.value = Get.parameters['uname']!;
  }

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
      archivePn = 1;
      searchArchives();
    }
  }

  // 搜索视频
  Future searchArchives({type = 'init'}) async {
    if (type == 'onLoad' && loadingText.value == '没有更多了') {
      return;
    }
    var res = await MemberHttp.memberArchive(
      mid: mid,
      pn: archivePn,
      keyword: controller.value.text,
      order: 'pubdate',
    );
    if (res['status']) {
      if (type == 'init' || archivePn == 1) {
        archiveList.value = res['data'].list.vlist;
      } else {
        archiveList.addAll(res['data'].list.vlist);
      }
      archiveCount = res['data'].page['count'];
      if (archiveList.length == archiveCount) {
        loadingText.value = '没有更多了';
      }
      archivePn += 1;
      hasRequest = true;
    }
    // loadingStatus.value = 'finish';
    return res;
  }

  // 搜索动态
  Future searchDynamic() async {}

  //
  onLoad() {
    searchArchives(type: 'onLoad');
  }
}
