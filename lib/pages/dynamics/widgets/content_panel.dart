// 内容
import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/pages/preview/index.dart';

import 'rich_node_panel.dart';

// ignore: must_be_immutable
class Content extends StatefulWidget {
  dynamic item;
  String? source;
  Content({
    super.key,
    this.item,
    this.source,
  });

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  late bool hasPics;
  List<OpusPicsModel> pics = [];

  @override
  void initState() {
    super.initState();
    hasPics = widget.item.modules.moduleDynamic.major != null &&
        widget.item.modules.moduleDynamic.major.opus != null &&
        widget.item.modules.moduleDynamic.major.opus.pics.isNotEmpty;
    if (hasPics) {
      pics = widget.item.modules.moduleDynamic.major.opus.pics;
    }
  }

  InlineSpan picsNodes() {
    List<InlineSpan> spanChilds = [];
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
              double maxWidth = box.maxWidth.truncateToDouble();
              double maxHeight = box.maxWidth * 0.6; // 设置最大高度
              double height = maxWidth *
                  0.5 *
                  (pictureItem.height != null && pictureItem.width != null
                      ? pictureItem.height! / pictureItem.width!
                      : 1);
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
                child: Container(
                    padding: const EdgeInsets.only(top: 4),
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    width: box.maxWidth / 2,
                    height: height,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: NetworkImgLayer(
                            src: pictureItem.url,
                            width: maxWidth / 2,
                            height: height,
                          ),
                        ),
                        height > maxHeight
                            ? const PBadge(
                                text: '长图',
                                right: 8,
                                bottom: 8,
                              )
                            : const SizedBox(),
                      ],
                    )),
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
              double maxWidth = box.maxWidth.truncateToDouble();
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
                  width: maxWidth,
                  height: maxWidth,
                  origAspectRatio:
                      pics[i].width!.toInt() / pics[i].height!.toInt(),
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
              double maxWidth = box.maxWidth.truncateToDouble();
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
    return TextSpan(
      children: spanChilds,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle authorStyle =
        TextStyle(color: Theme.of(context).colorScheme.primary);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.item.modules.moduleDynamic.topic != null) ...[
            GestureDetector(
              child: Text(
                '#${widget.item.modules.moduleDynamic.topic.name}',
                style: authorStyle,
              ),
            ),
          ],
          IgnorePointer(
            // 禁用SelectableRegion的触摸交互功能
            ignoring: widget.source == 'detail' ? false : true,
            child: SelectableRegion(
              magnifierConfiguration: const TextMagnifierConfiguration(),
              focusNode: FocusNode(),
              selectionControls: MaterialTextSelectionControls(),
              child: Text.rich(
                /// fix 默认20px高度
                style: const TextStyle(height: 0),
                richNode(widget.item, context),
                maxLines: widget.source == 'detail' ? 999 : 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (hasPics) ...[
            Text.rich(picsNodes()),
          ]
        ],
      ),
    );
  }
}
