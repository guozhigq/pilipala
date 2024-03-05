import 'package:flutter/material.dart';

List defaultNavigationBars = [
  {
    'id': 0,
    'icon': const Icon(
      Icons.home_outlined,
      size: 21,
    ),
    'selectIcon': const Icon(
      Icons.home,
      size: 21,
    ),
    'label': "首页",
    'count': 0,
  },
  {
    'id': 1,
    'icon': const Icon(
      Icons.motion_photos_on_outlined,
      size: 21,
    ),
    'selectIcon': const Icon(
      Icons.motion_photos_on,
      size: 21,
    ),
    'label': "动态",
    'count': 0,
  },
  {
    'id': 2,
    'icon': const Icon(
      Icons.video_collection_outlined,
      size: 20,
    ),
    'selectIcon': const Icon(
      Icons.video_collection,
      size: 21,
    ),
    'label': "媒体库",
    'count': 0,
  }
];
