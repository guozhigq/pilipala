// 视频or合集
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/utils.dart';

import 'rich_node_panel.dart';

Widget videoSeasonWidget(item, context, type, {floor = 1}) {
  TextStyle authorStyle =
      TextStyle(color: Theme.of(context).colorScheme.primary);
  // type archive  ugcSeason
  // archive 视频/显示发布人
  // ugcSeason 合集/不显示发布人

  // floor 1 2
  // 1 投稿视频 铺满 borderRadius 0
  // 2 转发视频 铺满 borderRadius 6
  Map<dynamic, dynamic> dynamicProperty = {
    'ugcSeason': item.modules.moduleDynamic.major.ugcSeason,
    'archive': item.modules.moduleDynamic.major.archive,
    'pgc': item.modules.moduleDynamic.major.pgc
  };
  dynamic content = dynamicProperty[type];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      if (floor == 2) ...[
        Row(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(
                  '/member?mid=${item.modules.moduleAuthor.mid}',
                  arguments: {'face': item.modules.moduleAuthor.face}),
              child: Text(
                item.modules.moduleAuthor.type == null
                    ? '@${item.modules.moduleAuthor.name}'
                    : item.modules.moduleAuthor.name,
                style: authorStyle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.modules.moduleAuthor.pubTs != null
                  ? Utils.dateFormat(item.modules.moduleAuthor.pubTs)
                  : item.modules.moduleAuthor.pubTime,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
            ),
          ],
        ),
        const SizedBox(height: 6),
      ],
      // const SizedBox(height: 4),
      if (item.modules.moduleDynamic.topic != null) ...[
        Padding(
          padding: floor == 2
              ? EdgeInsets.zero
              : const EdgeInsets.only(left: 12, right: 12),
          child: GestureDetector(
            child: Text(
              '#${item.modules.moduleDynamic.topic.name}',
              style: authorStyle,
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
      if (floor == 2 && item.modules.moduleDynamic.desc != null) ...[
        Text.rich(richNode(item, context)),
        const SizedBox(height: 6),
      ],
      LayoutBuilder(builder: (context, box) {
        double width = box.maxWidth;
        return Stack(
          children: [
            Hero(
              tag: content.bvid,
              child: NetworkImgLayer(
                type: floor == 1 ? 'emote' : null,
                width: width,
                height: width / StyleString.aspectRatio,
                src: content.cover,
              ),
            ),
            if (content.badge != null && type == 'pgc')
              PBadge(
                text: content.badge['text'],
                top: 8.0,
                right: 10.0,
                bottom: null,
                left: null,
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 80,
                padding: const EdgeInsets.fromLTRB(12, 0, 10, 10),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black54,
                      ],
                    ),
                    borderRadius: floor == 1
                        ? null
                        : const BorderRadius.all(Radius.circular(6))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DefaultTextStyle.merge(
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium!.fontSize,
                          color: Colors.white),
                      child: Row(
                        children: [
                          Text(content.durationText ?? ''),
                          if (content.durationText != null)
                            const SizedBox(width: 10),
                          Text(content.stat.play + '次围观'),
                          const SizedBox(width: 10),
                          Text(content.stat.danmaku + '条弹幕')
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/play.png',
                      width: 60,
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      const SizedBox(height: 6),
      Padding(
        padding: floor == 1
            ? const EdgeInsets.only(left: 12, right: 12)
            : EdgeInsets.zero,
        child: Text(
          content.title,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
