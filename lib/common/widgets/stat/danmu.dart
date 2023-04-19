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
    return Row(
      children: [
        Image.asset(
          'assets/images/dm_$theme.png',
          width: size == 'medium' ? 16 : 14,
          height: size == 'medium' ? 16 : 14,
        ),
        const SizedBox(width: 2),
        Text(
          Utils.numFormat(danmu!),
          style: TextStyle(
            fontSize: size == 'medium' ? 12 : 11,
            color: theme == 'white'
                ? Colors.white
                : Theme.of(context).colorScheme.outline,
          ),
        )
      ],
    );
  }
}
