import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_meedu_media_kit/meedu_player.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/video/detail/reply/index.dart';
import 'package:pilipala/pages/video/detail/controller.dart';
import 'package:pilipala/pages/video/detail/introduction/index.dart';
import 'package:pilipala/pages/video/detail/related/index.dart';
import 'package:pilipala/pages/video/detail/replyReply/index.dart';
import 'package:wakelock/wakelock.dart';

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
  late AnimationController animationController;

  // final _meeduPlayerController = MeeduPlayerController(
  //   pipEnabled: true,
  //   controlsStyle: ControlsStyle.secondary,
  //   enabledButtons: const EnabledButtons(pip: true),
  // );
  StreamSubscription? _playerEventSubs;
  bool isPlay = false;
  bool isShowCover = true;
  double doubleOffset = 0;

  @override
  void initState() {
    super.initState();
    _meeduPlayerController = videoDetailController.meeduPlayerController;
    _playerEventSubs = _meeduPlayerController!.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        videoDetailController.markHeartBeat();
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
        }
        // 播放完成停止 or 切换下一个
        if (status == PlayerStatus.completed) {
          _meeduPlayerController!.pause();
        }
      },
    );

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    _extendNestCtr.addListener(
      () {
        double offset = _extendNestCtr.position.pixels;
        if (offset > doubleOffset) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
        doubleOffset = offset;
        setState(() {});
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

  @override
  void dispose() {
    videoDetailController.meeduPlayerController.dispose();
    videoDetailController.timer!.cancel();
    super.dispose();
  }

  @override
  // 离开当前页面时
  void didPushNext() async {
    if (!_meeduPlayerController!.pipEnabled) {
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
    return DefaultTabController(
      initialIndex: videoDetailController.tabInitialIndex,
      length: videoDetailController.tabs.length, // tab的数量.
      child: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              key: videoDetailController.scaffoldKey,
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
                      // collapsedHeight: videoHeight,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
                          child: LayoutBuilder(
                            builder: (context, boxConstraints) {
                              double maxWidth = boxConstraints.maxWidth;
                              double maxHeight = boxConstraints.maxHeight;
                              // double PR =
                              // MediaQuery.of(context).devicePixelRatio;
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
                                            title: Text(
                                              '视频详情',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .fontSize),
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
                  return isPlay
                      ? MediaQuery.of(context).padding.top + 50
                      : pinnedHeaderHeight;
                },
                onlyOneScrollInBody: true,
                body: Column(
                  children: [
                    Container(
                      height: 45,
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
                                dividerColor: Colors.transparent,
                                tabs: videoDetailController.tabs
                                    .map((String name) => Tab(text: name))
                                    .toList(),
                              ),
                            ),
                          ),
                          // 弹幕开关
                          // const Spacer(),
                          // Flexible(
                          //   flex: 2,
                          //   child: Container(
                          //     height: 50,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Builder(
                            builder: (context) {
                              return const CustomScrollView(
                                key: PageStorageKey<String>('简介'),
                                slivers: <Widget>[
                                  VideoIntroPanel(),
                                  RelatedVideoPanel(),
                                ],
                              );
                            },
                          ),
                          VideoReplyPanel()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 播放完成/暂停播放
            Positioned(
              top: -MediaQuery.of(context).padding.top +
                  (doubleOffset / videoHeight) * 50,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: doubleOffset / videoHeight,
                child: Container(
                  height: 50 + MediaQuery.of(context).padding.top,
                  color: Theme.of(context).colorScheme.background,
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: AppBar(
                    primary: false,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    centerTitle: true,
                    title: TextButton(
                      onPressed: () {
                        _extendNestCtr.animateTo(0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.play_arrow_rounded),
                          Text('继续播放')
                        ],
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            size: 20,
                          )),
                      const SizedBox(width: 12)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
