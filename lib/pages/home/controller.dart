import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/api.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/models_rec_video_item.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  int count = 12;
  int _currentPage = 1;
  int crossAxisCount = 2;
  RxList<RecVideoItemModel> videoList = [RecVideoItemModel()].obs;
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
    List<RecVideoItemModel> list = [];
    for (var i in res.data['data']['item']) {
      print(i);
      list.add(RecVideoItemModel.fromJson(i));
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
    queryRcmdFeed('onRefresh');
  }

  // 上拉加载
  Future onLoad() async {
    await Future.delayed(const Duration(milliseconds: 500));
    queryRcmdFeed('onLoad');
  }
}
