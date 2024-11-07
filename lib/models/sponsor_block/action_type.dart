// 片段类型枚举
enum ActionType {
  skip,
  mute,
  full,
  poi,
  chapter,
}

extension ActionTypeExtension on ActionType {
  String get value => [
        'skip',
        'mute',
        'full',
        'poi',
        'chapter',
      ][index];

  String get name => [
        '跳过',
        '静音',
        '完整观看',
        '亮点',
        '章节切换',
      ][index];
}
