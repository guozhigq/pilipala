import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/utils/feed_back.dart';

class ZanButton extends StatefulWidget {
  const ZanButton({
    super.key,
    this.replyItem,
    this.replyType,
  });

  final ReplyItemModel? replyItem;
  final ReplyType? replyType;

  @override
  State<ZanButton> createState() => _ZanButtonState();
}

class _ZanButtonState extends State<ZanButton> {
  // 评论点赞
  Future onLikeReply() async {
    feedBack();
    // SmartDialog.showLoading(msg: 'pilipala ...');
    ReplyItemModel replyItem = widget.replyItem!;
    int oid = replyItem.oid!;
    int rpid = replyItem.rpid!;
    // 1 已点赞 2 不喜欢 0 未操作
    int action = replyItem.action == 0 ? 1 : 0;
    var res = await ReplyHttp.likeReply(
        type: widget.replyType!.index, oid: oid, rpid: rpid, action: action);
    // SmartDialog.dismiss();
    if (res['status']) {
      SmartDialog.showToast(replyItem.action == 0 ? '点赞成功 👍' : '取消赞 💔');
      if (action == 1) {
        replyItem.like = replyItem.like! + 1;
        replyItem.action = 1;
      } else {
        replyItem.like = replyItem.like! - 1;
        replyItem.action = 0;
      }
      setState(() {});
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
  bool isProcessing = false;
  VoidCallback handleState(Future Function() action) {
    return () async {
      if (!isProcessing) {
        setState(() => isProcessing = true);
        await action();
        setState(() => isProcessing = false);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme.outline;
    var primary = Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 32,
      child: TextButton(
        onPressed: handleState(onLikeReply),
        child: Row(
          children: [
            Icon(
              widget.replyItem!.action == 1
                  ? FontAwesomeIcons.solidThumbsUp
                  : FontAwesomeIcons.thumbsUp,
              size: 16,
              color: widget.replyItem!.action == 1 ? primary : color,
            ),
            const SizedBox(width: 4),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(widget.replyItem!.like.toString(),
                  key: ValueKey<int>(widget.replyItem!.like!),
                  style: TextStyle(
                      color: widget.replyItem!.action == 1 ? primary : color,
                      fontSize:
                          Theme.of(context).textTheme.labelSmall!.fontSize)),
            ),
          ],
        ),
      ),
    );
  }
}
