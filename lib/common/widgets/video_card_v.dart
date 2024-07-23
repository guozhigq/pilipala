import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/image_save.dart';
import 'package:pilipala/utils/route_push.dart';
import '../../models/model_rec_video_item.dart';
import 'stat/danmu.dart';
import 'stat/view.dart';
import '../../http/dynamics.dart';
import '../../http/user.dart';
import '../../http/video.dart';
import '../../utils/id_utils.dart';
import '../../utils/utils.dart';
import '../constants.dart';
import 'badge.dart';
import 'network_img_layer.dart';

// 视频卡片 - 垂直布局
class VideoCardV extends StatelessWidget {
  final dynamic videoItem;
  final int crossAxisCount;
  final Function? blockUserCb;

  const VideoCardV({
    Key? key,
    required this.videoItem,
    required this.crossAxisCount,
    this.blockUserCb,
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
        RoutePush.bangumiPush(
          null,
          epId,
          heroTag: heroTag,
        );
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
    return InkWell(
      onTap: () async => onPushDetail(heroTag),
      onLongPress: () => imageSaveDialog(
        context,
        videoItem,
        SmartDialog.dismiss,
      ),
      borderRadius: BorderRadius.circular(16),
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
          VideoContent(
            videoItem: videoItem,
            crossAxisCount: crossAxisCount,
            blockUserCb: blockUserCb,
          )
        ],
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  final dynamic videoItem;
  final int crossAxisCount;
  final Function? blockUserCb;

  const VideoContent({
    Key? key,
    required this.videoItem,
    required this.crossAxisCount,
    this.blockUserCb,
  }) : super(key: key);

  Widget _buildBadge(String text, String type, [double fs = 12]) {
    return PBadge(
      text: text,
      stack: 'normal',
      size: 'small',
      type: type,
      fs: fs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: crossAxisCount == 1
          ? const EdgeInsets.fromLTRB(9, 9, 9, 4)
          : const EdgeInsets.fromLTRB(5, 8, 5, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            videoItem.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (crossAxisCount > 1) ...[
            const SizedBox(height: 2),
            VideoStat(videoItem: videoItem, crossAxisCount: crossAxisCount),
          ],
          if (crossAxisCount == 1) const SizedBox(height: 4),
          Row(
            children: [
              if (videoItem.goto == 'bangumi')
                _buildBadge(videoItem.bangumiBadge, 'line', 9),
              if (videoItem.rcmdReason != null)
                _buildBadge(videoItem.rcmdReason, 'color'),
              if (videoItem.goto == 'picture') _buildBadge('动态', 'line', 9),
              if (videoItem.isFollowed == 1) _buildBadge('已关注', 'color'),
              Expanded(
                flex: crossAxisCount == 1 ? 0 : 1,
                child: Text(
                  videoItem.owner.name,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              if (crossAxisCount == 1) ...[
                const SizedBox(width: 10),
                VideoStat(
                  videoItem: videoItem,
                  crossAxisCount: crossAxisCount,
                ),
                const Spacer(),
              ],
              if (videoItem.goto == 'av')
                SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      feedBack();
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        builder: (context) {
                          return MorePanel(
                            videoItem: videoItem,
                            blockUserCb: blockUserCb,
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.more_vert_outlined,
                      color: Theme.of(context).colorScheme.outline,
                      size: 14,
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

class VideoStat extends StatelessWidget {
  final dynamic videoItem;
  final int crossAxisCount;

  const VideoStat({
    Key? key,
    required this.videoItem,
    required this.crossAxisCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatView(theme: 'gray', view: videoItem.stat.view),
        const SizedBox(width: 8),
        StatDanMu(theme: 'gray', danmu: videoItem.stat.danmu),
        if (videoItem is RecVideoItemModel) ...<Widget>[
          crossAxisCount > 1 ? const Spacer() : const SizedBox(width: 8),
          RichText(
            maxLines: 1,
            text: TextSpan(
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
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

class MorePanel extends StatelessWidget {
  final dynamic videoItem;
  final Function? blockUserCb;
  const MorePanel({
    super.key,
    required this.videoItem,
    this.blockUserCb,
  });

  Future<dynamic> menuActionHandler(String type) async {
    switch (type) {
      case 'block':
        Get.back();
        blockUser();
        break;
      case 'watchLater':
        var res = await UserHttp.toViewLater(bvid: videoItem.bvid as String);
        SmartDialog.showToast(res['msg']);
        Get.back();
        break;
      default:
    }
  }

  void blockUser() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text('确定拉黑:${videoItem.owner.name}(${videoItem.owner.mid})?'
              '\n\n注：被拉黑的Up可以在隐私设置-黑名单管理中解除'),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: Text(
                '点错了',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
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
                if (res['status']) {
                  blockUserCb?.call(videoItem.owner.mid);
                }
                SmartDialog.showToast(res['msg']);
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              height: 35,
              padding: const EdgeInsets.only(bottom: 2),
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                ),
              ),
            ),
          ),
          ListTile(
            onTap: () async => await menuActionHandler('block'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.block, size: 19),
            title: Text(
              '拉黑up主 「${videoItem.owner.name}」',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListTile(
            onTap: () async => await menuActionHandler('watchLater'),
            minLeadingWidth: 0,
            leading: const Icon(Icons.watch_later_outlined, size: 19),
            title:
                Text('添加至稍后再看', style: Theme.of(context).textTheme.titleSmall),
          ),
          ListTile(
            onTap: () =>
                imageSaveDialog(context, videoItem, SmartDialog.dismiss),
            minLeadingWidth: 0,
            leading: const Icon(Icons.photo_outlined, size: 19),
            title:
                Text('查看视频封面', style: Theme.of(context).textTheme.titleSmall),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
