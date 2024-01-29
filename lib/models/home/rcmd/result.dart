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

  int? id;
  int? aid;
  String? bvid;
  int? cid;
  String? pic;
  RcmdStat? stat;
  String? duration;
  String? title;
  int? isFollowed;
  RcmdOwner? owner;
  RcmdReason? rcmdReason;
  String? goto;
  int? param;
  String? uri;
  String? talkBack;
  // 番剧
  String? bangumiView;
  String? bangumiFollow;
  String? bangumiBadge;

  String? cardType;
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

class RcmdStat {
  RcmdStat({
    this.view,
    this.like,
    this.danmu,
  });
  String? view;
  String? like;
  String? danmu;

  RcmdStat.fromJson(Map<String, dynamic> json) {
    view = json["cover_left_text_1"];
    danmu = json['cover_left_text_2'] ?? '-';
  }
}

class RcmdOwner {
  RcmdOwner({this.name, this.mid});

  String? name;
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

class RcmdReason {
  RcmdReason({
    this.content,
  });

  String? content;

  RcmdReason.fromJson(Map<String, dynamic> json) {
    content = json["text"] ?? '';
  }
}
