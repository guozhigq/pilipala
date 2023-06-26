import 'package:flutter/material.dart';
import 'package:pilipala/utils/utils.dart';

import 'pic_panel.dart';

Widget articlePanel(item, context, {floor = 1}) {
  TextStyle authorStyle =
      TextStyle(color: Theme.of(context).colorScheme.primary);
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
                    fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
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
        if (item.modules.moduleDynamic.major.opus.summary.text != 'undefined')
          Text(
            item.modules.moduleDynamic.major.opus.summary.richTextNodes.first
                .text,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        picWidget(item, context)
      ],
    ),
  );
}
