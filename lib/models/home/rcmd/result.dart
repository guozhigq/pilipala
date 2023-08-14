import 'package:hive/hive.dart';

part 'result.g.dart';

@HiveType(typeId: 0)
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
    this.goto,
    this.param,
    this.uri,
    this.talkBack,
    this.bangumiView,
    this.bangumiFollow,
    this.bangumiBadge,
    this.cardType,
    this.adInfo,
  });

  @HiveField(0)
  int? id;
  @HiveField(1)
  int? aid;
  @HiveField(2)
  String? bvid;
  @HiveField(3)
  int? cid;
  @HiveField(4)
  String? pic;
  @HiveField(5)
  RcmdStat? stat;
  @HiveField(6)
  String? duration;
  @HiveField(7)
  String? title;
  @HiveField(8)
  int? isFollowed;
  @HiveField(9)
  RcmdOwner? owner;
  @HiveField(10)
  RcmdReason? rcmdReason;
  @HiveField(11)
  String? goto;
  @HiveField(12)
  int? param;
  @HiveField(13)
  String? uri;
  @HiveField(14)
  String? talkBack;
  // 番剧
  @HiveField(15)
  String? bangumiView;
  @HiveField(16)
  String? bangumiFollow;
  @HiveField(17)
  String? bangumiBadge;

  @HiveField(18)
  String? cardType;
  @HiveField(19)
  Map? adInfo;

  RecVideoItemAppModel.fromJson(Map<String, dynamic> json) {
    id = json['player_args'] != null
        ? json['player_args']['aid']
        : int.parse(json['param'] ?? '-1');
    aid = json['player_args'] != null ? json['player_args']['aid'] : -1;
    bvid = null;
    cid = json['player_args'] != null ? json['player_args']['cid'] : -1;
    pic = json['cover'];
    stat = RcmdStat.fromJson(json);
    duration = json['cover_right_text'];
    title = json['title'];
    isFollowed = 0;
    owner = RcmdOwner.fromJson(json);
    rcmdReason = json['rcmd_reason_style'] != null
        ? RcmdReason.fromJson(json['rcmd_reason_style'])
        : null;
    goto = json['goto'];
    param = int.parse(json['param']);
    uri = json['uri'];
    talkBack = json['talk_back'];

    if (json['goto'] == 'bangumi') {
      bangumiView = json['cover_left_text_1'];
      bangumiFollow = json['cover_left_text_2'];
      bangumiBadge = json['badge'];
    }

    cardType = json['card_type'];
    adInfo = json['ad_info'];
  }
}

@HiveType(typeId: 1)
class RcmdStat {
  RcmdStat({
    this.view,
    this.like,
    this.danmu,
  });
  @HiveField(0)
  String? view;
  @HiveField(1)
  String? like;
  @HiveField(2)
  String? danmu;

  RcmdStat.fromJson(Map<String, dynamic> json) {
    view = json["cover_left_text_1"];
    danmu = json['cover_left_text_2'];
  }
}

@HiveType(typeId: 2)
class RcmdOwner {
  RcmdOwner({this.name, this.mid});

  @HiveField(0)
  String? name;
  @HiveField(1)
  int? mid;

  RcmdOwner.fromJson(Map<String, dynamic> json) {
    name = json['goto'] == 'av'
        ? json['args']['up_name']
        : json['desc_button'] != null
            ? json['desc_button']['text']
            : '';
    mid = json['args']['up_id'] ?? -1;
  }
}

@HiveType(typeId: 8)
class RcmdReason {
  RcmdReason({
    this.content,
  });

  @HiveField(0)
  String? content;

  RcmdReason.fromJson(Map<String, dynamic> json) {
    content = json["text"] ?? '';
  }
}
