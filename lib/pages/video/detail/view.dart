import 'dart:async';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/sliver_header.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/pages/bangumi/introduction/index.dart';
import 'package:pilipala/pages/video/detail/introduction/widgets/menu_row.dart';
import 'package:pilipala/pages/video/detail/reply/index.dart';
import 'package:pilipala/pages/video/detail/controller.dart';
import 'package:pilipala/pages/video/detail/introduction/index.dart';
import 'package:pilipala/pages/video/detail/related/index.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/utils/storage.dart';

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
  final VideoIntroController videoIntroController =
      Get.put(VideoIntroController(), tag: Get.arguments['heroTag']);

  PlayerStatus playerStatus = PlayerStatus.playing;
  // bool isShowCover = true;
  double doubleOffset = 0;

  Box localCache = GStrorage.localCache;
  late double statusBarHeight;
  final videoHeight = Get.size.width * 9 / 16;
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    plPlayerController = videoDetailController.plPlayerController;
    playerListener();

    appbarStream = StreamController<double>();

    _extendNestCtr.addListener(
      () {
        double offset = _extendNestCtr.position.pixels;
        appbarStream.add(offset);
      },
    );

    statusBarHeight = localCache.get('statusBarHeight');
    _futureBuilderFuture = videoDetailController.queryVideoUrl();
  }

  // 播放器状态监听
  void playerListener() {
    plPlayerController!.onPlayerStatusChanged.listen(
      (PlayerStatus status) async {
        playerStatus = status;
        if (status == PlayerStatus.playing) {
          videoDetailController.isShowCover.value = false;
        } else {
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
  }

  // 继续播放或重新播放
  void continuePlay() async {
    await _extendNestCtr.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    plPlayerController!.play();
  }

  @override
  void dispose() {
    plPlayerController!.dispose();
    super.dispose();
  }

  @override
  // 离开当前页面时
  void didPushNext() async {
    videoDetailController.defaultST = plPlayerController!.position.value;
    videoIntroController.isPaused = true;
    plPlayerController!.pause();
    super.didPushNext();
  }

  @override
  // 返回当前页面时
  void didPopNext() async {
    videoDetailController.playerInit();
    videoIntroController.isPaused = false;
    if (_extendNestCtr.position.pixels == 0) {
      await Future.delayed(const Duration(milliseconds: 300));
      plPlayerController!.play();
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
            // fix 1px black line
            // backgroundColor: Colors.transparent,
            backgroundColor: Theme.of(context).colorScheme.background,
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
                    backgroundColor:
                        MediaQuery.of(Get.context!).platformBrightness ==
                                Brightness.dark
                            ? Colors.black
                            : Theme.of(context).colorScheme.background,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: EdgeInsets.only(top: statusBarHeight),
                        child: LayoutBuilder(
                          builder: (context, boxConstraints) {
                            double maxWidth = boxConstraints.maxWidth;
                            double maxHeight = boxConstraints.maxHeight;
                            return Hero(
                              tag: videoDetailController.heroTag,
                              child: Stack(
                                children: [
                                  FutureBuilder(
                                    future: _futureBuilderFuture,
                                    builder: ((context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data['status']) {
                                        return PLVideoPlayer(
                                          controller: plPlayerController!,
                                          headerControl: HeaderControl(
                                            controller: plPlayerController,
                                            videoDetailCtr:
                                                videoDetailController,
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
                                                          .history_outlined))
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 12,
                                              bottom: 6,
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
                                                    videoDetailController
                                                        .handlePlay(),
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
                                    BangumiIntroPanel(
                                        cid: videoDetailController.cid)
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
          // 播放完成/暂停播放
          StreamBuilder(
            stream: appbarStream.stream,
            initialData: 0,
            builder: ((context, snapshot) {
              return ScrollAppBar(
                snapshot.data!.toDouble(),
                () => continuePlay(),
                playerStatus,
                null,
              );
            }),
          )
        ],
      ),
    );
  }
}
