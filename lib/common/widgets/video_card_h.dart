import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../../http/search.dart';
import '../../http/user.dart';
import '../../http/video.dart';
import '../../utils/utils.dart';
import '../constants.dart';
import 'badge.dart';
import 'network_img_layer.dart';
import 'stat/danmu.dart';
import 'stat/view.dart';

// 视频卡片 - 水平布局
class VideoCardH extends StatelessWidget {
  const VideoCardH({
    super.key,
    required this.videoItem,
    this.longPress,
    this.longPressEnd,
    this.source = 'normal',
    this.showOwner = true,
    this.showView = true,
    this.showDanmaku = true,
    this.showPubdate = false,
  });
  // ignore: prefer_typing_uninitialized_variables
  final videoItem;
  final Function()? longPress;
  final Function()? longPressEnd;
  final String source;
  final bool showOwner;
  final bool showView;
  final bool showDanmaku;
  final bool showPubdate;

  @override
  Widget build(BuildContext context) {
    final int aid = videoItem.aid;
    final String bvid = videoItem.bvid;
    final String heroTag = Utils.makeHeroTag(aid);
    return GestureDetector(
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
        onTap: () async {
          try {
            final int cid =
                videoItem.cid ?? await SearchHttp.ab2c(aid: aid, bvid: bvid);
            Get.toNamed('/video?bvid=$bvid&cid=$cid',
                arguments: {'videoItem': videoItem, 'heroTag': heroTag});
          } catch (err) {
            SmartDialog.showToast(err.toString());
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              StyleString.safeSpace, 5, StyleString.safeSpace, 5),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
              final double width = (boxConstraints.maxWidth -
                      StyleString.cardSpace *
                          6 /
                          MediaQuery.of(context).textScaleFactor) /
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
                              PBadge(
                                text: Utils.timeFormat(videoItem.duration!),
                                right: 6.0,
                                bottom: 6.0,
                                type: 'gray',
                              ),
                              // if (videoItem.rcmdReason != null &&
                              //     videoItem.rcmdReason.content != '')
                              //   pBadge(videoItem.rcmdReason.content, context,
                              //       6.0, 6.0, null, null),
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
                    )
                  ],
                ),
              );
            },
          ),
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

  const VideoContent({
    super.key,
    required this.videoItem,
    this.source = 'normal',
    this.showOwner = true,
    this.showView = true,
    this.showDanmaku = true,
    this.showPubdate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 6, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (videoItem.title is String) ...[
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
                    for (final i in videoItem.title) ...[
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
                  StatView(
                    theme: 'gray',
                    view: videoItem.stat.view as int,
                  ),
                  const SizedBox(width: 8),
                ],
                if (showDanmaku)
                  StatDanMu(
                    theme: 'gray',
                    danmu: videoItem.stat.danmaku as int,
                  ),

                const Spacer(),
                // SizedBox(
                //   width: 20,
                //   height: 20,
                //   child: IconButton(
                //     tooltip: '稍后再看',
                //     style: ButtonStyle(
                //       padding: MaterialStateProperty.all(EdgeInsets.zero),
                //     ),
                //     onPressed: () async {
                //       var res =
                //           await UserHttp.toViewLater(bvid: videoItem.bvid);
                //       SmartDialog.showToast(res['msg']);
                //     },
                //     icon: Icon(
                //       Icons.more_vert_outlined,
                //       color: Theme.of(context).colorScheme.outline,
                //       size: 14,
                //     ),
                //   ),
                // ),
                if (source == 'normal')
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
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
                                bvid: videoItem.bvid as String);
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
                              animationType:
                                  SmartAnimationType.centerFade_otherSlide,
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline),
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
                                        SmartDialog.showToast(
                                            res['msg'] ?? '成功');
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
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
