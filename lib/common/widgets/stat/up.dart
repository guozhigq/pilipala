import 'package:flutter/material.dart';

class UpTag extends StatelessWidget {
  const UpTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 10,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Theme.of(context).colorScheme.outline)),
      margin: const EdgeInsets.only(right: 4),
      child: Center(
        child: Text(
          'UP',
          style: TextStyle(
              fontSize: 6, color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }
}
