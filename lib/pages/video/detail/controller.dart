import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/play/quality.dart';
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
  late PlayUrlModel data;
  // 当前画质
  late VideoQuality currentVideoQa;
  // 当前音质
  late AudioQuality currentAudioQa;

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
  // 是否开始自动播放 存在多p的情况下，第二p需要为true
  RxBool autoPlay = true.obs;
  // 视频资源是否有效
  RxBool isEffective = true.obs;

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

  /// 更新画质、音质
  /// TODO 继续进度播放
  updatePlayer() {
    Duration position = plPlayerController.position.value;
    plPlayerController.removeListeners();
    plPlayerController.isBuffering.value = false;
    plPlayerController.buffered.value = Duration.zero;

    /// 暂不匹配解码规则

    /// 根据currentVideoQa 重新设置videoUrl
    VideoItem firstVideo =
        data.dash!.video!.firstWhere((i) => i.id == currentVideoQa.code);
    // String videoUrl = firstVideo.baseUrl!;

    /// 根据currentAudioQa 重新设置audioUrl
    AudioItem firstAudio =
        data.dash!.audio!.firstWhere((i) => i.id == currentAudioQa.code);
    String audioUrl = firstAudio.baseUrl ?? '';

    playerInit(firstVideo, audioUrl, defaultST: position);
  }

  playerInit(firstVideo, audioSource,
      {Duration defaultST = Duration.zero, int duration = 0}) async {
    plPlayerController.setDataSource(
      DataSource(
        videoSource: firstVideo.baseUrl,
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
      autoplay: autoPlay.value,
      seekTo: defaultST,
      duration: Duration(milliseconds: duration),
      // 宽>高 水平 否则 垂直
      direction:
          firstVideo.width - firstVideo.height > 0 ? 'horizontal' : 'vertical',
    );
  }

  // 手动点击播放
  handlePlay() {
    plPlayerController.togglePlay();
  }

  // 视频链接
  queryVideoUrl() async {
    var result = await VideoHttp.videoUrl(cid: cid, bvid: bvid);
    if (result['status']) {
      data = result['data'];

      /// 优先顺序 省流模式 -> 设置中指定质量 -> 当前可选的最高质量
      VideoItem firstVideo = data.dash!.video!.first;
      // String videoUrl = firstVideo.baseUrl!;
      //
      currentVideoQa = VideoQualityCode.fromCode(firstVideo.id!)!;

      /// 优先顺序 设置中指定质量 -> 当前可选的最高质量
      AudioItem firstAudio =
          data.dash!.audio!.isNotEmpty ? data.dash!.audio!.first : AudioItem();
      String audioUrl = firstAudio.baseUrl ?? '';
      //
      if (firstAudio.id != null) {
        currentAudioQa = AudioQualityCode.fromCode(firstAudio.id!)!;
      }
      playerInit(
        firstVideo,
        audioUrl,
        defaultST: Duration(milliseconds: data.lastPlayTime!),
        duration: data.timeLength ?? 0,
      );
    }
    return result;
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
