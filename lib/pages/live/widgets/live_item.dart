import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/models/live/item.dart';
import 'package:pilipala/pages/video/detail/reply/widgets/reply_item.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

// 视频卡片 - 垂直布局
class LiveCardV extends StatelessWidget {
  LiveItemModel liveItem;
  Function()? longPress;
  Function()? longPressEnd;

  LiveCardV({
    Key? key,
    required this.liveItem,
    this.longPress,
    this.longPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(liveItem.roomId);
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      // shape: RoundedRectangleBorder(
      //   borderRadius: StyleString.mdRadius,
      // ),
      margin: EdgeInsets.zero,
      child: GestureDetector(
        onLongPress: () {
          if (longPress != null) {
            longPress!();
          }
        },
        onLongPressEnd: (details) {
          if (longPressEnd != null) {
            longPressEnd!();
          }
        },
        child: InkWell(
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            Get.toNamed('/liveRoom?roomid=${liveItem.roomId}',
                arguments: {'liveItem': liveItem, 'heroTag': heroTag});
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: StyleString.imgRadius,
                  topRight: StyleString.imgRadius,
                  bottomLeft: StyleString.imgRadius,
                  bottomRight: StyleString.imgRadius,
                ),
                child: AspectRatio(
                  aspectRatio: StyleString.aspectRatio,
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    double maxWidth = boxConstraints.maxWidth;
                    double maxHeight = boxConstraints.maxHeight;
                    return Stack(
                      children: [
                        Hero(
                          tag: heroTag,
                          child: NetworkImgLayer(
                            src: '${liveItem.cover!}@.webp',
                            width: maxWidth,
                            height: maxHeight,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              LiveContent(liveItem: liveItem)
            ],
          ),
        ),
      ),
    );
  }
}

class LiveContent extends StatelessWidget {
  final liveItem;
  const LiveContent({Key? key, required this.liveItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        // 多列
        padding: const EdgeInsets.fromLTRB(4, 5, 6, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              liveItem.title,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                UpTag(),
                Expanded(
                  child: Text(
                    liveItem.uname,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  '${'[' + liveItem.areaName}]',
                  style: const TextStyle(fontSize: 11),
                ),
                const Text(' • '),
                Text(
                  liveItem.watchedShow['text_large'],
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
