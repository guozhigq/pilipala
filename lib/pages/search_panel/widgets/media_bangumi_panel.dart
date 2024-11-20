import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/route_push.dart';
import 'package:pilipala/utils/utils.dart';

Widget searchMbangumiPanel(BuildContext context, ctr, list) {
  TextStyle style =
      TextStyle(fontSize: Theme.of(context).textTheme.labelMedium!.fontSize);
  return ListView.builder(
    controller: ctr!.scrollController,
    addAutomaticKeepAlives: false,
    addRepaintBoundaries: false,
    itemCount: list!.length,
    itemBuilder: (context, index) {
      var i = list![index];
      return InkWell(
        onTap: () {
          /// TODO 番剧详情页面
          // Get.toNamed('/video?bvid=${i.bvid}&cid=${i.cid}', arguments: {
          //   'videoItem': i,
          //   'heroTag': Utils.makeHeroTag(i.id),
          //   'videoType': SearchType.media_bangumi
          // });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: StyleString.safeSpace, vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  NetworkImgLayer(
                    width: 111,
                    height: 148,
                    src: i.cover,
                  ),
                  PBadge(
                    text: i.mediaType == 1 ? '番剧' : '国创',
                    top: 6.0,
                    right: 4.0,
                    bottom: null,
                    left: null,
                  )
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        children: [
                          for (var i in i.titleList) ...[
                            TextSpan(
                              text: i['text'],
                              style: TextStyle(
                                fontSize: MediaQuery.textScalerOf(context)
                                    .scale(Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .fontSize!),
                                fontWeight: FontWeight.bold,
                                color: i['type'] == 'em'
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('评分:${i.mediaScore['score'].toString()}',
                        style: style),
                    Row(
                      children: [
                        Text(i.areas, style: style),
                        const SizedBox(width: 3),
                        const Text('·'),
                        const SizedBox(width: 3),
                        Text(Utils.dateFormat(i.pubtime).toString(),
                            style: style),
                      ],
                    ),
                    Row(
                      children: [
                        Text(i.styles, style: style),
                        const SizedBox(width: 3),
                        const Text('·'),
                        const SizedBox(width: 3),
                        Text(i.indexShow, style: style),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          RoutePush.bangumiPush(i.seasonId, null);
                        },
                        child: const Text('观看'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
