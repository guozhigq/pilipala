import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/skeleton/video_reply.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/reply/widgets/reply_item.dart';
import 'package:pilipala/utils/storage.dart';
import 'controller.dart';

class VideoReplyReplyPanel extends StatefulWidget {
  const VideoReplyReplyPanel({
    this.oid,
    this.rpid,
    this.closePanel,
    this.firstFloor,
    this.source,
    this.replyType,
    this.sheetHeight,
    this.currentReply,
    this.loadMore = true,
    this.showRoot = false,
    super.key,
  });
  final int? oid;
  final int? rpid;
  final Function? closePanel;
  final ReplyItemModel? firstFloor;
  final String? source;
  final ReplyType? replyType;
  final double? sheetHeight;
  final dynamic currentReply;
  final bool loadMore;
  final bool showRoot;

  @override
  State<VideoReplyReplyPanel> createState() => _VideoReplyReplyPanelState();
}

class _VideoReplyReplyPanelState extends State<VideoReplyReplyPanel> {
  late VideoReplyReplyController _videoReplyReplyController;
  late AnimationController replyAnimationCtl;
  final Box<dynamic> localCache = GStrorage.localCache;
  Future? _futureBuilderFuture;
  late ScrollController scrollController;

  @override
  void initState() {
    _videoReplyReplyController = Get.put(
        VideoReplyReplyController(
          widget.oid,
          widget.rpid.toString(),
          widget.replyType!,
          widget.showRoot,
        ),
        tag: widget.rpid.toString());
    super.initState();

    // 上拉加载更多
    scrollController = _videoReplyReplyController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          EasyThrottle.throttle('replylist', const Duration(milliseconds: 200),
              () {
            _videoReplyReplyController.queryReplyList(type: 'onLoad');
          });
        }
      },
    );

    _futureBuilderFuture = _videoReplyReplyController.queryReplyList(
      currentReply: widget.currentReply,
    );
  }

  void replyReply(replyItem) {}

  @override
  void dispose() {
    // scrollController.dispose();
    super.dispose();
  }

  Widget _buildAppBar() {
    return AppBar(
      toolbarHeight: 45,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(
        '评论详情',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: () {
            _videoReplyReplyController.currentPage = 0;
            widget.closePanel?.call();
            Navigator.pop(context);
          },
        ),
        const SizedBox(width: 14),
      ],
    );
  }

  Widget _buildReplyItem(ReplyItemModel? replyItem, String replyLevel) {
    return ReplyItem(
      replyItem: replyItem,
      replyLevel: replyLevel,
      showReplyRow: false,
      addReply: (replyItem) {
        _videoReplyReplyController.replyList.add(replyItem);
      },
      replyType: widget.replyType,
      replyReply: (replyItem) => replyReply(replyItem),
    );
  }

  Widget _buildSliverList() {
    return Obx(
      () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (index == 0) {
              return _videoReplyReplyController.rootReply != null
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.1),
                            width: 6,
                          ),
                        ),
                      ),
                      child: _buildReplyItem(
                          _videoReplyReplyController.rootReply, '1'),
                    )
                  : const SizedBox();
            }
            int adjustedIndex = index - 1;
            if (adjustedIndex == _videoReplyReplyController.replyList.length) {
              return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                height: MediaQuery.of(context).padding.bottom + 100,
                child: Center(
                  child: Obx(
                    () => Text(
                      _videoReplyReplyController.noMore.value,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return _buildReplyItem(
                  _videoReplyReplyController.replyList[adjustedIndex], '2');
            }
          },
          childCount: _videoReplyReplyController.replyList.length + 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.source == 'videoDetail' ? widget.sheetHeight : null,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          if (widget.source == 'videoDetail') _buildAppBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _videoReplyReplyController.currentPage = 1;
                return await _videoReplyReplyController.queryReplyList(
                  currentReply: widget.currentReply,
                );
              },
              child: CustomScrollView(
                controller: _videoReplyReplyController.scrollController,
                slivers: <Widget>[
                  if (widget.firstFloor != null)
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.1),
                              width: 6,
                            ),
                          ),
                        ),
                        child: _buildReplyItem(widget.firstFloor, '2'),
                      ),
                    ),
                  widget.loadMore
                      ? FutureBuilder(
                          future: _futureBuilderFuture,
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map? data = snapshot.data;
                              if (data != null && data['status']) {
                                return _buildSliverList();
                              } else {
                                return HttpError(
                                  errMsg: data?['msg'] ?? '请求错误',
                                  fn: () => setState(() {}),
                                );
                              }
                            } else {
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return const VideoReplySkeleton();
                                  },
                                  childCount: 8,
                                ),
                              );
                            }
                          },
                        )
                      : SliverToBoxAdapter(
                          child: SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(
                                '还没有评论',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
