import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../../models/model_rec_video_item.dart';
import 'stat/danmu.dart';
import 'stat/view.dart';
import '../../http/dynamics.dart';
import '../../http/search.dart';
import '../../http/user.dart';
import '../../http/video.dart';
import '../../models/common/search_type.dart';
import '../../utils/id_utils.dart';
import '../../utils/utils.dart';
import '../constants.dart';
import 'badge.dart';
import 'network_img_layer.dart';

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
                      if (videoItem.duration > 0)
                        if (crossAxisCount == 1) ...[
                          PBadge(
                            bottom: 10,
                            right: 10,
                            text: Utils.timeFormat(videoItem.duration),
                          )
                        ] else ...[
                          PBadge(
                            bottom: 6,
                            right: 7,
                            size: 'small',
                            type: 'gray',
                            text: Utils.timeFormat(videoItem.duration),
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
                  VideoPopupMenu(
                    size: 32,
                    iconSize: 18,
                    videoItem: videoItem,
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
                  VideoPopupMenu(
                    size: 24,
                    iconSize: 14,
                    videoItem: videoItem,
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
    return Row(
      children: [
        StatView(
          theme: 'gray',
          view: videoItem.stat.view,
        ),
        const SizedBox(width: 8),
        StatDanMu(
          theme: 'gray',
          danmu: videoItem.stat.danmu,
        ),
        if (videoItem is RecVideoItemModel) ...<Widget>[
          const Spacer(),
          RichText(
            maxLines: 1,
            text: TextSpan(
                style: TextStyle(
                  fontSize: MediaQuery.textScalerOf(context)
                      .scale(Theme.of(context).textTheme.labelSmall!.fontSize!),
                  color: Theme.of(context).colorScheme.outline,
                ),
                text: Utils.formatTimestampToRelativeTime(videoItem.pubdate)),
          ),
          const SizedBox(width: 4),
        ]
      ],
    );
  }
}

class VideoPopupMenu extends StatelessWidget {
  final double? size;
  final double? iconSize;
  final dynamic videoItem;

  const VideoPopupMenu({
    Key? key,
    required this.size,
    required this.iconSize,
    required this.videoItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
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
            onTap: () async {
              var res =
                  await UserHttp.toViewLater(bvid: videoItem.bvid as String);
              SmartDialog.showToast(res['msg']);
            },
            value: 'pause',
            height: 40,
            child: const Row(
              children: [
                Icon(Icons.watch_later_outlined, size: 16),
                SizedBox(width: 6),
                Text('稍后再看', style: TextStyle(fontSize: 13))
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            onTap: () async {
              SmartDialog.show(
                useSystem: true,
                animationType: SmartAnimationType.centerFade_otherSlide,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('提示'),
                    content: Text(
                        '确定拉黑:${videoItem.owner.name}(${videoItem.owner.mid})?'
                        '\n\n注：被拉黑的Up可以在隐私设置-黑名单管理中解除'),
                    actions: [
                      TextButton(
                        onPressed: () => SmartDialog.dismiss(),
                        child: Text(
                          '点错了',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          var res = await VideoHttp.relationMod(
                            mid: videoItem.owner.mid,
                            act: 5,
                            reSrc: 11,
                          );
                          SmartDialog.dismiss();
                          SmartDialog.showToast(res['msg'] ?? '成功');
                        },
                        child: const Text('确认'),
                      )
                    ],
                  );
                },
              );
            },
            value: 'pause',
            height: 40,
            child: Row(
              children: [
                const Icon(Icons.block, size: 16),
                const SizedBox(width: 6),
                Text('拉黑：${videoItem.owner.name}',
                    style: const TextStyle(fontSize: 13))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
