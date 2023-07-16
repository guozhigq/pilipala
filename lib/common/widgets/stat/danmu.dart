import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/utils/utils.dart';

class StatDanMu extends StatelessWidget {
  final String? theme;
  final int? danmu;
  final String? size;

  const StatDanMu({Key? key, this.theme, this.danmu, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color =
        theme == 'white' ? Colors.white : Theme.of(context).colorScheme.outline;
    return Row(
      children: [
        Icon(
          // CupertinoIcons.ellipses_bubble,
          Icons.subtitles_outlined,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 3),
        Text(
          Utils.numFormat(danmu!),
          style: TextStyle(
            fontSize: size == 'medium' ? 12 : 11,
            color: color,
          ),
        )
      ],
    );
  }
}
