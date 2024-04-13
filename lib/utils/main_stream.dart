import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../pages/home/index.dart';
import '../pages/main/index.dart';

void handleScrollEvent(
  ScrollController scrollController,
  // StreamController<bool> mainStream,
  // StreamController<bool>? searchBarStream,
) {
  StreamController<bool> mainStream =
      Get.find<MainController>().bottomBarStream;
  StreamController<bool> searchBarStream =
      Get.find<HomeController>().searchBarStream;
  EasyThrottle.throttle(
    'stream-throttler',
    const Duration(milliseconds: 300),
    () {
      final ScrollDirection direction =
          scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.forward) {
        mainStream.add(true);
        searchBarStream.add(true);
      } else if (direction == ScrollDirection.reverse) {
        mainStream.add(false);
        searchBarStream.add(false);
      }
    },
  );
}
