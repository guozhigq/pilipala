import 'package:flutter/material.dart';

const defaultNavigationBars = [
  {
    'id': 0,
    'icon': Icon(
      Icons.home_outlined,
      size: 21,
    ),
    'selectIcon': Icon(
      Icons.home,
      size: 21,
    ),
    'label': "首页",
    'count': 0,
  },
  {
    'id': 1,
    'icon': Icon(
      Icons.motion_photos_on_outlined,
      size: 21,
    ),
    'selectIcon': Icon(
      Icons.motion_photos_on,
      size: 21,
    ),
    'label': "动态",
    'count': 0,
  },
  {
    'id': 2,
    'icon': Icon(
      Icons.video_collection_outlined,
      size: 20,
    ),
    'selectIcon': Icon(
      Icons.video_collection,
      size: 21,
    ),
    'label': "媒体库",
    'count': 0,
  }
];
