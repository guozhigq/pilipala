import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/utils.dart';

Widget searchMbangumiPanel(BuildContext context, ctr, list) {
  return ListView.builder(
    controller: ctr!.scrollController,
    addAutomaticKeepAlives: false,
    addRepaintBoundaries: false,
    itemCount: list!.length,
    itemBuilder: (context, index) {
      var i = list![index];
      return InkWell(
        onTap: () {
          Get.toNamed('/video?bvid=${i.bvid}&cid=${i.cid}',
              arguments: {'videoItem': i, 'heroTag': Utils.makeHeroTag(i.id)});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkImgLayer(
                width: 111,
                height: 148,
                src: i.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        children: [
                          WidgetSpan(child: UpTag(type: i.mediaType)),
                          for (var i in i.title) ...[
                            TextSpan(
                              text: i['text'],
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .fontSize,
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
                    Text('评分:${i.mediaScore['score'].toString()}'),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(i.areas),
                        const SizedBox(width: 3),
                        const Text('·'),
                        const SizedBox(width: 3),
                        Text(Utils.dateFormat(i.pubtime).toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Text(i.styles),
                        const SizedBox(width: 3),
                        const Text('·'),
                        const SizedBox(width: 3),
                        Text(i.indexShow),
                        const SizedBox(width: 3),
                      ],
                    ),
                    // Text('声优：${i.cv}'),
                    const SizedBox(height: 6),
                    Text(i.desc, overflow: TextOverflow.ellipsis, maxLines: 2),
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

class UpTag extends StatelessWidget {
  int? type;
  UpTag({super.key, this.type = 4});
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return Container(
      width: 24,
      height: 16,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(3), color: primary),
      margin: const EdgeInsets.only(right: 4),
      child: Center(
        child: Text(
          type == 1 ? '番剧' : '国创',
          style: TextStyle(
            fontSize: 9,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
