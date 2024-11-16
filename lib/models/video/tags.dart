class VideoTagItem {
  String? tagName;
  int? tagId;
  int? tagType;

  VideoTagItem({
    this.tagName,
    this.tagId,
    this.tagType,
  });

  VideoTagItem.fromJson(Map<String, dynamic> json) {
    tagName = json['tag_name'];
    tagId = json['tag_id'];
    tagType = json['type'];
  }
}
