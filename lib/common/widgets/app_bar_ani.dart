import 'package:flutter/material.dart';

class AppBarAni extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAni({
    required this.child,
    required this.controller,
    required this.visible,
    this.position,
    Key? key,
  }) : super(key: key);

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;
  final String? position;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0, position! == 'top' ? -1 : 1),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      )),
      child: Container(
        decoration: BoxDecoration(
          gradient: position! == 'top'
              ? const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black45,
                  ],
                  tileMode: TileMode.clamp,
                )
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black45,
                  ],
                  tileMode: TileMode.mirror,
                ),
        ),
        child: child,
      ),
    );
  }
}
