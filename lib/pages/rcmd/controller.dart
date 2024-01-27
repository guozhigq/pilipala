import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/home/rcmd/result.dart';
import 'package:pilipala/models/model_rec_video_item.dart';
import 'package:pilipala/utils/storage.dart';

class RcmdController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int _currentPage = 0;
  RxList<RecVideoItemAppModel> appVideoList = <RecVideoItemAppModel>[].obs;
  RxList<RecVideoItemModel> webVideoList = <RecVideoItemModel>[].obs;
  bool isLoadingMore = true;
  OverlayEntry? popupDialog;
  Box setting = GStrorage.setting;
  RxInt crossAxisCount = 2.obs;
  late bool enableSaveLastData;
  late String defaultRcmdType = 'web';

  @override
  void onInit() {
    super.onInit();
    crossAxisCount.value =
        setting.get(SettingBoxKey.customRows, defaultValue: 2);
    enableSaveLastData =
        setting.get(SettingBoxKey.enableSaveLastData, defaultValue: false);
    defaultRcmdType =
        setting.get(SettingBoxKey.defaultRcmdType, defaultValue: 'web');
  }

  // 获取推荐
  Future queryRcmdFeed(type) async {
    print(defaultRcmdType);
    if (defaultRcmdType == 'app') {
      return await queryRcmdFeedApp(type);
    }
    if (defaultRcmdType == 'web') {
      return await queryRcmdFeedWeb(type);
    }
  }

  // 获取app端推荐
  Future queryRcmdFeedApp(type) async {
    if (isLoadingMore == false) {
      return;
    }
    if (type == 'onRefresh') {
      _currentPage = 0;
    }
    var res = await VideoHttp.rcmdVideoListApp(
      freshIdx: _currentPage,
    );
    if (res['status']) {
      if (type == 'init') {
        if (appVideoList.isNotEmpty) {
          appVideoList.addAll(res['data']);
        } else {
          appVideoList.value = res['data'];
        }
      } else if (type == 'onRefresh') {
        if (enableSaveLastData) {
          appVideoList.insertAll(0, res['data']);
        } else {
          appVideoList.value = res['data'];
        }
      } else if (type == 'onLoad') {
        appVideoList.addAll(res['data']);
      }
      _currentPage += 1;
    }
    isLoadingMore = false;
    return res;
  }

  // 获取web端推荐
  Future queryRcmdFeedWeb(type) async {
    if (isLoadingMore == false) {
      return;
    }
    if (type == 'onRefresh') {
      _currentPage = 0;
    }
    var res = await VideoHttp.rcmdVideoList(
      ps: 20,
      freshIdx: _currentPage,
    );
    if (res['status']) {
      if (type == 'init') {
        if (webVideoList.isNotEmpty) {
          webVideoList.addAll(res['data']);
        } else {
          webVideoList.value = res['data'];
        }
      } else if (type == 'onRefresh') {
        if (enableSaveLastData) {
          webVideoList.insertAll(0, res['data']);
        } else {
          webVideoList.value = res['data'];
        }
      } else if (type == 'onLoad') {
        webVideoList.addAll(res['data']);
      }
      _currentPage += 1;
    }
    isLoadingMore = false;
    return res;
  }

  // 下拉刷新
  Future onRefresh() async {
    isLoadingMore = true;
    queryRcmdFeed('onRefresh');
  }

  // 上拉加载
  Future onLoad() async {
    queryRcmdFeed('onLoad');
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
