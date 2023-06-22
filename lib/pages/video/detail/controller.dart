import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_media_kit/meedu_player.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/video/play/url.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/replyReply/index.dart';

class VideoDetailController extends GetxController {
  int tabInitialIndex = 0;
  // tabs
  RxList<String> tabs = <String>['简介', '评论'].obs;

  // 视频aid
  String bvid = Get.parameters['bvid']!;
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

  Timer? timer;

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

  playerInit(source, audioSource, {Duration defaultST = Duration.zero}) {
    meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: source,
        audioSource: audioSource,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': HttpString.baseUrl
        },
      ),
      autoplay: true,
      looping: false,
      seekTo: defaultST,
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
    print('🐶🐶🐶');
    var result = await VideoHttp.videoUrl(cid: cid, bvid: bvid);
    // log('result: ${result.toString()}');
    if (result['status']) {
      PlayUrlModel data = result['data'];
      // 指定质量的视频 -> 最高质量的视频
      String videoUrl = data.dash!.video!.first.baseUrl!;
      String audioUrl = data.dash!.audio!.first.baseUrl!;
      playerInit(videoUrl, audioUrl,
          defaultST: Duration(milliseconds: data.lastPlayTime!));
    }
  }

  void loopHeartBeat() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      markHeartBeat();
    });
  }

  void markHeartBeat() async {
    Duration progress = meeduPlayerController.position.value;
    await VideoHttp.heartBeat(bvid: bvid, progress: progress.inSeconds);
  }

  @override
  void onClose() {
    markHeartBeat();
    if (timer!.isActive) {
      timer!.cancel();
    }
    super.onClose();
  }
}
