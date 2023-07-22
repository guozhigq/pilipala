import 'dart:async';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_meedu_media_kit/meedu_player.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/sliver_header.dart';
import 'package:pilipala/pages/video/detail/introduction/widgets/menu_row.dart';
import 'package:pilipala/pages/video/detail/reply/index.dart';
import 'package:pilipala/pages/video/detail/controller.dart';
import 'package:pilipala/pages/video/detail/introduction/index.dart';
import 'package:pilipala/pages/video/detail/related/index.dart';
import 'package:wakelock/wakelock.dart';

import 'widgets/app_bar.dart';

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
  MeeduPlayerController? _meeduPlayerController;
  final ScrollController _extendNestCtr = ScrollController();
  late StreamController<double> appbarStream;

  StreamSubscription? _playerEventSubs;
  bool isPlay = false;
  PlayerStatus playerStatus = PlayerStatus.paused;
  bool isShowCover = true;
  double doubleOffset = 0;

  @override
  void initState() {
    super.initState();
    _meeduPlayerController = videoDetailController.meeduPlayerController;
    _playerEventSubs = _meeduPlayerController!.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        videoDetailController.markHeartBeat();
        playerStatus = status;
        if (status == PlayerStatus.playing) {
          Wakelock.enable();
          isPlay = false;
          isShowCover = false;
          setState(() {});
          videoDetailController.loopHeartBeat();
        } else {
          videoDetailController.timer!.cancel();
          isPlay = true;
          setState(() {});
          Wakelock.disable();
          // 播放完成停止 or 切换下一个
          if (status == PlayerStatus.completed) {}
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

  Future<void> _meeduDispose() async {
    if (_meeduPlayerController != null) {
      _playerEventSubs?.cancel();
      await _meeduPlayerController!.dispose();
      _meeduPlayerController = null;
      // The next line disables the wakelock again.
      await Wakelock.disable();
    }
  }

  void continuePlay() async {
    await _extendNestCtr.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    _meeduPlayerController!.play();
  }

  @override
  void dispose() {
    videoDetailController.meeduPlayerController.dispose();
    if (videoDetailController.timer != null) {
      videoDetailController.timer!.cancel();
    }
    super.dispose();
  }

  @override
  // 离开当前页面时
  void didPushNext() async {
    if (!_meeduPlayerController!.pipAvailable.value) {
      _meeduPlayerController!.pause();
    }
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
      _meeduPlayerController!.play();
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
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: MeeduVideoPlayer(
                                      controller: _meeduPlayerController!,
                                      header: (BuildContext context,
                                          MeeduPlayerController
                                              _meeduPlayerController,
                                          Responsive) {
                                        return AppBar(
                                          toolbarHeight: 40,
                                          backgroundColor: Colors.transparent,
                                          primary: false,
                                          elevation: 0,
                                          scrolledUnderElevation: 0,
                                          foregroundColor: Colors.white,
                                          leading: IconButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                              size: 19,
                                            ),
                                          ),
                                        );
                                      },
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
                    Container(
                      width: double.infinity,
                      height: 0,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.1),
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
                                      child: MenuRow(loadingStatus: false),
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
                continuePlay,
                playerStatus,
              );
            }),
          )
        ],
      ),
    );
  }
}
