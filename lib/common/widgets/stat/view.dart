import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/utils/utils.dart';

class StatView extends StatelessWidget {
  final String? theme;
  final int? view;
  final String? size;

  const StatView({Key? key, this.theme, this.view, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Color> colorObject = {
      'white': Colors.white,
      'gray': Theme.of(context).colorScheme.outline,
      'black': Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
    };
    Color color = colorObject[theme]!;
    return Row(
      children: [
        Icon(
          // CupertinoIcons.play_rectangle,
          Icons.play_circle_fill_outlined,
          size: 13,
          color: color,
        ),
        const SizedBox(width: 3),
        Text(
          Utils.numFormat(view!),
          style: TextStyle(
            fontSize: size == 'medium' ? 12 : 11,
            color: color,
          ),
        ),
      ],
    );
  }
}
