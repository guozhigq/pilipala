enum CommentRangeType {
  video,
  bangumi,
  // dynamic,
}

extension ActionTypeExtension on CommentRangeType {
  String get value => [
        'video',
        'bangumi',
        // 'dynamic',
      ][index];
  String get label => [
        '视频',
        '番剧',
        // '动态',
      ][index];
}
