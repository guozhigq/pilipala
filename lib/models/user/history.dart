class HistoryData {
  HistoryData({
    this.cursor,
    this.tab,
    this.list,
  });

  Cursor? cursor;
  List<HisTabItem>? tab;
  List<HisListItem>? list;

  HistoryData.fromJson(Map<String, dynamic> json) {
    cursor = Cursor.fromJson(json['cursor']);
    tab = json['tab'].map<HisTabItem>((e) => HisTabItem.fromJson(e)).toList();
    list =
        json['list'].map<HisListItem>((e) => HisListItem.fromJson(e)).toList();
  }
}

class Cursor {
  Cursor({
    this.max,
    this.viewAt,
    this.business,
    this.ps,
  });

  int? max;
  int? viewAt;
  String? business;
  int? ps;

  Cursor.fromJson(Map<String, dynamic> json) {
    max = json['max'];
    viewAt = json['view_at'];
    business = json['business'];
    ps = json['ps'];
  }
}

class HisTabItem {
  HisTabItem({
    this.type,
    this.name,
  });

  String? type;
  String? name;

  HisTabItem.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
  }
}

class HisListItem {
  HisListItem({
    this.title,
    this.longTitle,
    this.cover,
    this.pic,
    this.covers,
    this.uri,
    this.history,
    this.videos,
    this.authorName,
    this.authorFace,
    this.authorMid,
    this.viewAt,
    this.progress,
    this.badge,
    this.showTitle,
    this.duration,
    this.current,
    this.total,
    this.newDesc,
    this.isFinish,
    this.isFav,
    this.kid,
    this.tagName,
    this.liveStatus,
  });

  String? title;
  String? longTitle;
  String? cover;
  String? pic;
  List? covers;
  String? uri;
  History? history;
  int? videos;
  String? authorName;
  String? authorFace;
  int? authorMid;
  int? viewAt;
  int? progress;
  String? badge;
  String? showTitle;
  int? duration;
  String? current;
  int? total;
  String? newDesc;
  int? isFinish;
  int? isFav;
  int? kid;
  String? tagName;
  int? liveStatus;

  HisListItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    longTitle = json['long_title'];
    cover = json['cover'];
    pic = json['cover'] ?? '';
    covers = json['covers'] ?? [];
    uri = json['uri'];
    history = History.fromJson(json['history']);
    videos = json['videos'];
    authorName = json['author_name'];
    authorFace = json['author_face'];
    authorMid = json['author_mid'];
    viewAt = json['view_at'];
    progress = json['progress'];
    badge = json['badge'];
    showTitle = json['show_title'];
    duration = json['duration'];
    current = json['current'];
    total = json['total'];
    newDesc = json['new_desc'];
    isFinish = json['is_finish'];
    isFav = json['is_fav'];
    kid = json['kid'];
    tagName = json['tag_name'];
    liveStatus = json['live_status'];
  }
}

class History {
  History({
    this.oid,
    this.epid,
    this.bvid,
    this.page,
    this.cid,
    this.part,
    this.business,
    this.dt,
  });

  int? oid;
  int? epid;
  String? bvid;
  int? page;
  int? cid;
  String? part;
  String? business;
  int? dt;

  History.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    epid = json['epid'];
    bvid = json['bvid'] == '' ? null : json['bvid'];
    page = json['page'];
    cid = json['cid'] == 0 ? null : json['cid'];
    part = json['part'];
    business = json['business'];
    dt = json['dt'];
  }
}
