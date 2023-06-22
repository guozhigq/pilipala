import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/video.dart';

class ReleatedController extends GetxController {
  // 视频aid
  String bvid = Get.parameters['bvid']!;
  // 推荐视频列表
  List relatedVideoList = [];

  OverlayEntry? popupDialog;

  Future<dynamic> queryRelatedVideo() => VideoHttp.relatedVideoList(bvid: bvid);
}
