// 操作类型的枚举值：点赞 不喜欢 收藏 投币 稍后再看 下载封面 后台播放 听视频 分享 下载视频
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ActionType {
  like,
  coin,
  collect,
  watchLater,
  share,
  dislike,
  downloadCover,
  copyLink,
  threeAction,
  // backgroundPlay,
  // listenVideo,
  // downloadVideo,
}

extension ActionTypeExtension on ActionType {
  String get value => [
        'like',
        'coin',
        'collect',
        'watchLater',
        'share',
        'dislike',
        'downloadCover',
        'copyLink',
        // 'backgroundPlay',
        // 'listenVideo',
        // 'downloadVideo',
      ][index];
  String get label => [
        '点赞视频',
        '投币',
        '收藏视频',
        '稍后再看',
        '视频分享',
        '不喜欢',
        '下载封面',
        '复制链接',
        // '后台播放',
        // '听视频',
        // '下载视频',
      ][index];
}

List<Map> actionMenuConfig = [
  {
    'icon': const Icon(Icons.thumb_up_alt_outlined),
    'label': '点赞视频',
    'value': ActionType.like,
  },
  {
    'icon': Image.asset(
      'assets/images/coin.png',
      width: 26,
      color: IconTheme.of(Get.context!).color!.withOpacity(0.65),
    ),
    'label': '投币',
    'value': ActionType.coin,
  },
  {
    'icon': const Icon(Icons.star_border),
    'label': '收藏视频',
    'value': ActionType.collect,
  },
  {
    'icon': const Icon(Icons.watch_later_outlined),
    'label': '稍后再看',
    'value': ActionType.watchLater,
  },
  {
    'icon': const Icon(Icons.share),
    'label': '视频分享',
    'value': ActionType.share,
  },
  {
    'icon': const Icon(Icons.thumb_down_alt_outlined),
    'label': '不喜欢',
    'value': ActionType.dislike,
  },
  {
    'icon': const Icon(Icons.image_outlined),
    'label': '下载封面',
    'value': ActionType.downloadCover,
  },
  {
    'icon': const Icon(Icons.link_outlined),
    'label': '复制链接',
    'value': ActionType.copyLink,
  },
];
