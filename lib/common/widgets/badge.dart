import 'package:flutter/material.dart';

Widget pBadge(
  text,
  context,
  double? top,
  double? right,
  double? bottom,
  double? left, {
  type = 'primary',
}) {
  Color bgColor = Theme.of(context).colorScheme.primary;
  Color color = Theme.of(context).colorScheme.onPrimary;
  if (type == 'gray') {
    bgColor = Colors.black54.withOpacity(0.4);
    color = Colors.white;
  }
  return Positioned(
    top: top,
    left: left,
    right: right,
    bottom: bottom,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(4), color: bgColor),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, color: color),
      ),
    ),
  );
}
