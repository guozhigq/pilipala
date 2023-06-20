import 'package:hive/hive.dart';

part 'hot.g.dart';

@HiveType(typeId: 6)
class HotSearchModel {
  HotSearchModel({
    this.list,
  });

  @HiveField(0)
  List<HotSearchItem>? list;

  HotSearchModel.fromJson(Map<String, dynamic> json) {
    list = json['list']
        .map<HotSearchItem>((e) => HotSearchItem.fromJson(e))
        .toList();
  }
}

@HiveType(typeId: 7)
class HotSearchItem {
  HotSearchItem({
    this.keyword,
    this.showName,
    this.wordType,
    this.icon,
  });

  @HiveField(0)
  String? keyword;
  @HiveField(1)
  String? showName;
  // 4/5热 11话题 8普通 7直播
  @HiveField(2)
  int? wordType;
  @HiveField(3)
  String? icon;

  HotSearchItem.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    showName = json['show_name'];
    wordType = json['word_type'];
    icon = json['icon'];
  }
}
