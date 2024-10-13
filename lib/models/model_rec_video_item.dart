import './model_owner.dart';

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

  int? id = -1;
  String? bvid = '';
  int? cid = -1;
  String? goto = '';
  String? uri = '';
  String? pic = '';
  String? title = '';
  int? duration = -1;
  int? pubdate = -1;
  Owner? owner;
  Stat? stat;
  int? isFollowed;
  String? rcmdReason;

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
    rcmdReason = json["rcmd_reason"]?['content'];
  }
}

class Stat {
  Stat({
    this.view,
    this.like,
    this.danmu,
  });

  int? view;
  int? like;
  int? danmu;
  Stat.fromJson(Map<String, dynamic> json) {
    // 无需在model中转换以保留原始数据，在view层处理即可
    view = json["view"];
    like = json["like"];
    danmu = json['danmaku'];
  }
}
