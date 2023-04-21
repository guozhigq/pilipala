import 'package:get/get.dart';
import 'package:pilipala/http/video.dart';

class ReleatedController extends GetxController {
  // 视频aid
  String aid = Get.parameters['aid']!;
  // 推荐视频列表
  List relatedVideoList = [];

  Future<dynamic> queryRelatedVideo() => VideoHttp.relatedVideoList(aid);
}
