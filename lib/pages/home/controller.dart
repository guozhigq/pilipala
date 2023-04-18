import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/api.dart';
import 'package:pilipala/http/init.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int count = 12;
  int _currentPage = 1;
  int crossAxisCount = 2;
  RxList videoList = [].obs;
  bool isLoadingMore = false;
  @override
  void onInit() {
    super.onInit();
    queryRcmdFeed('init');
  }

  // 获取推荐
  Future queryRcmdFeed(type) async {
    var res = await Request().get(
      Api.recommendList,
      data: {'feed_version': "V3", 'ps': count, 'fresh_idx': _currentPage},
    );
    var data = res.data['data']['item'];
    if (type == 'init') {
      videoList.value = data;
    } else if (type == 'onRefresh') {
      videoList.insertAll(0, data);
    } else if (type == 'onLoad') {
      videoList.addAll(data);
    }
    _currentPage += 1;
    isLoadingMore = false;
  }

  // 下拉刷新
  Future onRefresh() async {
    queryRcmdFeed('onRefresh');
  }

  // 上拉加载
  Future onLoad() async {
    await Future.delayed(const Duration(milliseconds: 500));
    queryRcmdFeed('onLoad');
  }
}
