import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/skeleton/video_card_v.dart';
import 'package:pilipala/common/widgets/animated_dialog.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/overlay_pop.dart';

import 'controller.dart';
import 'widgets/live_item.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final LiveController _liveController = Get.put(LiveController());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _liveController.scrollController.addListener(
      () {
        if (_liveController.scrollController.position.pixels >=
            _liveController.scrollController.position.maxScrollExtent - 200) {
          if (!_liveController.isLoadingMore) {
            _liveController.isLoadingMore = true;
            _liveController.onLoad();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return await _liveController.onRefresh();
      },
      child: CustomScrollView(
        controller: _liveController.scrollController,
        slivers: [
          SliverPadding(
            // 单列布局 EdgeInsets.zero
            padding: const EdgeInsets.fromLTRB(
                StyleString.safeSpace, 0, StyleString.safeSpace, 0),
            sliver: FutureBuilder(
              future: _liveController.queryLiveList('init'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map data = snapshot.data as Map;
                  if (data['status']) {
                    return Obx(() =>
                        contentGrid(_liveController, _liveController.liveList));
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
    );
  }

  OverlayEntry _createPopupDialog(liveItem) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: OverlayPop(videoItem: liveItem),
      ),
    );
  }

  Widget contentGrid(ctr, liveList) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 行间距
        mainAxisSpacing: StyleString.cardSpace + 2,
        // 列间距
        crossAxisSpacing: StyleString.cardSpace,
        // 列数
        crossAxisCount: ctr.crossAxisCount,
        mainAxisExtent:
            Get.size.width / ctr.crossAxisCount / StyleString.aspectRatio + 60,
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
