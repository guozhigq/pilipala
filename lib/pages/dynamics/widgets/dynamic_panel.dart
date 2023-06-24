import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/models/dynamics/result.dart';

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
                        ? ' - ${item.modules.moduleAuthor.pubAction}'
                        : ''),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
              )
            ],
          )
        ],
      ),
    );
  }

  // 内容
  Widget content(item, context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      child: Text(
        item!.modules!.moduleDynamic!.desc!.text!,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // 转发
  Widget forWard(item, context, {floor = 1}) {
    switch (item.type) {
      // 图文
      case 'DYNAMIC_TYPE_DRAW':
        return Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: picWidget(item, context),
        );
      // 视频
      case 'DYNAMIC_TYPE_AV':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (floor == 2) ...[
              Text('@' + item.modules.moduleAuthor.name),
              const SizedBox(height: 8),
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
                      src: item.modules.moduleDynamic.major.archive.cover,
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 22, 10, 15),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.transparent,
                                  Colors.black87,
                                ],
                                tileMode: TileMode.mirror,
                              ),
                              borderRadius: floor == 1
                                  ? null
                                  : const BorderRadius.all(Radius.circular(6))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.modules.moduleDynamic.major.archive
                                        .durationText,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .fontSize,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    item.modules.moduleDynamic.major.archive
                                        .stat.play,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .fontSize,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    item.modules.moduleDynamic.major.archive
                                        .stat.danmaku,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .fontSize,
                                        color: Colors.white),
                                  )
                                ],
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
                item.modules.moduleDynamic.major.archive.title,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
          ],
        );
      // 文章
      case 'DYNAMIC_TYPE_ARTICLE':
        return const Text('DYNAMIC_TYPE_ARTICLE');
      // 转发
      case 'DYNAMIC_TYPE_FORWARD':
        // return const Text('DYNAMIC_TYPE_FORWARD');
        switch (item.orig.type) {
          // 递归
          case 'DYNAMIC_TYPE_AV':
            return Container(
              padding: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 10),
              color: Theme.of(context).dividerColor.withOpacity(0.08),
              child: forWard(item.orig, context, floor: 2),
            );
          default:
            return const Text('渲染出错了');
        }
      // 直播
      case 'DYNAMIC_TYPE_LIVE_RCMD':
        return const Text('DYNAMIC_TYPE_LIVE_RCMD');
      // 合集
      case 'DYNAMIC_TYPE_UGC_SEASON':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (floor == 2) ...[
            //   Text('@' + item.modules.moduleAuthor.name),
            //   const SizedBox(height: 8),
            // ],
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
                      src: item.modules.moduleDynamic.major.ugcSeason.cover,
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 22, 10, 15),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Colors.transparent,
                                  Colors.black87,
                                ],
                                tileMode: TileMode.mirror,
                              ),
                              borderRadius: floor == 1
                                  ? null
                                  : const BorderRadius.all(Radius.circular(6))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.modules.moduleDynamic.major.ugcSeason
                                        .durationText,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .fontSize,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    item.modules.moduleDynamic.major.ugcSeason
                                        .stat.play,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .fontSize,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    item.modules.moduleDynamic.major.ugcSeason
                                        .stat.danmaku,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .fontSize,
                                        color: Colors.white),
                                  )
                                ],
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
                item.modules.moduleDynamic.major.ugcSeason.title,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
          ],
        );
      default:
        return const Text('渲染出错了');
    }
  }

  // 操作栏
  Widget action(item, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.shareFromSquare,
            size: 16,
          ),
          label: const Text('转发'),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.comment,
            size: 16,
          ),
          label: Text(item.modules.moduleStat.comment.count),
        ),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(
            FontAwesomeIcons.thumbsUp,
            size: 16,
          ),
          label: Text(item.modules.moduleStat.like.count),
        )
      ],
    );
  }

  Widget picWidget(item, context) {
    List pictures = item.modules.moduleDynamic.major.draw.items;
    int len = pictures.length;
    List picList = [];

    List<Widget> list = [];
    for (var i = 0; i < len; i++) {
      picList.add(pictures[i].src);
      list.add(
        LayoutBuilder(
          builder: (context, BoxConstraints box) {
            return GestureDetector(
              onTap: () {
                Get.toNamed('/preview',
                    arguments: {'initialPage': i, 'imgList': picList});
              },
              child: NetworkImgLayer(
                src: pictures[i].src,
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
}
