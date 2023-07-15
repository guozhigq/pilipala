import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/common/business_type.dart';
import 'package:pilipala/models/live/item.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/utils.dart';

class HistoryItem extends StatelessWidget {
  var videoItem;
  HistoryItem({super.key, required this.videoItem});

  @override
  Widget build(BuildContext context) {
    int aid = videoItem.history.oid;
    String bvid = videoItem.history.bvid ?? IdUtils.av2bv(aid);
    String heroTag = Utils.makeHeroTag(aid);
    return InkWell(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 200));
        if (videoItem.history.business.contains('article')) {
          int cid = videoItem.history.cid ??
              // videoItem.history.oid ??
              await SearchHttp.ab2c(aid: aid, bvid: bvid);
          Get.toNamed(
            '/webview',
            parameters: {
              'url': 'https://www.bilibili.com/read/cv$cid',
              'type': 'note',
              'pageTitle': videoItem.title
            },
          );
        } else if (videoItem.history.business == 'live' &&
            videoItem.liveStatus == 1) {
          LiveItemModel liveItem = LiveItemModel.fromJson({
            'face': videoItem.authorFace,
            'roomid': videoItem.history.oid,
            'pic': videoItem.cover,
            'title': videoItem.title,
            'uname': videoItem.authorName,
            'cover': videoItem.cover,
          });
          Get.toNamed(
            '/liveRoom?roomid=${videoItem.history.oid}',
            arguments: {'liveItem': liveItem},
          );
        } else {
          int cid = videoItem.history.cid ??
              // videoItem.history.oid ??
              await SearchHttp.ab2c(aid: aid, bvid: bvid);
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
                                  pBadge(
                                      videoItem.progress == -1
                                          ? '已看完'
                                          : '${Utils.timeFormat(videoItem.progress!)}/${Utils.timeFormat(videoItem.duration!)}',
                                      context,
                                      null,
                                      6.0,
                                      6.0,
                                      null,
                                      type: 'gray'),
                                // 右上角
                                if (BusinessType.showBadge.showBadge
                                        .contains(videoItem.history.business) ||
                                    videoItem.history.business ==
                                        BusinessType.live.type)
                                  pBadge(videoItem.badge, context, 6.0, 6.0,
                                      null, null),
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
