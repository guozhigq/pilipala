import 'dart:async';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_reply.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/pages/video/detail/reply_new/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'controller.dart';
import 'widgets/reply_item.dart';

class VideoReplyPanel extends StatefulWidget {
  final String? bvid;
  final int? oid;
  final int rpid;
  final String? replyLevel;

  const VideoReplyPanel({
    this.bvid,
    this.oid,
    this.rpid = 0,
    this.replyLevel,
    super.key,
  });

  @override
  State<VideoReplyPanel> createState() => _VideoReplyPanelState();
}

class _VideoReplyPanelState extends State<VideoReplyPanel>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late VideoReplyController _videoReplyController;
  late AnimationController fabAnimationCtr;
  late ScrollController scrollController;

  Future? _futureBuilderFuture;
  bool _isFabVisible = true;
  String replyLevel = '1';
  late String heroTag;

  // 添加页面缓存
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // int oid = widget.bvid != null ? IdUtils.bv2av(widget.bvid!) : 0;
    heroTag = Get.arguments['heroTag'];
    replyLevel = widget.replyLevel ?? '1';
    if (replyLevel == '2') {
      _videoReplyController = Get.put(
          VideoReplyController(widget.oid, widget.rpid.toString(), replyLevel),
          tag: widget.rpid.toString());
    } else {
      _videoReplyController = Get.put(
          VideoReplyController(widget.oid, '', replyLevel),
          tag: heroTag);
    }

    fabAnimationCtr = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _futureBuilderFuture = _videoReplyController.queryReplyList();

    fabAnimationCtr.forward();
    scrollListener();
  }

  void scrollListener() {
    scrollController = _videoReplyController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          EasyThrottle.throttle('replylist', const Duration(milliseconds: 200),
              () {
            _videoReplyController.onLoad();
          });
        }

        final ScrollDirection direction =
            scrollController.position.userScrollDirection;
        if (direction == ScrollDirection.forward) {
          _showFab();
        } else if (direction == ScrollDirection.reverse) {
          _hideFab();
        }
      },
    );
  }

  void _showFab() {
    if (!_isFabVisible) {
      _isFabVisible = true;
      fabAnimationCtr.forward();
    }
  }

  void _hideFab() {
    if (_isFabVisible) {
      _isFabVisible = false;
      fabAnimationCtr.reverse();
    }
  }

  // 展示二级回复
  void replyReply(replyItem) {
    final VideoDetailController videoDetailCtr =
        Get.find<VideoDetailController>(tag: heroTag);
    if (replyItem != null) {
      videoDetailCtr.oid.value = replyItem.oid;
      videoDetailCtr.fRpid = replyItem.rpid!;
      videoDetailCtr.firstFloor = replyItem;
      videoDetailCtr.showReplyReplyPanel();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    fabAnimationCtr.dispose();
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        _videoReplyController.currentPage = 0;
        return await _videoReplyController.queryReplyList();
      },
      child: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            key: const PageStorageKey<String>('评论'),
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: _MySliverPersistentHeaderDelegate(
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.1)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            },
                            child: Text(
                              '共${_videoReplyController.count.value}条回复',
                              key: ValueKey<int>(
                                  _videoReplyController.count.value),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: TextButton.icon(
                            onPressed: () =>
                                _videoReplyController.queryBySort(),
                            icon: const Icon(Icons.sort, size: 16),
                            label: Obx(() => Text(
                                  _videoReplyController.sortTypeLabel.value,
                                  style: const TextStyle(fontSize: 13),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: _futureBuilderFuture,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var data = snapshot.data;
                    if (data['status']) {
                      // 请求成功
                      return Obx(
                        () => _videoReplyController.isLoadingMore &&
                                _videoReplyController.replyList.isEmpty
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, index) {
                                  return const VideoReplySkeleton();
                                }, childCount: 5),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, index) {
                                    double bottom =
                                        MediaQuery.of(context).padding.bottom;
                                    if (index ==
                                        _videoReplyController
                                            .replyList.length) {
                                      return Container(
                                        padding:
                                            EdgeInsets.only(bottom: bottom),
                                        height: bottom + 100,
                                        child: Center(
                                          child: Obx(
                                            () => Text(
                                              _videoReplyController
                                                  .noMore.value,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return ReplyItem(
                                        replyItem: _videoReplyController
                                            .replyList[index],
                                        showReplyRow: true,
                                        replyLevel: replyLevel,
                                        replyReply: (replyItem) =>
                                            replyReply(replyItem),
                                        replyType: ReplyType.video,
                                      );
                                    }
                                  },
                                  childCount:
                                      _videoReplyController.replyList.length +
                                          1,
                                ),
                              ),
                      );
                    } else {
                      // 请求错误
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () {
                          setState(() {
                            _futureBuilderFuture =
                                _videoReplyController.queryReplyList();
                          });
                        },
                      );
                    }
                  } else {
                    // 骨架屏
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, index) {
                        return const VideoReplySkeleton();
                      }, childCount: 5),
                    );
                  }
                },
              )
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 14,
            right: 14,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 2),
                end: const Offset(0, 0),
              ).animate(CurvedAnimation(
                parent: fabAnimationCtr,
                curve: Curves.easeInOut,
              )),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  feedBack();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return VideoReplyNewDialog(
                        oid: _videoReplyController.aid ??
                            IdUtils.bv2av(Get.parameters['bvid']!),
                        root: 0,
                        parent: 0,
                        replyType: ReplyType.video,
                      );
                    },
                  ).then(
                    (value) => {
                      // 完成评论，数据添加
                      if (value != null && value['data'] != null)
                        {_videoReplyController.replyList.add(value['data'])}
                    },
                  );
                },
                tooltip: '发表评论',
                child: const Icon(Icons.reply),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _MySliverPersistentHeaderDelegate({required this.child});
  final double _minExtent = 45;
  final double _maxExtent = 45;
  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    //创建child子组件
    //shrinkOffset：child偏移值minExtent~maxExtent
    //overlapsContent：SliverPersistentHeader覆盖其他子组件返回true，否则返回false
    return child;
  }

  //SliverPersistentHeader最大高度
  @override
  double get maxExtent => _maxExtent;

  //SliverPersistentHeader最小高度
  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(covariant _MySliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
