import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_media_kit/meedu_player.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/replyReply/index.dart';

class VideoDetailController extends GetxController {
  int tabInitialIndex = 0;
  // tabs
  RxList<String> tabs = <String>['简介', '评论'].obs;

  // 视频aid
  int aid = int.parse(Get.parameters['aid']!);
  int cid = int.parse(Get.parameters['cid']!);

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

  MeeduPlayerController meeduPlayerController = MeeduPlayerController(
    colorTheme: Theme.of(Get.context!).colorScheme.primary,
    pipEnabled: true,
    controlsStyle: ControlsStyle.youtube,
    enabledButtons: const EnabledButtons(pip: true),
  );

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
      if (Get.arguments.containsKey('pic')) {
        videoItem['pic'] = Get.arguments['pic'];
      }
      heroTag = Get.arguments['heroTag'];
    }
    queryVideoUrl();
  }

  showReplyReplyPanel() {
    PersistentBottomSheetController<void>? ctr =
        scaffoldKey.currentState?.showBottomSheet<void>((BuildContext context) {
      return VideoReplyReplyPanel(
        oid: oid,
        rpid: fRpid,
        closePanel: () => {
          fRpid = 0,
        },
        firstFloor: firstFloor,
      );
    });
    ctr?.closed.then((value) {
      fRpid = 0;
    });
  }

  playerInit(url) {
    meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: url,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': HttpString.baseUrl
        },
      ),
      autoplay: true,
      looping: false
    );
  }

  // Future<void> meeduDispose() async {
  //   if (meeduPlayerController != null) {
  //     _playerEventSubs?.cancel();
  //     await meeduPlayerController!.dispose();
  //     meeduPlayerController = null;
  //     // The next line disables the wakelock again.
  //     // await Wakelock.disable();
  //   }
  // }

  // 视频链接
  queryVideoUrl() async {
    var result = await VideoHttp.videoUrl(cid: cid, avid: aid);
    var url = result['data']['durl'].first['url'];
    playerInit(url);
  }
}
