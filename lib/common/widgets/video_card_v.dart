import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/http/dynamics.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

// 视频卡片 - 垂直布局
class VideoCardV extends StatelessWidget {
  final dynamic videoItem;
  final int crossAxisCount;
  final Function()? longPress;
  final Function()? longPressEnd;

  const VideoCardV({
    Key? key,
    required this.videoItem,
    required this.crossAxisCount,
    this.longPress,
    this.longPressEnd,
  }) : super(key: key);

  bool isStringNumeric(String str) {
    RegExp numericRegex = RegExp(r'^\d+$');
    return numericRegex.hasMatch(str);
  }

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
      // 动态
      case 'picture':
        try {
          String dynamicType = 'picture';
          String uri = videoItem.uri;
          String id = '';
          if (videoItem.uri.startsWith('bilibili://article/')) {
            // https://www.bilibili.com/read/cv27063554
            dynamicType = 'read';
            RegExp regex = RegExp(r'\d+');
            Match match = regex.firstMatch(videoItem.uri)!;
            String matchedNumber = match.group(0)!;
            videoItem.param = int.parse(matchedNumber);
            id = 'cv${videoItem.param}';
          }
          if (uri.startsWith('http')) {
            String path = Uri.parse(uri).path;
            if (isStringNumeric(path.split('/')[1])) {
              // 请求接口
              var res =
                  await DynamicsHttp.dynamicDetail(id: path.split('/')[1]);
              if (res['status']) {
                Get.toNamed('/dynamicDetail', arguments: {
                  'item': res['data'],
                  'floor': 1,
                  'action': 'detail'
                });
              }
              return;
            }
          }
          Get.toNamed('/htmlRender', parameters: {
            'url': uri,
            'title': videoItem.title,
            'id': id,
            'dynamicType': dynamicType
          });
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
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
      elevation: 0,
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
                      if (videoItem.duration != null)
                        if (crossAxisCount == 1) ...[
                          PBadge(
                            bottom: 10,
                            right: 10,
                            text: videoItem.duration,
                          )
                        ] else ...[
                          PBadge(
                            bottom: 6,
                            right: 7,
                            size: 'small',
                            type: 'gray',
                            text: videoItem.duration,
                          )
                        ],
                    ],
                  );
                }),
              ),
              VideoContent(videoItem: videoItem, crossAxisCount: crossAxisCount)
            ],
          ),
        ),
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  final dynamic videoItem;
  final int crossAxisCount;
  const VideoContent(
      {Key? key, required this.videoItem, required this.crossAxisCount})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: crossAxisCount == 1 ? 0 : 1,
      child: Padding(
        padding: crossAxisCount == 1
            ? const EdgeInsets.fromLTRB(9, 9, 9, 4)
            : const EdgeInsets.fromLTRB(5, 8, 5, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    videoItem.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (videoItem.goto == 'av' && crossAxisCount == 1) ...[
                  const SizedBox(width: 10),
                  WatchLater(
                    size: 32,
                    iconSize: 18,
                    callFn: () async {
                      int aid = videoItem.param;
                      var res =
                          await UserHttp.toViewLater(bvid: IdUtils.av2bv(aid));
                      SmartDialog.showToast(res['msg']);
                    },
                  ),
                ],
              ],
            ),
            if (crossAxisCount > 1) ...[
              const SizedBox(height: 2),
              VideoStat(
                videoItem: videoItem,
              ),
            ],
            if (crossAxisCount == 1) const SizedBox(height: 4),
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
                if (videoItem.isFollowed == 1) ...[
                  const PBadge(
                    text: '已关注',
                    stack: 'normal',
                    size: 'small',
                    type: 'color',
                  )
                ],
                Expanded(
                  flex: crossAxisCount == 1 ? 0 : 1,
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
                if (crossAxisCount == 1) ...[
                  Text(
                    ' • ',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  VideoStat(
                    videoItem: videoItem,
                  ),
                  const Spacer(),
                ],
                if (videoItem.goto == 'av' && crossAxisCount != 1) ...[
                  WatchLater(
                    size: 24,
                    iconSize: 14,
                    callFn: () async {
                      int aid = videoItem.param;
                      var res =
                          await UserHttp.toViewLater(bvid: IdUtils.av2bv(aid));
                      SmartDialog.showToast(res['msg']);
                    },
                  ),
                ] else ...[
                  const SizedBox(height: 24)
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VideoStat extends StatelessWidget {
  final dynamic videoItem;

  const VideoStat({
    Key? key,
    required this.videoItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      text: TextSpan(
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
          color: Theme.of(context).colorScheme.outline,
        ),
        children: [
          if (videoItem.stat.view != '-')
            TextSpan(text: '${videoItem.stat.view}观看'),
          if (videoItem.stat.danmu != '-')
            TextSpan(text: ' • ${videoItem.stat.danmu}弹幕'),
        ],
      ),
    );
  }
}

class WatchLater extends StatelessWidget {
  final double? size;
  final double? iconSize;
  final Function? callFn;

  const WatchLater({
    Key? key,
    required this.size,
    required this.iconSize,
    this.callFn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        tooltip: '稍后再看',
        icon: Icon(
          Icons.more_vert_outlined,
          color: Theme.of(context).colorScheme.outline,
          size: iconSize,
        ),
        position: PopupMenuPosition.under,
        // constraints: const BoxConstraints(maxHeight: 35),
        onSelected: (String type) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            onTap: () => callFn!(),
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
    );
  }
}
