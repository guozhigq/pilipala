import 'package:flutter/material.dart';

class PlPopupRoute extends PopupRoute<void> {
  PlPopupRoute({
    this.backgroudColor,
    this.alignment = Alignment.center,
    required this.child,
    this.onClick,
  });

  /// backgroudColor
  final Color? backgroudColor;

  /// child'alignment, default value: [Alignment.center]
  final Alignment alignment;

  /// child
  final Widget child;

  /// backgroudView action
  final Function? onClick;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return child;
  }
}
