enum DynamicsType {
  all,
  video,
  pgc,
  article,
}

extension BusinessTypeExtension on DynamicsType {
  String get values => ['all', 'video', 'pgc', 'article'][index];
  String get labels => ['全部', '视频投稿', '追番追剧', '专栏'][index];
}
