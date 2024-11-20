import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/models/bangumi/list.dart';
import 'package:pilipala/utils/image_save.dart';
import 'package:pilipala/utils/route_push.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

// 视频卡片 - 垂直布局
class BangumiCardV extends StatelessWidget {
  const BangumiCardV({
    super.key,
    required this.bangumiItem,
  });

  final BangumiListItemModel bangumiItem;

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(bangumiItem.mediaId);
    return InkWell(
      onTap: () {
        RoutePush.bangumiPush(
          bangumiItem.seasonId,
          null,
          progressIndex: bangumiItem.progressIndex,
          heroTag: heroTag,
        );
      },
      onLongPress: () =>
          imageSaveDialog(context, bangumiItem, SmartDialog.dismiss),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              StyleString.imgRadius,
            ),
            child: AspectRatio(
              aspectRatio: 0.75,
              child: LayoutBuilder(builder: (context, boxConstraints) {
                final double maxWidth = boxConstraints.maxWidth;
                final double maxHeight = boxConstraints.maxHeight;
                return Stack(
                  children: [
                    Hero(
                      tag: heroTag,
                      child: NetworkImgLayer(
                        src: bangumiItem.cover,
                        width: maxWidth,
                        height: maxHeight,
                      ),
                    ),
                    if (bangumiItem.badge != null)
                      PBadge(
                          text: bangumiItem.badge,
                          top: 6,
                          right: 6,
                          bottom: null,
                          left: null),
                    if (bangumiItem.order != null)
                      PBadge(
                        text: bangumiItem.order,
                        top: null,
                        right: null,
                        bottom: 6,
                        left: 6,
                        type: 'gray',
                      ),
                  ],
                );
              }),
            ),
          ),
          BangumiContent(bangumiItem: bangumiItem)
        ],
      ),
    );
  }
}

class BangumiContent extends StatelessWidget {
  const BangumiContent({super.key, required this.bangumiItem});
  // ignore: prefer_typing_uninitialized_variables
  final bangumiItem;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        // 多列
        padding: const EdgeInsets.fromLTRB(4, 5, 0, 3),
        // 单列
        // padding: const EdgeInsets.fromLTRB(14, 10, 4, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  bangumiItem.title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
            const SizedBox(height: 1),
            if (bangumiItem.indexShow != null)
              Text(
                bangumiItem.indexShow,
                maxLines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            if (bangumiItem.progress != null)
              Text(
                bangumiItem.progress,
                maxLines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
