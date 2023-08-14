import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/home/rcmd/result.dart';
import 'package:pilipala/models/model_rec_video_item.dart';
import 'package:pilipala/utils/storage.dart';

class RcmdController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int count = 12;
  int _currentPage = 0;
  int crossAxisCount = 2;
  RxList<RecVideoItemAppModel> videoList = [RecVideoItemAppModel()].obs;
  bool isLoadingMore = false;
  bool flag = false;
  OverlayEntry? popupDialog;
  Box recVideo = GStrorage.recVideo;

  @override
  void onInit() {
    super.onInit();
    // if (recVideo.get('cacheList') != null &&
    //     recVideo.get('cacheList').isNotEmpty) {
    //   List<RecVideoItemModel> list = [];
    //   for (var i in recVideo.get('cacheList')) {
    //     list.add(i);
    //   }
    //   videoList.value = list;
    // }
  }

  // 获取推荐
  Future queryRcmdFeed(type) async {
    if (type == 'onRefresh') {
      _currentPage = 0;
    }
    var res = await VideoHttp.rcmdVideoListApp(
      ps: count,
      freshIdx: _currentPage,
    );
    if (res['status']) {
      if (type == 'init') {
        if (videoList.length > 1) {
          videoList.addAll(res['data']);
        } else {
          videoList.value = res['data'];
        }
      } else if (type == 'onRefresh') {
        videoList.insertAll(0, res['data']);
      } else if (type == 'onLoad') {
        videoList.addAll(res['data']);
      }
      // recVideo.put('cacheList', res['data']);
      _currentPage += 1;
    }
    isLoadingMore = false;
    return res;
  }

  // 下拉刷新
  Future onRefresh() async {
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
