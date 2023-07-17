class RecVideoItemAppModel {
  RecVideoItemAppModel({
    this.id,
    this.aid,
    this.bvid,
    this.cid,
    this.pic,
    this.stat,
    this.duration,
    this.title,
    this.isFollowed,
    this.owner,
    this.rcmdReason,
  });

  int? id;
  int? aid;
  int? bvid;
  int? cid;
  String? pic;
  Stat? stat;
  int? duration;
  String? title;
  int? isFollowed;
  Owner? owner;
  String? rcmdReason;

  RecVideoItemAppModel.fromJson(Map<String, dynamic> json) {
    id = json['player_args']['aid'];
    aid = json['player_args']['aid'];
    cid = json['player_args']['cid'];
    pic = json['cover'];
    stat = Stat.fromJson(json);
    duration = json['player_args']['duration'];
    title = json['title'];
    isFollowed = 0;
    owner = Owner.fromJson(json);
  }
}

class Stat {
  Stat({
    this.view,
    this.like,
    this.danmaku,
  });
  String? view;
  String? like;
  String? danmaku;

  Stat.fromJson(Map<String, dynamic> json) {
    view = json["cover_left_text_1"];
    danmaku = json['cover_left_text_2'];
  }
}

class Owner {
  Owner({this.name});

  String? name;

  Owner.fromJson(Map<String, dynamic> json) {
    name = json['args']['up_name'];
  }
}
