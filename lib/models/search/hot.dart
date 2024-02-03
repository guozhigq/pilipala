class HotSearchModel {
  HotSearchModel({
    this.list,
  });

  List<HotSearchItem>? list;

  HotSearchModel.fromJson(Map<String, dynamic> json) {
    list = json['list']
        .map<HotSearchItem>((e) => HotSearchItem.fromJson(e))
        .toList();
  }
}

class HotSearchItem {
  HotSearchItem({
    this.keyword,
    this.showName,
    this.wordType,
    this.icon,
  });

  String? keyword;
  String? showName;
  // 4/5热 11话题 8普通 7直播
  int? wordType;
  String? icon;
  List? liveId;

  HotSearchItem.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    showName = json['show_name'];
    wordType = json['word_type'];
    icon = json['icon'];
    liveId = json['live_id'];
    liveId = json['live_id'];
  }
}
