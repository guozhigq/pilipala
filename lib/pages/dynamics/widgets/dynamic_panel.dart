import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/utils/utils.dart';

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
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
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
              Text(
                item.modules.moduleAuthor.pubTime +
                    (item.modules.moduleAuthor.pubAction != ''
                        ? '  ${item.modules.moduleAuthor.pubAction}'
                        : ''),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // 内容
  Widget content(item, context) {
    TextStyle authorStyle =
        TextStyle(color: Theme.of(context).colorScheme.primary);
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.modules.moduleDynamic.topic != null) ...[
              GestureDetector(
                child: Text(
                  '#${item.modules.moduleDynamic.topic.name}',
                  style: authorStyle,
                ),
              ),
            ],
            Text.rich(richNode(item, context)),
          ],
        ));
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
              Text(item.modules.moduleDynamic.desc.text),
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
        return Padding(
          padding: floor == 2
              ? EdgeInsets.zero
              : const EdgeInsets.only(left: 12, right: 12),
          child: Column(
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
                const SizedBox(height: 8),
              ],
              Text(
                item.modules.moduleDynamic.major.opus.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(item.modules.moduleDynamic.major.opus.summary.richTextNodes
                  .first.text),
              picWidget(item, context)
            ],
          ),
        );
      // 转发
      case 'DYNAMIC_TYPE_FORWARD':
        switch (item.orig.type) {
          // 递归
          case 'DYNAMIC_TYPE_AV':
            return Container(
              padding: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 10),
              color: Theme.of(context).dividerColor.withOpacity(0.08),
              child: forWard(item.orig, context, floor: 2),
            );
          case 'DYNAMIC_TYPE_DRAW':
            return Container(
              padding: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 10),
              color: Theme.of(context).dividerColor.withOpacity(0.08),
              child: forWard(item.orig, context, floor: 2),
            );
          case 'DYNAMIC_TYPE_WORD':
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 10),
              color: Theme.of(context).dividerColor.withOpacity(0.08),
              child: forWard(item.orig, context, floor: 2),
            );
          case 'DYNAMIC_TYPE_NONE':
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 10),
              color: Theme.of(context).dividerColor.withOpacity(0.08),
              child: forWard(item.orig, context, floor: 2),
            );
          case 'DYNAMIC_TYPE_ARTICLE':
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 10),
              color: Theme.of(context).dividerColor.withOpacity(0.08),
              child: forWard(item.orig, context, floor: 2),
            );
          default:
            return const Text('渲染出错了1');
        }
      // 直播
      case 'DYNAMIC_TYPE_LIVE_RCMD':
        return const Text('DYNAMIC_TYPE_LIVE_RCMD');
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

  // 操作栏
  Widget action(item, context) {
    ModuleStatModel stat = item.modules.moduleStat;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.shareFromSquare,
            size: 16,
          ),
          label: Text(stat.forward!.count ?? '转发'),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.comment,
            size: 16,
          ),
          label: Text(stat.comment!.count ?? '评论'),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.thumbsUp,
            size: 16,
          ),
          label: Text(stat.like!.count ?? '点赞'),
        )
      ],
    );
  }

  Widget picWidget(item, context) {
    String type = item.modules.moduleDynamic.major.type;
    List pictures = [];
    if (type == 'MAJOR_TYPE_OPUS') {
      pictures = item.modules.moduleDynamic.major.opus.pics;
    }
    if (type == 'MAJOR_TYPE_DRAW') {
      pictures = item.modules.moduleDynamic.major.draw.items;
    }
    int len = pictures.length;
    List picList = [];

    List<Widget> list = [];
    for (var i = 0; i < len; i++) {
      picList.add(pictures[i].src ?? pictures[i].url);
      list.add(
        LayoutBuilder(
          builder: (context, BoxConstraints box) {
            return GestureDetector(
              onTap: () {
                Get.toNamed('/preview',
                    arguments: {'initialPage': i, 'imgList': picList});
              },
              child: NetworkImgLayer(
                src: pictures[i].src ?? pictures[i].url,
                width: box.maxWidth,
                height: box.maxWidth,
              ),
            );
          },
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, BoxConstraints box) {
        double maxWidth = box.maxWidth;
        double crossCount = len < 3 ? 2 : 3;
        double height = maxWidth /
                crossCount *
                (len % crossCount == 0
                    ? len ~/ crossCount
                    : len ~/ crossCount + 1) +
            6;
        return Container(
          padding: const EdgeInsets.only(top: 6),
          height: height,
          child: GridView.count(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossCount.toInt(),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 1,
            children: list,
          ),
        );
      },
    );
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
    };
    dynamic content = dynamicProperty[type];

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
                    fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
              ),
            ],
          ),
        ],
        if (item.modules.moduleDynamic.topic != null) ...[
          const SizedBox(height: 4),
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
        const SizedBox(height: 6),
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
                              Colors.black87,
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
                                Text(content.durationText),
                                const SizedBox(width: 10),
                                Text(content.stat.play + '次围观'),
                                const SizedBox(width: 10),
                                Text(content.stat.danmaku + '条弹幕')
                              ],
                            ),
                          ),
                          Image.asset(
                            'assets/images/play.png',
                            width: 70,
                            height: 70,
                          ),
                        ],
                      ),
                    )),
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
        const SizedBox(height: 2),
      ],
    );
  }

  InlineSpan richNode(item, context) {
    TextStyle authorStyle =
        TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 13);
    List<InlineSpan> spanChilds = [];
    for (var i in item.modules.moduleDynamic.desc.richTextNodes) {
      if (i.type == 'RICH_TEXT_NODE_TYPE_TEXT') {
        spanChilds.add(TextSpan(text: i.origText));
      }
      if (i.type == 'RICH_TEXT_NODE_TYPE_AT') {
        spanChilds.add(
          WidgetSpan(
            baseline: TextBaseline.ideographic,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    '@${item.modules.moduleAuthor.name}',
                    style: authorStyle,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (i.type == 'RICH_TEXT_NODE_TYPE_TOPIC') {
        spanChilds.add(
          WidgetSpan(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                ' ${i.origText} ',
                style: authorStyle,
              ),
            ),
          ),
        );
      }
      if (i.type == 'RICH_TEXT_NODE_TYPE_WEB') {
        spanChilds.add(
          WidgetSpan(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                i.text,
                style: authorStyle,
              ),
            ),
          ),
        );
      }
      if (i.type == 'RICH_TEXT_NODE_TYPE_VOTE') {
        spanChilds.add(
          WidgetSpan(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                i.text,
                style: authorStyle,
              ),
            ),
          ),
        );
      }
      if (i.type == 'RICH_TEXT_NODE_TYPE_EMOJI') {
        spanChilds.add(
          WidgetSpan(
            child: NetworkImgLayer(
              src: i.emoji.iconUrl,
              type: 'emote',
              width: i.emoji.size * 20,
              height: i.emoji.size * 20,
            ),
          ),
        );
      }
    }
    return TextSpan(children: spanChilds);
  }
}
