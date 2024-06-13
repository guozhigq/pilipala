import 'package:flutter/material.dart';

class ToolbarIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final String toolbarType;
  final bool selected;

  const ToolbarIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.toolbarType,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        highlightColor: Theme.of(context).colorScheme.secondaryContainer,
        color: selected
            ? Theme.of(context).colorScheme.onSecondaryContainer
            : Theme.of(context).colorScheme.outline,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            return selected
                ? Theme.of(context).colorScheme.secondaryContainer
                : null;
          }),
        ),
      ),
    );
  }
}
