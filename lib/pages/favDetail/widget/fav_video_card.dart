import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

import '../controller.dart';

// 收藏视频卡片 - 水平布局
class FavVideoCardH extends StatelessWidget {
  var videoItem;
  final FavDetailController _favDetailController =
      Get.put(FavDetailController());

  FavVideoCardH({Key? key, required this.videoItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int id = videoItem.id;
    String heroTag = Utils.makeHeroTag(id);
    return Dismissible(
      movementDuration: const Duration(milliseconds: 300),
      background: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
          await Future.delayed(const Duration(milliseconds: 200));
          Get.toNamed('/video?aid=$id&cid=${videoItem.cid}',
              arguments: {'videoItem': videoItem, 'heroTag': heroTag});
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
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
                              double PR =
                                  MediaQuery.of(context).devicePixelRatio;
                              return Stack(
                                children: [
                                  Hero(
                                    tag: heroTag,
                                    child: NetworkImgLayer(
                                      // src: videoItem['pic'] +
                                      //     '@${(maxWidth * 2).toInt()}w',
                                      src: videoItem.pic + '@.webp',
                                      width: maxWidth,
                                      height: maxHeight,
                                    ),
                                  ),
                                  // Image.network( videoItem['pic'], width: double.infinity, height: double.infinity,),
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              videoItem.owner.name,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
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
