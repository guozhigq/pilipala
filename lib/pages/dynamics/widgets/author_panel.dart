import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/utils.dart';

Widget author(item, context) {
  String heroTag = Utils.makeHeroTag(item.modules.moduleAuthor.mid);
  return Row(
    children: [
      GestureDetector(
        onTap: () {
          feedBack();
          Get.toNamed(
            '/member?mid=${item.modules.moduleAuthor.mid}',
            arguments: {
              'face': item.modules.moduleAuthor.face,
              'heroTag': heroTag
            },
          );
        },
        child: Hero(
          tag: heroTag,
          child: NetworkImgLayer(
            width: 40,
            height: 40,
            type: 'avatar',
            src: item.modules.moduleAuthor.face,
          ),
        ),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.modules.moduleAuthor.name,
            style: TextStyle(
              color: item.modules.moduleAuthor!.vip!['status'] > 0
                  ? const Color.fromARGB(255, 251, 100, 163)
                  : Theme.of(context).colorScheme.onBackground,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
          ),
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
  );
}
