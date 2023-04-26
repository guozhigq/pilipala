import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'controller.dart';
import 'widgets/reply_item.dart';

class VideoReplyPanel extends StatefulWidget {
  const VideoReplyPanel({super.key});

  @override
  State<VideoReplyPanel> createState() => _VideoReplyPanelState();
}

class _VideoReplyPanelState extends State<VideoReplyPanel>
    with AutomaticKeepAliveClientMixin {
  final VideoReplyController _videoReplyController =
      Get.put(VideoReplyController(), tag: Get.arguments['heroTag']);

  // 添加页面缓存
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _videoReplyController.queryReplyList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data['status']) {
            List<ReplyItemModel> replies = snapshot.data['data'].replies;
            // 添加置顶回复
            if (snapshot.data['data'].upper.top != null) {
              bool flag = false;
              for (var i = 0;
                  i < snapshot.data['data'].topReplies.length;
                  i++) {
                if (snapshot.data['data'].topReplies[i].rpid ==
                    snapshot.data['data'].upper.top.rpid) {
                  flag = true;
                }
              }
              if (!flag) {
                replies.insert(0, snapshot.data['data'].upper.top);
              }
            }

            replies.insertAll(0, snapshot.data['data'].topReplies);
            // 请求成功
            return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              if (index == replies.length) {
                return SizedBox(height: MediaQuery.of(context).padding.bottom);
              } else {
                return ReplyItem(
                    replyItem: replies[index],
                    isUp:
                        replies[index].mid == snapshot.data['data'].upper.mid);
              }
            }, childCount: replies.length + 1));
          } else {
            // 请求错误
            return HttpError(
              errMsg: snapshot.data['msg'],
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
    );
  }
}
