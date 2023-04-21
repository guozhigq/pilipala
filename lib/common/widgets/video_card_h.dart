import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

// 视频卡片 - 水平布局
class VideoCardH extends StatelessWidget {
  var videoItem;

  VideoCardH({Key? key, required this.videoItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int aid = videoItem.aid;
    String heroTag = Utils.makeHeroTag(aid);
    return InkWell(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 200));
        Get.toNamed('/video?aid=$aid',
            arguments: {'videoItem': videoItem, 'heroTag': heroTag});
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                StyleString.cardSpace, 7, StyleString.cardSpace, 7),
            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                double width =
                    (boxConstraints.maxWidth - StyleString.cardSpace * 6) / 2;
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
                            double PR = MediaQuery.of(context).devicePixelRatio;
                            return Stack(
                              children: [
                                Hero(
                                  tag: heroTag,
                                  child: NetworkImgLayer(
                                    // src: videoItem['pic'] +
                                    //     '@${(maxWidth * 2).toInt()}w',
                                    src: videoItem.pic + '@.webp',
                                    width: maxWidth,
                                    height: maxHeight,
                                  ),
                                ),
                                // Image.network( videoItem['pic'], width: double.infinity, height: double.infinity,),
                                Positioned(
                                  right: 4,
                                  bottom: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.black54.withOpacity(0.4)),
                                    child: Text(
                                      Utils.timeFormat(videoItem.duration!),
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.white),
                                    ),
                                  ),
                                )
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
          Divider(
            height: 1,
            indent: 8,
            endIndent: 12,
            color: Theme.of(context).dividerColor.withOpacity(0.08),
          )
        ],
      ),
      // Container(
      //   padding: const EdgeInsets.fromLTRB(
      //       StyleString.cardSpace, 5, StyleString.cardSpace, 5),
      //   child: LayoutBuilder(
      //     builder: (context, boxConstraints) {
      //       double width =
      //           (boxConstraints.maxWidth - StyleString.cardSpace * 6) / 2;
      //       return SizedBox(
      //         height: width / StyleString.aspectRatio,
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             AspectRatio(
      //               aspectRatio: StyleString.aspectRatio,
      //               // child: ClipRRect(
      //               //   borderRadius: StyleString.mdRadius,
      //               child: LayoutBuilder(
      //                 builder: (context, boxConstraints) {
      //                   double maxWidth = boxConstraints.maxWidth;
      //                   double maxHeight = boxConstraints.maxHeight;
      //                   double PR = MediaQuery.of(context).devicePixelRatio;
      //                   return Stack(
      //                     children: [
      //                       Hero(
      //                         tag: heroTag,
      //                         child: NetworkImgLayer(
      //                           // src: videoItem['pic'] +
      //                           //     '@${(maxWidth * 2).toInt()}w',
      //                           src: videoItem.pic + '@.webp',
      //                           width: maxWidth,
      //                           height: maxHeight,
      //                         ),
      //                       ),
      //                       // Image.network( videoItem['pic'], width: double.infinity, height: double.infinity,),
      //                       Positioned(
      //                         right: 4,
      //                         bottom: 4,
      //                         child: Container(
      //                           padding: const EdgeInsets.symmetric(
      //                               vertical: 1, horizontal: 6),
      //                           decoration: BoxDecoration(
      //                               borderRadius: BorderRadius.circular(4),
      //                               color: Colors.black54.withOpacity(0.4)),
      //                           child: Text(
      //                             Utils.timeFormat(videoItem.duration!),
      //                             style: const TextStyle(
      //                                 fontSize: 11, color: Colors.white),
      //                           ),
      //                         ),
      //                       )
      //                     ],
      //                   );
      //                 },
      //               ),
      //               // ),
      //             ),
      //             VideoContent(videoItem: videoItem)
      //           ],
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}

class VideoContent extends StatelessWidget {
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
            Text(
              videoItem.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (videoItem.rcmdReason != null &&
                videoItem.rcmdReason.content != '')
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.surfaceTint),
                ),
                child: Text(
                  videoItem.rcmdReason.content,
                  style: TextStyle(
                      fontSize: 9,
                      color: Theme.of(context).colorScheme.surfaceTint),
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Image.asset(
                  'assets/images/up_gray.png',
                  width: 14,
                  height: 12,
                ),
                const SizedBox(width: 2),
                Text(
                  videoItem.owner.name,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                StatView(
                  theme: 'gray',
                  view: videoItem.stat.view,
                ),
                const SizedBox(width: 8),
                Text(
                  Utils.dateFormat(videoItem.pubdate!),
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.outline),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
