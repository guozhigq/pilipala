import './model_owner.dart';

class HotVideoItemModel {
  HotVideoItemModel({
    this.aid,
    this.cid,
    this.bvid,
    this.videos,
    this.tid,
    this.tname,
    this.copyright,
    this.pic,
    this.title,
    this.pubdate,
    this.ctime,
    this.desc,
    this.state,
    this.duration,
    this.middionId,
    this.owner,
    this.stat,
    this.vDynamic,
    this.dimension,
    this.shortLinkV2,
    this.firstFrame,
    this.pubLocation,
    this.seasontype,
    this.isOgv,
    this.rcmdReason,
  });

  int? aid;
  int? cid;
  String? bvid;
  int? videos;
  int? tid;
  String? tname;
  int? copyright;
  String? pic;
  String? title;
  int? pubdate;
  int? ctime;
  String? desc;
  int? state;
  int? duration;
  int? middionId;
  Owner? owner;
  Stat? stat;
  String? vDynamic;
  Dimension? dimension;
  String? shortLinkV2;
  String? firstFrame;
  String? pubLocation;
  int? seasontype;
  bool? isOgv;
  RcmdReason? rcmdReason;

  HotVideoItemModel.fromJson(Map<String, dynamic> json) {
    aid = json["aid"];
    cid = json["cid"];
    bvid = json["bvid"];
    videos = json["videos"];
    tid = json["tid"];
    tname = json["tname"];
    copyright = json["copyright"];
    pic = json["pic"];
    title = json["title"];
    pubdate = json["pubdate"];
    ctime = json["ctime"];
    desc = json["desc"];
    state = json["state"];
    duration = json["duration"];
    middionId = json["middion_id"];
    owner = Owner.fromJson(json["owner"]);
    stat = Stat.fromJson(json['stat']);
    vDynamic = json["vDynamic"];
    dimension = Dimension.fromMap(json['dimension']);
    shortLinkV2 = json["short_link_v2"];
    firstFrame = json["first_frame"];
    pubLocation = json["pub_location"];
    seasontype = json["seasontype"];
    isOgv = json["isOgv"];
    rcmdReason = json['rcmd_reason'] != ''
        ? RcmdReason.fromJson(json['rcmd_reason'])
        : null;
  }
}

class Stat {
  Stat({
    this.aid,
    this.view,
    this.danmaku,
    this.reply,
    this.favorite,
    this.coin,
    this.share,
    this.nowRank,
    this.hisRank,
    this.like,
    this.dislike,
    this.vt,
    this.vv,
  });

  int? aid;
  int? view;
  int? danmaku;
  int? reply;
  int? favorite;
  int? coin;
  int? share;
  int? nowRank;
  int? hisRank;
  int? like;
  int? dislike;
  int? vt;
  int? vv;

  Stat.fromJson(Map<String, dynamic> json) {
    aid = json["aid"];
    view = json["view"];
    danmaku = json['danmaku'];
    reply = json["reply"];
    favorite = json["favorite"];
    coin = json['coin'];
    share = json["share"];
    nowRank = json["now_rank"];
    hisRank = json['his_rank'];
    like = json["like"];
    dislike = json["dislike"];
    vt = json['vt'];
    vv = json["vv"];
  }
}

class Dimension {
  Dimension({this.width, this.height, this.rotate});

  int? width;
  int? height;
  int? rotate;

  Dimension.fromMap(Map<String, dynamic> json) {
    width = json["width"];
    height = json["height"];
    rotate = json["rotate"];
  }
}

class RcmdReason {
  RcmdReason({
    this.rcornerMark,
    this.content,
  });

  int? rcornerMark;
  String? content = '';

  RcmdReason.fromJson(Map<String, dynamic> json) {
    rcornerMark = json["corner_mark"];
    content = json["content"] ?? '';
  }
}
