import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/utils/utils.dart';

class ReplyItem extends StatelessWidget {
  ReplyItem({super.key, this.replyItem, required this.isUp});
  ReplyItemModel? replyItem;
  bool isUp = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 14),
            child: content(context),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.08),
          )
        ],
      ),
    );
  }

  Widget lfAvtar(context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.03)),
      ),
      child: NetworkImgLayer(
        src: replyItem!.member!.avatar,
        width: 34,
        height: 34,
        type: 'avatar',
      ),
    );
  }

  Widget content(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 头像、昵称
        Row(
          // 两端对齐
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              // onTap: () =>
              //     Get.toNamed('/member/${reply.userName}', parameters: {
              //   'memberAvatar': reply.avatar,
              //   'heroTag': reply.userName + heroTag,
              // }),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  lfAvtar(context),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            replyItem!.member!.uname!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: isUp!
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                ),
                          ),
                          const SizedBox(width: 6),
                          Image.asset(
                            'assets/images/lv/lv${replyItem!.member!.level}.png',
                            height: 13,
                          ),
                        ],
                      ),
                      Text(
                        Utils.dateFormat(replyItem!.ctime),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // SizedBox(
            //   width: 35,
            //   height: 35,
            //   child: IconButton(
            //     padding: const EdgeInsets.all(2.0),
            //     icon: const Icon(Icons.more_horiz_outlined, size: 18.0),
            //     onPressed: () {},
            //   ),
            // )
          ],
        ),
        // title
        Container(
          margin: const EdgeInsets.only(top: 6, left: 45, right: 8),
          child: SelectionArea(
            child: Text(
              replyItem!.content!.message!,
              style: const TextStyle(height: 1.8),
            ),
          ),
        ),
        bottonAction(context),
        // Text(replyItem!.replies!.length.toString()),
        if (replyItem!.replies!.isNotEmpty)
          ReplyItemRow(
            replies: replyItem!.replies,
            replyControl: replyItem!.replyControl,
          )
      ],
    );
  }

  // 感谢、回复、复制
  Widget bottonAction(context) {
    var color = Theme.of(context).colorScheme.outline;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 42),
        SizedBox(
          height: 35,
          child: TextButton(
            child: Row(
              children: [
                Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 4),
                Text(
                  replyItem!.like.toString(),
                  style: TextStyle(
                      color: color,
                      fontSize:
                          Theme.of(context).textTheme.labelSmall!.fontSize),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 5)
      ],
    );
  }
}

class ReplyItemRow extends StatelessWidget {
  ReplyItemRow({super.key, this.replies, this.replyControl});
  List? replies;
  var replyControl;

  @override
  Widget build(BuildContext context) {
    bool isShow = replyControl.isShow;
    int extraRow = replyControl != null && isShow ? 1 : 0;
    return Container(
      margin: const EdgeInsets.only(left: 45, right: 10),
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Theme.of(context).colorScheme.onInverseSurface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.hardEdge,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: replies!.length + extraRow,
          itemBuilder: (context, index) {
            if (extraRow == 1 && index == replies!.length) {
              return ListTile(
                onTap: () {},
                dense: true,
                contentPadding: const EdgeInsets.only(left: 10, right: 6),
                title: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize:
                          Theme.of(context).textTheme.titleSmall!.fontSize,
                    ),
                    children: [
                      if (replyControl.upReply) const TextSpan(text: 'up回复了'),
                      if (replyControl.isUpTop) const TextSpan(text: 'up点赞了'),
                      TextSpan(text: replyControl.entryText)
                    ],
                  ),
                ),
              );
            } else {
              return ListTile(
                onTap: () {},
                dense: true,
                contentPadding: const EdgeInsets.only(left: 10, right: 6),
                title: Text.rich(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  TextSpan(
                    children: [
                      TextSpan(
                          text: replies![index].member.uname + '：',
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .fontSize,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => {print('跳转至用户主页')}),
                      TextSpan(
                        text: replies![index].content.message,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleSmall!.fontSize,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
