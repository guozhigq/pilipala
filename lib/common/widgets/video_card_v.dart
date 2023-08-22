import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

// 视频卡片 - 垂直布局
class VideoCardV extends StatelessWidget {
  final dynamic videoItem;
  final Function()? longPress;
  final Function()? longPressEnd;

  const VideoCardV({
    Key? key,
    required this.videoItem,
    this.longPress,
    this.longPressEnd,
  }) : super(key: key);

  void onPushDetail(heroTag) async {
    String goto = videoItem.goto;
    switch (goto) {
      case 'bangumi':
        if (videoItem.bangumiBadge == '电影') {
          SmartDialog.showToast('暂不支持电影观看');
          return;
        }
        int epId = videoItem.param;
        SmartDialog.showLoading(msg: '资源获取中');
        var result = await SearchHttp.bangumiInfo(seasonId: null, epId: epId);
        if (result['status']) {
          var bangumiDetail = result['data'];
          int cid = bangumiDetail.episodes!.first.cid;
          String bvid = IdUtils.av2bv(bangumiDetail.episodes!.first.aid);
          SmartDialog.dismiss().then(
            (value) => Get.toNamed(
              '/video?bvid=$bvid&cid=$cid&epId=$epId',
              arguments: {
                'pic': videoItem.pic,
                'heroTag': heroTag,
                'videoType': SearchType.media_bangumi,
              },
            ),
          );
        }
        break;
      case 'av':
        String bvid = videoItem.bvid ?? IdUtils.av2bv(videoItem.aid);
        Get.toNamed('/video?bvid=$bvid&cid=${videoItem.cid}', arguments: {
          // 'videoItem': videoItem,
          'pic': videoItem.pic,
          'heroTag': heroTag,
        });
        break;
      default:
        SmartDialog.showToast(videoItem.goto);
        Get.toNamed(
          '/webview',
          parameters: {
            'url': videoItem.uri,
            'type': 'url',
            'pageTitle': videoItem.title,
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(videoItem.id);
    return Card(
      elevation: 1,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: GestureDetector(
        onLongPress: () {
          if (longPress != null) {
            longPress!();
          }
        },
        // onLongPressEnd: (details) {
        //   if (longPressEnd != null) {
        //     longPressEnd!();
        //   }
        // },
        child: InkWell(
          onTap: () async => onPushDetail(heroTag),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: StyleString.aspectRatio,
                child: LayoutBuilder(builder: (context, boxConstraints) {
                  double maxWidth = boxConstraints.maxWidth;
                  double maxHeight = boxConstraints.maxHeight;
                  return Hero(
                    tag: heroTag,
                    child: NetworkImgLayer(
                      src: videoItem.pic,
                      width: maxWidth,
                      height: maxHeight,
                    ),
                  );
                }),
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
  final dynamic videoItem;
  const VideoContent({Key? key, required this.videoItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(9, 8, 9, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              videoItem.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            Row(
              children: [
                if (videoItem.goto == 'bangumi') ...[
                  PBadge(
                    text: videoItem.bangumiBadge,
                    stack: 'normal',
                    size: 'small',
                    type: 'line',
                    fs: 9,
                  )
                ],
                if (videoItem.rcmdReason != null &&
                    videoItem.rcmdReason.content != '') ...[
                  PBadge(
                    text: videoItem.rcmdReason.content,
                    stack: 'normal',
                    size: 'small',
                    type: 'color',
                  )
                ],
                if (videoItem.goto == 'picture') ...[
                  const PBadge(
                    text: '动态',
                    stack: 'normal',
                    size: 'small',
                    type: 'line',
                    fs: 9,
                  )
                ],
                Expanded(
                  child: Text(
                    videoItem.owner.name,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                if (videoItem.goto == 'av')
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
                            int aid = videoItem.param;
                            var res = await UserHttp.toViewLater(
                                bvid: IdUtils.av2bv(aid));
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
            // Row(
            //   children: [
            //     const SizedBox(width: 1),
            //     StatView(
            //       theme: 'gray',
            //       view: videoItem.stat.view,
            //     ),
            //     const SizedBox(width: 10),
            //     StatDanMu(
            //       theme: 'gray',
            //       danmu: videoItem.stat.danmaku,
            //     ),
            //     const Spacer(),
            //     SizedBox(
            //       width: 24,
            //       height: 24,
            //       child: PopupMenuButton<String>(
            //         padding: EdgeInsets.zero,
            //         tooltip: '稍后再看',
            //         icon: Icon(
            //           Icons.more_vert_outlined,
            //           color: Theme.of(context).colorScheme.outline,
            //           size: 14,
            //         ),
            //         position: PopupMenuPosition.under,
            //         // constraints: const BoxConstraints(maxHeight: 35),
            //         onSelected: (String type) {},
            //         itemBuilder: (BuildContext context) =>
            //             <PopupMenuEntry<String>>[
            //           PopupMenuItem<String>(
            //             onTap: () async {
            //               var res =
            //                   await UserHttp.toViewLater(bvid: videoItem.bvid);
            //               SmartDialog.showToast(res['msg']);
            //             },
            //             value: 'pause',
            //             height: 35,
            //             child: const Row(
            //               children: [
            //                 Icon(Icons.watch_later_outlined, size: 16),
            //                 SizedBox(width: 6),
            //                 Text('稍后再看', style: TextStyle(fontSize: 13))
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
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
      height: 48,
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
