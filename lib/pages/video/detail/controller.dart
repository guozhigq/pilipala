import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/replyReply/index.dart';

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

  int oid = 0;
  // 评论id 请求楼中楼评论使用
  int fRpid = 0;

  ReplyItemModel? firstFloor;

  final scaffoldKey = GlobalKey<ScaffoldState>();

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

  showReplyReplyPanel() {
    PersistentBottomSheetController<void>? ctr = scaffoldKey.currentState?.showBottomSheet<void>((BuildContext context) {
      return
      VideoReplyReplyPanel(
        oid: oid,
        rpid: fRpid,
        closePanel: ()=> {
          fRpid = 0,
      },
        firstFloor: firstFloor,
      );
    });
    ctr?.closed.then((value) {
      fRpid = 0;
    });
  }
}
