import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'controller.dart';
import 'widgets/reply_item.dart';

class VideoReplyPanel extends StatefulWidget {
  int oid;
  int rpid;
  String level;
  VideoReplyPanel({
    this.oid = 0,
    this.rpid = 0,
    this.level = '',
    super.key,
  });

  @override
  State<VideoReplyPanel> createState() => _VideoReplyPanelState();
}

class _VideoReplyPanelState extends State<VideoReplyPanel>
    with AutomaticKeepAliveClientMixin {
  late VideoReplyController _videoReplyController;

  // List<ReplyItemModel>? replyList;
  Future? _futureBuilderFuture;
  // 添加页面缓存
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.level == '2') {
      _videoReplyController = Get.put(
          VideoReplyController(
              widget.oid.toString(), widget.rpid.toString(), '2'),
          tag: widget.rpid.toString());
    } else {
      _videoReplyController = Get.put(
          VideoReplyController(Get.parameters['aid']!, '', '1'),
          tag: Get.arguments['heroTag']);
    }

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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        _videoReplyController.currentPage = 0;
        return await _videoReplyController.queryReplyList();
      },
      child: CustomScrollView(
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
                          if (index == _videoReplyController.replyList.length) {
                            return Container(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).padding.bottom),
                              height:
                                  MediaQuery.of(context).padding.bottom + 60,
                              child: Center(
                                child: Text(_videoReplyController.noMore
                                    ? '没有更多了'
                                    : '加载中'),
                              ),
                            );
                          } else {
                            return ReplyItem(
                              replyItem: _videoReplyController.replyList[index],
                            );
                          }
                        },
                        childCount: _videoReplyController.replyList.length + 1,
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
                    return const VideoCardHSkeleton();
                  }, childCount: 5),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
