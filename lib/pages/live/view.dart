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
import 'package:pilipala/pages/main/index.dart';

import 'controller.dart';
import 'widgets/live_item.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final LiveController _liveController = Get.put(LiveController());
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _liveController.queryLiveList('init');
    ScrollController scrollController = _liveController.scrollController;
    StreamController<bool> mainStream =
        Get.find<MainController>().bottomBarStream;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle('my-throttler', const Duration(seconds: 1), () {
            _liveController.isLoadingMore = true;
            _liveController.onLoad();
          });
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
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(
          left: StyleString.safeSpace, right: StyleString.safeSpace),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(StyleString.imgRadius),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          return await _liveController.onRefresh();
        },
        child: CustomScrollView(
          controller: _liveController.scrollController,
          slivers: [
            SliverPadding(
              // 单列布局 EdgeInsets.zero
              padding:
                  const EdgeInsets.fromLTRB(0, StyleString.safeSpace, 0, 0),
              sliver: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return SliverLayoutBuilder(
                          builder: (context, boxConstraints) {
                        return Obx(() => contentGrid(
                            _liveController, _liveController.liveList));
                      });
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () => {},
                      );
                    }
                  } else {
                    // 缓存数据
                    if (_liveController.liveList.length > 1) {
                      return contentGrid(
                          _liveController, _liveController.liveList);
                    }
                    // 骨架屏
                    else {
                      return contentGrid(_liveController, []);
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

  OverlayEntry _createPopupDialog(liveItem) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        closeFn: _liveController.popupDialog?.remove,
        child: OverlayPop(
            videoItem: liveItem, closeFn: _liveController.popupDialog?.remove),
      ),
    );
  }

  Widget contentGrid(ctr, liveList) {
    double maxWidth = Get.size.width;
    int baseWidth = 500;
    int step = 300;
    int crossAxisCount =
        maxWidth > baseWidth ? 2 + ((maxWidth - baseWidth) / step).ceil() : 2;
    if (maxWidth < 300) {
      crossAxisCount = 1;
    }
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 行间距
        mainAxisSpacing: StyleString.cardSpace + 4,
        // 列间距
        crossAxisSpacing: StyleString.cardSpace + 4,
        // 列数
        crossAxisCount: crossAxisCount,
        mainAxisExtent:
            Get.size.width / crossAxisCount / StyleString.aspectRatio + 66,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return liveList!.isNotEmpty
              ? LiveCardV(
                  liveItem: liveList[index],
                  longPress: () {
                    _liveController.popupDialog =
                        _createPopupDialog(liveList[index]);
                    Overlay.of(context).insert(_liveController.popupDialog!);
                  },
                  longPressEnd: () {
                    _liveController.popupDialog?.remove();
                  },
                )
              : const VideoCardVSkeleton();
        },
        childCount: liveList!.isNotEmpty ? liveList!.length : 10,
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
