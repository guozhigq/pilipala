import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/skeleton/video_card_v.dart';
import 'package:pilipala/common/widgets/animated_dialog.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/overlay_pop.dart';
import 'package:pilipala/common/widgets/video_card_v.dart';
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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    ScrollController scrollController = _rcmdController.scrollController;
    StreamController<bool> mainStream =
        Get.find<MainController>().bottomBarStream;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          if (!_rcmdController.isLoadingMore) {
            _rcmdController.isLoadingMore = true;
            _rcmdController.onLoad();
          }
        }

        final ScrollDirection direction =
            scrollController.position.userScrollDirection;
        if (direction == ScrollDirection.forward) {
          mainStream.add(true);
        } else if (direction == ScrollDirection.reverse) {
          mainStream.add(false);
        }
      },
    );
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
          return await _rcmdController.onRefresh();
        },
        child: CustomScrollView(
          controller: _rcmdController.scrollController,
          slivers: [
            SliverPadding(
              // 单列布局 EdgeInsets.zero
              padding: _rcmdController.crossAxisCount == 1
                  ? EdgeInsets.zero
                  : const EdgeInsets.fromLTRB(0, 0, 0, 0),
              sliver: FutureBuilder(
                future: _rcmdController.queryRcmdFeed('init'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(() => contentGrid(
                          _rcmdController, _rcmdController.videoList));
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () => {},
                      );
                    }
                  } else {
                    // 缓存数据
                    if (_rcmdController.videoList.length > 1) {
                      return contentGrid(
                          _rcmdController, _rcmdController.videoList);
                    }
                    // 骨架屏
                    else {
                      return contentGrid(_rcmdController, []);
                    }
                  }
                },
              ),
            ),
            const LoadingMore()
          ],
        ),
      ),
    );
  }

  OverlayEntry _createPopupDialog(videoItem) {
    return OverlayEntry(
        builder: (context) => AnimatedDialog(
              child: OverlayPop(videoItem: videoItem),
            ));
  }

  Widget contentGrid(ctr, videoList) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 行间距
        mainAxisSpacing: StyleString.cardSpace + 2,
        // 列间距
        crossAxisSpacing: StyleString.cardSpace + 3,
        // 列数
        crossAxisCount: ctr.crossAxisCount,
        mainAxisExtent:
            Get.size.width / ctr.crossAxisCount / StyleString.aspectRatio + 60,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return videoList!.isNotEmpty
              ?
              // VideoCardV(videoItem: videoList![index])
              VideoCardV(
                  videoItem: videoList[index],
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
  const LoadingMore({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).padding.bottom + 80,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Center(
          child: Text(
            '加载中...',
            style: TextStyle(
                color: Theme.of(context).colorScheme.outline, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
