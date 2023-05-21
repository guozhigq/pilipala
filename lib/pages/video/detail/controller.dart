import 'package:get/get.dart';
import 'package:pilipala/models/video/reply/item.dart';

class VideoDetailController extends GetxController {
  int tabInitialIndex = 0;
  // tabs
  RxList<String> tabs = <String>['简介', '评论'].obs;

  // 视频aid
  String aid = Get.parameters['aid']!;

  // 是否预渲染 骨架屏
  bool preRender = false;

  // 视频详情 上个页面传入
  Map videoItem = {};

  // 请求状态
  RxBool isLoading = false.obs;

  String heroTag = '';

  RxInt oid = 0.obs;
  // 评论id 请求楼中楼评论使用
  RxInt fRpid = 0.obs;

  ReplyItemModel? firstFloor;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments.isNotEmpty) {
      if (Get.arguments.containsKey('videoItem')) {
        preRender = true;
        var args = Get.arguments['videoItem'];
        if (args.pic != null && args.pic != '') {
          videoItem['pic'] = args.pic;
        }
      }
      heroTag = Get.arguments['heroTag'];
    }
  }
}
