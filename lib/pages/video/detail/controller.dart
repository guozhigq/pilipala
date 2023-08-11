import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/models/video/play/quality.dart';
import 'package:pilipala/models/video/play/url.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/replyReply/index.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/utils.dart';

class VideoDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// 路由传参
  String bvid = Get.parameters['bvid']!;
  int cid = int.parse(Get.parameters['cid']!);
  String heroTag = Get.arguments['heroTag'];
  // 视频详情
  Map videoItem = {};
  // 视频类型 默认投稿视频
  SearchType videoType = Get.arguments['videoType'] ?? SearchType.video;

  /// tabs相关配置
  int tabInitialIndex = 0;
  late TabController tabCtr;
  RxList<String> tabs = <String>['简介', '评论'].obs;

  // 请求返回的视频信息
  late PlayUrlModel data;
  // 请求状态
  RxBool isLoading = false.obs;

  /// 播放器配置 画质 音质 解码格式
  late VideoQuality currentVideoQa;
  late AudioQuality currentAudioQa;
  late VideoDecodeFormats currentDecodeFormats;
  PlPlayerController plPlayerController = PlPlayerController();
  // 是否开始自动播放 存在多p的情况下，第二p需要为true
  RxBool autoPlay = true.obs;
  // 视频资源是否有效
  RxBool isEffective = true.obs;
  // 封面图的展示
  RxBool isShowCover = true.obs;
  // 硬解
  RxBool enableHA = true.obs;

  /// 本地存储
  Box user = GStrorage.user;
  Box localCache = GStrorage.localCache;
  Box setting = GStrorage.setting;

  int oid = 0;
  // 评论id 请求楼中楼评论使用
  int fRpid = 0;

  ReplyItemModel? firstFloor;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    Map argMap = Get.arguments;
    var keys = argMap.keys.toList();
    if (keys.isNotEmpty) {
      if (keys.contains('videoItem')) {
        var args = argMap['videoItem'];
        if (args.pic != null && args.pic != '') {
          videoItem['pic'] = args.pic;
        }
      }
      if (keys.contains('pic')) {
        videoItem['pic'] = argMap['pic'];
      }
    }
    tabCtr = TabController(length: 2, vsync: this);
    autoPlay.value =
        setting.get(SettingBoxKey.autoPlayEnable, defaultValue: true);
    enableHA.value = setting.get(SettingBoxKey.enableHA, defaultValue: true);
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

    /// 根据currentVideoQa和currentDecodeFormats 重新设置videoUrl
    List<VideoItem> videoList =
        data.dash!.video!.where((i) => i.id == currentVideoQa.code).toList();
    VideoItem firstVideo = videoList
        .firstWhere((i) => i.codecs!.startsWith(currentDecodeFormats.code));

    /// 根据currentAudioQa 重新设置audioUrl
    AudioItem firstAudio =
        data.dash!.audio!.firstWhere((i) => i.id == currentAudioQa.code);
    String audioUrl = firstAudio.baseUrl ?? '';

    playerInit(firstVideo, audioUrl, defaultST: position);
  }

  Future playerInit(firstVideo, audioSource,
      {Duration defaultST = Duration.zero, int duration = 0}) async {
    await plPlayerController.setDataSource(
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
      enableHA: enableHA.value,
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
  Future queryVideoUrl() async {
    var result = await VideoHttp.videoUrl(cid: cid, bvid: bvid);
    if (result['status']) {
      data = result['data'];

      /// 优先顺序 省流模式 -> 设置中指定质量 -> 当前可选的最高质量
      List<VideoItem> allVideosList = data.dash!.video!;
      late VideoItem firstVideo;

      try {
        // 当前可播放的最高质量视频
        int currentHighVideoQa = allVideosList.first.quality!.code;
        //
        int cacheVideoQa = setting.get(SettingBoxKey.defaultVideoQa,
            defaultValue: currentHighVideoQa);
        int resVideoQa = currentHighVideoQa;
        if (cacheVideoQa <= currentHighVideoQa) {
          List<int> numbers = data.acceptQuality!
              .where((e) => e <= currentHighVideoQa)
              .toList();
          resVideoQa = Utils.findClosestNumber(cacheVideoQa, numbers);
        }
        currentVideoQa = VideoQualityCode.fromCode(resVideoQa)!;

        /// 取出符合当前画质的videoList
        List<VideoItem> videosList =
            allVideosList.where((e) => e.quality!.code == resVideoQa).toList();

        /// 优先顺序 设置中指定解码格式 -> 当前可选的首个解码格式
        List<FormatItem> supportFormats = data.supportFormats!;
        // 根据画质选编码格式
        List supportDecodeFormats =
            supportFormats.firstWhere((e) => e.quality == resVideoQa).codecs!;

        try {
          currentDecodeFormats = VideoDecodeFormatsCode.fromString(setting.get(
              SettingBoxKey.defaultDecode,
              defaultValue: supportDecodeFormats.first))!;
        } catch (_) {}

        /// 取出符合当前解码格式的videoItem
        firstVideo = videosList
            .firstWhere((e) => e.codecs!.startsWith(currentDecodeFormats.code));
      } catch (_) {}

      /// 优先顺序 设置中指定质量 -> 当前可选的最高质量
      late AudioItem firstAudio;
      List audiosList = data.dash!.audio!;
      try {
        if (audiosList.isNotEmpty) {
          firstAudio = audiosList.first;
          int resultAudioQa = setting.get(SettingBoxKey.defaultAudioQa,
              defaultValue: firstAudio.id);
          // 选择最接近的那个音轨
          firstAudio = audiosList.firstWhere(
            (e) => e.id == resultAudioQa,
            orElse: () => AudioItem(),
          );
        } else {
          firstAudio = AudioItem();
        }
      } catch (_) {}

      String audioUrl = firstAudio.baseUrl ?? '';
      //
      if (firstAudio.id != null) {
        currentAudioQa = AudioQualityCode.fromCode(firstAudio.id!)!;
      }

      await playerInit(
        firstVideo,
        audioUrl,
        defaultST: Duration(milliseconds: data.lastPlayTime!),
        duration: data.timeLength ?? 0,
      );
    } else {
      SmartDialog.showToast(result['msg'].toString());
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
