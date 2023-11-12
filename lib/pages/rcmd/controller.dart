import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/home/rcmd/result.dart';
import 'package:pilipala/utils/storage.dart';

class RcmdController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int _currentPage = 0;
  RxList<RecVideoItemAppModel> videoList = <RecVideoItemAppModel>[].obs;
  bool isLoadingMore = true;
  OverlayEntry? popupDialog;
  Box recVideo = GStrorage.recVideo;
  Box setting = GStrorage.setting;
  RxInt crossAxisCount = 2.obs;
  late bool enableSaveLastData;

  @override
  void onInit() {
    super.onInit();
    crossAxisCount.value =
        setting.get(SettingBoxKey.customRows, defaultValue: 2);
    if (recVideo.get('cacheList') != null &&
        recVideo.get('cacheList').isNotEmpty) {
      List<RecVideoItemAppModel> list = [];
      for (var i in recVideo.get('cacheList')) {
        list.add(i);
      }
      videoList.value = list;
    }
    enableSaveLastData =
        setting.get(SettingBoxKey.enableSaveLastData, defaultValue: false);
  }

  // 获取推荐
  Future queryRcmdFeed(type) async {
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
        if (videoList.isNotEmpty) {
          videoList.addAll(res['data']);
        } else {
          videoList.value = res['data'];
        }
      } else if (type == 'onRefresh') {
        if (enableSaveLastData) {
          videoList.insertAll(0, res['data']);
        } else {
          videoList.value = res['data'];
        }
      } else if (type == 'onLoad') {
        videoList.addAll(res['data']);
      }
      recVideo.put('cacheList', res['data']);
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
