import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:floating/floating.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  late bool autoPiP;
  late Floating floating;
  bool isShowing = true;

  @override
  void initState() {
    super.initState();
    heroTag = Get.arguments['heroTag'];
    videoDetailController = Get.put(VideoDetailController(), tag: heroTag);
    videoIntroController = Get.put(
        VideoIntroController(bvid: Get.parameters['bvid']!),
        tag: heroTag);
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
    autoPlayEnable =
        setting.get(SettingBoxKey.autoPlayEnable, defaultValue: true);
    autoPiP = setting.get(SettingBoxKey.autoPiP, defaultValue: false);

    videoSourceInit();
    appbarStreamListen();
    fullScreenStatusListener();
    if (Platform.isAndroid) {
      floating = videoDetailController.floating!;
      autoEnterPip();
    }
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
    if (Platform.isAndroid) {
      floating.toggleAutoPip(
          autoEnter: status == PlayerStatus.playing && autoPiP);
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
    await videoDetailController.playerInit();
    plPlayerController = videoDetailController.plPlayerController;
    plPlayerController!.addStatusLister(playerListener);
    videoDetailController.autoPlay.value = true;
    videoDetailController.isShowCover.value = false;
  }

  void fullScreenStatusListener() {
    plPlayerController?.isFullScreen.listen((bool isFullScreen) {
      if (isFullScreen) {
        videoDetailController.hiddenReplyReplyPanel();
      }
    });
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
    if (Platform.isAndroid) {
      floating.toggleAutoPip(autoEnter: false);
      floating.dispose();
    }
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
    if (plPlayerController != null &&
        plPlayerController!.videoPlayerController != null) {
      setState(() => isShowing = true);
    }
    videoDetailController.isFirstTime = false;
    final bool autoplay = autoPlayEnable;
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

  void autoEnterPip() {
    final String routePath = Get.currentRoute;
    if (autoPiP && routePath.startsWith('/video')) {
      floating.toggleAutoPip(autoEnter: autoPiP);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double videoHeight = MediaQuery.sizeOf(context).width * 9 / 16;
    final double pinnedHeaderHeight =
        statusBarHeight + kToolbarHeight + videoHeight;
    Widget childWhenDisabled = SafeArea(
      top: MediaQuery.of(context).orientation == Orientation.portrait &&
          plPlayerController?.isFullScreen.value == true,
      bottom: MediaQuery.of(context).orientation == Orientation.portrait &&
          plPlayerController?.isFullScreen.value == true,
      left: false, //plPlayerController?.isFullScreen.value != true,
      right: false, //plPlayerController?.isFullScreen.value != true,
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
            body: ExtendedNestedScrollView(
              controller: _extendNestCtr,
              headerSliverBuilder:
                  (BuildContext context2, bool innerBoxIsScrolled) {
                return <Widget>[
                  Obx(
                    () {
                      if (MediaQuery.of(context).orientation ==
                              Orientation.landscape ||
                          plPlayerController?.isFullScreen.value == true) {
                        enterFullScreen();
                      } else {
                        exitFullScreen();
                      }
                      return SliverAppBar(
                        automaticallyImplyLeading: false,
                        // 假装使用一个非空变量，避免Obx检测不到而罢工
                        pinned: videoDetailController.autoPlay.value ^
                            false ^
                            videoDetailController.autoPlay.value,
                        elevation: 0,
                        scrolledUnderElevation: 0,
                        forceElevated: innerBoxIsScrolled,
                        expandedHeight: MediaQuery.of(context).orientation ==
                                    Orientation.landscape ||
                                plPlayerController?.isFullScreen.value == true
                            ? MediaQuery.sizeOf(context).height -
                                (MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? 0
                                    : MediaQuery.of(context).padding.top)
                            : videoHeight,
                        backgroundColor: Colors.black,
                        flexibleSpace: FlexibleSpaceBar(
                          background: PopScope(
                              canPop: plPlayerController?.isFullScreen.value !=
                                  true,
                              onPopInvoked: (bool didPop) {
                                if (plPlayerController?.isFullScreen.value ==
                                    true) {
                                  plPlayerController!
                                      .triggerFullScreen(status: false);
                                }
                                if (MediaQuery.of(context).orientation ==
                                    Orientation.landscape) {
                                  verticalScreen();
                                }
                              },
                              child: LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints boxConstraints) {
                                  final double maxWidth =
                                      boxConstraints.maxWidth;
                                  final double maxHeight =
                                      boxConstraints.maxHeight;
                                  return Stack(
                                    children: <Widget>[
                                      if (isShowing)
                                        FutureBuilder(
                                          future: _futureBuilderFuture,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data['status']) {
                                              return Obx(
                                                () =>
                                                    !videoDetailController
                                                            .autoPlay.value
                                                        ? nil
                                                        : PLVideoPlayer(
                                                            controller:
                                                                plPlayerController!,
                                                            headerControl:
                                                                videoDetailController
                                                                    .headerControl,
                                                            danmuWidget: Obx(
                                                              () => PlDanmaku(
                                                                key: Key(videoDetailController
                                                                    .danmakuCid
                                                                    .value
                                                                    .toString()),
                                                                cid: videoDetailController
                                                                    .danmakuCid
                                                                    .value,
                                                                playerController:
                                                                    plPlayerController!,
                                                              ),
                                                            ),
                                                          ),
                                              );
                                            } else {
                                              return buildCustomAppBar();
                                            }
                                          },
                                        ),

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
                                                  width: maxWidth,
                                                  height: maxHeight,
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
                                                    child: buildCustomAppBar(),
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
                                  );
                                },
                              )),
                        ),
                      );
                    },
                  ),
                ];
              },
              // pinnedHeaderSliverHeightBuilder: () {
              //   return playerStatus != PlayerStatus.playing
              //       ? statusBarHeight + kToolbarHeight
              //       : pinnedHeaderHeight;
              // },
              /// 不收回
              pinnedHeaderSliverHeightBuilder: () {
                return MediaQuery.of(context).orientation ==
                            Orientation.landscape ||
                        plPlayerController?.isFullScreen.value == true
                    ? MediaQuery.sizeOf(context).height
                    : pinnedHeaderHeight;
              },
              onlyOneScrollInBody: true,
              body: ColoredBox(
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
                                    VideoIntroPanel(
                                        bvid: videoDetailController.bvid),
                                  ] else if (videoDetailController.videoType ==
                                      SearchType.media_bangumi) ...[
                                    Obx(() => BangumiIntroPanel(
                                        cid: videoDetailController.cid.value)),
                                  ],
                                  // if (videoDetailController.videoType ==
                                  //     SearchType.video) ...[
                                  //   SliverPersistentHeader(
                                  //     floating: true,
                                  //     pinned: true,
                                  //     delegate: SliverHeaderDelegate(
                                  //       height: 50,
                                  //       child:
                                  //           const MenuRow(loadingStatus: false),
                                  //     ),
                                  //   ),
                                  // ],
                                  SliverToBoxAdapter(
                                    child: Divider(
                                      indent: 12,
                                      endIndent: 12,
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.06),
                                    ),
                                  ),
                                  const RelatedVideoPanel(),
                                ],
                              );
                            },
                          ),
                          Obx(
                            () => VideoReplyPanel(
                              bvid: videoDetailController.bvid,
                              oid: videoDetailController.oid.value,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 重新进入会刷新
          // 播放完成/暂停播放
          // StreamBuilder(
          //   stream: appbarStream.stream,
          //   initialData: 0,
          //   builder: ((context, snapshot) {
          //     return ScrollAppBar(
          //       snapshot.data!.toDouble(),
          //       () => continuePlay(),
          //       playerStatus,
          //       null,
          //     );
          //   }),
          // )
        ],
      ),
    );
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
                      bvid: videoDetailController.bvid,
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
    if (Platform.isAndroid) {
      return PiPSwitcher(
        childWhenDisabled: childWhenDisabled,
        childWhenEnabled: childWhenEnabled,
        floating: floating,
      );
    } else {
      return childWhenDisabled;
    }
  }

  Widget buildCustomAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent, // 使背景透明
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      primary: false,
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Container(
        height: kToolbarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: <Color>[
            Colors.transparent,
            Colors.black54,
          ],
          tileMode: TileMode.mirror,
        )),
        child: Row(
          children: [
            ComBtn(
              icon: const Icon(FontAwesomeIcons.arrowLeft, size: 15),
              fuc: () => Get.back(),
            ),
            const Spacer(),
            ComBtn(
              icon: const Icon(Icons.history_outlined, size: 22),
              fuc: () async {
                var res = await UserHttp.toViewLater(
                    bvid: videoDetailController.bvid);
                SmartDialog.showToast(res['msg']);
              },
            ),
          ],
        ),
      ),
    );
  }
}
