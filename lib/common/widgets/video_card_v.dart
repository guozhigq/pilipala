import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/pages/rcmd/index.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

// 视频卡片 - 垂直布局
class VideoCardV extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final videoItem;
  final Function()? longPress;
  final Function()? longPressEnd;

  const VideoCardV({
    Key? key,
    required this.videoItem,
    this.longPress,
    this.longPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(videoItem.id);
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: StyleString.mdRadius,
      ),
      margin: EdgeInsets.zero,
      child: GestureDetector(
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
            await Future.delayed(const Duration(milliseconds: 200));
            String bvid = videoItem.bvid ?? IdUtils.av2bv(videoItem.aid);
            Get.toNamed('/video?bvid=$bvid&cid=${videoItem.cid}',
                arguments: {'videoItem': videoItem, 'heroTag': heroTag});
          },
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: StyleString.imgRadius,
                    topRight: StyleString.imgRadius,
                    bottomLeft: StyleString.imgRadius,
                    bottomRight: StyleString.imgRadius,
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: StyleString.aspectRatio,
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    double maxWidth = boxConstraints.maxWidth;
                    double maxHeight = boxConstraints.maxHeight;
                    return Stack(
                      children: [
                        Hero(
                          tag: heroTag,
                          child: NetworkImgLayer(
                            src: videoItem.pic + '@.webp',
                            width: maxWidth,
                            height: maxHeight,
                          ),
                        ),
                        // if (videoItem.stat.view is int &&
                        //     videoItem.stat.danmaku is int)
                        //   Positioned(
                        //     left: 0,
                        //     right: 0,
                        //     bottom: 0,
                        //     child: AnimatedOpacity(
                        //       opacity: 1,
                        //       duration: const Duration(milliseconds: 200),
                        //       child: VideoStat(
                        //         view: videoItem.stat.view,
                        //         danmaku: videoItem.stat.danmaku,
                        //         duration: videoItem.duration,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    );
                  }),
                ),
              ),
              VideoContent(videoItem: videoItem)
            ],
          ),
        ),
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final videoItem;
  const VideoContent({Key? key, required this.videoItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        // 多列
        padding: const EdgeInsets.fromLTRB(4, 5, 6, 10),
        // 单列
        // padding: const EdgeInsets.fromLTRB(14, 10, 4, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              videoItem.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
              maxLines: Get.find<RcmdController>().crossAxisCount,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 18,
              child: Row(
                children: [
                  if (videoItem.rcmdReason != null &&
                      videoItem.rcmdReason.content != '') ...[
                    Container(
                      padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.6),
                          borderRadius: BorderRadius.circular(3)),
                      child: Text(
                        videoItem.rcmdReason.content,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelSmall!.fontSize,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4)
                  ] else if (videoItem.isFollowed == 1) ...[
                    Container(
                      padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.6),
                          borderRadius: BorderRadius.circular(3)),
                      child: Text(
                        '已关注',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelSmall!.fontSize,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4)
                  ],
                  Expanded(
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Text(
                          videoItem.owner.name,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .fontSize,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     StatView(
            //       theme: 'black',
            //       view: videoItem.stat.view,
            //     ),
            //     const SizedBox(width: 6),
            //     StatDanMu(
            //       theme: 'black',
            //       danmu: videoItem.stat.danmaku,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class VideoStat extends StatelessWidget {
  final int? view;
  final int? danmaku;
  final int? duration;

  const VideoStat(
      {Key? key,
      required this.view,
      required this.danmaku,
      required this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(top: 22, left: 6, right: 6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            Colors.black54,
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              StatView(
                theme: 'white',
                view: view,
              ),
              const SizedBox(width: 6),
              StatDanMu(
                theme: 'white',
                danmu: danmaku,
              ),
            ],
          ),
          Text(
            Utils.timeFormat(duration!),
            style: const TextStyle(fontSize: 11, color: Colors.white),
          )
        ],
      ),
    );
  }
}
