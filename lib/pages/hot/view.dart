import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/animated_dialog.dart';
import 'package:pilipala/common/widgets/overlay_pop.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/pages/hot/controller.dart';
import 'package:pilipala/pages/main/index.dart';

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> with AutomaticKeepAliveClientMixin {
  final HotController _hotController = Get.put(HotController());
  List videoList = [];
  Future? _futureBuilderFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _hotController.queryHotFeed('init');
    ScrollController scrollController = _hotController.scrollController;
    StreamController<bool> mainStream =
        Get.find<MainController>().bottomBarStream;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          if (!_hotController.isLoadingMore) {
            _hotController.isLoadingMore = true;
            _hotController.onLoad();
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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          return await _hotController.onRefresh();
        },
        child: CustomScrollView(
          controller: _hotController.scrollController,
          slivers: [
            SliverPadding(
              // 单列布局 EdgeInsets.zero
              padding:
                  const EdgeInsets.fromLTRB(0, StyleString.safeSpace - 5, 0, 0),
              sliver: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(
                        () => SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return VideoCardH(
                              videoItem: _hotController.videoList[index],
                              longPress: () {
                                _hotController.popupDialog = _createPopupDialog(
                                    _hotController.videoList[index]);
                                Overlay.of(context)
                                    .insert(_hotController.popupDialog!);
                              },
                              longPressEnd: () {
                                _hotController.popupDialog?.remove();
                              },
                            );
                          }, childCount: _hotController.videoList.length),
                        ),
                      );
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () => setState(() {}),
                      );
                    }
                  } else {
                    // 骨架屏
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return const VideoCardHSkeleton();
                      }, childCount: 10),
                    );
                  }
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 10,
              ),
            )
          ],
        ),
      ),
    );
  }

  OverlayEntry _createPopupDialog(videoItem) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        closeFn: _hotController.popupDialog?.remove,
        child: OverlayPop(
            videoItem: videoItem, closeFn: _hotController.popupDialog?.remove),
      ),
    );
  }
}
