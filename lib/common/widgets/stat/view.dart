import 'package:flutter/material.dart';
import 'package:pilipala/utils/utils.dart';

class StatView extends StatelessWidget {
  final String? theme;
  final int? view;
  final String? size;

  const StatView({Key? key, this.theme, this.view, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/view_$theme.png',
          width: size == 'medium' ? 16 : 14,
          height: size == 'medium' ? 16 : 14,
        ),
        const SizedBox(width: 2),
        Text(
          Utils.numFormat(view!),
          // videoItem['stat']['view'].toString(),
          style: TextStyle(
            fontSize: size == 'medium' ? 12 : 11,
            color: theme == 'white'
                ? Colors.white
                : Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
