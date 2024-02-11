import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:floating/floating.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nil/nil.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/pages/bangumi/introduction/index.dart';
import 'package:pilipala/pages/danmaku/view.dart';
import 'package:pilipala/pages/video/detail/reply/index.dart';
import 'package:pilipala/pages/video/detail/controller.dart';
import 'package:pilipala/pages/video/detail/introduction/index.dart';
import 'package:pilipala/pages/video/detail/related/index.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/plugin/pl_player/models/play_repeat.dart';
import 'package:pilipala/services/service_locator.dart';
import 'package:pilipala/utils/storage.dart';

import 'package:pilipala/plugin/pl_player/utils/fullscreen.dart';
import '../../../services/shutdown_timer_service.dart';
import 'widgets/header_control.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({Key? key}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin, RouteAware {
  late VideoDetailController videoDetailController;
  PlPlayerController? plPlayerController;
  final ScrollController _extendNestCtr = ScrollController();
  late StreamController<double> appbarStream;
  late VideoIntroController videoIntroController;
  late BangumiIntroController bangumiIntroController;
  late String heroTag;

  PlayerStatus playerStatus = PlayerStatus.playing;
  double doubleOffset = 0;

  final Box<dynamic> localCache = GStrorage.localCache;
  final Box<dynamic> setting = GStrorage.setting;
  late double statusBarHeight;
  final double videoHeight = Get.size.width * 9 / 16;
  late Future _futureBuilderFuture;
  // 自动退出全屏
  late bool autoExitFullcreen;
  late bool autoPlayEnable;
  late bool horizontalScreen;
  late bool autoPiP;
  final Floating floating = Floating();
  // 生命周期监听
  late final AppLifecycleListener _lifecycleListener;
  bool isShowing = true;
  RxBool isFullScreen = false.obs;

  @override
  void initState() {
    super.initState();
    heroTag = Get.arguments['heroTag'];
    videoDetailController = Get.put(VideoDetailController(), tag: heroTag);
    videoIntroController = Get.put(VideoIntroController(), tag: heroTag);
    videoIntroController.videoDetail.listen((value) {
      videoPlayerServiceHandler.onVideoDetailChange(
          value, videoDetailController.cid.value);
    });
    bangumiIntroController = Get.put(BangumiIntroController(), tag: heroTag);
    bangumiIntroController.bangumiDetail.listen((value) {
      videoPlayerServiceHandler.onVideoDetailChange(
          value, videoDetailController.cid.value);
    });
    videoDetailController.cid.listen((p0) {
      videoPlayerServiceHandler.onVideoDetailChange(
          bangumiIntroController.bangumiDetail.value, p0);
    });
    statusBarHeight = localCache.get('statusBarHeight');
    autoExitFullcreen =
        setting.get(SettingBoxKey.enableAutoExit, defaultValue: false);
    horizontalScreen =
        setting.get(SettingBoxKey.horizontalScreen, defaultValue: false);
    autoPlayEnable =
        setting.get(SettingBoxKey.autoPlayEnable, defaultValue: true);
    autoPiP = setting.get(SettingBoxKey.autoPiP, defaultValue: false);
    videoDetailController
        .setTriggerFullScreenCallback(triggerFullScreenCallback);
    videoSourceInit();
    appbarStreamListen();
    lifecycleListener();
  }

  // 获取视频资源，初始化播放器
  Future<void> videoSourceInit() async {
    _futureBuilderFuture = videoDetailController.queryVideoUrl();
    if (videoDetailController.autoPlay.value) {
      plPlayerController = videoDetailController.plPlayerController;
      plPlayerController!.addStatusLister(playerListener);
    }
  }

  // 流
  appbarStreamListen() {
    appbarStream = StreamController<double>();
    _extendNestCtr.addListener(
      () {
        final double offset = _extendNestCtr.position.pixels;
        appbarStream.add(offset);
      },
    );
  }

  // 播放器状态监听
  void playerListener(PlayerStatus? status) async {
    playerStatus = status!;
    if (status == PlayerStatus.completed) {
      // 结束播放退出全屏
      if (autoExitFullcreen) {
        plPlayerController!.triggerFullScreen(status: false);
      }
      shutdownTimerService.handleWaitingFinished();

      /// 顺序播放 列表循环
      if (plPlayerController!.playRepeat != PlayRepeat.pause &&
          plPlayerController!.playRepeat != PlayRepeat.singleCycle) {
        if (videoDetailController.videoType == SearchType.video) {
          videoIntroController.nextPlay();
        }
        if (videoDetailController.videoType == SearchType.media_bangumi) {
          bangumiIntroController.nextPlay();
        }
      }

      /// 单个循环
      if (plPlayerController!.playRepeat == PlayRepeat.singleCycle) {
        plPlayerController!.seekTo(Duration.zero);
        plPlayerController!.play();
      }
      // 播放完展示控制栏
      try {
        PiPStatus currentStatus =
            await videoDetailController.floating!.pipStatus;
        if (currentStatus == PiPStatus.disabled) {
          plPlayerController!.onLockControl(false);
        }
      } catch (_) {}
    }
  }

  // 继续播放或重新播放
  void continuePlay() async {
    await _extendNestCtr.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    plPlayerController!.play();
  }

  /// 未开启自动播放时触发播放
  Future<void> handlePlay() async {
    videoDetailController
        .setTriggerFullScreenCallback(triggerFullScreenCallback);
    await videoDetailController.playerInit();
    plPlayerController = videoDetailController.plPlayerController;
    plPlayerController!.addStatusLister(playerListener);
    videoDetailController.autoPlay.value = true;
    videoDetailController.isShowCover.value = false;
  }

  // 生命周期监听
  void lifecycleListener() {
    _lifecycleListener = AppLifecycleListener(
      onResume: () => _handleTransition('resume'),
      // 后台
      onInactive: () => _handleTransition('inactive'),
      // 在Android和iOS端不生效
      onHide: () => _handleTransition('hide'),
      onShow: () => _handleTransition('show'),
      onPause: () => _handleTransition('pause'),
      onRestart: () => _handleTransition('restart'),
      onDetach: () => _handleTransition('detach'),
      // 只作用于桌面端
      onExitRequested: () {
        ScaffoldMessenger.maybeOf(context)
            ?.showSnackBar(const SnackBar(content: Text("拦截应用退出")));
        return Future.value(AppExitResponse.cancel);
      },
    );
  }

  @override
  void dispose() {
    shutdownTimerService.handleWaitingFinished();
    if (plPlayerController != null) {
      plPlayerController!.removeStatusLister(playerListener);
      plPlayerController!.dispose();
    }
    if (videoDetailController.floating != null) {
      videoDetailController.floating!.dispose();
    }
    videoPlayerServiceHandler.onVideoDetailDispose();
    floating.dispose();
    _lifecycleListener.dispose();
    exitFullScreen();
    super.dispose();
  }

  @override
  // 离开当前页面时
  void didPushNext() async {
    /// 开启
    if (setting.get(SettingBoxKey.enableAutoBrightness, defaultValue: false)
        as bool) {
      videoDetailController.brightness = plPlayerController!.brightness.value;
    }
    if (plPlayerController != null) {
      videoDetailController.defaultST = plPlayerController!.position.value;
      videoIntroController.isPaused = true;
      plPlayerController!.removeStatusLister(playerListener);
      plPlayerController!.pause();
    }
    setState(() => isShowing = false);
    super.didPushNext();
  }

  @override
  // 返回当前页面时
  void didPopNext() async {
    setState(() => isShowing = true);
    videoDetailController.isFirstTime = false;
    final bool autoplay = autoPlayEnable;
    videoDetailController
        .setTriggerFullScreenCallback(triggerFullScreenCallback);
    videoDetailController.playerInit(autoplay: autoplay);

    /// 未开启自动播放时，未播放跳转下一页返回/播放后跳转下一页返回
    videoDetailController.autoPlay.value =
        !videoDetailController.isShowCover.value;
    videoIntroController.isPaused = false;
    if (_extendNestCtr.position.pixels == 0 && autoplay) {
      await Future.delayed(const Duration(milliseconds: 300));
      plPlayerController?.seekTo(videoDetailController.defaultST);
      plPlayerController?.play();
    }
    plPlayerController?.addStatusLister(playerListener);
    super.didPopNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    VideoDetailPage.routeObserver
        .subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  void _handleTransition(String name) {
    switch (name) {
      case 'inactive':
        if (plPlayerController != null &&
            playerStatus == PlayerStatus.playing) {
          autoEnterPip();
        }
        break;
    }
  }

  void autoEnterPip() {
    final String routePath = Get.currentRoute;
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    /// TODO 横屏全屏状态下误触pip
    if (autoPiP && routePath.startsWith('/video') && isPortrait) {
      floating.enable(
          aspectRatio: Rational(
        videoDetailController.data.dash!.video!.first.width!,
        videoDetailController.data.dash!.video!.first.height!,
      ));
    }
  }

  void triggerFullScreenCallback({bool? status}) {
    // SmartDialog.showToast('triggerFullScreen $status $isFullScreen.value');
    setState(() {
      isFullScreen.value = status ?? !isFullScreen.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget childWhenDisabled = SafeArea(
      top: MediaQuery.of(context).orientation == Orientation.portrait &&
          isFullScreen.value == true,
      bottom: MediaQuery.of(context).orientation == Orientation.portrait &&
          isFullScreen.value == true,
      left: false, //isFullScreen != true,
      right: false, //isFullScreen != true,
      child: Stack(
        children: [
          Scaffold(
              resizeToAvoidBottomInset: false,
              key: videoDetailController.scaffoldKey,
              backgroundColor: Colors.black,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              body: Column(
                children: [
                  Obx(
                    () {
                      if (MediaQuery.of(context).orientation ==
                              Orientation.landscape ||
                          isFullScreen.value == true) {
                        enterFullScreen();
                      } else {
                        exitFullScreen();
                      }
                      final double videoheight = Get.width * 9 / 16;
                      final double videowidth = Get.width;
                      return SizedBox(
                        height: MediaQuery.of(context).orientation ==
                                    Orientation.landscape ||
                                isFullScreen.value == true
                            ? MediaQuery.sizeOf(context).height -
                                (MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? 0
                                    : MediaQuery.of(context).padding.top)
                            : videoheight,
                        width: MediaQuery.of(context).size.width,
                        child: PopScope(
                            canPop: isFullScreen.value != true,
                            onPopInvoked: (bool didPop) {
                              if (isFullScreen.value == true) {
                                plPlayerController!
                                    .triggerFullScreen(status: false);
                              }
                              if (MediaQuery.of(context).orientation ==
                                      Orientation.landscape &&
                                  !horizontalScreen) {
                                verticalScreen();
                              }
                            },
                            child: Stack(
                              children: <Widget>[
                                if (isShowing)
                                  FutureBuilder(
                                      future: _futureBuilderFuture,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data['status']) {
                                          return Obx(
                                            () => !videoDetailController
                                                        .autoPlay.value ||
                                                    plPlayerController ==
                                                        null ||
                                                    plPlayerController!
                                                            .videoController ==
                                                        null
                                                ? nil
                                                : PLVideoPlayer(
                                                    controller:
                                                        plPlayerController!,
                                                    headerControl:
                                                        videoDetailController
                                                            .headerControl,
                                                    danmuWidget: Obx(
                                                      () => PlDanmaku(
                                                        key: Key(
                                                            videoDetailController
                                                                .danmakuCid
                                                                .value
                                                                .toString()),
                                                        cid:
                                                            videoDetailController
                                                                .danmakuCid
                                                                .value,
                                                        playerController:
                                                            plPlayerController!,
                                                      ),
                                                    ),
                                                  ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      }),

                                /// 关闭自动播放时 手动播放
                                if (!videoDetailController
                                    .autoPlay.value) ...<Widget>[
                                  Obx(
                                    () => Visibility(
                                      visible: videoDetailController
                                          .isShowCover.value,
                                      child: Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            handlePlay();
                                          },
                                          child: NetworkImgLayer(
                                            type: 'emote',
                                            src: videoDetailController
                                                .videoItem['pic'],
                                            width: videowidth,
                                            height: videoheight,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => Visibility(
                                        visible: videoDetailController
                                                .isShowCover.value &&
                                            videoDetailController
                                                .isEffective.value,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              right: 0,
                                              child: AppBar(
                                                primary: false,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                scrolledUnderElevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                actions: [
                                                  IconButton(
                                                    tooltip: '稍后再看',
                                                    onPressed: () async {
                                                      var res = await UserHttp
                                                          .toViewLater(
                                                              bvid:
                                                                  videoDetailController
                                                                      .bvid);
                                                      SmartDialog.showToast(
                                                          res['msg']);
                                                    },
                                                    icon: const Icon(
                                                        Icons.history_outlined),
                                                  ),
                                                  const SizedBox(width: 14)
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 12,
                                              bottom: 10,
                                              child: IconButton(
                                                  tooltip: '播放',
                                                  onPressed: () => handlePlay(),
                                                  icon: Image.asset(
                                                    'assets/images/play.png',
                                                    width: 60,
                                                    height: 60,
                                                  )),
                                            ),
                                          ],
                                        )),
                                  ),
                                ]
                              ],
                            )),
                      );
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).orientation ==
                                Orientation.landscape ||
                            isFullScreen.value == true
                        ? 0
                        : Get.height -
                            Get.width * 9 / 16 -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                    width: MediaQuery.of(context).size.width,
                    child: ColoredBox(
                      key: Key(heroTag),
                      color: Theme.of(context).colorScheme.background,
                      child: Column(
                        children: [
                          Opacity(
                            opacity: 0,
                            child: SizedBox(
                              width: double.infinity,
                              height: 0,
                              child: Obx(
                                () => TabBar(
                                  controller: videoDetailController.tabCtr,
                                  dividerColor: Colors.transparent,
                                  indicatorColor:
                                      Theme.of(context).colorScheme.background,
                                  tabs: videoDetailController.tabs
                                      .map((String name) => Tab(text: name))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: videoDetailController.tabCtr,
                              children: <Widget>[
                                Builder(
                                  builder: (BuildContext context) {
                                    return CustomScrollView(
                                      key: const PageStorageKey<String>('简介'),
                                      slivers: <Widget>[
                                        if (videoDetailController.videoType ==
                                            SearchType.video) ...[
                                          const VideoIntroPanel(),
                                        ] else if (videoDetailController
                                                .videoType ==
                                            SearchType.media_bangumi) ...[
                                          Obx(() => BangumiIntroPanel(
                                              cid: videoDetailController
                                                  .cid.value)),
                                        ],
                                        SliverToBoxAdapter(
                                          child: Divider(
                                            indent: 12,
                                            endIndent: 12,
                                            color: Theme.of(context)
                                                .dividerColor
                                                .withOpacity(0.06),
                                          ),
                                        ),
                                        RelatedVideoPanel(),
                                      ],
                                    );
                                  },
                                ),
                                VideoReplyPanel(
                                  bvid: videoDetailController.bvid,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );

    Widget childWhenDisabledLandscape = SafeArea(
        left: isFullScreen.value != true,
        right: isFullScreen.value != true,
        child: Stack(children: [
          Scaffold(
              resizeToAvoidBottomInset: false,
              key: videoDetailController.scaffoldKey,
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              body: Obx(() {
                // 系数是以下三个方程（分别代表特定平板、折叠屏内屏、普通手机横屏尺寸）的近似解
                // 820x+1180y+983.67z=450
                // 1812x+2176y+1985.68z=680
                // 1080x+2340y+1589.72z=540
                final double videoheight =
                    sqrt(Get.height * Get.width) * 12.972 -
                        Get.height * 7.928 -
                        Get.width * 4.923;
                final double videowidth = videoheight * 16 / 9;
                return Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                            width: isFullScreen.value == true
                                ? Get.width
                                : videowidth,
                            height: isFullScreen.value == true
                                ? Get.height
                                : videoheight,
                            child: PopScope(
                                canPop: isFullScreen.value != true,
                                onPopInvoked: (bool didPop) {
                                  if (isFullScreen.value == true) {
                                    plPlayerController!
                                        .triggerFullScreen(status: false);
                                  }
                                  if (MediaQuery.of(context).orientation ==
                                          Orientation.landscape &&
                                      !horizontalScreen) {
                                    verticalScreen();
                                  }
                                },
                                child: Stack(
                                  children: <Widget>[
                                    if (isShowing)
                                      FutureBuilder(
                                          future: _futureBuilderFuture,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data['status']) {
                                              return Obx(
                                                () => !videoDetailController
                                                            .autoPlay.value ||
                                                        plPlayerController ==
                                                            null ||
                                                        plPlayerController!
                                                                .videoController ==
                                                            null
                                                    ? nil
                                                    : PLVideoPlayer(
                                                        controller:
                                                            plPlayerController!,
                                                        headerControl:
                                                            videoDetailController
                                                                .headerControl,
                                                        danmuWidget: Obx(
                                                          () => PlDanmaku(
                                                            key: Key(
                                                                videoDetailController
                                                                    .danmakuCid
                                                                    .value
                                                                    .toString()),
                                                            cid:
                                                                videoDetailController
                                                                    .danmakuCid
                                                                    .value,
                                                            playerController:
                                                                plPlayerController!,
                                                          ),
                                                        ),
                                                      ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          }),

                                    /// 关闭自动播放时 手动播放
                                    if (!videoDetailController
                                        .autoPlay.value) ...<Widget>[
                                      Obx(
                                        () => Visibility(
                                          visible: videoDetailController
                                              .isShowCover.value,
                                          child: Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                handlePlay();
                                              },
                                              child: NetworkImgLayer(
                                                type: 'emote',
                                                src: videoDetailController
                                                    .videoItem['pic'],
                                                width: videowidth,
                                                height: videoheight,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                            visible: videoDetailController
                                                    .isShowCover.value &&
                                                videoDetailController
                                                    .isEffective.value,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: AppBar(
                                                    primary: false,
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    scrolledUnderElevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    actions: [
                                                      IconButton(
                                                        tooltip: '稍后再看',
                                                        onPressed: () async {
                                                          var res = await UserHttp
                                                              .toViewLater(
                                                                  bvid:
                                                                      videoDetailController
                                                                          .bvid);
                                                          SmartDialog.showToast(
                                                              res['msg']);
                                                        },
                                                        icon: const Icon(Icons
                                                            .history_outlined),
                                                      ),
                                                      const SizedBox(width: 14)
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 12,
                                                  bottom: 10,
                                                  child: IconButton(
                                                      tooltip: '播放',
                                                      onPressed: () =>
                                                          handlePlay(),
                                                      icon: Image.asset(
                                                        'assets/images/play.png',
                                                        width: 60,
                                                        height: 60,
                                                      )),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ]
                                  ],
                                ))),
                        SizedBox(
                          width: isFullScreen.value == true
                              ? Get.width
                              : videowidth,
                          height: isFullScreen.value == true
                              ? 0
                              : Get.height -
                                  videoheight -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom,
                          child: (videoDetailController.videoType ==
                                  SearchType.video)
                              ? const CustomScrollView(
                                  slivers: [VideoIntroPanel()])
                              : (videoDetailController.videoType ==
                                      SearchType.media_bangumi)
                                  ? Obx(() => BangumiIntroPanel(
                                      cid: videoDetailController.cid.value))
                                  : const SizedBox(),
                        )
                      ],
                    ),
                    SizedBox(
                      width: isFullScreen.value == true
                          ? 0
                          : (Get.width -
                              MediaQuery.of(context).padding.left -
                              MediaQuery.of(context).padding.right -
                              videowidth),
                      height: Get.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                      child: TabBarView(
                        controller: videoDetailController.tabCtr,
                        children: <Widget>[
                          CustomScrollView(
                            slivers: [
                              RelatedVideoPanel(),
                            ],
                          ),
                          VideoReplyPanel(
                            bvid: videoDetailController.bvid,
                          )
                        ],
                      ),
                    )
                  ],
                );
              }))
        ]));
    Widget childWhenEnabled = FutureBuilder(
      key: Key(heroTag),
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data['status']) {
          return Obx(
            () => !videoDetailController.autoPlay.value
                ? const SizedBox()
                : PLVideoPlayer(
                    controller: plPlayerController!,
                    headerControl: HeaderControl(
                      controller: plPlayerController,
                      videoDetailCtr: videoDetailController,
                    ),
                    danmuWidget: Obx(
                      () => PlDanmaku(
                        key: Key(
                            videoDetailController.danmakuCid.value.toString()),
                        cid: videoDetailController.danmakuCid.value,
                        playerController: plPlayerController!,
                      ),
                    ),
                  ),
          );
        } else {
          return nil;
        }
      },
    );
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      if (orientation == Orientation.landscape) {
        enterFullScreen();
      }
      if (Platform.isAndroid) {
        return PiPSwitcher(
          childWhenDisabled: Container(
            key: UniqueKey(),
            child: !horizontalScreen || orientation == Orientation.portrait
                ? childWhenDisabled
                : childWhenDisabledLandscape,
          ),
          childWhenEnabled: childWhenEnabled,
          floating: floating,
        );
      }
      return Container(
        key: UniqueKey(),
        child: !horizontalScreen || orientation == Orientation.portrait
            ? childWhenDisabled
            : childWhenDisabledLandscape,
      );
    });
  }
}
