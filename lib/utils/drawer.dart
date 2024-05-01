import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class DrawerUtils {
  static void showRightDialog({
    required Widget child,
    double width = 400,
    bool useSystem = false,
  }) {
    SmartDialog.show(
      alignment: Alignment.topRight,
      animationBuilder: (controller, child, animationParam) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(controller.view),
          child: child,
        );
      },
      useSystem: useSystem,
      maskColor: Colors.black.withOpacity(0.5),
      animationTime: const Duration(milliseconds: 200),
      builder: (context) => Container(
        width: width,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.zero),
            child: child,
          ),
        ),
      ),
    );
  }
}
