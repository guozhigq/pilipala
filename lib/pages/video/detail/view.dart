import 'dart:async';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/sliver_header.dart';
import 'package:pilipala/pages/video/detail/introduction/widgets/menu_row.dart';
import 'package:pilipala/pages/video/detail/reply/index.dart';
import 'package:pilipala/pages/video/detail/controller.dart';
import 'package:pilipala/pages/video/detail/introduction/index.dart';
import 'package:pilipala/pages/video/detail/related/index.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

import 'widgets/app_bar.dart';
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
  final VideoDetailController videoDetailController =
      Get.put(VideoDetailController(), tag: Get.arguments['heroTag']);
  PlPlayerController? plPlayerController;
  final ScrollController _extendNestCtr = ScrollController();
  late StreamController<double> appbarStream;

  bool isPlay = false;
  PlayerStatus playerStatus = PlayerStatus.playing;
  bool isShowCover = true;
  double doubleOffset = 0;

  @override
  void initState() {
    super.initState();
    plPlayerController = videoDetailController.plPlayerController;
    plPlayerController!.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        videoDetailController.markHeartBeat();
        playerStatus = status;
        if (status == PlayerStatus.playing) {
          isPlay = false;
          isShowCover = false;
          setState(() {});
          videoDetailController.loopHeartBeat();
        } else {
          videoDetailController.timer!.cancel();
          isPlay = true;
          setState(() {});
          // 播放完成停止 or 切换下一个
          if (status == PlayerStatus.completed) {
            // 当只有1p或多p未打开自动播放时，播放完成还原进度条，展示控制栏
            plPlayerController!.seekTo(Duration.zero);
            plPlayerController!.onLockControl(false);
            plPlayerController!.videoPlayerController!.pause();
          }
        }
      },
    );

    appbarStream = StreamController<double>();

    _extendNestCtr.addListener(
      () {
        double offset = _extendNestCtr.position.pixels;
        appbarStream.add(offset);
      },
    );
  }

  void continuePlay() async {
    await _extendNestCtr.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    plPlayerController!.play();
  }

  @override
  void dispose() {
    plPlayerController!.dispose();
    if (videoDetailController.timer != null) {
      videoDetailController.timer!.cancel();
    }
    super.dispose();
  }

  @override
  // 离开当前页面时
  void didPushNext() async {
    if (videoDetailController.timer!.isActive) {
      videoDetailController.timer!.cancel();
    }
    super.didPushNext();
  }

  @override
  // 返回当前页面时
  void didPopNext() async {
    if (_extendNestCtr.position.pixels == 0) {
      await Future.delayed(const Duration(milliseconds: 300));
      plPlayerController!.play();
    }
    if (!videoDetailController.timer!.isActive) {
      videoDetailController.loopHeartBeat();
    }
    super.didPopNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    VideoDetailPage.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final videoHeight = MediaQuery.of(context).size.width * 9 / 16;
    final double pinnedHeaderHeight =
        statusBarHeight + kToolbarHeight + videoHeight;
    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            key: videoDetailController.scaffoldKey,
            backgroundColor: Colors.transparent,
            body: ExtendedNestedScrollView(
              controller: _extendNestCtr,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: false,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    forceElevated: innerBoxIsScrolled,
                    expandedHeight: videoHeight,
                    // backgroundColor: Colors.transparent,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: LayoutBuilder(
                          builder: (context, boxConstraints) {
                            double maxWidth = boxConstraints.maxWidth;
                            double maxHeight = boxConstraints.maxHeight;
                            return Hero(
                              tag: videoDetailController.heroTag,
                              child: Stack(
                                children: [
                                  if (plPlayerController!
                                          .videoPlayerController !=
                                      null)
                                    PLVideoPlayer(
                                      controller: plPlayerController!,
                                      headerControl: HeaderControl(
                                        controller: plPlayerController,
                                        videoDetailCtr: videoDetailController,
                                      ),
                                    ),
                                  Visibility(
                                    visible: isShowCover,
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

                                  /// 关闭自动播放时 手动播放
                                  Obx(
                                    () => Visibility(
                                      visible: isShowCover &&
                                          videoDetailController
                                              .isEffective.value &&
                                          !videoDetailController.autoPlay.value,
                                      child: Positioned(
                                        right: 12,
                                        bottom: 6,
                                        child: TextButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) {
                                              return Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer;
                                            }),
                                          ),
                                          onPressed: () => videoDetailController
                                              .handlePlay(),
                                          icon: const Icon(
                                            Icons.play_circle_outline,
                                            size: 20,
                                          ),
                                          label: const Text('Play'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ];
              },
              pinnedHeaderSliverHeightBuilder: () {
                return playerStatus != PlayerStatus.playing
                    ? statusBarHeight + kToolbarHeight
                    : pinnedHeaderHeight;
              },
              onlyOneScrollInBody: true,
              body: Container(
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  children: [
                    Opacity(
                      opacity: 0,
                      child: Container(
                        width: double.infinity,
                        height: 0,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.1),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 280,
                              margin: const EdgeInsets.only(left: 20),
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
                          ],
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
                                  const VideoIntroPanel(),
                                  SliverPersistentHeader(
                                    floating: true,
                                    pinned: true,
                                    delegate: SliverHeaderDelegate(
                                      height: 50,
                                      child:
                                          const MenuRow(loadingStatus: false),
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
          // 播放完成/暂停播放
          StreamBuilder(
            stream: appbarStream.stream,
            initialData: 0,
            builder: ((context, snapshot) {
              return ScrollAppBar(
                snapshot.data!.toDouble(),
                () {},
                playerStatus != PlayerStatus.playing,
                null,
              );
            }),
          )
        ],
      ),
    );
  }
}
