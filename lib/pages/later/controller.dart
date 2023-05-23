import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/model_hot_video_item.dart';

class LaterController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxList<HotVideoItemModel> laterList = [HotVideoItemModel()].obs;
  int count = 0;

  Future queryLaterList() async {
    var res = await UserHttp.seeYouLater();
    if (res['status']) {
      laterList.value = res['data']['list'];
      count = res['data']['count'];
    }
    return res;
  }
}
