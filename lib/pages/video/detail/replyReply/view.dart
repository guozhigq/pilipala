import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_reply.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/reply/widgets/reply_item.dart';

import 'controller.dart';

class VideoReplyReplyPanel extends StatefulWidget {
  int? oid;
  int? rpid;
  Function? closePanel;
  ReplyItemModel? firstFloor;
  VideoReplyReplyPanel({
    this.oid,
    this.rpid,
    this.closePanel,
    this.firstFloor,
    super.key,
  });

  @override
  State<VideoReplyReplyPanel> createState() => _VideoReplyReplyPanelState();
}

class _VideoReplyReplyPanelState extends State<VideoReplyReplyPanel> {
  late VideoReplyReplyController _videoReplyReplyController;
  late AnimationController replyAnimationCtl;

  @override
  void initState() {
    _videoReplyReplyController = Get.put(
        VideoReplyReplyController(
            widget.oid.toString(), widget.rpid.toString()),
        tag: widget.rpid.toString());
    super.initState();

    // 上拉加载更多
    _videoReplyReplyController.scrollController.addListener(
      () {
        if (_videoReplyReplyController.scrollController.position.pixels >=
            _videoReplyReplyController
                    .scrollController.position.maxScrollExtent -
                300) {
          if (!_videoReplyReplyController.isLoadingMore) {
            _videoReplyReplyController.onLoad();
          }
        }
      },
    );
  }

  @override
  void dispose() {
    // _videoReplyReplyController.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.size.height - Get.size.width * 9 / 16 - 48,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Container(
            height: 45,
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '评论详情',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _videoReplyReplyController.currentPage = 0;
                    _videoReplyReplyController.rPid = 0;
                    widget.closePanel!();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                _videoReplyReplyController.currentPage = 0;
                return await _videoReplyReplyController.queryReplyList();
              },
              child: CustomScrollView(
                controller: _videoReplyReplyController.scrollController,
                slivers: <Widget>[
                  if (widget.firstFloor != null) ...[
                    SliverToBoxAdapter(
                      child: ReplyItem(
                        replyItem: widget.firstFloor,
                        replyLevel: '2',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Divider(
                        height: 30,
                        color: Theme.of(context).dividerColor.withOpacity(0.1),
                        thickness: 6,
                      ),
                    ),
                  ],
                  FutureBuilder(
                    future: _videoReplyReplyController.queryReplyList(),
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
                                      _videoReplyReplyController
                                          .replyList.length) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom),
                                      height: MediaQuery.of(context)
                                              .padding
                                              .bottom +
                                          60,
                                      child: Center(
                                        child: Obx(() => Text(
                                            _videoReplyReplyController
                                                    .noMore.value
                                                ? '没有更多了'
                                                : '加载中')),
                                      ),
                                    );
                                  } else {
                                    return ReplyItem(
                                      replyItem: _videoReplyReplyController
                                          .replyList[index],
                                    );
                                  }
                                },
                                childCount: _videoReplyReplyController
                                        .replyList.length +
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
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                            return const VideoReplySkeleton();
                          }, childCount: 5),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
