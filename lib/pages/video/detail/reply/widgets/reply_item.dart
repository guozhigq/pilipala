import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/controller.dart';
import 'package:pilipala/pages/video/detail/reply/index.dart';
import 'package:pilipala/pages/video/detail/replyNew/index.dart';
import 'package:pilipala/pages/video/detail/replyReply/index.dart';
import 'package:pilipala/utils/utils.dart';

class ReplyItem extends StatelessWidget {
  ReplyItem(
      {super.key,
      this.replyItem,
      this.addReply,
      this.replyLevel,
      this.showReplyRow});
  ReplyItemModel? replyItem;
  Function? addReply;
  String? replyLevel;
  bool? showReplyRow = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 2, 8, 0),
            child: content(context),
          ),
          // Divider(
          //   height: 1,
          //   indent: 52,
          //   endIndent: 10,
          //   color: Theme.of(context).dividerColor.withOpacity(0.08),
          // )
        ],
      ),
    );
  }

  Widget lfAvtar(context) {
    return Container(
        margin: const EdgeInsets.only(top: 5),
        child: Stack(
          children: [
            NetworkImgLayer(
              src: replyItem!.member!.avatar,
              width: 34,
              height: 34,
              type: 'avatar',
            ),
            if (replyItem!.member!.officialVerify != null &&
                replyItem!.member!.officialVerify!['type'] == 0)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Icon(
                    Icons.offline_bolt,
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ),
              ),
          ],
        )
        // child:
        // NetworkImgLayer(
        //   src: replyItem!.member!.avatar,
        //   width: 30,
        //   height: 30,
        //   type: 'avatar',
        // ),
        );
  }

  Widget content(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 头像、昵称
        GestureDetector(
          // onTap: () =>
          //     Get.toNamed('/member/${reply.userName}', parameters: {
          //   'memberAvatar': reply.avatar,
          //   'heroTag': reply.userName + heroTag,
          // }),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: replyItem!.member!.userSailing!.cardbg != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        replyItem!.member!.userSailing!.cardbg!['image'],
                      ),
                    )
                  : null,
            ),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    lfAvtar(context),
                    const SizedBox(width: 12),
                    Text(
                      replyItem!.member!.uname!,
                      style: TextStyle(
                        color: replyItem!.isUp! ||
                                replyItem!.member!.vip!['vipType'] > 0
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        fontSize:
                            Theme.of(context).textTheme.titleSmall!.fontSize,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      'assets/images/lv/lv${replyItem!.member!.level}.png',
                      height: 11,
                    ),
                    const SizedBox(width: 6),
                    if (replyItem!.isUp!) UpTag(),
                  ],
                ),
                if (replyItem!.member!.userSailing!.cardbg != null &&
                    replyItem!.member!.userSailing!.cardbg!['fan']['number'] >
                        0)
                  Positioned(
                    top: 8,
                    left: Get.size.width / 7 * 5.6,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontFamily: 'fansCard',
                        fontSize: 9,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('NO.'),
                          Text(
                            replyItem!.member!.userSailing!.cardbg!['fan']
                                ['num_desc'],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // title
        Container(
          margin: const EdgeInsets.only(top: 0, left: 45, right: 6, bottom: 6),
          child: SelectableRegion(
            magnifierConfiguration: const TextMagnifierConfiguration(),
            focusNode: FocusNode(),
            selectionControls: MaterialTextSelectionControls(),
            child: Text.rich(
              style: const TextStyle(height: 1.65),
              TextSpan(
                children: [
                  if (replyItem!.isTop!)
                    WidgetSpan(child: UpTag(tagText: 'TOP')),
                  buildContent(context, replyItem!.content!),
                ],
              ),
            ),
          ),
        ),
        // 操作区域
        bottonAction(context, replyItem!.replyControl),
        const SizedBox(height: 3),
        if (replyItem!.replies!.isNotEmpty && showReplyRow!) ...[
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 12),
            child: ReplyItemRow(
              replies: replyItem!.replies,
              replyControl: replyItem!.replyControl,
              f_rpid: replyItem!.rpid,
              replyItem: replyItem,
            ),
          ),
        ],
      ],
    );
  }

  // 感谢、回复、复制
  Widget bottonAction(context, replyControl) {
    var color = Theme.of(context).colorScheme.outline;
    return Row(
      children: [
        const SizedBox(width: 48),
        if (replyItem!.cardLabel!.isNotEmpty &&
            replyItem!.cardLabel!.contains('热评'))
          Text(
            '热评 • ',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        Text(
          Utils.dateFormat(replyItem!.ctime),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Theme.of(context).colorScheme.outline),
        ),
        if (replyItem!.replyControl != null &&
            replyItem!.replyControl!.location != '')
          Text(
            ' • ${replyItem!.replyControl!.location!}',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        const Spacer(),
        if (replyItem!.upAction!.like!)
          Icon(Icons.favorite, color: Colors.red[400], size: 18),
        SizedBox(
          height: 28,
          width: 42,
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Text('回复',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.outline)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (builder) {
                  return VideoReplyNewDialog(
                    replyLevel: replyLevel,
                    oid: replyItem!.oid,
                    root: replyItem!.rpid,
                    parent: replyItem!.rpid,
                  );
                },
              ).then((value) => {
                    // 完成评论，数据添加
                    if (value['data'] != null)
                      {
                        addReply!(value['data'])
                        // replyControl.replies.add(value['data']),
                      }
                  });
            },
          ),
        ),
        SizedBox(
          height: 32,
          child: TextButton(
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.thumbsUp,
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

// ignore: must_be_immutable
class ReplyItemRow extends StatelessWidget {
  ReplyItemRow(
      {super.key,
      this.replies,
      this.replyControl,
      this.f_rpid,
      this.replyItem});
  List? replies;
  ReplyControl? replyControl;
  int? f_rpid;
  ReplyItemModel? replyItem;

  @override
  Widget build(BuildContext context) {
    bool isShow = replyControl!.isShow!;
    int extraRow = replyControl != null && isShow ? 1 : 0;
    return Container(
      margin: const EdgeInsets.only(left: 42, right: 4, top: 0),
      child: Material(
        color: Theme.of(context).colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.hardEdge,
        animationDuration: Duration.zero,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: replies!.length + extraRow,
          itemBuilder: (context, index) {
            if (extraRow == 1 && index == replies!.length) {
              // 有楼中楼回复，在最后显示
              return InkWell(
                onTap: () => replyReply(replyItem),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize,
                      ),
                      children: [
                        if (replyControl!.upReply!)
                          const TextSpan(text: 'up主等人 '),
                        TextSpan(
                          text: replyControl!.entryText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return InkWell(
                onTap: () => replyReply(replyItem),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      8,
                      index == 0 && (extraRow == 1 || replies!.length > 1)
                          ? 8
                          : 5,
                      8,
                      5),
                  child: Text.rich(
                    overflow: extraRow == 1
                        ? TextOverflow.ellipsis
                        : TextOverflow.visible,
                    maxLines: extraRow == 1 ? 2 : null,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: replies![index].member.uname + ' ',
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .fontSize,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => {
                                  print('跳转至用户主页'),
                                },
                        ),
                        if (replies![index].isUp)
                          WidgetSpan(
                            child: UpTag(),
                          ),
                        buildContent(context, replies![index].content),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void replyReply(replyItem) {
    // replyItem 楼主评论
    VideoDetailController videoDetailCtr =
        Get.find<VideoDetailController>(tag: Get.arguments['heroTag']);
    videoDetailCtr.oid = replies!.first.oid;
    videoDetailCtr.fRpid = f_rpid!;
    videoDetailCtr.firstFloor = replyItem;
    videoDetailCtr.showReplyReplyPanel();
  }
}

InlineSpan buildContent(BuildContext context, content) {
  if (content.emote.isEmpty &&
      content.atNameToMid.isEmpty &&
      content.jumpUrl.isEmpty &&
      content.vote.isEmpty &&
      content.pictures.isEmpty) {
    return TextSpan(
      text: content.message,
      // recognizer: TapGestureRecognizer()..onTap = () => {print('点击')},
    );
  }
  List<InlineSpan> spanChilds = [];
  bool hasMatchMember = true;

  // 投票
  if (content.vote.isNotEmpty) {
    content.message.splitMapJoin(RegExp(r"\{vote:.*?\}"),
        onMatch: (Match match) {
      String matchStr = match[0]!;
      spanChilds.add(
        TextSpan(
          text: '投票: ${content.vote['title']}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => {
                  Get.toNamed(
                    '/webview',
                    parameters: {
                      'url': content.vote['url'],
                      'type': 'vote',
                      'pageTitle': content.vote['title'],
                    },
                  )
                },
        ),
      );
      return '';
    }, onNonMatch: (String str) {
      return str;
    });
  }
  // content.message = content.message.replaceAll(RegExp(r"\{vote:.*?\}"), ' ');
  // 匹配表情
  String matchEmote = content.message.splitMapJoin(
    RegExp(r"\[.*?\]"),
    onMatch: (Match match) {
      String matchStr = match[0]!;
      if (content.emote.isNotEmpty &&
          matchStr.indexOf('[') == matchStr.lastIndexOf('[') &&
          matchStr.indexOf(']') == matchStr.lastIndexOf(']')) {
        int size = content.emote[matchStr]['meta']['size'];
        if (content.emote.keys.contains(matchStr)) {
          spanChilds.add(
            WidgetSpan(
              child: NetworkImgLayer(
                src: content.emote[matchStr]['url'],
                type: 'emote',
                width: size * 20,
                height: size * 20,
              ),
            ),
          );
        } else {
          spanChilds.add(TextSpan(text: matchStr));
          return matchStr;
        }
      } else {
        spanChilds.add(TextSpan(text: matchStr));
        return matchStr;
      }
      return '';
    },
    onNonMatch: (String str) {
      // 匹配@用户
      String matchMember = str;
      if (content.atNameToMid.isNotEmpty) {
        matchMember = str.splitMapJoin(
          RegExp(r"@.*( |:)"),
          onMatch: (Match match) {
            if (match[0] != null) {
              hasMatchMember = false;
              content.atNameToMid.forEach((key, value) {
                spanChilds.add(
                  TextSpan(
                    text: '@$key ',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleSmall!.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => {
                            print('跳转至用户主页'),
                          },
                  ),
                );
              });
            }
            return '';
          },
          onNonMatch: (String str) {
            spanChilds.add(TextSpan(text: str));
            return str;
          },
        );
      } else {
        matchMember = str;
      }

      // 匹配 jumpUrl
      String matchUrl = matchMember;
      if (content.jumpUrl.isNotEmpty && hasMatchMember) {
        List urlKeys = content.jumpUrl.keys.toList();
        matchUrl = matchMember.splitMapJoin(
          RegExp("(?:${urlKeys.join("|")})"),
          onMatch: (Match match) {
            String matchStr = match[0]!;
            spanChilds.add(
              TextSpan(
                text: content.jumpUrl[matchStr]['title'],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => {
                        Get.toNamed('/searchResult', parameters: {
                          'keyword': content.jumpUrl[matchStr]['title']
                        })
                      },
              ),
            );
            spanChilds.add(
              WidgetSpan(
                child: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 9,
                  color: Theme.of(context).colorScheme.primary,
                ),
                alignment: PlaceholderAlignment.top,
              ),
            );
            return '';
          },
          onNonMatch: (String str) {
            spanChilds.add(TextSpan(text: str));
            return str;
          },
        );
      }
      str = matchUrl.splitMapJoin(
        RegExp(r"\d{1,2}:\d{1,2}"),
        onMatch: (Match match) {
          String matchStr = match[0]!;
          spanChilds.add(
            TextSpan(
              text: ' $matchStr ',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              // recognizer: TapGestureRecognizer()
              //   ..onTap = () => {
              //         print('time 点击'),
              //       },
            ),
          );
          return '';
        },
        onNonMatch: (str) {
          return str;
        },
      );

      if (content.atNameToMid.isEmpty && content.jumpUrl.isEmpty) {
        spanChilds.add(TextSpan(text: str));
      }
      return str;
    },
  );

  // 图片渲染
  if (content.pictures.isNotEmpty) {
    List picList = [];
    int len = content.pictures.length;
    if (len == 1) {
      Map pictureItem = content.pictures.first;
      picList.add(pictureItem['img_src']);
      spanChilds.add(const TextSpan(text: '\n'));
      spanChilds.add(
        WidgetSpan(
          child: LayoutBuilder(
            builder: (context, BoxConstraints box) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed('/preview',
                      arguments: {'initialPage': 0, 'imgList': picList});
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: NetworkImgLayer(
                    src: pictureItem['img_src'],
                    width: box.maxWidth / 2,
                    height: box.maxWidth *
                        0.5 *
                        pictureItem['img_height'] /
                        pictureItem['img_width'],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    if (len > 1) {
      List<Widget> list = [];
      for (var i = 0; i < len; i++) {
        picList.add(content.pictures[i]['img_src']);
        list.add(
          LayoutBuilder(
            builder: (context, BoxConstraints box) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed('/preview',
                      arguments: {'initialPage': i, 'imgList': picList});
                },
                child: NetworkImgLayer(
                  src: content.pictures[i]['img_src'],
                  width: box.maxWidth,
                  height: box.maxWidth,
                ),
              );
            },
          ),
        );
      }
      spanChilds.add(
        WidgetSpan(
          child: LayoutBuilder(
            builder: (context, BoxConstraints box) {
              double maxWidth = box.maxWidth;
              double crossCount = len < 3 ? 2 : 3;
              double height = maxWidth /
                      crossCount *
                      (len % crossCount == 0
                          ? len ~/ crossCount
                          : len ~/ crossCount + 1) +
                  6;
              return Container(
                padding: const EdgeInsets.only(top: 6),
                height: height,
                child: GridView(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  // 子Item排列规则
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //横轴元素个数
                    crossAxisCount: crossCount.toInt(),
                    //纵轴间距
                    mainAxisSpacing: 4.0,
                    //横轴间距
                    crossAxisSpacing: 4.0,
                    //子组件宽高长度比例
                    // childAspectRatio: 1,
                  ),
                  //GridView中使用的子Widegt
                  children: list,
                ),
              );
            },
          ),
        ),
      );
    }
  }

  // 笔记链接
  if (content.richText.isNotEmpty) {
    spanChilds.add(
      TextSpan(
        text: ' 笔记',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => {
                Get.toNamed(
                  '/webview',
                  parameters: {
                    'url': content.richText['note']['click_url'],
                    'type': 'note',
                    'pageTitle': '笔记预览'
                  },
                )
              },
      ),
    );
  }
  // spanChilds.add(TextSpan(text: matchMember));
  return TextSpan(children: spanChilds);
}

class UpTag extends StatelessWidget {
  String? tagText;
  UpTag({super.key, this.tagText = 'UP'});
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return Container(
      width: 24,
      height: 14,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: tagText == 'UP' ? primary : null,
          border: Border.all(color: primary)),
      margin: const EdgeInsets.only(right: 4),
      child: Center(
        child: Text(
          tagText!,
          style: TextStyle(
            fontSize: 9,
            color: tagText == 'UP'
                ? Theme.of(context).colorScheme.onPrimary
                : primary,
          ),
        ),
      ),
    );
  }
}
