enum DynamicsType {
  all,
  video,
  pgc,
  article,
}

extension BusinessTypeExtension on DynamicsType {
  String get values => ['all', 'video', 'pgc', 'article'][index];
  String get labels => ['全部', '视频', '追番', '专栏'][index];
}
