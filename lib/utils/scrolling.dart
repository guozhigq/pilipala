import 'package:flutter/material.dart';

class ScrollingUtils {
  static Future<void> navigateToTop(
      ScrollController scrollController, double screenHeight) async {
    if (scrollController.offset >= screenHeight * 5) {
      scrollController.jumpTo(0);
    } else {
      await scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }
}
