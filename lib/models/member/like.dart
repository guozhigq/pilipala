class MemberLikeDataModel {
  MemberLikeDataModel({
    this.aid,
    this.videos,
    this.tid,
    this.tname,
    this.pic,
    this.title,
    this.pubdate,
    this.ctime,
    this.desc,
    this.state,
    this.duration,
    this.redirectUrl,
    this.rights,
    this.owner,
    this.stat,
    this.dimension,
    this.cover43,
    this.bvid,
    this.interVideo,
    this.resourceType,
    this.subtitle,
    this.enableVt,
  });

  final int? aid;
  final int? videos;
  final int? tid;
  final String? tname;
  final String? pic;
  final String? title;
  final int? pubdate;
  final int? ctime;
  final String? desc;
  final int? state;
  final int? duration;
  final String? redirectUrl;
  final Rights? rights;
  final Owner? owner;
  final Stat? stat;
  final Dimension? dimension;
  final String? cover43;
  final String? bvid;
  final bool? interVideo;
  final String? resourceType;
  final String? subtitle;
  final int? enableVt;

  factory MemberLikeDataModel.fromJson(Map<String, dynamic> json) =>
      MemberLikeDataModel(
        aid: json["aid"],
        videos: json["videos"],
        tid: json["tid"],
        tname: json["tname"],
        pic: json["pic"],
        title: json["title"],
        pubdate: json["pubdate"],
        ctime: json["ctime"],
        desc: json["desc"],
        state: json["state"],
        duration: json["duration"],
        redirectUrl: json["redirect_url"],
        rights: Rights.fromJson(json["rights"]),
        owner: Owner.fromJson(json["owner"]),
        stat: Stat.fromJson(json["stat"]),
        dimension: Dimension.fromJson(json["dimension"]),
        cover43: json["cover43"],
        bvid: json["bvid"],
        interVideo: json["inter_video"],
        resourceType: json["resource_type"],
        subtitle: json["subtitle"],
        enableVt: json["enable_vt"],
      );
}

class Dimension {
  Dimension({
    required this.width,
    required this.height,
    required this.rotate,
  });

  final int width;
  final int height;
  final int rotate;

  factory Dimension.fromJson(Map<String, dynamic> json) => Dimension(
        width: json["width"],
        height: json["height"],
        rotate: json["rotate"],
      );
}

class Owner {
  Owner({
    required this.mid,
    required this.name,
    required this.face,
  });

  final int mid;
  final String name;
  final String face;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        mid: json["mid"],
        name: json["name"],
        face: json["face"],
      );
}

class Rights {
  Rights({
    required this.bp,
    required this.elec,
    required this.download,
    required this.movie,
    required this.pay,
    required this.hd5,
    required this.noReprint,
    required this.autoplay,
    required this.ugcPay,
    required this.isCooperation,
    required this.ugcPayPreview,
    required this.noBackground,
    required this.arcPay,
    required this.payFreeWatch,
  });

  final int bp;
  final int elec;
  final int download;
  final int movie;
  final int pay;
  final int hd5;
  final int noReprint;
  final int autoplay;
  final int ugcPay;
  final int isCooperation;
  final int ugcPayPreview;
  final int noBackground;
  final int arcPay;
  final int payFreeWatch;

  factory Rights.fromJson(Map<String, dynamic> json) => Rights(
        bp: json["bp"],
        elec: json["elec"],
        download: json["download"],
        movie: json["movie"],
        pay: json["pay"],
        hd5: json["hd5"],
        noReprint: json["no_reprint"],
        autoplay: json["autoplay"],
        ugcPay: json["ugc_pay"],
        isCooperation: json["is_cooperation"],
        ugcPayPreview: json["ugc_pay_preview"],
        noBackground: json["no_background"],
        arcPay: json["arc_pay"],
        payFreeWatch: json["pay_free_watch"],
      );
}

class Stat {
  Stat({
    required this.aid,
    required this.view,
    required this.danmaku,
    required this.reply,
    required this.favorite,
    required this.coin,
    required this.share,
    required this.nowRank,
    required this.hisRank,
    required this.like,
    required this.dislike,
    required this.vt,
    required this.vv,
  });

  final int aid;
  final int view;
  final int danmaku;
  final int reply;
  final int favorite;
  final int coin;
  final int share;
  final int nowRank;
  final int hisRank;
  final int like;
  final int dislike;
  final int vt;
  final int vv;

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        aid: json["aid"],
        view: json["view"],
        danmaku: json["danmaku"],
        reply: json["reply"],
        favorite: json["favorite"],
        coin: json["coin"],
        share: json["share"],
        nowRank: json["now_rank"],
        hisRank: json["his_rank"],
        like: json["like"],
        dislike: json["dislike"],
        vt: json["vt"],
        vv: json["vv"],
      );
}
