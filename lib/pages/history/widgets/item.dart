import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/bangumi/info.dart';
import 'package:pilipala/models/common/business_type.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/models/live/item.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/utils.dart';

class HistoryItem extends StatelessWidget {
  final dynamic videoItem;
  const HistoryItem({super.key, required this.videoItem});

  @override
  Widget build(BuildContext context) {
    int aid = videoItem.history.oid;
    String bvid = videoItem.history.bvid ?? IdUtils.av2bv(aid);
    String heroTag = Utils.makeHeroTag(aid);
    return InkWell(
      onTap: () async {
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
        } else if (videoItem.history.business == 'live') {
          if (videoItem.liveStatus == 1) {
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
            SmartDialog.showToast('直播未开播');
          }
        } else if (videoItem.badge == '番剧' ||
            videoItem.tagName.contains('动画')) {
          /// hack
          var bvid = videoItem.history.bvid;
          if (bvid != null && bvid != '') {
            var result = await VideoHttp.videoIntro(bvid: bvid);
            if (result['status']) {
              String bvid = result['data'].bvid!;
              int cid = result['data'].cid!;
              String pic = result['data'].pic!;
              String heroTag = Utils.makeHeroTag(cid);
              var epid = result['data'].epId;
              if (epid != null) {
                Get.toNamed(
                  '/video?bvid=$bvid&cid=$cid&epId=${result['data'].epId}',
                  arguments: {
                    'pic': pic,
                    'heroTag': heroTag,
                    'videoType': SearchType.media_bangumi,
                  },
                );
              } else {
                int cid = videoItem.history.cid ??
                    // videoItem.history.oid ??
                    await SearchHttp.ab2c(aid: aid, bvid: bvid);
                Get.toNamed('/video?bvid=$bvid&cid=$cid',
                    arguments: {'heroTag': heroTag, 'pic': videoItem.cover});
              }
            }
          } else {
            if (videoItem.history.epid != '') {
              SmartDialog.showLoading(msg: '获取中...');
              var res =
                  await SearchHttp.bangumiInfo(epId: videoItem.history.epid);
              SmartDialog.dismiss();
              if (res['status']) {
                EpisodeItem episode = res['data'].episodes.first;
                String bvid = episode.bvid!;
                int cid = episode.cid!;
                String pic = episode.cover!;
                String heroTag = Utils.makeHeroTag(cid);
                Get.toNamed(
                  '/video?bvid=$bvid&cid=$cid&seasonId=${res['data'].seasonId}',
                  arguments: {
                    'pic': pic,
                    'heroTag': heroTag,
                    'videoType': SearchType.media_bangumi,
                    'bangumiItem': res['data'],
                  },
                );
              }
            }
          }
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
                StyleString.safeSpace, 5, StyleString.safeSpace, 5),
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
                            return Stack(
                              children: [
                                Hero(
                                  tag: heroTag,
                                  child: NetworkImgLayer(
                                    src: (videoItem.cover != ''
                                        ? videoItem.cover
                                        : videoItem.covers.first),
                                    width: maxWidth,
                                    height: maxHeight,
                                  ),
                                ),
                                if (!BusinessType
                                    .hiddenDurationType.hiddenDurationType
                                    .contains(videoItem.history.business))
                                  PBadge(
                                    text: videoItem.progress == -1
                                        ? '已看完'
                                        : '${Utils.timeFormat(videoItem.progress!)}/${Utils.timeFormat(videoItem.duration!)}',
                                    right: 6.0,
                                    bottom: 6.0,
                                    type: 'gray',
                                  ),
                                // 右上角
                                if (BusinessType.showBadge.showBadge
                                        .contains(videoItem.history.business) ||
                                    videoItem.history.business ==
                                        BusinessType.live.type)
                                  PBadge(
                                    text: videoItem.badge,
                                    top: 6.0,
                                    right: 6.0,
                                    bottom: null,
                                    left: null,
                                  ),
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
        ],
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  final dynamic videoItem;
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
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
              maxLines: videoItem.videos > 1 ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (videoItem.showTitle != null)
              Text(
                videoItem.showTitle,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
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
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Utils.dateFormat(videoItem.viewAt!),
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline),
                ),
                if (videoItem.badge != '番剧' &&
                    !videoItem.tagName.contains('动画') &&
                    videoItem.history.business != 'live' &&
                    !videoItem.history.business.contains('article'))
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      tooltip: '稍后再看',
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: Theme.of(context).colorScheme.outline,
                        size: 14,
                      ),
                      position: PopupMenuPosition.under,
                      // constraints: const BoxConstraints(maxHeight: 35),
                      onSelected: (String type) {},
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          onTap: () async {
                            var res = await UserHttp.toViewLater(
                                bvid: videoItem.history.bvid);
                            SmartDialog.showToast(res['msg']);
                          },
                          value: 'pause',
                          height: 35,
                          child: const Row(
                            children: [
                              Icon(Icons.watch_later_outlined, size: 16),
                              SizedBox(width: 6),
                              Text('稍后再看', style: TextStyle(fontSize: 13))
                            ],
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
    );
  }
}
