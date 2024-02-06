import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import '../../../common/widgets/badge.dart';

// 收藏视频卡片 - 水平布局
class FavVideoCardH extends StatelessWidget {
  final dynamic videoItem;
  final Function? callFn;

  const FavVideoCardH({Key? key, required this.videoItem, this.callFn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int id = videoItem.id;
    String bvid = videoItem.bvid ?? IdUtils.av2bv(id);
    String heroTag = Utils.makeHeroTag(id);
    return InkWell(
      onTap: () async {
        // int? seasonId;
        String? epId;
        if (videoItem.ogv != null &&
            (videoItem.ogv['type_name'] == '番剧' ||
                videoItem.ogv['type_name'] == '国创')) {
          videoItem.cid = await SearchHttp.ab2c(bvid: bvid);
          // seasonId = videoItem.ogv['season_id'];
          epId = videoItem.epId;
        } else if (videoItem.page == 0 || videoItem.page > 1) {
          var result = await VideoHttp.videoIntro(bvid: bvid);
          if (result['status']) {
            epId = result['data'].epId;
          }
        }

        Map<String, String> parameters = {
          'bvid': bvid,
          'cid': videoItem.cid.toString(),
          'epId': epId ?? '',
        };
        // if (seasonId != null) {
        //   parameters['seasonId'] = seasonId.toString();
        // }
        Get.toNamed('/video', parameters: parameters, arguments: {
          'videoItem': videoItem,
          'heroTag': heroTag,
          'videoType':
              epId != null ? SearchType.media_bangumi : SearchType.video,
        });
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
                                    src: videoItem.pic,
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
                                if (videoItem.ogv != null) ...[
                                  PBadge(
                                    text: videoItem.ogv['type_name'],
                                    top: 6.0,
                                    right: 6.0,
                                    bottom: null,
                                    left: null,
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                      VideoContent(videoItem: videoItem, callFn: callFn)
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
  final Function? callFn;
  const VideoContent({super.key, required this.videoItem, this.callFn});

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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (videoItem.ogv != null) ...[
              Text(
                videoItem.intro,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
            const Spacer(),
            Text(
              Utils.dateFormat(videoItem.favTime),
              style: TextStyle(
                  fontSize: 11, color: Theme.of(context).colorScheme.outline),
            ),
            if (videoItem.owner.name != '') ...[
              Text(
                videoItem.owner.name,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
            Row(
              children: [
                StatView(
                  theme: 'gray',
                  view: videoItem.cntInfo['play'],
                ),
                const SizedBox(width: 8),
                StatDanMu(theme: 'gray', danmu: videoItem.cntInfo['danmaku']),
                const Spacer(),
                SizedBox(
                  width: 26,
                  height: 26,
                  child: IconButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      showDialog(
                        context: Get.context!,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('提示'),
                            content: const Text('要取消收藏吗?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline),
                                  )),
                              TextButton(
                                onPressed: () async {
                                  await callFn!();
                                  Get.back();
                                },
                                child: const Text('确定取消'),
                              )
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.clear_outlined,
                      color: Theme.of(context).colorScheme.outline,
                      size: 18,
                    ),
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
