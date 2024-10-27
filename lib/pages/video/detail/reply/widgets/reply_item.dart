import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/main/index.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/pages/video/detail/reply_new/index.dart';
import 'package:pilipala/plugin/pl_gallery/index.dart';
import 'package:pilipala/plugin/pl_popup/index.dart';
import 'package:pilipala/utils/app_scheme.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/global_data_cache.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/url_utils.dart';
import 'package:pilipala/utils/utils.dart';
import 'reply_save.dart';
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
    this.replySave = false,
    super.key,
  });
  final ReplyItemModel? replyItem;
  final Function? addReply;
  final String? replyLevel;
  final bool? showReplyRow;
  final Function? replyReply;
  final ReplyType? replyType;
  final bool replySave;

  @override
  Widget build(BuildContext context) {
    final bool isOwner = int.parse(replyItem!.member!.mid!) ==
        (GlobalDataCache().userInfo?.mid ?? -1);
    return Material(
      child: InkWell(
        // 点击整个评论区 评论详情/回复
        onTap: () {
          if (replySave) {
            return;
          }
          feedBack();
          replyReply?.call(replyItem, null, replyItem!.rcount! > 0);
        },
        onLongPress: () {
          if (replySave) {
            return;
          }
          feedBack();
          showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (context) {
              return MorePanel(
                item: replyItem,
                mainFloor: true,
                isOwner: isOwner,
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 14, 8, 5),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            width: 1,
            color:
                Theme.of(context).colorScheme.onInverseSurface.withOpacity(0.5),
          ))),
          child: content(context),
        ),
      ),
    );
  }

  Widget lfAvtar(BuildContext context, String heroTag) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
                color: colorScheme.surface,
              ),
              child: Icon(
                Icons.offline_bolt,
                color: colorScheme.primary,
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
                color: colorScheme.background,
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

  Widget content(BuildContext context) {
    final String heroTag = Utils.makeHeroTag(replyItem!.mid);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                              : colorScheme.outline,
                          fontSize: 13,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Image.asset(
                          'assets/images/lv/lv${replyItem!.member!.level}.png',
                          height: 11,
                        ),
                      ),
                      if (replyItem!.isUp!)
                        const PBadge(
                          text: 'UP',
                          size: 'small',
                          stack: 'normal',
                          fs: 9,
                        ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: Utils.dateFormat(replyItem!.ctime),
                          style: TextStyle(
                            fontSize: textTheme.labelSmall!.fontSize,
                            color: colorScheme.outline,
                          ),
                        ),
                        if (replyItem!.replyControl != null &&
                            replyItem!.replyControl!.location != '')
                          TextSpan(
                            text: ' • ${replyItem!.replyControl!.location!}',
                            style: TextStyle(
                              fontSize: textTheme.labelSmall!.fontSize,
                              color: colorScheme.outline,
                            ),
                          ),
                        if (replyItem!.invisible!)
                          TextSpan(
                            text: ' • 隐藏的评论',
                            style: TextStyle(
                              color: colorScheme.outline,
                              fontSize: textTheme.labelSmall!.fontSize,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // title
        Container(
          margin: const EdgeInsets.only(top: 10, left: 45, right: 6, bottom: 4),
          child: !replySave
              ? LayoutBuilder(builder:
                  (BuildContext context, BoxConstraints boxConstraints) {
                  String text = replyItem?.content?.message ?? '';
                  bool didExceedMaxLines = false;
                  final double maxWidth = boxConstraints.maxWidth;
                  TextPainter? textPainter;
                  final int maxLines =
                      replyItem!.content!.isText! && replyLevel == '1'
                          ? 6
                          : 999;
                  try {
                    textPainter = TextPainter(
                      text: TextSpan(text: text),
                      maxLines: maxLines,
                      textDirection: Directionality.of(context),
                    );
                    textPainter.layout(maxWidth: maxWidth);
                    didExceedMaxLines = textPainter.didExceedMaxLines;
                  } catch (e) {
                    debugPrint('Error while measuring text: $e');
                    didExceedMaxLines = false;
                  }
                  return replyContent(context, didExceedMaxLines, textPainter);
                })
              : replyContent(context, false, null),
        ),
        // 操作区域
        bottonAction(context, replyItem!.replyControl, replySave),
        // 一楼的评论
        if ((replyItem!.rcount! > 0) && showReplyRow!) ...[
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

  Widget replyContent(
      BuildContext context, bool? didExceedMaxLines, TextPainter? textPainter) {
    return Text.rich(
      style: const TextStyle(height: 1.75),
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
          buildContent(
            context,
            replyItem!,
            replyReply,
            null,
            didExceedMaxLines ?? false,
            textPainter,
          ),
        ],
      ),
    );
  }

  // 感谢、回复、复制
  Widget bottonAction(BuildContext context, replyControl, replySave) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
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
                        addReply?.call(value['data'])
                        // replyControl.replies.add(value['data']),
                      }
                  });
            },
            child: Row(children: [
              if (!replySave!) ...[
                Icon(Icons.reply,
                    size: 18, color: colorScheme.outline.withOpacity(0.8)),
                const SizedBox(width: 3),
                Text(
                  '回复',
                  style: TextStyle(
                    fontSize: textTheme.labelMedium!.fontSize,
                    color: colorScheme.outline,
                  ),
                )
              ],
              if (replySave!)
                Text(
                  IdUtils.av2bv(replyItem!.oid!),
                  style: TextStyle(
                    fontSize: textTheme.labelMedium!.fontSize,
                    color: colorScheme.outline,
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
                color: colorScheme.primary,
                fontSize: textTheme.labelMedium!.fontSize),
          ),
          const SizedBox(width: 2),
        ],
        if (replyItem!.cardLabel!.isNotEmpty &&
            replyItem!.cardLabel!.contains('热评'))
          Text(
            '热评',
            style: TextStyle(
                color: colorScheme.primary,
                fontSize: textTheme.labelMedium!.fontSize),
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
  final List? replies;
  ReplyControl? replyControl;
  // int? f_rpid;
  ReplyItemModel? replyItem;
  Function? replyReply;

  @override
  Widget build(BuildContext context) {
    final int extraRow = replyItem!.rcount! > 0 ? 1 : 0;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(left: 42, right: 4, top: 0),
      child: Material(
        color: colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.hardEdge,
        animationDuration: Duration.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (replies!.isNotEmpty)
              for (int i = 0; i < replies!.length; i++) ...[
                InkWell(
                  // 一楼点击评论展开评论详情
                  onTap: () {
                    replyReply?.call(
                      replyItem,
                      replies![i],
                      replyItem!.replies!.isNotEmpty,
                    );
                  },
                  onLongPress: () {
                    feedBack();
                    showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      builder: (context) {
                        return MorePanel(item: replies![i]);
                      },
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      8,
                      i == 0 && (extraRow == 1 || replies!.length > 1) ? 8 : 5,
                      8,
                      6,
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
                              color: colorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                feedBack();
                                final String heroTag =
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
                          buildContent(context, replies![i], replyReply,
                              replyItem, false, null),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            if (extraRow == 1)
              InkWell(
                // 一楼点击【共xx条回复】展开评论详情
                onTap: () => replyReply?.call(replyItem, null, true),
                onLongPress: () => {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 8),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: textTheme.labelMedium!.fontSize,
                      ),
                      children: [
                        if (replyControl!.upReply!)
                          const TextSpan(text: 'up主等人 '),
                        TextSpan(
                          text: replyControl!.entryText!,
                          style: TextStyle(
                            color: colorScheme.primary,
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
  BuildContext context,
  replyItem,
  replyReply,
  fReplyItem,
  bool didExceedMaxLines,
  TextPainter? textPainter,
) {
  final String routePath = Get.currentRoute;
  bool isVideoPage = routePath.startsWith('/video');
  ColorScheme colorScheme = Theme.of(context).colorScheme;

  // replyItem 当前回复内容
  // replyReply 查看二楼回复（回复详情）回调
  // fReplyItem 父级回复内容，用作二楼回复（回复详情）展示
  final content = replyItem.content;
  final List<InlineSpan> spanChilds = <InlineSpan>[];

  if (didExceedMaxLines && content.message != '') {
    final textSize = textPainter!.size;
    var position = textPainter.getPositionForOffset(
      Offset(
        textSize.width,
        textSize.height,
      ),
    );
    final endOffset = textPainter.getOffsetBefore(position.offset);

    if (endOffset != null && endOffset > 0) {
      content.message = content.message.substring(0, endOffset);
    } else {
      content.message = content.message.substring(0, position.offset);
    }
  } else {
    content.message = content.message2;
  }

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
  content.message = content.message.replaceAll(RegExp(r"\{vote:.*?\}"), ' ');
  // 构建正则表达式
  final List<String> specialTokens = [
    ...content.emote.keys,
    ...content.topicsMeta?.keys?.map((e) => '#$e#') ?? [],
    ...content.atNameToMid.keys.map((e) => '@$e'),
  ];
  List<dynamic> jumpUrlKeysList = content.jumpUrl.keys.map((e) {
    return e.replaceAllMapped(
        RegExp(r'[?+*]'), (match) => '\\${match.group(0)}');
  }).toList();

  String patternStr = specialTokens.map(RegExp.escape).join('|');
  if (patternStr.isNotEmpty) {
    patternStr += "|";
  }
  patternStr += r'(\b(?:\d+[:：])?[0-5]?[0-9][:：][0-5]?[0-9]\b)';
  if (jumpUrlKeysList.isNotEmpty) {
    patternStr += '|${jumpUrlKeysList.join('|')}';
  }
  RegExp bv23Regex = RegExp(r'https://b23\.tv/[a-zA-Z0-9]{7}');
  final RegExp pattern = RegExp(patternStr);
  List<String> matchedStrs = [];
  void addPlainTextSpan(str) {
    spanChilds.add(
      TextSpan(
        text: str,
        // recognizer: TapGestureRecognizer()
        //   ..onTap = () => replyReply?.call(
        //         replyItem.root == 0 ? replyItem : fReplyItem,
        //         replyItem,
        //         fReplyItem!.replies!.isNotEmpty,
        //       ),
      ),
    );
  }

  void onPreviewImg(picList, initIndex, randomInt) {
    final MainController mainController = Get.find<MainController>();
    mainController.imgPreviewStatus = true;
    Navigator.of(context).push(
      HeroDialogRoute<void>(
        builder: (BuildContext context) => InteractiveviewerGallery(
          sources: picList,
          initIndex: initIndex,
          onPageChanged: (int pageIndex) {},
          onDismissed: (int value) {
            print('onDismissed');
            final MainController mainController = Get.find<MainController>();
            mainController.imgPreviewStatus = false;
          },
        ),
      ),
    );
  }

  // 分割文本并处理每个部分
  content.message.splitMapJoin(
    pattern,
    onMatch: (Match match) {
      String matchStr = match[0]!;
      if (content.emote.containsKey(matchStr)) {
        // 处理表情
        final int size = content.emote[matchStr]['meta']['size'];
        spanChilds.add(WidgetSpan(
          child: NetworkImgLayer(
            src: content.emote[matchStr]['url'],
            type: 'emote',
            width: size * 20,
            height: size * 20,
          ),
        ));
      } else if (matchStr.startsWith("@") &&
          content.atNameToMid.containsKey(matchStr.substring(1))) {
        // 处理@用户
        final String userName = matchStr.substring(1);
        final int userId = content.atNameToMid[userName];
        spanChilds.add(
          TextSpan(
            text: matchStr,
            style: TextStyle(
              color: colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                final String heroTag = Utils.makeHeroTag(userId);
                Get.toNamed(
                  '/member?mid=$userId',
                  arguments: {'face': '', 'heroTag': heroTag},
                );
              },
          ),
        );
      } else if (RegExp(r'^\b(?:\d+[:：])?[0-5]?[0-9][:：][0-5]?[0-9]\b$')
          .hasMatch(matchStr)) {
        matchStr = matchStr.replaceAll('：', ':');
        spanChilds.add(
          TextSpan(
            text: ' $matchStr ',
            style: isVideoPage
                ? TextStyle(
                    color: colorScheme.primary,
                  )
                : null,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // 跳转到指定位置
                if (isVideoPage) {
                  try {
                    SmartDialog.showToast('跳转至：$matchStr');
                    Get.find<VideoDetailController>(
                            tag: Get.arguments['heroTag'])
                        .plPlayerController
                        .seekTo(
                          Duration(seconds: Utils.duration(matchStr)),
                        );
                  } catch (e) {
                    SmartDialog.showToast('跳转失败: $e');
                  }
                }
              },
          ),
        );
      } else {
        String appUrlSchema = '';
        final bool enableWordRe = setting.get(SettingBoxKey.enableWordRe,
            defaultValue: false) as bool;
        if (content.jumpUrl[matchStr] != null &&
            !matchedStrs.contains(matchStr)) {
          appUrlSchema = content.jumpUrl[matchStr]['app_url_schema'];
          if (appUrlSchema.startsWith('bilibili://search') && !enableWordRe) {
            addPlainTextSpan(matchStr);
            return "";
          }
          spanChilds.addAll(
            [
              if (content.jumpUrl[matchStr]?['prefix_icon'] != null) ...[
                WidgetSpan(
                  child: Image.network(
                    content.jumpUrl[matchStr]['prefix_icon'],
                    height: 19,
                    color: colorScheme.primary,
                  ),
                )
              ],
              TextSpan(
                text: content.jumpUrl[matchStr]['title'],
                style: TextStyle(
                  color: colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final String title = content.jumpUrl[matchStr]['title'];
                    if (appUrlSchema == '') {
                      if (matchStr.startsWith('BV')) {
                        UrlUtils.matchUrlPush(
                          matchStr,
                          title,
                          '',
                        );
                      } else if (RegExp(r'^cv\d+$').hasMatch(matchStr)) {
                        Get.toNamed('/read', parameters: {
                          'title': title,
                          'id': Utils.matchNum(matchStr).first.toString(),
                          'articleType': 'read',
                        });
                      } else {
                        Uri uri = Uri.parse(matchStr.replaceAll('/?', '?'));
                        Uri scheme = Uri(
                          scheme: uri.scheme,
                          host: uri.host,
                          port: uri.port,
                          path: uri.path,
                          // query: uri.queryParameters,
                          // source: '',
                          // dataString: matchStr,
                        );
                        PiliSchame.httpsScheme(scheme);
                      }
                    } else {
                      if (appUrlSchema.startsWith('bilibili://search')) {
                        Get.toNamed('/searchResult',
                            parameters: {'keyword': title});
                      } else if (matchStr.startsWith('https://b23.tv')) {
                        final String redirectUrl =
                            await UrlUtils.parseRedirectUrl(matchStr);
                        final String pathSegment = Uri.parse(redirectUrl).path;
                        final String lastPathSegment =
                            pathSegment.split('/').last;
                        if (lastPathSegment.startsWith('BV')) {
                          UrlUtils.matchUrlPush(
                            lastPathSegment,
                            title,
                            redirectUrl,
                          );
                        } else {
                          Get.toNamed(
                            '/webview',
                            parameters: {
                              'url': redirectUrl,
                              'type': 'url',
                              'pageTitle': title
                            },
                          );
                        }
                      } else {
                        Get.toNamed(
                          '/webview',
                          parameters: {
                            'url': matchStr,
                            'type': 'url',
                            'pageTitle': title
                          },
                        );
                      }
                    }
                  },
              )
            ],
          );
          // 只显示一次
          matchedStrs.add(matchStr);
        } else if (content.topicsMeta.keys.isNotEmpty &&
            matchStr.length > 1 &&
            content.topicsMeta[matchStr.substring(1, matchStr.length - 1)] !=
                null) {
          spanChilds.add(
            TextSpan(
              text: matchStr,
              style: TextStyle(
                color: colorScheme.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final String topic =
                      matchStr.substring(1, matchStr.length - 1);
                  Get.toNamed('/searchResult', parameters: {'keyword': topic});
                },
            ),
          );
        } else {
          addPlainTextSpan(matchStr);
        }
      }
      return '';
    },
    onNonMatch: (String nonMatchStr) {
      return nonMatchStr.splitMapJoin(
        bv23Regex,
        onMatch: (Match match) {
          String matchStr = match[0]!;
          spanChilds.add(
            TextSpan(
              text: ' $matchStr ',
              style: isVideoPage
                  ? TextStyle(
                      color: colorScheme.primary,
                    )
                  : null,
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.toNamed(
                      '/webview',
                      parameters: {
                        'url': matchStr,
                        'type': 'url',
                        'pageTitle': matchStr
                      },
                    ),
            ),
          );
          return '';
        },
        onNonMatch: (String nonMatchOtherStr) {
          addPlainTextSpan(nonMatchOtherStr);
          return nonMatchOtherStr;
        },
      );
    },
  );

  if (content.jumpUrl.keys.isNotEmpty) {
    List<String> unmatchedItems = content.jumpUrl.keys
        .toList()
        .where((item) => !content.message.contains(item))
        .toList();
    if (unmatchedItems.isNotEmpty) {
      for (int i = 0; i < unmatchedItems.length; i++) {
        String patternStr = unmatchedItems[i];
        spanChilds.addAll(
          [
            if (content.jumpUrl[patternStr]?['prefix_icon'] != null) ...[
              WidgetSpan(
                child: Image.network(
                  content.jumpUrl[patternStr]['prefix_icon'],
                  height: 19,
                  color: colorScheme.primary,
                ),
              )
            ],
            TextSpan(
              text: content.jumpUrl[patternStr]['title'],
              style: TextStyle(
                color: colorScheme.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.toNamed(
                    '/webview',
                    parameters: {
                      'url': patternStr,
                      'type': 'url',
                      'pageTitle': content.jumpUrl[patternStr]['title']
                    },
                  );
                },
            )
          ],
        );
      }
    }
  }

  if (didExceedMaxLines) {
    spanChilds.add(
      TextSpan(
        text: '\n查看更多',
        style: TextStyle(
          color: colorScheme.primary,
        ),
      ),
    );
  }

  // 图片渲染
  if (content.pictures.isNotEmpty) {
    final List<String> picList = <String>[];
    final int len = content.pictures.length;
    spanChilds.add(const TextSpan(text: '\n'));
    if (len == 1) {
      Map pictureItem = content.pictures.first;
      picList.add(pictureItem['img_src']);
      spanChilds.add(
        WidgetSpan(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints box) {
              double maxHeight = box.maxWidth * 0.6; // 设置最大高度
              // double width = (box.maxWidth / 2).truncateToDouble();
              double height = 100;
              try {
                height = ((box.maxWidth /
                        2 *
                        pictureItem['img_height'] /
                        pictureItem['img_width']))
                    .truncateToDouble();
              } catch (_) {}
              String randomInt = Random().nextInt(101).toString();

              return Hero(
                tag: picList[0] + randomInt,
                child: GestureDetector(
                  onTap: () => onPreviewImg(picList, 0, randomInt),
                  child: Container(
                    padding: const EdgeInsets.only(top: 4),
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    width: box.maxWidth / 2,
                    height: height,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: NetworkImgLayer(
                            src: picList[0],
                            width: box.maxWidth / 2,
                            height: height,
                          ),
                        ),
                        height > Get.size.height * 0.9
                            ? const PBadge(
                                text: '长图',
                                right: 8,
                                bottom: 8,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else if (len > 1) {
      List<Widget> list = [];
      for (var i = 0; i < len; i++) {
        picList.add(content.pictures[i]['img_src']);
      }
      for (var i = 0; i < len; i++) {
        String randomInt = Random().nextInt(101).toString();
        list.add(
          LayoutBuilder(
            builder: (context, BoxConstraints box) {
              return Hero(
                tag: picList[i] + randomInt,
                child: GestureDetector(
                  onTap: () => onPreviewImg(picList, i, randomInt),
                  child: NetworkImgLayer(
                      src: picList[i],
                      width: box.maxWidth,
                      height: box.maxWidth,
                      origAspectRatio: content.pictures[i]['img_width'] /
                          content.pictures[i]['img_height']),
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

class MorePanel extends StatelessWidget {
  final dynamic item;
  final bool mainFloor;
  final bool isOwner;
  const MorePanel({
    super.key,
    required this.item,
    this.mainFloor = false,
    this.isOwner = false,
  });

  Future<dynamic> menuActionHandler(String type) async {
    String message = item.content.message ?? item.content;
    switch (type) {
      case 'copyAll':
        await Clipboard.setData(ClipboardData(text: message));
        SmartDialog.showToast('已复制');
        Get.back();
        break;
      case 'copyFreedom':
        Get.back();
        showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: const Text('自由复制'),
              content: SelectableText(message),
            );
          },
        );
        break;
      case 'save':
        Get.back();
        Navigator.push(
          Get.context!,
          PlPopupRoute(child: ReplySave(replyItem: item)),
        );
        break;
      // case 'block':
      //   SmartDialog.showToast('加入黑名单');
      //   break;
      // case 'report':
      //   SmartDialog.showToast('举报');
      //   break;
      case 'delete':
        // 删除评论提示
        await showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: const Text('删除评论'),
              content: const Text('删除评论后，评论下所有回复将被删除，确定删除吗？'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('取消',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline)),
                ),
                TextButton(
                  onPressed: () async {
                    Get.back();
                    var result = await ReplyHttp.replyDel(
                      type: item.type!,
                      oid: item.oid!,
                      rpid: item.rpid!,
                    );
                    if (result['status']) {
                      SmartDialog.showToast('评论删除成功，需手动刷新');
                      Get.back();
                    } else {
                      SmartDialog.showToast(result['msg']);
                    }
                  },
                  child: const Text('确定'),
                ),
              ],
            );
          },
        );
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    Color errorColor = colorScheme.error;
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              height: 35,
              padding: const EdgeInsets.only(bottom: 2),
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                      color: colorScheme.outline,
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () async => await menuActionHandler('copyAll'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.copy_all_outlined, size: 19),
            title: Text('复制全部', style: textTheme.titleSmall),
          ),
          ListTile(
            onTap: () async => await menuActionHandler('copyFreedom'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.copy_outlined, size: 19),
            title: Text('自由复制', style: textTheme.titleSmall),
          ),
          if (mainFloor && item.content.pictures.isEmpty)
            ListTile(
              onTap: () async => await menuActionHandler('save'),
              minLeadingWidth: 0,
              leading: const Icon(Icons.save_alt_rounded, size: 19),
              title: Text('本地保存', style: textTheme.titleSmall),
            ),
          // ListTile(
          //   onTap: () async => await menuActionHandler('block'),
          //   minLeadingWidth: 0,
          //   leading: Icon(Icons.block_outlined, color: errorColor),
          //   title: Text('加入黑名单', style: TextStyle(color: errorColor)),
          // ),
          // ListTile(
          //   onTap: () async => await menuActionHandler('report'),
          //   minLeadingWidth: 0,
          //   leading: Icon(Icons.report_outlined, color: errorColor),
          //   title: Text('举报', style: TextStyle(color: errorColor)),
          // ),
          if (isOwner)
            ListTile(
              onTap: () async => await menuActionHandler('delete'),
              minLeadingWidth: 0,
              leading: Icon(Icons.delete_outline, color: errorColor),
              title: Text('删除评论',
                  style: textTheme.titleSmall!.copyWith(color: errorColor)),
            ),
        ],
      ),
    );
  }
}
