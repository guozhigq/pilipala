import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/bangumi/info.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

// 视频卡片 - 垂直布局
class BangumiCardV extends StatelessWidget {
  const BangumiCardV({
    super.key,
    required this.bangumiItem,
    this.longPress,
    this.longPressEnd,
  });

  final bangumiItem;
  final Function()? longPress;
  final Function()? longPressEnd;

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(bangumiItem.mediaId);
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: GestureDetector(
        // onLongPress: () {
        //   if (longPress != null) {
        //     longPress!();
        //   }
        // },
        // onLongPressEnd: (details) {
        //   if (longPressEnd != null) {
        //     longPressEnd!();
        //   }
        // },
        child: InkWell(
          onTap: () async {
            final int seasonId = bangumiItem.seasonId;
            SmartDialog.showLoading(msg: '获取中...');
            final res = await SearchHttp.bangumiInfo(seasonId: seasonId);
            SmartDialog.dismiss().then((value) {
              if (res['status']) {
                if (res['data'].episodes.isEmpty) {
                  SmartDialog.showToast('资源加载失败');
                  return;
                }
                EpisodeItem episode = res['data'].episodes.first;
                String bvid = episode.bvid!;
                int cid = episode.cid!;
                String pic = episode.cover!;
                String heroTag = Utils.makeHeroTag(cid);
                Get.toNamed(
                  '/video?bvid=$bvid&cid=$cid&seasonId=$seasonId',
                  arguments: {
                    'pic': pic,
                    'heroTag': heroTag,
                    'videoType': SearchType.media_bangumi,
                    'bangumiItem': res['data'],
                  },
                );
              }
            });
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
                  aspectRatio: 0.65,
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
        ),
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
