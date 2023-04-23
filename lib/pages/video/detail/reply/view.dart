import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/reply_item.dart';
import 'controller.dart';

class VideoReplyPanel extends StatefulWidget {
  const VideoReplyPanel({super.key});

  @override
  State<VideoReplyPanel> createState() => _VideoReplyPanelState();
}

class _VideoReplyPanelState extends State<VideoReplyPanel> {
  final VideoReplyController _videoReplyController =
      Get.put(VideoReplyController(), tag: Get.arguments['heroTag']);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _videoReplyController.queryReplyList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data['status']) {
            List<dynamic> replies = snapshot.data['data'].replies;
            replies.addAll(snapshot.data['data'].topReplies);
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
