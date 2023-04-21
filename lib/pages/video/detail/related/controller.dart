import 'dart:convert';

import 'package:get/get.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/model_hot_video_item.dart';

class ReleatedController extends GetxController {
  // 视频aid
  String aid = Get.parameters['aid']!;
  // 推荐视频列表
  List relatedVideoList = [];

  Future<dynamic> queryVideoRecommend() async {
    try {
      var res = await VideoHttp.videoRecommend({'aid': aid});
      List<HotVideoItemModel> list = [];
      try {
        for (var i in res.data['data']) {
          list.add(HotVideoItemModel.fromJson(i));
        }
        relatedVideoList = list;
      } catch (err) {
        return err.toString();
      }

      return res.data['data'];
    } catch (err) {
      return err.toString();
    }
  }
}
