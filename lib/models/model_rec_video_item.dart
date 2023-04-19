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
    rcmdReason = json["rcmd_reason"] != null
        ? RcmdReason.fromJson(json["rcmd_reason"])
        : RcmdReason(content: '');
  }
}

class Stat {
  Stat({
    this.view,
    this.like,
    this.danmaku,
  });

  int? view;
  int? like;
  int? danmaku;

  Stat.fromJson(Map<String, dynamic> json) {
    view = json["view"];
    like = json["like"];
    danmaku = json['danmaku'];
  }
}

class RcmdReason {
  RcmdReason({
    this.reasonType,
    this.content,
  });

  int? reasonType;
  String? content = '';

  RcmdReason.fromJson(Map<String, dynamic> json) {
    reasonType = json["reason_type"];
    content = json["content"] ?? '';
  }
}
