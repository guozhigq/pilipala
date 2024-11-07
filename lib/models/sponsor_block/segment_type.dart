// 片段类型枚举
// ignore_for_file: constant_identifier_names

enum SegmentType {
  sponsor,
  intro,
  outro,
  interaction,
  selfpromo,
  music_offtopic,
  preview,
  poi_highlight,
  filler,
  exclusive_access,
  chapter,
}

extension SegmentTypeExtension on SegmentType {
  String get value => [
        'sponsor',
        'intro',
        'outro',
        'interaction',
        'selfpromo',
        'music_offtopic',
        'preview',
        'poi_highlight',
        'filler',
        'exclusive_access',
        'chapter',
      ][index];

  String get name => [
        '赞助',
        '开场介绍',
        '片尾致谢',
        '互动',
        '自我推广',
        '音乐',
        '预览',
        '亮点',
        '无效填充',
        '独家访问',
        '章节',
      ][index];
}
