import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/skeleton/video_reply.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'controller.dart';
import 'widgets/reply_item.dart';

class VideoReplyPanel extends StatefulWidget {
  int oid;
  int rpid;
  String? level;
  VideoReplyPanel({
    this.oid = 0,
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
  late AnimationController replyAnimationCtl;

  // List<ReplyItemModel>? replyList;
  Future? _futureBuilderFuture;
  bool _isFabVisible = true;
  String replyLevel = '1';

  // 添加页面缓存
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    replyLevel = widget.level ?? '1';
    if (widget.level != null && widget.level == '2') {
      _videoReplyController = Get.put(
          VideoReplyController(
              widget.oid.toString(), widget.rpid.toString(), '2'),
          tag: widget.rpid.toString());
      _videoReplyController.rPid = widget.rpid;
    } else {
      _videoReplyController = Get.put(
          VideoReplyController(Get.parameters['aid']!, '', '1'),
          tag: Get.arguments['heroTag']);
    }
    // if(replyLevel != ''){
    //   _videoReplyController.replyLevel = replyLevel;
    // }
    print(
        '_videoReplyController.replyLevel: ${_videoReplyController.replyLevel}');

    fabAnimationCtr = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    replyAnimationCtl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

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

    replyAnimationCtl.forward();
    await Future.delayed(const Duration(microseconds: 100));
    _videoReplyController.wakeUpReply();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _videoReplyController.scrollController,
              key: const PageStorageKey<String>('评论'),
              slivers: <Widget>[
                FutureBuilder(
                  future: _futureBuilderFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map data = snapshot.data as Map;
                      if (data['status']) {
                        // 请求成功
                        return Obx(
                          () => SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index ==
                                    _videoReplyController.replyList.length) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .padding
                                            .bottom),
                                    height:
                                        MediaQuery.of(context).padding.bottom +
                                            60,
                                    child: Center(
                                      child: Obx(() => Text(
                                          _videoReplyController.noMore.value
                                              ? '没有更多了'
                                              : '加载中')),
                                    ),
                                  );
                                } else {
                                  return ReplyItem(
                                      replyItem: _videoReplyController
                                          .replyList[index],
                                      weakUpReply: (replyItem, replyLevel) =>
                                          _showReply(
                                            'floor',
                                            replyItem: replyItem,
                                            replyLevel: replyLevel,
                                          ),
                                      replyLevel: replyLevel);
                                }
                              },
                              childCount:
                                  _videoReplyController.replyList.length + 1,
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
                  // begin: const Offset(0, 2),
                  // 评论内容为空/不足一屏
                  begin: const Offset(0, 0),
                  end: const Offset(0, 0),
                ).animate(CurvedAnimation(
                  parent: fabAnimationCtr,
                  curve: Curves.easeInOut,
                )),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () => _showReply('main'),
                  tooltip: '发表评论',
                  child: const Icon(Icons.reply),
                ),
              ),
            ),
            Obx(
              () => Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 2),
                    end: const Offset(0, 0),
                  ).animate(CurvedAnimation(
                    parent: replyAnimationCtl,
                    curve: Curves.easeInOut,
                  )),
                  child: Container(
                    height: 100 + MediaQuery.of(context).padding.bottom,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: _videoReplyController.autoFocus.value,
                            child: const TextField(
                              autofocus: true,
                              maxLines: null,
                              decoration: InputDecoration(
                                  hintText: "友善评论", border: InputBorder.none),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                _videoReplyController.submitReplyAdd(),
                            child: const Text('发送'),
                          )
                        ],
                      ),
                    ),
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
