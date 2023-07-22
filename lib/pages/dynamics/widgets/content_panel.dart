// 内容
import 'package:flutter/material.dart';

import 'rich_node_panel.dart';

Widget content(item, context, source) {
  TextStyle authorStyle =
      TextStyle(color: Theme.of(context).colorScheme.primary);
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
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
        IgnorePointer(
          // 禁用SelectableRegion的触摸交互功能
          ignoring: source == 'detail' ? false : true,
          child: SelectableRegion(
            magnifierConfiguration: const TextMagnifierConfiguration(),
            focusNode: FocusNode(),
            selectionControls: MaterialTextSelectionControls(),
            child: Text.rich(
              richNode(item, context),
              maxLines: source == 'detail' ? 999 : 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ),
  );
}
