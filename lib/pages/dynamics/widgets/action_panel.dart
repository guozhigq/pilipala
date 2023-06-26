// 操作栏
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pilipala/models/dynamics/result.dart';

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
