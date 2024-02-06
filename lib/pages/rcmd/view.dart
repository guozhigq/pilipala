import 'dart:async';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/skeleton/video_card_v.dart';
import 'package:pilipala/common/widgets/animated_dialog.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/overlay_pop.dart';
import 'package:pilipala/common/widgets/video_card_v.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/main/index.dart';

import 'controller.dart';

class RcmdPage extends StatefulWidget {
  const RcmdPage({super.key});

  @override
  State<RcmdPage> createState() => _RcmdPageState();
}

class _RcmdPageState extends State<RcmdPage>
    with AutomaticKeepAliveClientMixin {
  final RcmdController _rcmdController = Get.put(RcmdController());
  late Future _futureBuilderFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _rcmdController.queryRcmdFeed('init');
    ScrollController scrollController = _rcmdController.scrollController;
    StreamController<bool> mainStream =
        Get.find<MainController>().bottomBarStream;
    StreamController<bool> searchBarStream =
        Get.find<HomeController>().searchBarStream;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'my-throttler', const Duration(milliseconds: 500), () {
            _rcmdController.isLoadingMore = true;
            _rcmdController.onLoad();
          });
        }
        final ScrollDirection direction =
            scrollController.position.userScrollDirection;
        if (direction == ScrollDirection.forward) {
          mainStream.add(true);
          searchBarStream.add(true);
        } else if (direction == ScrollDirection.reverse) {
          mainStream.add(false);
          searchBarStream.add(false);
        }
      },
    );
  }

  @override
  void dispose() {
    _rcmdController.scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(
          left: StyleString.safeSpace, right: StyleString.safeSpace),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(StyleString.imgRadius),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await _rcmdController.onRefresh();
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: CustomScrollView(
          controller: _rcmdController.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding:
                  const EdgeInsets.fromLTRB(0, StyleString.safeSpace, 0, 0),
              sliver: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(
                        () {
                          if (_rcmdController.isLoadingMore &&
                              _rcmdController.videoList.isEmpty) {
                            return contentGrid(_rcmdController, []);
                          } else {
                            // 显示视频列表
                            return contentGrid(
                                _rcmdController, _rcmdController.videoList);
                          }
                        },
                      );
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () {
                          setState(() {
                            _futureBuilderFuture =
                                _rcmdController.queryRcmdFeed('init');
                          });
                        },
                      );
                    }
                  } else {
                    return contentGrid(_rcmdController, []);
                  }
                },
              ),
            ),
            LoadingMore(ctr: _rcmdController),
          ],
        ),
      ),
    );
  }

  OverlayEntry _createPopupDialog(videoItem) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        closeFn: _rcmdController.popupDialog?.remove,
        child: OverlayPop(
            videoItem: videoItem, closeFn: _rcmdController.popupDialog?.remove),
      ),
    );
  }

  Widget contentGrid(ctr, videoList) {
    // double maxWidth = Get.size.width;
    // int baseWidth = 500;
    // int step = 300;
    // int crossAxisCount =
    //     maxWidth > baseWidth ? 2 + ((maxWidth - baseWidth) / step).ceil() : 2;
    // if (maxWidth < 300) {
    //   crossAxisCount = 1;
    // }
    int crossAxisCount = ctr.crossAxisCount.value;
    double mainAxisExtent = (Get.size.width /
            crossAxisCount /
            StyleString.aspectRatio) +
        (crossAxisCount == 1 ? 68 : MediaQuery.textScalerOf(context).scale(86));
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 行间距
        mainAxisSpacing: StyleString.safeSpace,
        // 列间距
        crossAxisSpacing: StyleString.safeSpace,
        // 列数
        crossAxisCount: crossAxisCount,
        mainAxisExtent: mainAxisExtent,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return videoList!.isNotEmpty
              ? VideoCardV(
                  videoItem: videoList[index],
                  crossAxisCount: crossAxisCount,
                  longPress: () {
                    _rcmdController.popupDialog =
                        _createPopupDialog(videoList[index]);
                    Overlay.of(context).insert(_rcmdController.popupDialog!);
                  },
                  longPressEnd: () {
                    _rcmdController.popupDialog?.remove();
                  },
                )
              : const VideoCardVSkeleton();
        },
        childCount: videoList!.isNotEmpty ? videoList!.length : 10,
      ),
    );
  }
}

class LoadingMore extends StatelessWidget {
  final dynamic ctr;
  const LoadingMore({super.key, this.ctr});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).padding.bottom + 80,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: GestureDetector(
          onTap: () {
            if (ctr != null) {
              ctr!.isLoadingMore = true;
              ctr!.onLoad();
            }
          },
          child: Center(
            child: Text(
              '点击加载更多 👇',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
