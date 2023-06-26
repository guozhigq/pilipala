import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/utils/utils.dart';

import 'action_panel.dart';
import 'article_panel.dart';
import 'content_panel.dart';
import 'live_rcmd_panel.dart';
import 'pic_panel.dart';
import 'rich_node_panel.dart';

class DynamicPanel extends StatelessWidget {
  DynamicItemModel? item;
  DynamicPanel({this.item, Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 8,
            color: Theme.of(context).dividerColor.withOpacity(0.05),
          ),
        ),
      ),
      child: Material(
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: InkWell(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              author(item, context),
              if (item!.modules!.moduleDynamic!.desc != null)
                content(item, context),
              Padding(
                padding: EdgeInsets.zero,
                // padding: const EdgeInsets.only(left: 15, right: 15),
                child: forWard(item, context),
              ),
              action(item, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget author(item, context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          NetworkImgLayer(
            width: 40,
            height: 40,
            type: 'avatar',
            src: item.modules.moduleAuthor.face,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.modules.moduleAuthor.name),
              DefaultTextStyle.merge(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
                ),
                child: Row(
                  children: [
                    Text(item.modules.moduleAuthor.pubTime),
                    if (item.modules.moduleAuthor.pubTime != '' &&
                        item.modules.moduleAuthor.pubAction != '')
                      const Text(' '),
                    Text(item.modules.moduleAuthor.pubAction),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // 转发
  Widget forWard(item, context, {floor = 1}) {
    TextStyle authorStyle =
        TextStyle(color: Theme.of(context).colorScheme.primary);
    switch (item.type) {
      // 图文
      case 'DYNAMIC_TYPE_DRAW':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (floor == 2) ...[
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      '@${item.modules.moduleAuthor.name}',
                      style: authorStyle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    Utils.dateFormat(item.modules.moduleAuthor.pubTs),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize:
                            Theme.of(context).textTheme.labelSmall!.fontSize),
                  ),
                ],
              ),
              const SizedBox(height: 2),
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
              ],
              Text.rich(
                richNode(item, context),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
            Padding(
              padding: floor == 2
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(left: 12, right: 12),
              child: picWidget(item, context),
            ),
          ],
        );
      // 视频
      case 'DYNAMIC_TYPE_AV':
        return videoSeasonWidget(item, context, 'archive', floor: floor);
      // 文章
      case 'DYNAMIC_TYPE_ARTICLE':
        return articlePanel(item, context, floor: floor);
      // 转发
      case 'DYNAMIC_TYPE_FORWARD':
        return Container(
          padding:
              const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 8),
          color: Theme.of(context).dividerColor.withOpacity(0.08),
          child: forWard(item.orig, context, floor: 2),
        );
      // 直播
      case 'DYNAMIC_TYPE_LIVE_RCMD':
        return liveRcmdPanel(item, context, floor: floor);
      // 合集
      case 'DYNAMIC_TYPE_UGC_SEASON':
        return videoSeasonWidget(item, context, 'ugcSeason');
      case 'DYNAMIC_TYPE_WORD':
        return floor == 2
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          '@${item.modules.moduleAuthor.name}',
                          style: authorStyle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        Utils.dateFormat(item.modules.moduleAuthor.pubTs),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .fontSize),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(item.modules.moduleDynamic.desc.text)
                ],
              )
            : const SizedBox(height: 0);
      case 'DYNAMIC_TYPE_PGC':
        return videoSeasonWidget(item, context, 'pgc', floor: floor);
      case 'DYNAMIC_TYPE_NONE':
        return Row(
          children: [
            const Icon(
              FontAwesomeIcons.ghost,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(item.modules.moduleDynamic.major.none.tips)
          ],
        );
      default:
        return const SizedBox(height: 0);
    }
  }

  // 视频or合集
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
                onTap: () {},
                child: Text(
                  '@${item.modules.moduleAuthor.name}',
                  style: authorStyle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                Utils.dateFormat(item.modules.moduleAuthor.pubTs),
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
        GestureDetector(
          onTap: () {},
          child: LayoutBuilder(builder: (context, box) {
            double width = box.maxWidth;
            return Stack(
              children: [
                NetworkImgLayer(
                  type: floor == 1 ? 'emote' : null,
                  width: width,
                  height: width / StyleString.aspectRatio,
                  src: content.cover,
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
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .fontSize,
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
        ),
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
}
