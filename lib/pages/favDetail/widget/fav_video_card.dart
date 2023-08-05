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

import '../controller.dart';

// 收藏视频卡片 - 水平布局
class FavVideoCardH extends StatelessWidget {
  final dynamic videoItem;
  final FavDetailController _favDetailController =
      Get.put(FavDetailController());

  FavVideoCardH({Key? key, required this.videoItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int id = videoItem.id;
    String bvid = videoItem.bvid ?? IdUtils.av2bv(id);
    String heroTag = Utils.makeHeroTag(id);
    return Dismissible(
      movementDuration: const Duration(milliseconds: 300),
      background: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.clear_all_rounded),
              SizedBox(width: 6),
              Text('取消收藏')
            ],
          )),
      direction: DismissDirection.endToStart,
      key: ValueKey<int>(videoItem.id),
      onDismissed: (DismissDirection direction) {
        _favDetailController.onCancelFav(videoItem.id);
        // widget.onDeleteNotice();
      },
      child: InkWell(
        onTap: () async {
          // int? seasonId;
          String? epId;
          if (videoItem.ogv != null && videoItem.ogv['type_name'] == '番剧') {
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
                                        Utils.timeFormat(videoItem.duration!),
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
          ],
        ),
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
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              videoItem.owner.name,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                StatView(
                  theme: 'gray',
                  view: videoItem.cntInfo['play'],
                ),
                const SizedBox(width: 8),
                StatDanMu(theme: 'gray', danmu: videoItem.cntInfo['danmaku'])
              ],
            ),
          ],
        ),
      ),
    );
  }
}
