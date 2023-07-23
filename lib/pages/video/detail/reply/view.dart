import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_reply.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/pages/video/detail/replyNew/index.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'controller.dart';
import 'widgets/reply_item.dart';

class VideoReplyPanel extends StatefulWidget {
  String? bvid;
  int rpid;
  String? level;
  Key? key;
  VideoReplyPanel({
    this.bvid,
    this.rpid = 0,
    this.level,
    super.key,
  });

  @override
  State<VideoReplyPanel> createState() => _VideoReplyPanelState();
}

class _VideoReplyPanelState extends State<VideoReplyPanel>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late VideoReplyController _videoReplyController;
  late AnimationController fabAnimationCtr;

  Future? _futureBuilderFuture;
  bool _isFabVisible = true;
  String replyLevel = '1';

  // 添加页面缓存
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    int oid = widget.bvid != null ? IdUtils.bv2av(widget.bvid!) : 0;
    super.initState();
    replyLevel = widget.level ?? '1';
    if (widget.level != null && widget.level == '2') {
      _videoReplyController = Get.put(
          VideoReplyController(oid, widget.rpid.toString(), '2'),
          tag: widget.rpid.toString());
      _videoReplyController.rPid = widget.rpid;
    } else {
      // fix 评论加载不对称
      // int oid = Get.parameters['bvid'] != null
      //     ? IdUtils.bv2av(Get.parameters['bvid']!)
      //     : 0;
      _videoReplyController = Get.put(VideoReplyController(oid, '', '1'),
          tag: Get.arguments['heroTag']);
    }

    fabAnimationCtr = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _futureBuilderFuture = _videoReplyController.queryReplyList();
    _videoReplyController.scrollController.addListener(
      () {
        if (_videoReplyController.scrollController.position.pixels >=
            _videoReplyController.scrollController.position.maxScrollExtent -
                300) {
          if (!_videoReplyController.isLoadingMore) {
            _videoReplyController.onLoad();
          }
        }

        final ScrollDirection direction =
            _videoReplyController.scrollController.position.userScrollDirection;
        if (direction == ScrollDirection.forward) {
          _showFab();
        } else if (direction == ScrollDirection.reverse) {
          _hideFab();
        }
      },
    );
    fabAnimationCtr.forward();
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

  void _showReply(source, {ReplyItemModel? replyItem, replyLevel}) async {
    // source main 直接回复  floor 楼中楼回复
    if (source == 'floor') {
      _videoReplyController.currentReplyItem = replyItem;
      _videoReplyController.replySource = source;
      _videoReplyController.replyLevel = replyLevel ?? '1';
    } else {
      _videoReplyController.replyLevel = '0';
    }

    // await Future.delayed(const Duration(microseconds: 100));
    // _videoReplyController.wakeUpReply();
  }

  // 展示二级回复
  void replyReply(replyItem) {
    VideoDetailController videoDetailCtr =
        Get.find<VideoDetailController>(tag: Get.arguments['heroTag']);
    videoDetailCtr.oid = replyItem.oid;
    videoDetailCtr.fRpid = replyItem.rpid!;
    videoDetailCtr.firstFloor = replyItem;
    videoDetailCtr.showReplyReplyPanel();
  }

  @override
  void dispose() {
    super.dispose();
    fabAnimationCtr.dispose();
    _videoReplyController.scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        _videoReplyController.currentPage = 0;
        return await _videoReplyController.queryReplyList();
      },
      child: Stack(
        children: [
          CustomScrollView(
            controller: _videoReplyController.scrollController,
            key: const PageStorageKey<String>('评论'),
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: false,
                floating: true,
                delegate: _MySliverPersistentHeaderDelegate(
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    padding: const EdgeInsets.fromLTRB(12, 6, 10, 6),
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
                              _videoReplyController.sortTypeTitle.value,
                              key: ValueKey<String>(
                                  _videoReplyController.sortTypeTitle.value),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: TextButton.icon(
                            onPressed: () =>
                                _videoReplyController.queryBySort(),
                            icon: const Icon(Icons.sort, size: 17),
                            label: Obx(() => Text(
                                _videoReplyController.sortTypeLabel.value)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      // 请求成功
                      return Obx(
                        () => _videoReplyController.replyList.isEmpty
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return const VideoReplySkeleton();
                                }, childCount: 5),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index ==
                                        _videoReplyController
                                            .replyList.length) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .padding
                                                .bottom),
                                        height: MediaQuery.of(context)
                                                .padding
                                                .bottom +
                                            100,
                                        child: Center(
                                          child: Obx(() => Text(
                                              _videoReplyController
                                                  .noMore.value)),
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
                        fn: () => setState(() {}),
                      );
                    }
                  } else {
                    // 骨架屏
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
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
                // 评论内容为空/不足一屏
                // begin: const Offset(0, 0),
                end: const Offset(0, 0),
              ).animate(CurvedAnimation(
                parent: fabAnimationCtr,
                curve: Curves.easeInOut,
              )),
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return VideoReplyNewDialog(
                        oid: IdUtils.bv2av(Get.parameters['bvid']!),
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
  final double _minExtent = 45;
  final double _maxExtent = 45;
  final Widget child;

  _MySliverPersistentHeaderDelegate({required this.child});

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
