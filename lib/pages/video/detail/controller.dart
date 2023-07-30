import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/play/url.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/replyReply/index.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/utils/storage.dart';

class VideoDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  int tabInitialIndex = 0;
  TabController? tabCtr;
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
  Timer? timer;
  RxString bgCover = ''.obs;
  Box user = GStrorage.user;
  Box localCache = GStrorage.localCache;
  PlPlayerController plPlayerController = PlPlayerController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments.isNotEmpty) {
      if (Get.arguments.containsKey('videoItem')) {
        preRender = true;
        var args = Get.arguments['videoItem'];
        if (args.pic != null && args.pic != '') {
          videoItem['pic'] = args.pic;
          bgCover.value = args.pic;
        }
      }
      if (Get.arguments.containsKey('pic')) {
        videoItem['pic'] = Get.arguments['pic'];
        bgCover.value = Get.arguments['pic'];
      }
      heroTag = Get.arguments['heroTag'];
    }
    tabCtr = TabController(length: 2, vsync: this);
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
        replyType: ReplyType.video,
        source: 'videoDetail',
      );
    });
    ctr?.closed.then((value) {
      fRpid = 0;
    });
  }

  playerInit(source, audioSource,
      {Duration defaultST = Duration.zero, int duration = 0}) async {
    plPlayerController.setDataSource(
      DataSource(
        videoSource: source,
        audioSource: audioSource,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': HttpString.baseUrl
        },
      ),
      // 硬解
      enableHA: true,
      autoplay: true,
      seekTo: defaultST,
      duration: Duration(milliseconds: duration),
    );
  }

  // 视频链接
  queryVideoUrl() async {
    var result = await VideoHttp.videoUrl(cid: cid, bvid: bvid);
    if (result['status']) {
      PlayUrlModel data = result['data'];
      // 指定质量的视频 -> 最高质量的视频
      String videoUrl = data.dash!.video!.first.baseUrl!;
      String audioUrl =
          data.dash!.audio!.isNotEmpty ? data.dash!.audio!.first.baseUrl! : '';
      playerInit(videoUrl, audioUrl,
          defaultST: Duration(milliseconds: data.lastPlayTime!),
          duration: data.timeLength ?? 0);
    }
  }

  void loopHeartBeat() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      markHeartBeat();
    });
  }

  void markHeartBeat() async {
    if (user.get(UserBoxKey.userMid) == null) {
      return;
    }
    if (localCache.get(LocalCacheKey.historyStatus) == true) {
      return;
    }
    Duration progress = plPlayerController.position.value;
    await VideoHttp.heartBeat(
      bvid: bvid,
      cid: cid,
      progress: progress.inSeconds,
    );
  }

  @override
  void onClose() {
    markHeartBeat();
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    super.onClose();
  }
}
