import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/msg/reply.dart';
import 'package:pilipala/utils/utils.dart';

import 'controller.dart';

class MessageReplyPage extends StatefulWidget {
  const MessageReplyPage({super.key});

  @override
  State<MessageReplyPage> createState() => _MessageReplyPageState();
}

class _MessageReplyPageState extends State<MessageReplyPage> {
  final MessageReplyController _messageReplyCtr =
      Get.put(MessageReplyController());
  late Future _futureBuilderFuture;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _messageReplyCtr.queryMessageReply();
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle('follow', const Duration(seconds: 1), () {
            _messageReplyCtr.queryMessageReply(type: 'onLoad');
          });
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('回复我的'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _messageReplyCtr.queryMessageReply(type: 'init');
        },
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return const SizedBox();
              }
              if (snapshot.data['status']) {
                final replyItems = _messageReplyCtr.replyItems;
                return Obx(
                  () => ListView.separated(
                    controller: scrollController,
                    itemBuilder: (context, index) =>
                        ReplyItem(item: replyItems[index]),
                    itemCount: replyItems.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        indent: 66,
                        endIndent: 14,
                        height: 1,
                        color: Colors.grey.withOpacity(0.1),
                      );
                    },
                  ),
                );
              } else {
                // 请求错误
                return CustomScrollView(
                  slivers: [
                    HttpError(
                      errMsg: snapshot.data['msg'],
                      fn: () {
                        setState(() {
                          _futureBuilderFuture =
                              _messageReplyCtr.queryMessageReply();
                        });
                      },
                    )
                  ],
                );
              }
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class ReplyItem extends StatelessWidget {
  final MessageReplyItem item;

  const ReplyItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String heroTag = Utils.makeHeroTag(item.user!.mid);
    final String bvid = item.item!.uri!.split('/').last;
    // 页码
    final String page =
        item.item!.nativeUri!.split('page=').last.split('&').first;
    // 根评论id
    final String commentRootId =
        item.item!.nativeUri!.split('comment_root_id=').last.split('&').first;
    // 二级评论id
    final String commentSecondaryId =
        item.item!.nativeUri!.split('comment_secondary_id=').last;

    return InkWell(
      onTap: () async {
        final int cid = await SearchHttp.ab2c(bvid: bvid);
        final String heroTag = Utils.makeHeroTag(bvid);
        Get.toNamed<dynamic>(
          '/video?bvid=$bvid&cid=$cid',
          arguments: <String, String?>{
            'pic': '',
            'heroTag': heroTag,
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed('/member?mid=${item.user!.mid}',
                    arguments: {'face': item.user!.avatar, 'heroTag': heroTag});
              },
              child: Hero(
                tag: heroTag,
                child: NetworkImgLayer(
                  width: 42,
                  height: 42,
                  type: 'avatar',
                  src: item.user!.avatar,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: item.user!.nickname!),
                    const TextSpan(text: ' '),
                    if (item.item!.type! == 'video')
                      TextSpan(
                        text: '对我的视频发表了评论',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    if (item.item!.type! == 'reply')
                      TextSpan(
                        text: '回复了我的评论',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                  ])),
                  const SizedBox(height: 6),
                  Text.rich(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(letterSpacing: 0.3),
                      buildContent(context, item.item)),
                  if (item.item!.targetReplyContent != '') ...[
                    const SizedBox(height: 2),
                    Text(
                      item.item!.targetReplyContent!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        Utils.dateFormat(item.replyTime!, formatType: 'detail'),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '回复',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Spacer(),
            const SizedBox(width: 25),
            if (item.item!.type! == 'reply')
              Container(
                width: 60,
                height: 80,
                padding: const EdgeInsets.all(4),
                child: Text(
                  item.item!.rootReplyContent!,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 12,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (item.item!.type! == 'video')
              NetworkImgLayer(
                width: 60,
                height: 60,
                src: item.item!.image,
              ),
          ],
        ),
      ),
    );
  }
}

InlineSpan buildContent(BuildContext context, item) {
  List? atDetails = item!.atDetails;
  final List<InlineSpan> spanChilds = <InlineSpan>[];
  if (atDetails!.isNotEmpty) {
    final String patternStr =
        atDetails.map<String>((e) => '@${e['nickname']}').toList().join('|');
    final RegExp regExp = RegExp(patternStr);
    item.sourceContent!.splitMapJoin(
      regExp,
      onMatch: (Match match) {
        spanChilds.add(
          TextSpan(
            text: match.group(0),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                var currentUser = atDetails
                    .where((e) => e['nickname'] == match.group(0)!.substring(1))
                    .first;
                Get.toNamed('/member?mid=${currentUser['mid']}', arguments: {
                  'face': currentUser['avatar'],
                });
              },
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        );
        return '';
      },
      onNonMatch: (String nonMatch) {
        spanChilds.add(
          TextSpan(text: nonMatch),
        );
        return '';
      },
    );
  } else {
    spanChilds.add(
      TextSpan(text: item.sourceContent),
    );
  }

  return TextSpan(children: spanChilds);
}
