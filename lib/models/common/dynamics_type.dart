enum DynamicsType {
  all,
  video,
  pgc,
  article,
}

extension BusinessTypeExtension on DynamicsType {
  String get values => ['all', 'video', 'pgc', 'article'][index];
  String get labels => ['全部', '投稿', '番剧', '专栏'][index];
}
