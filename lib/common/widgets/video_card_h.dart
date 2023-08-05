import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

// 视频卡片 - 水平布局
class VideoCardH extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final videoItem;
  final Function()? longPress;
  final Function()? longPressEnd;

  const VideoCardH({
    Key? key,
    required this.videoItem,
    this.longPress,
    this.longPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int aid = videoItem.aid;
    String bvid = videoItem.bvid;
    String heroTag = Utils.makeHeroTag(aid);
    return GestureDetector(
      onLongPress: () {
        if (longPress != null) {
          longPress!();
        }
      },
      onLongPressEnd: (details) {
        if (longPressEnd != null) {
          longPressEnd!();
        }
      },
      child: InkWell(
        onTap: () async {
          try {
            int cid =
                videoItem.cid ?? await SearchHttp.ab2c(aid: aid, bvid: bvid);
            Get.toNamed('/video?bvid=$bvid&cid=$cid',
                arguments: {'videoItem': videoItem, 'heroTag': heroTag});
          } catch (err) {
            SmartDialog.showToast(err.toString());
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  StyleString.safeSpace, 6, StyleString.safeSpace, 6),
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  double width =
                      (boxConstraints.maxWidth - StyleString.cardSpace * 9) / 2;
                  return SizedBox(
                    height: width / StyleString.aspectRatio,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: StyleString.aspectRatio,
                          child: LayoutBuilder(
                            builder: (context, boxConstraints) {
                              double maxWidth = boxConstraints.maxWidth;
                              double maxHeight = boxConstraints.maxHeight;
                              return Stack(
                                children: [
                                  Hero(
                                    tag: heroTag,
                                    child: NetworkImgLayer(
                                      src: videoItem.pic,
                                      width: maxWidth,
                                      height: maxHeight,
                                    ),
                                  ),
                                  pBadge(Utils.timeFormat(videoItem.duration!),
                                      context, null, 6.0, 6.0, null,
                                      type: 'gray'),
                                  if (videoItem.rcmdReason != null &&
                                      videoItem.rcmdReason.content != '')
                                    pBadge(videoItem.rcmdReason.content,
                                        context, 6.0, 6.0, null, null),
                                ],
                              );
                            },
                          ),
                        ),
                        VideoContent(videoItem: videoItem)
                      ],
                    ),
                  );
                },
              ),
            ),
            // Divider(
            //   height: 1,
            //   indent: 8,
            //   endIndent: 12,
            //   color: Theme.of(context).dividerColor.withOpacity(0.08),
            // )
          ],
        ),
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final videoItem;
  const VideoContent({super.key, required this.videoItem});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 6, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (videoItem.title is String) ...[
              Text(
                videoItem.title,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ] else ...[
              RichText(
                maxLines: 2,
                text: TextSpan(
                  children: [
                    for (var i in videoItem.title) ...[
                      TextSpan(
                        text: i['text'],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                          color: i['type'] == 'em'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
            const Spacer(),
            // if (videoItem.rcmdReason != null &&
            //     videoItem.rcmdReason.content != '')
            //   Container(
            //     padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(4),
            //       border: Border.all(
            //           color: Theme.of(context).colorScheme.surfaceTint),
            //     ),
            //     child: Text(
            //       videoItem.rcmdReason.content,
            //       style: TextStyle(
            //           fontSize: 9,
            //           color: Theme.of(context).colorScheme.surfaceTint),
            //     ),
            //   ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  videoItem.owner.name,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                StatView(
                  theme: 'gray',
                  view: videoItem.stat.view,
                ),
                const SizedBox(width: 8),
                StatDanMu(
                  theme: 'gray',
                  danmu: videoItem.stat.danmaku,
                ),
                // Text(
                //   Utils.dateFormat(videoItem.pubdate!),
                //   style: TextStyle(
                //       fontSize: 11,
                //       color: Theme.of(context).colorScheme.outline),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
