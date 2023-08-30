import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/pages/video/detail/replyNew/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/utils.dart';

import 'zan.dart';

Box setting = GStrorage.setting;

class ReplyItem extends StatelessWidget {
  const ReplyItem({
    this.replyItem,
    this.addReply,
    this.replyLevel,
    this.showReplyRow = true,
    this.replyReply,
    this.replyType,
    Key? key,
  }) : super(key: key);
  final ReplyItemModel? replyItem;
  final Function? addReply;
  final String? replyLevel;
  final bool? showReplyRow;
  final Function? replyReply;
  final ReplyType? replyType;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        // 点击整个评论区 评论详情/回复
        onTap: () {
          feedBack();
          if (replyReply != null) {
            replyReply!(replyItem);
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 8, 5),
              child: content(context),
            ),
            Divider(
              indent: 55,
              endIndent: 15,
              height: 0.3,
              color: Theme.of(context)
                  .colorScheme
                  .onInverseSurface
                  .withOpacity(0.5),
            )
          ],
        ),
      ),
    );
  }

  Widget lfAvtar(context, heroTag) {
    return Stack(
      children: [
        Hero(
          tag: heroTag,
          child: NetworkImgLayer(
            src: replyItem!.member!.avatar,
            width: 34,
            height: 34,
            type: 'avatar',
          ),
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
        if (replyItem!.member!.vip!['vipStatus'] > 0 &&
            replyItem!.member!.vip!['vipType'] == 2)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Image.asset(
                'assets/images/big-vip.png',
                height: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget content(context) {
    String heroTag = Utils.makeHeroTag(replyItem!.mid);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 头像、昵称
        // SizedBox(
        //   width: double.infinity,
        //   child: Stack(
        //     children: [
        //       GestureDetector(
        //         behavior: HitTestBehavior.opaque,
        //         onTap: () {
        //           feedBack();
        //           Get.toNamed('/member?mid=${replyItem!.mid}', arguments: {
        //             'face': replyItem!.member!.avatar!,
        //             'heroTag': heroTag
        //           });
        //         },
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisSize: MainAxisSize.min,
        //           children: <Widget>[
        //             lfAvtar(context, heroTag),
        //             const SizedBox(width: 12),
        //             Text(
        //               replyItem!.member!.uname!,
        //               style: TextStyle(
        //                 color: replyItem!.member!.vip!['vipStatus'] > 0
        //                     ? const Color.fromARGB(255, 251, 100, 163)
        //                     : Theme.of(context).colorScheme.outline,
        //                 fontSize: 13,
        //               ),
        //             ),
        //             const SizedBox(width: 6),
        //             Image.asset(
        //               'assets/images/lv/lv${replyItem!.member!.level}.png',
        //               height: 11,
        //             ),
        //             const SizedBox(width: 6),
        //             if (replyItem!.isUp!)
        //               const PBadge(
        //                 text: 'UP',
        //                 size: 'small',
        //                 stack: 'normal',
        //                 fs: 9,
        //               ),
        //           ],
        //         ),
        //       ),
        //       Positioned(
        //         top: 0,
        //         left: 0,
        //         right: 0,
        //         child: Container(
        //           width: double.infinity,
        //           height: 45,
        //           decoration: BoxDecoration(
        //             image: replyItem!.member!.userSailing!.cardbg != null
        //                 ? DecorationImage(
        //                     alignment: Alignment.centerRight,
        //                     fit: BoxFit.fitHeight,
        //                     image: NetworkImage(
        //                       replyItem!.member!.userSailing!.cardbg!['image'],
        //                     ),
        //                   )
        //                 : null,
        //           ),
        //         ),
        //       ),
        //       if (replyItem!.member!.userSailing!.cardbg != null &&
        //           replyItem!.member!.userSailing!.cardbg!['fan']['number'] > 0)
        //         Positioned(
        //           top: 10,
        //           left: Get.size.width / 7 * 5.8,
        //           child: DefaultTextStyle(
        //             style: TextStyle(
        //               fontFamily: 'fansCard',
        //               fontSize: 9,
        //               color: Theme.of(context).colorScheme.primary,
        //             ),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 const Text('NO.'),
        //                 Text(
        //                   replyItem!.member!.userSailing!.cardbg!['fan']
        //                       ['num_desc'],
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //     ],
        //   ),
        // ),
        /// fix Stack内GestureDetector  onTap无效
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            feedBack();
            Get.toNamed('/member?mid=${replyItem!.mid}', arguments: {
              'face': replyItem!.member!.avatar!,
              'heroTag': heroTag
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              lfAvtar(context, heroTag),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        replyItem!.member!.uname!,
                        style: TextStyle(
                          color: replyItem!.member!.vip!['vipStatus'] > 0
                              ? const Color.fromARGB(255, 251, 100, 163)
                              : Theme.of(context).colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(
                        'assets/images/lv/lv${replyItem!.member!.level}.png',
                        height: 11,
                      ),
                      const SizedBox(width: 6),
                      if (replyItem!.isUp!)
                        const PBadge(
                          text: 'UP',
                          size: 'small',
                          stack: 'normal',
                          fs: 9,
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        Utils.dateFormat(replyItem!.ctime),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelSmall!.fontSize,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      if (replyItem!.replyControl != null &&
                          replyItem!.replyControl!.location != '')
                        Text(
                          ' • ${replyItem!.replyControl!.location!}',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .fontSize,
                              color: Theme.of(context).colorScheme.outline),
                        ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        // title
        Container(
          margin: const EdgeInsets.only(top: 10, left: 45, right: 6, bottom: 4),
          child: SelectableRegion(
            magnifierConfiguration: const TextMagnifierConfiguration(),
            focusNode: FocusNode(),
            selectionControls: MaterialTextSelectionControls(),
            child: Text.rich(
              style: const TextStyle(height: 1.75),
              maxLines:
                  replyItem!.content!.isText! && replyLevel == '1' ? 3 : 999,
              overflow: TextOverflow.ellipsis,
              TextSpan(
                children: [
                  if (replyItem!.isTop!)
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: PBadge(
                        text: 'TOP',
                        size: 'small',
                        stack: 'normal',
                        type: 'line',
                        fs: 9,
                      ),
                    ),
                  buildContent(context, replyItem!, replyReply, null),
                ],
              ),
            ),
          ),
        ),
        // 操作区域
        bottonAction(context, replyItem!.replyControl),
        // 一楼的评论
        if ((replyItem!.replyControl!.isShow! ||
                replyItem!.replies!.isNotEmpty) &&
            showReplyRow!) ...[
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 12),
            child: ReplyItemRow(
              replies: replyItem!.replies,
              replyControl: replyItem!.replyControl,
              // f_rpid: replyItem!.rpid,
              replyItem: replyItem,
              replyReply: replyReply,
            ),
          ),
        ],
      ],
    );
  }

  // 感谢、回复、复制
  Widget bottonAction(context, replyControl) {
    return Row(
      children: [
        const SizedBox(width: 32),
        SizedBox(
          height: 32,
          child: TextButton(
            onPressed: () {
              feedBack();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (builder) {
                  return VideoReplyNewDialog(
                    oid: replyItem!.oid,
                    root: replyItem!.rpid,
                    parent: replyItem!.rpid,
                    replyType: replyType,
                    replyItem: replyItem,
                  );
                },
              ).then((value) => {
                    // 完成评论，数据添加
                    if (value != null && value['data'] != null)
                      {
                        addReply!(value['data'])
                        // replyControl.replies.add(value['data']),
                      }
                  });
            },
            child: Row(children: [
              Icon(Icons.reply,
                  size: 18,
                  color:
                      Theme.of(context).colorScheme.outline.withOpacity(0.8)),
              const SizedBox(width: 3),
              Text(
                '回复',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ]),
          ),
        ),
        const SizedBox(width: 2),
        if (replyItem!.upAction!.like!) ...[
          Text(
            'up主觉得很赞',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize),
          ),
          const SizedBox(width: 2),
        ],
        if (replyItem!.cardLabel!.isNotEmpty &&
            replyItem!.cardLabel!.contains('热评'))
          Text(
            '热评',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize),
          ),
        const Spacer(),
        ZanButton(replyItem: replyItem, replyType: replyType),
        const SizedBox(width: 5)
      ],
    );
  }
}

// ignore: must_be_immutable
class ReplyItemRow extends StatelessWidget {
  ReplyItemRow({
    super.key,
    this.replies,
    this.replyControl,
    // this.f_rpid,
    this.replyItem,
    this.replyReply,
  });
  List? replies;
  ReplyControl? replyControl;
  // int? f_rpid;
  ReplyItemModel? replyItem;
  Function? replyReply;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (replies!.isNotEmpty)
              for (var i = 0; i < replies!.length; i++) ...[
                InkWell(
                  // 一楼点击评论展开评论详情
                  onTap: () => replyReply!(replyItem),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      8,
                      i == 0 && (extraRow == 1 || replies!.length > 1) ? 8 : 5,
                      8,
                      i == 0 && (extraRow == 1 || replies!.length > 1) ? 5 : 6,
                    ),
                    child: Text.rich(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: replies![i].member.uname + ' ',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .fontSize,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                feedBack();
                                String heroTag =
                                    Utils.makeHeroTag(replies![i].member.mid);
                                Get.toNamed(
                                    '/member?mid=${replies![i].member.mid}',
                                    arguments: {
                                      'face': replies![i].member.avatar,
                                      'heroTag': heroTag
                                    });
                              },
                          ),
                          if (replies![i].isUp)
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.top,
                              child: PBadge(
                                text: 'UP',
                                size: 'small',
                                stack: 'normal',
                                fs: 9,
                              ),
                            ),
                          buildContent(
                              context, replies![i], replyReply, replyItem),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            if (extraRow == 1)
              InkWell(
                // 一楼点击【共xx条回复】展开评论详情
                onTap: () => replyReply!(replyItem),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
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
              )
          ],
        ),
      ),
    );
  }
}

