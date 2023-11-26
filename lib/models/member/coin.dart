class MemberCoinsDataModel {
  MemberCoinsDataModel({
    this.aid,
    this.bvid,
    this.cid,
    this.coins,
    this.copyright,
    this.ctime,
    this.desc,
    this.duration,
    this.owner,
    this.pic,
    this.pubLocation,
    this.pubdate,
    this.resourceType,
    this.state,
    this.subtitle,
    this.time,
    this.title,
    this.tname,
    this.videos,
    this.view,
    this.danmaku,
  });

  int? aid;
  String? bvid;
  int? cid;
  int? coins;
  int? copyright;
  int? ctime;
  String? desc;
  int? duration;
  Owner? owner;
  String? pic;
  String? pubLocation;
  int? pubdate;
  String? resourceType;
  int? state;
  String? subtitle;
  int? time;
  String? title;
  String? tname;
  int? videos;
  int? view;
  int? danmaku;

  MemberCoinsDataModel.fromJson(Map<String, dynamic> json) {
    aid = json['aid'];
    bvid = json['bvid'];
    cid = json['cid'];
    coins = json['coins'];
    copyright = json['copyright'];
    ctime = json['ctime'];
    desc = json['desc'];
    duration = json['duration'];
    owner = Owner.fromJson(json['owner']);
    pic = json['pic'];
    pubLocation = json['pub_location'];
    pubdate = json['pubdate'];
    resourceType = json['resource_type'];
    state = json['state'];
    subtitle = json['subtitle'];
    time = json['time'];
    title = json['title'];
    tname = json['tname'];
    videos = json['videos'];
    view = json['stat']['view'];
    danmaku = json['stat']['danmaku'];
  }
}

class Owner {
  Owner({
    this.mid,
    this.name,
    this.face,
  });

  int? mid;
  String? name;
  String? face;

  Owner.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    name = json['name'];
    face = json['face'];
  }
}
