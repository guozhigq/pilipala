import 'package:flutter/material.dart';
import 'package:pilipala/pages/rank/zone/index.dart';

enum RandType {
  all,
  animation,
  music,
  dance,
  game,
  knowledge,
  technology,
  sport,
  car,
  food,
  animal,
  madness,
  fashion,
  entertainment,
  film
}

extension RankTypeDesc on RandType {
  String get description => [
        '全站',
        '动画',
        '音乐',
        '舞蹈',
        '游戏',
        '知识',
        '科技',
        '运动',
        '汽车',
        '美食',
        '动物圈',
        '鬼畜',
        '时尚',
        '娱乐',
        '影视'
      ][index];

  String get id => [
        'all',
        'animation',
        'music',
        'dance',
        'game',
        'knowledge',
        'technology',
        'sport',
        'car',
        'food',
        'animal',
        'madness',
        'fashion',
        'entertainment',
        'film'
      ][index];
}

List tabsConfig = [
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '全站',
    'type': RandType.all,
    'page': const ZonePage(rid: 0),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '动画',
    'type': RandType.animation,
    'page': const ZonePage(rid: 1005),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '音乐',
    'type': RandType.music,
    'page': const ZonePage(rid: 1003),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '舞蹈',
    'type': RandType.dance,
    'page': const ZonePage(rid: 1004),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '游戏',
    'type': RandType.game,
    'page': const ZonePage(rid: 1008),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '知识',
    'type': RandType.knowledge,
    'page': const ZonePage(rid: 1010),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '科技',
    'type': RandType.technology,
    'page': const ZonePage(rid: 1012),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '运动',
    'type': RandType.sport,
    'page': const ZonePage(rid: 1018),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '汽车',
    'type': RandType.car,
    'page': const ZonePage(rid: 1013),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '美食',
    'type': RandType.food,
    'page': const ZonePage(rid: 1020),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '动物圈',
    'type': RandType.animal,
    'page': const ZonePage(rid: 1024),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '鬼畜',
    'type': RandType.madness,
    'page': const ZonePage(rid: 1007),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '时尚',
    'type': RandType.fashion,
    'page': const ZonePage(rid: 1014),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '娱乐',
    'type': RandType.entertainment,
    'page': const ZonePage(rid: 1002),
  },
  {
    'icon': const Icon(
      Icons.live_tv_outlined,
      size: 15,
    ),
    'label': '影视',
    'type': RandType.film,
    'page': const ZonePage(rid: 1001),
  }
];
