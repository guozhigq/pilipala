import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/image_save.dart';
import 'package:pilipala/utils/route_push.dart';
import 'package:pilipala/utils/url_utils.dart';
import '../../http/search.dart';
import '../../http/user.dart';
import '../../http/video.dart';
import '../../utils/utils.dart';
import '../constants.dart';
import 'badge.dart';
import 'drag_handle.dart';
import 'network_img_layer.dart';
import 'stat/danmu.dart';
import 'stat/view.dart';

// 视频卡片 - 水平布局
class VideoCardH extends StatelessWidget {
  const VideoCardH({
    super.key,
    required this.videoItem,
    this.onPressedFn,
    this.source = 'normal',
    this.showOwner = true,
    this.showView = true,
    this.showDanmaku = true,
    this.showPubdate = false,
    this.showCharge = false,
  });
  // ignore: prefer_typing_uninitialized_variables
  final videoItem;
  final Function()? onPressedFn;
  // normal 推荐, later 稍后再看, search 搜索
  final String source;
  final bool showOwner;
  final bool showView;
  final bool showDanmaku;
  final bool showPubdate;
  final bool showCharge;

  @override
  Widget build(BuildContext context) {
    final int aid = videoItem.aid;
    final String bvid = videoItem.bvid;
    String type = 'video';
    try {
      type = videoItem.type;
    } catch (_) {}
    final String heroTag = Utils.makeHeroTag(aid);
    return InkWell(
      onTap: () async {
        try {
          if (type == 'ketang') {
            SmartDialog.showToast('课堂视频暂不支持播放');
            return;
          }
          if (showCharge && videoItem?.typeid == 33) {
            final String redirectUrl = await UrlUtils.parseRedirectUrl(
                '${HttpString.baseUrl}/video/$bvid/');
            final String lastPathSegment = redirectUrl.split('/').last;
            if (lastPathSegment.contains('ss')) {
              RoutePush.bangumiPush(
                  Utils.matchNum(lastPathSegment).first, null);
            }
            if (lastPathSegment.contains('ep')) {
              RoutePush.bangumiPush(
                  null, Utils.matchNum(lastPathSegment).first);
            }
            return;
          }
          final int cid =
              videoItem.cid ?? await SearchHttp.ab2c(aid: aid, bvid: bvid);
          Get.toNamed('/video?bvid=$bvid&cid=$cid',
              arguments: {'videoItem': videoItem, 'heroTag': heroTag});
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
      },
      onLongPress: () => imageSaveDialog(
        context,
        videoItem,
        SmartDialog.dismiss,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            StyleString.safeSpace, 5, StyleString.safeSpace, 5),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
            final double width = (boxConstraints.maxWidth -
                    StyleString.cardSpace *
                        6 /
                        MediaQuery.textScalerOf(context).scale(1.0)) /
                2;
            return Container(
              constraints: const BoxConstraints(minHeight: 88),
              height: width / StyleString.aspectRatio,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: StyleString.aspectRatio,
                    child: LayoutBuilder(
                      builder: (BuildContext context,
                          BoxConstraints boxConstraints) {
                        final double maxWidth = boxConstraints.maxWidth;
                        final double maxHeight = boxConstraints.maxHeight;
                        return Stack(
                          children: [
                            Hero(
                              tag: heroTag,
                              child: NetworkImgLayer(
                                src: videoItem.pic as String,
                                width: maxWidth,
                                height: maxHeight,
                              ),
                            ),
                            if (videoItem.duration != 0)
                              PBadge(
                                text: Utils.timeFormat(videoItem.duration!),
                                right: 6.0,
                                bottom: 6.0,
                                type: 'gray',
                              ),
                            if (type != 'video')
                              PBadge(
                                text: type,
                                left: 6.0,
                                bottom: 6.0,
                                type: 'primary',
                              ),
                            // if (videoItem.rcmdReason != null &&
                            //     videoItem.rcmdReason.content != '')
                            //   pBadge(videoItem.rcmdReason.content, context,
                            //       6.0, 6.0, null, null),
                            if (showCharge && videoItem?.isChargingSrc)
                              const PBadge(
                                text: '充电专属',
                                right: 6.0,
                                top: 6.0,
                                type: 'primary',
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  VideoContent(
                    videoItem: videoItem,
                    source: source,
                    showOwner: showOwner,
                    showView: showView,
                    showDanmaku: showDanmaku,
                    showPubdate: showPubdate,
                    onPressedFn: onPressedFn,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final videoItem;
  final String source;
  final bool showOwner;
  final bool showView;
  final bool showDanmaku;
  final bool showPubdate;
  final Function()? onPressedFn;

  const VideoContent({
    super.key,
    required this.videoItem,
    this.source = 'normal',
    this.showOwner = true,
    this.showView = true,
    this.showDanmaku = true,
    this.showPubdate = false,
    this.onPressedFn,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 6, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (source == 'normal' || source == 'later') ...[
              Text(
                videoItem.title as String,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ] else ...[
              RichText(
                maxLines: 2,
                text: TextSpan(
                  children: [
                    for (final i in videoItem.titleList) ...[
                      TextSpan(
                        text: i['text'] as String,
                        style: TextStyle(
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
            // const SizedBox(height: 4),
            if (showPubdate)
              Text(
                Utils.dateFormat(videoItem.pubdate!),
                style: TextStyle(
                    fontSize: 11, color: Theme.of(context).colorScheme.outline),
              ),
            if (showOwner)
              Row(
                children: [
                  Text(
                    videoItem.owner.name as String,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                if (showView) ...[
                  StatView(view: videoItem.stat.view as int),
                  const SizedBox(width: 8),
                ],
                if (showDanmaku)
                  StatDanMu(danmu: videoItem.stat.danmaku as int),
                const Spacer(),
                if (source == 'normal')
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
                            return MorePanel(videoItem: videoItem);
                          },
                        );
                      },
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: Theme.of(context).colorScheme.outline,
                        size: 14,
                      ),
                    ),
                  ),
                if (source == 'later') ...[
                  IconButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () => onPressedFn?.call(),
                    icon: Icon(
                      Icons.clear_outlined,
                      color: Theme.of(context).colorScheme.outline,
                      size: 18,
                    ),
                  )
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MorePanel extends StatelessWidget {
  final dynamic videoItem;
  const MorePanel({super.key, required this.videoItem});

  Future<dynamic> menuActionHandler(String type) async {
    switch (type) {
      case 'block':
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
                SmartDialog.showToast(res['msg'] ?? '成功');
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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DragHandle(),
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
