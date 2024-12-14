import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/models/member/archive.dart';

class MemberSearchController extends GetxController
    with GetTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  TextEditingController textController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  RxString searchKeyWord = ''.obs;
  late int mid;
  RxString uname = ''.obs;

  // 投稿相关
  final int ps = 30;
  int archivePn = 1;
  int _archiveCount = 0;
  RxString loadingArchiveText = '加载中...'.obs;
  RxList<VListItemModel> archiveList = <VListItemModel>[].obs;

  // 动态相关
  String dynamicOffset = '';
  int dynamicPn = 1;
  int _dynamicCount = 0;
  bool dynamicHasMore = true;
  RxString loadingDynamicText = '加载中...'.obs;
  RxList<DynamicItemModel> dynamicList = <DynamicItemModel>[].obs;

  late TabController tabController;
  RxList<String> tabs = <String>['视频', '动态'].obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    uname.value = Get.parameters['uname']!;
    tabController = TabController(length: tabs.length, vsync: this);
  }

  // 清空搜索
  void onClear() {
    if (textController.text.isNotEmpty) {
      textController.clear();
      searchKeyWord.value = '';
      tabController.index = 0;
      reset();
    } else {
      Get.back();
    }
  }

  //  提交搜索内容
  void submit() {
    if (searchKeyWord.value != textController.text) {
      reset();
      searchKeyWord.value = textController.text;
    }
  }

  // 搜索视频
  Future searchArchives({type = 'init'}) async {
    if (type == 'onLoad' && loadingArchiveText.value == '没有更多了') {
      return;
    }
    var res = await MemberHttp.memberArchive(
      mid: mid,
      pn: archivePn,
      keyword: textController.text,
      order: 'pubdate',
    );
    if (res['status']) {
      if (type == 'init' || archivePn == 1) {
        archiveList.value = res['data'].list.vlist;
        _archiveCount = res['data'].page['count'];
        setCount();
      } else {
        archiveList.addAll(res['data'].list.vlist);
      }
      if (archiveList.length == _archiveCount) {
        loadingArchiveText.value = '没有更多了';
      }
      archivePn += 1;
    }
    return res;
  }

  // 搜索动态
  Future searchDynamic({type = 'init'}) async {
    if (!dynamicHasMore) {
      return;
    }
    var res = await MemberHttp.memberDynamicSearch(
      pn: dynamicPn,
      mid: mid,
      offset: dynamicOffset,
      keyword: textController.text,
    );
    if (res['status']) {
      dynamicOffset = res['data'].offset;
      dynamicHasMore = res['data'].hasMore;
      if (type == 'init') {
        dynamicList.value = res['data'].items;
        _dynamicCount = res['data'].total;
        setCount();
      } else {
        dynamicList.addAll(res['data'].items);
      }
      if (!dynamicHasMore) {
        loadingDynamicText.value = '没有更多了';
      }
      dynamicPn += 1;
    }
    return res;
  }

  //
  onLoad() {
    if (tabController.index == 0) {
      searchArchives(type: 'onLoad');
    } else {
      searchDynamic(type: 'onLoad');
    }
  }

  // 重置状态
  void reset() {
    archiveList.clear();
    dynamicList.clear();
    archivePn = 1;
    dynamicPn = 1;
    dynamicOffset = '';
    dynamicHasMore = true;
    _archiveCount = 0;
    _dynamicCount = 0;
    loadingArchiveText.value = '加载中...';
    loadingDynamicText.value = '加载中...';
  }

  setCount() {
    tabs.value = [
      "视频${_archiveCount > 0 ? '($_archiveCount)' : ''}",
      "动态${_dynamicCount > 0 ? '($_dynamicCount)' : ''}"
    ];
  }
}
