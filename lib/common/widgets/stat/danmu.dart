import 'package:flutter/material.dart';
import 'package:pilipala/utils/utils.dart';

class StatDanMu extends StatelessWidget {
  final String? theme;
  final dynamic danmu;
  final String? size;

  const StatDanMu({Key? key, this.theme = 'gray', this.danmu, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, Color> colorObject = {
      'white': Colors.white,
      'gray': Theme.of(context).colorScheme.outline,
      'black': Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
    };
    Color color = colorObject[theme]!;
    return StatIconText(
      icon: Icons.subtitles_outlined,
      text: Utils.numFormat(danmu!),
      color: color,
      size: size,
    );
  }
}

class StatIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final String? size;

  const StatIconText({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: TextStyle(
            fontSize: size == 'medium' ? 12 : 11,
            color: color,
          ),
        ),
      ],
    );
  }
}
