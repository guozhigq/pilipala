import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

Widget author(item, context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            print('个人主页');
          },
          child: NetworkImgLayer(
            width: 40,
            height: 40,
            type: 'avatar',
            src: item.modules.moduleAuthor.face,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.modules.moduleAuthor.name,
              style: TextStyle(
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
    ),
  );
}
