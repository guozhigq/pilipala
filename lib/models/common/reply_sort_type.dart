enum ReplySortType { time, like, reply }

extension ReplySortTypeExtension on ReplySortType {
  String get titles => ['最新评论', '最热评论', '回复最多'][index];
  String get labels => ['最新', '最热', '最多回复'][index];
}
