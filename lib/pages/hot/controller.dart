import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/api.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/model_hot_video_item.dart';

class HotController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final int _count = 20;
  int _currentPage = 1;
  RxList<HotVideoItemModel> videoList = [HotVideoItemModel()].obs;
  bool isLoadingMore = false;
  bool flag = false;
  OverlayEntry? popupDialog;

  @override
  void onInit() {
    super.onInit();
    queryHotFeed('init');
  }

  // 获取推荐
  Future queryHotFeed(type) async {
    var res = await Request().get(
      Api.hotList,
      data: {'pn': _currentPage, 'ps': _count},
    );
    List<HotVideoItemModel> list = [];
    for (var i in res.data['data']['list']) {
      list.add(HotVideoItemModel.fromJson(i));
    }
    if (type == 'init') {
      videoList.value = list;
    } else if (type == 'onRefresh') {
      videoList.insertAll(0, list);
    } else if (type == 'onLoad') {
      videoList.addAll(list);
    }
    _currentPage += 1;
    isLoadingMore = false;
  }

  // 下拉刷新
  Future onRefresh() async {
    queryHotFeed('onRefresh');
  }

  // 上拉加载
  Future onLoad() async {
    queryHotFeed('onLoad');
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
