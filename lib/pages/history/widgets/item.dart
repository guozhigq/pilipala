import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/common/business_type.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/utils.dart';

class HistoryItem extends StatelessWidget {
  var videoItem;
  HistoryItem({super.key, required this.videoItem});

  @override
  Widget build(BuildContext context) {
    int aid = videoItem.history.oid;
    String bvid = videoItem.history.bvid;
    String heroTag = Utils.makeHeroTag(aid);
    return InkWell(
      onTap: () async {
        int cid = videoItem.history.cid ??
            await SearchHttp.ab2c(aid: aid, bvid: bvid);
        await Future.delayed(const Duration(milliseconds: 200));
        if (videoItem.history.business.contains('article')) {
          Get.toNamed(
            '/webview',
            parameters: {
              'url': 'https://www.bilibili.com/read/cv$cid',
              'type': 'note',
              'pageTitle': videoItem.title
            },
          );
        } else {
          Get.toNamed('/video?bvid=$bvid&cid=$cid',
              arguments: {'heroTag': heroTag, 'pic': videoItem.cover});
        }
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
                                    src: (videoItem.cover != ''
                                            ? videoItem.cover
                                            : videoItem.covers.first) +
                                        '@.webp',
                                    width: maxWidth,
                                    height: maxHeight,
                                  ),
                                ),
                                if (!BusinessType
                                    .hiddenDurationType.hiddenDurationType
                                    .contains(videoItem.history.business))
                                  Positioned(
                                    right: 4,
                                    bottom: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 6),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color:
                                              Colors.black54.withOpacity(0.4)),
                                      child: Text(
                                        videoItem.progress == -1
                                            ? '已看完'
                                            : '${Utils.timeFormat(videoItem.progress!)}/${Utils.timeFormat(videoItem.duration!)}',
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                // 右上角
                                if (BusinessType.showBadge.showBadge
                                    .contains(videoItem.history.business))
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 6),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer),
                                      child: Text(
                                        videoItem.badge,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                  ),
                                if (videoItem.history.business ==
                                    BusinessType.live.type)
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 6),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color:
                                              Colors.black54.withOpacity(0.4)),
                                      child: Text(
                                        videoItem.badge,
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
              maxLines: videoItem.videos > 1 ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (videoItem.videos > 1)
              Text(
                videoItem.showTitle,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.outline),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const Spacer(),
            Row(
              children: [
                Text(
                  videoItem.authorName,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  Utils.dateFormat(videoItem.viewAt!),
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
