import 'dart:async';
import 'dart:io';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:floating/floating.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
import 'widgets/header_control.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({Key? key}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  late VideoDetailController videoDetailController;
  PlPlayerController? plPlayerController;
  final ScrollController _extendNestCtr = ScrollController();
  late StreamController<double> appbarStream;
  late VideoIntroController videoIntroController;
  late BangumiIntroController bangumiIntroController;
  late String heroTag;

  PlayerStatus playerStatus = PlayerStatus.playing;
  double doubleOffset = 0;

  Box localCache = GStrorage.localCache;
  Box setting = GStrorage.setting;
  late double statusBarHeight;
  final videoHeight = Get.size.width * 9 / 16;
  late Future _futureBuilderFuture;
  // 自动退出全屏
  late bool autoExitFullcreen;
  late bool autoPlayEnable;
  late bool autoPiP;
  final floating = Floating();

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
    autoPlayEnable =
        setting.get(SettingBoxKey.autoPlayEnable, defaultValue: true);
    autoPiP = setting.get(SettingBoxKey.autoPiP, defaultValue: false);

    videoSourceInit();
    appbarStreamListen();
    WidgetsBinding.instance.addObserver(this);
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
        double offset = _extendNestCtr.position.pixels;
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
    await videoDetailController.playerInit();
    plPlayerController = videoDetailController.plPlayerController;
    videoDetailController.autoPlay.value = true;
    videoDetailController.isShowCover.value = false;
  }

  @override
  void dispose() {
    if (plPlayerController != null) {
      plPlayerController!.removeStatusLister(playerListener);
      plPlayerController!.dispose();
    }
    if (videoDetailController.floating != null) {
      videoDetailController.floating!.dispose();
    }
    videoPlayerServiceHandler.onVideoDetailDispose();
    WidgetsBinding.instance.removeObserver(this);
    floating.dispose();
    super.dispose();
  }

  @override
  // 离开当前页面时
  void didPushNext() async {
    /// 开启
    if (setting.get(SettingBoxKey.enableAutoBrightness, defaultValue: false)) {
      videoDetailController.brightness = plPlayerController!.brightness.value;
    }
    if (plPlayerController != null) {
      videoDetailController.defaultST = plPlayerController!.position.value;
      videoIntroController.isPaused = true;
      plPlayerController!.removeStatusLister(playerListener);
      plPlayerController!.pause();
    }
    super.didPushNext();
  }

  @override
  // 返回当前页面时
  void didPopNext() async {
    videoDetailController.isFirstTime = false;
    bool autoplay = autoPlayEnable;
    videoDetailController.playerInit(autoplay: autoplay);

    /// 未开启自动播放时，未播放跳转下一页返回/播放后跳转下一页返回
    videoDetailController.autoPlay.value =
        !videoDetailController.isShowCover.value;
    videoIntroController.isPaused = false;
    if (_extendNestCtr.position.pixels == 0 && autoplay) {
      await Future.delayed(const Duration(milliseconds: 300));
      plPlayerController!.seekTo(videoDetailController.defaultST);
      plPlayerController?.play();
    }
    plPlayerController?.addStatusLister(playerListener);
    super.didPopNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    VideoDetailPage.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    var routePath = Get.currentRoute;
    if (lifecycleState == AppLifecycleState.inactive &&
        autoPiP &&
        routePath.startsWith('/video')) {
      floating.enable(
          aspectRatio: Rational(
        videoDetailController.data.dash!.video!.first.width!,
        videoDetailController.data.dash!.video!.first.height!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoHeight = MediaQuery.of(context).size.width * 9 / 16;
    final double pinnedHeaderHeight =
        statusBarHeight + kToolbarHeight + videoHeight;
    if (MediaQuery.of(context).orientation == Orientation.landscape ||
        plPlayerController!.isFullScreen.value) {
      enterFullScreen();
    } else {
      exitFullScreen();
    }
    Widget childWhenDisabled = SafeArea(
      top: MediaQuery.of(context).orientation == Orientation.portrait,
      bottom: MediaQuery.of(context).orientation == Orientation.portrait,
      left: !plPlayerController!.isFullScreen.value,
      right: !plPlayerController!.isFullScreen.value,
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            key: videoDetailController.scaffoldKey,
            backgroundColor: Colors.black,
            body: ExtendedNestedScrollView(
              controller: _extendNestCtr,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  Obx(() => PopScope(
                        canPop: !plPlayerController!.isFullScreen.value,
                        onPopInvoked: (bool didPop) {
                          if (plPlayerController!.isFullScreen.value) {
                            plPlayerController!
                                .triggerFullScreen(status: false);
                          }
                          if (MediaQuery.of(context).orientation ==
                              Orientation.landscape) {
                            verticalScreen();
                          }
                        },
                        child: SliverAppBar(
                            automaticallyImplyLeading: false,
                            pinned: false,
                            elevation: 0,
                            scrolledUnderElevation: 0,
                            forceElevated: innerBoxIsScrolled,
                            expandedHeight:
                                plPlayerController!.isFullScreen.value ||
                                        MediaQuery.of(context).orientation ==
                                            Orientation.landscape
                                    ? MediaQuery.of(context).size.height -
                                        (MediaQuery.of(context).orientation ==
                                                Orientation.landscape
                                            ? 0
                                            : statusBarHeight)
                                    : videoHeight,
                            backgroundColor: Colors.black,
                            flexibleSpace: FlexibleSpaceBar(
                              background: LayoutBuilder(
                                builder: (context, boxConstraints) {
                                  double maxWidth = boxConstraints.maxWidth;
                                  double maxHeight = boxConstraints.maxHeight;
                                  return Stack(
                                    children: [
                                      FutureBuilder(
                                        future: _futureBuilderFuture,
                                        builder: ((context, snapshot) {
                                          if (snapshot.hasData &&
                                              snapshot.data['status']) {
                                            return Obx(
                                              () => !videoDetailController
                                                      .autoPlay.value
                                                  ? const SizedBox()
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
                                      ),

                                      Obx(
                                        () => Visibility(
                                          visible: videoDetailController
                                              .isShowCover.value,
                                          child: Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
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

                                      /// 关闭自动播放时 手动播放
                                      Obx(
                                        () => Visibility(
                                            visible: videoDetailController
                                                    .isShowCover.value &&
                                                videoDetailController
                                                    .isEffective.value &&
                                                !videoDetailController
                                                    .autoPlay.value,
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
                                                  child: TextButton.icon(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .resolveWith(
                                                                  (states) {
                                                        return Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer;
                                                      }),
                                                    ),
                                                    onPressed: () =>
                                                        handlePlay(),
                                                    icon: const Icon(
                                                      Icons.play_circle_outline,
                                                      size: 20,
                                                    ),
                                                    label: const Text('Play'),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )),
                      )),
                ];
              },
              // pinnedHeaderSliverHeightBuilder: () {
              //   return playerStatus != PlayerStatus.playing
              //       ? statusBarHeight + kToolbarHeight
              //       : pinnedHeaderHeight;
              // },
              /// 不收回
              pinnedHeaderSliverHeightBuilder: () {
                return pinnedHeaderHeight;
              },
              onlyOneScrollInBody: true,
              body: Container(
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
                        children: [
                          Builder(
                            builder: (context) {
                              return CustomScrollView(
                                key: const PageStorageKey<String>('简介'),
                                slivers: <Widget>[
                                  if (videoDetailController.videoType ==
                                      SearchType.video) ...[
                                    const VideoIntroPanel(),
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
      builder: ((context, snapshot) {
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
          return const SizedBox();
        }
      }),
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
}
