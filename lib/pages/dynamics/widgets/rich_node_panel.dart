import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/pages/preview/index.dart';

// 富文本
InlineSpan richNode(item, context) {
  final spacer = _VerticalSpaceSpan(0.0);
  try {
    TextStyle authorStyle =
        TextStyle(color: Theme.of(context).colorScheme.primary);
    List<InlineSpan> spanChilds = [];
    String contentType = 'desc';

    dynamic richTextNodes;
    if (item.modules.moduleDynamic.desc != null) {
      richTextNodes = item.modules.moduleDynamic.desc.richTextNodes;
    } else if (item.modules.moduleDynamic.major != null) {
      contentType = 'major';
      // 动态页面 richTextNodes 层级可能与主页动态层级不同
      richTextNodes =
          item.modules.moduleDynamic.major.opus.summary.richTextNodes;
    }
    if (richTextNodes == null || richTextNodes.isEmpty) {
      return spacer;
    } else {
      for (var i in richTextNodes) {
        /// fix 渲染专栏时内容会重复
        if (item.modules.moduleDynamic.major.opus.title == null &&
            i.type == 'RICH_TEXT_NODE_TYPE_TEXT') {
          spanChilds.add(
              TextSpan(text: i.origText, style: const TextStyle(height: 1.65)));
        }
        // @用户
        if (i.type == 'RICH_TEXT_NODE_TYPE_AT') {
          spanChilds.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Get.toNamed('/member?mid=${i.rid}',
                        arguments: {'face': null}),
                    child: Text(
                      ' ${i.text}',
                      style: authorStyle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        // 话题
        if (i.type == 'RICH_TEXT_NODE_TYPE_TOPIC') {
          spanChilds.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  '${i.origText}',
                  style: authorStyle,
                ),
              ),
            ),
          );
        }
        // 网页链接
        if (i.type == 'RICH_TEXT_NODE_TYPE_WEB') {
          spanChilds.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.link,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
          spanChilds.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(
                    '/webview',
                    parameters: {
                      'url': i.origText,
                      'type': 'url',
                      'pageTitle': ''
                    },
                  );
                },
                child: Text(
                  i.text,
                  style: authorStyle,
                ),
              ),
            ),
          );
        }
        // 投票
        if (i.type == 'RICH_TEXT_NODE_TYPE_VOTE') {
          spanChilds.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () {
                  String dynamicId = item.basic['comment_id_str'];
                  Get.toNamed(
                    '/webview',
                    parameters: {
                      'url':
                          'https://t.bilibili.com/vote/h5/index/#/result?vote_id=${i.rid}&dynamic_id=$dynamicId&isWeb=1',
                      'type': 'vote',
                      'pageTitle': '投票'
                    },
                  );
                },
                child: Text(
                  '投票：${i.text}',
                  style: authorStyle,
                ),
              ),
            ),
          );
        }
        // 表情
        if (i.type == 'RICH_TEXT_NODE_TYPE_EMOJI') {
          spanChilds.add(
            WidgetSpan(
              child: NetworkImgLayer(
                src: i.emoji.iconUrl,
                type: 'emote',
                width: i.emoji.size * 20,
                height: i.emoji.size * 20,
              ),
            ),
          );
        }
        // 抽奖
        if (i.type == 'RICH_TEXT_NODE_TYPE_LOTTERY') {
          spanChilds.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.redeem_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
          spanChilds.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  '${i.origText} ',
                  style: authorStyle,
                ),
              ),
            ),
          );
        }

        /// TODO 商品
        if (i.type == 'RICH_TEXT_NODE_TYPE_GOODS') {
          spanChilds.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
          spanChilds.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  '${i.text} ',
                  style: authorStyle,
                ),
              ),
            ),
          );
        }
      }
      if (contentType == 'major' &&
          item.modules.moduleDynamic.major.opus.pics.isNotEmpty) {
        // 图片可能跟其他widget重复渲染
        List<OpusPicsModel> pics = item.modules.moduleDynamic.major.opus.pics;
        int len = pics.length;
        List<String> picList = [];

        if (len == 1) {
          OpusPicsModel pictureItem = pics.first;
          picList.add(pictureItem.url!);
          spanChilds.add(const TextSpan(text: '\n'));
          spanChilds.add(
            WidgetSpan(
              child: LayoutBuilder(
                builder: (context, BoxConstraints box) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        useSafeArea: false,
                        context: context,
                        builder: (context) {
                          return ImagePreview(initialPage: 0, imgList: picList);
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: NetworkImgLayer(
                        src: pictureItem.url,
                        width: box.maxWidth / 2,
                        height: box.maxWidth *
                            0.5 *
                            (pictureItem.height != null &&
                                    pictureItem.width != null
                                ? pictureItem.height! / pictureItem.width!
                                : 1),
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
            picList.add(pics[i].url!);
            list.add(
              LayoutBuilder(
                builder: (context, BoxConstraints box) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        useSafeArea: false,
                        context: context,
                        builder: (context) {
                          return ImagePreview(initialPage: i, imgList: picList);
                        },
                      );
                    },
                    child: NetworkImgLayer(
                      src: pics[i].url,
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
        // spanChilds.add(
        //   WidgetSpan(
        //     child: NetworkImgLayer(
        //       src: pics.first.url,
        //       type: 'emote',
        //       width: 100,
        //       height: 200,
        //     ),
        //   ),
        // );
      }
      return TextSpan(
        children: spanChilds,
      );
    }
  } catch (err) {
    print('❌rich_node_panel err: $err');
    return spacer;
  }
}

class _VerticalSpaceSpan extends WidgetSpan {
  _VerticalSpaceSpan(double height)
      : super(child: SizedBox(height: height, width: double.infinity));
}
