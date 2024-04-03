import './model_owner.dart';
import 'package:hive/hive.dart';

part 'model_rec_video_item.g.dart';

@HiveType(typeId: 0)
class RecVideoItemModel {
  RecVideoItemModel({
    this.id,
    this.bvid,
    this.cid,
    this.goto,
    this.uri,
    this.pic,
    this.title,
    this.duration,
    this.pubdate,
    this.owner,
    this.stat,
    this.isFollowed,
    this.rcmdReason,
  });

  @HiveField(0)
  int? id = -1;
  @HiveField(1)
  String? bvid = '';
  @HiveField(2)
  int? cid = -1;
  @HiveField(3)
  String? goto = '';
  @HiveField(4)
  String? uri = '';
  @HiveField(5)
  String? pic = '';
  @HiveField(6)
  String? title = '';
  @HiveField(7)
  int? duration = -1;
  @HiveField(8)
  int? pubdate = -1;
  @HiveField(9)
  Owner? owner;
  @HiveField(10)
  Stat? stat;
  @HiveField(11)
  int? isFollowed;
  @HiveField(12)
  RcmdReason? rcmdReason;

  RecVideoItemModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    bvid = json["bvid"];
    cid = json["cid"];
    goto = json["goto"];
    uri = json["uri"];
    pic = json["pic"];
    title = json["title"];
    duration = json["duration"];
    pubdate = json["pubdate"];
    owner = Owner.fromJson(json["owner"]);
    stat = Stat.fromJson(json["stat"]);
    isFollowed = json["is_followed"] ?? 0;
    rcmdReason = json["rcmd_reason"] != null
        ? RcmdReason.fromJson(json["rcmd_reason"])
        : RcmdReason(content: '');
  }
}

@HiveType(typeId: 1)
class Stat {
  Stat({
    this.view,
    this.like,
    this.danmu,
  });
  @HiveField(0)
  int? view;
  @HiveField(1)
  int? like;
  @HiveField(2)
  int? danmu;

  Stat.fromJson(Map<String, dynamic> json) {
    // 无需在model中转换以保留原始数据，在view层处理即可
    view = json["view"];
    like = json["like"];
    danmu = json['danmaku'];
  }
}

@HiveType(typeId: 2)
class RcmdReason {
  RcmdReason({
    this.reasonType,
    this.content,
  });
  @HiveField(0)
  int? reasonType;
  @HiveField(1)
  String? content = '';

  RcmdReason.fromJson(Map<String, dynamic> json) {
    reasonType = json["reason_type"];
    content = json["content"] ?? '';
  }
}
