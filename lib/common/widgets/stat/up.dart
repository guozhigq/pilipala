import 'package:flutter/material.dart';

class UpTag extends StatelessWidget {
  final String? tagText;
  const UpTag({super.key, this.tagText = 'UP'});
  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: tagText == 'UP' ? primary : null,
          border: Border.all(color: primary)),
      margin: const EdgeInsets.only(right: 5),
      child: Center(
        child: Text(
          tagText!,
          style: TextStyle(
            fontSize: 9,
            color: tagText == 'UP'
                ? Theme.of(context).colorScheme.onPrimary
                : primary,
          ),
        ),
      ),
    );
  }
}