InlineSpan buildContent(
    BuildContext context, replyItem, replyReply, fReplyItem) {
  // replyItem 当前回复内容
  // replyReply 查看二楼回复（回复详情）回调
  // fReplyItem 父级回复内容，用作二楼回复（回复详情）展示
  var content = replyItem.content;
  if (content.emote.isEmpty &&
      content.atNameToMid.isEmpty &&
      content.jumpUrl.isEmpty &&
      content.vote.isEmpty &&
      content.pictures.isEmpty) {
    return TextSpan(
      text: content.message,
      recognizer: TapGestureRecognizer()
        ..onTap =
            () => replyReply(replyItem.root == 0 ? replyItem : fReplyItem),
    );
  }
  List<InlineSpan> spanChilds = [];
  bool hasMatchMember = true;

  // 投票
  if (content.vote.isNotEmpty) {
    content.message.splitMapJoin(RegExp(r"\{vote:.*?\}"),
        onMatch: (Match match) {
      // String matchStr = match[0]!;
      spanChilds.add(
        TextSpan(
          text: '投票: ${content.vote['title']}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => Get.toNamed(
                  '/webview',
                  parameters: {
                    'url': content.vote['url'],
                    'type': 'vote',
                    'pageTitle': content.vote['title'],
                  },
                ),
        ),
      );
      return '';
    }, onNonMatch: (String str) {
      return str;
    });
  }
  // content.message = content.message.replaceAll(RegExp(r"\{vote:.*?\}"), ' ');
  if (content.message.contains('&amp;')) {
    content.message = content.message.replaceAll('&amp;', '&');
  }
  // 匹配表情
  content.message.splitMapJoin(
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
          spanChilds.add(TextSpan(
              text: matchStr,
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    replyReply(replyItem.root == 0 ? replyItem : fReplyItem)));
          return matchStr;
        }
      } else {
        spanChilds.add(TextSpan(
            text: matchStr,
            recognizer: TapGestureRecognizer()
              ..onTap = () =>
                  replyReply(replyItem.root == 0 ? replyItem : fReplyItem)));
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
                      ..onTap = () {
                        String heroTag = Utils.makeHeroTag(value);
                        Get.toNamed(
                          '/member?mid=$value',
                          arguments: {'face': '', 'heroTag': heroTag},
                        );
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
          /// RegExp.escape() 转义特殊字符
          RegExp(RegExp.escape(urlKeys.join("|"))),
          onMatch: (Match match) {
            String matchStr = match[0]!;
            String appUrlSchema = content.jumpUrl[matchStr]['app_url_schema'];
            // 默认不显示关键词
            bool enableWordRe =
                setting.get(SettingBoxKey.enableWordRe, defaultValue: false);
            spanChilds.add(
              TextSpan(
                text: content.jumpUrl[matchStr]['title'],
                style: TextStyle(
                  color: enableWordRe
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (appUrlSchema == '') {
                      Get.toNamed(
                        '/webview',
                        parameters: {
                          'url': matchStr,
                          'type': 'url',
                          'pageTitle': ''
                        },
                      );
                    } else {
                      if (appUrlSchema.startsWith('bilibili://search') &&
                          enableWordRe) {
                        Get.toNamed('/searchResult', parameters: {
                          'keyword': content.jumpUrl[matchStr]['title']
                        });
                      }
                    }
                  },
              ),
            );
            if (appUrlSchema.startsWith('bilibili://search') && enableWordRe) {
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
            }
            return '';
          },
          onNonMatch: (String str) {
            spanChilds.add(TextSpan(
                text: str,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => replyReply(
                      replyItem.root == 0 ? replyItem : fReplyItem)));
            return str;
          },
        );
      }
      str = matchUrl.splitMapJoin(
        RegExp(r'\b\d{2}:\d{2}\b'),
        onMatch: (Match match) {
          String matchStr = match[0]!;
          spanChilds.add(
            TextSpan(
              text: ' $matchStr ',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // 跳转到指定位置
                  Get.find<VideoDetailController>(tag: Get.arguments['heroTag'])
                      .plPlayerController
                      .seekTo(
                        Duration(seconds: Utils.duration(matchStr)),
                      );
                },
            ),
          );
          return '';
        },
        onNonMatch: (str) {
          return str;
        },
      );

      if (content.atNameToMid.isEmpty && content.jumpUrl.isEmpty) {
        if (str != '') {
          spanChilds.add(TextSpan(
              text: str,
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    replyReply(replyItem.root == 0 ? replyItem : fReplyItem)));
        }
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
                child: GridView.count(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossCount.toInt(),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  childAspectRatio: 1,
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
          ..onTap = () => Get.toNamed(
                '/webview',
                parameters: {
                  'url': content.richText['note']['click_url'],
                  'type': 'note',
                  'pageTitle': '笔记预览'
                },
              ),
      ),
    );
  }
  // spanChilds.add(TextSpan(text: matchMember));
  return TextSpan(children: spanChilds);
}
