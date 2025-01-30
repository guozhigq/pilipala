import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../pages/main/index.dart';

void handleScrollEvent(ScrollController scrollController) {
  StreamController<bool> mainStream =
      Get.find<MainController>().bottomBarStream;
  EasyThrottle.throttle(
    'stream-throttler',
    const Duration(milliseconds: 300),
    () {
      try {
        final ScrollDirection direction =
            scrollController.position.userScrollDirection;
        if (direction == ScrollDirection.forward) {
          mainStream.add(true);
        } else if (direction == ScrollDirection.reverse) {
          mainStream.add(false);
        }
      } catch (_) {}
    },
  );
}
