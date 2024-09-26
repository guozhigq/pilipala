import 'package:flutter/material.dart';
import 'package:pilipala/models/read/opus.dart';

class TextHelper {
  static Alignment getAlignment(int? align) {
    switch (align) {
      case 1:
        return Alignment.center;
      case 0:
        return Alignment.centerLeft;
      case 2:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }

  static TextSpan buildTextSpan(
      ModuleParagraphTextNode node, int? align, BuildContext context) {
    // 获取node的所有key
    if (node.nodeType != null) {
      return TextSpan(
        text: node.word?.words ?? '',
        style: TextStyle(
          fontSize:
              node.word?.fontSize != null ? node.word!.fontSize! * 0.95 : 14,
          fontWeight: node.word?.style?.bold != null
              ? FontWeight.bold
              : FontWeight.normal,
          height: align == 1 ? 2 : 1.5,
          color: node.word?.color != null
              ? Color(int.parse(node.word!.color!.substring(1, 7), radix: 16) +
                  0xFF000000)
              : Theme.of(context).colorScheme.onBackground,
        ),
      );
    } else {
      switch (node.type) {
        case 'TEXT_NODE_TYPE_WORD':
          return TextSpan(
            text: node.word?.words ?? '',
            style: TextStyle(
              fontSize: node.word?.fontSize != null
                  ? node.word!.fontSize! * 0.95
                  : 14,
              fontWeight: node.word?.style?.bold != null
                  ? FontWeight.bold
                  : FontWeight.normal,
              height: align == 1 ? 2 : 1.5,
              color: node.word?.color != null
                  ? Color(
                      int.parse(node.word!.color!.substring(1, 7), radix: 16) +
                          0xFF000000)
                  : Theme.of(context).colorScheme.onBackground,
            ),
          );
        default:
          return const TextSpan(text: '');
      }
    }
  }
}
