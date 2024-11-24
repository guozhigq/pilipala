class LiveFollowingModel {
  int? count;
  List<LiveFollowingItemModel>? list;
  int? liveCount;
  int? neverLivedCount;
  List? neverLivedFaces;
  int? pageSize;
  String? title;
  int? totalPage;

  LiveFollowingModel({
    this.count,
    this.list,
    this.liveCount,
    this.neverLivedCount,
    this.neverLivedFaces,
    this.pageSize,
    this.title,
    this.totalPage,
  });

  LiveFollowingModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['list'] != null) {
      list = <LiveFollowingItemModel>[];
      json['list'].forEach((v) {
        list!.add(LiveFollowingItemModel.fromJson(v));
      });
    }
    liveCount = json['live_count'];
    neverLivedCount = json['never_lived_count'];
    if (json['never_lived_faces'] != null) {
      neverLivedFaces = <dynamic>[];
      json['never_lived_faces'].forEach((v) {
        neverLivedFaces!.add(v);
      });
    }
    pageSize = json['pageSize'];
    title = json['title'];
    totalPage = json['totalPage'];
  }
}

class LiveFollowingItemModel {
  int? roomId;
  int? uid;
  String? uname;
  String? title;
  String? face;
  int? liveStatus;
  int? recordNum;
  String? recentRecordId;
  int? isAttention;
  int? clipNum;
  int? fansNum;
  String? areaName;
  String? areaValue;
  String? tags;
  String? recentRecordIdV2;
  int? recordNumV2;
  int? recordLiveTime;
  String? areaNameV2;
  String? roomNews;
  String? watchIcon;
  String? textSmall;
  String? cover;
  String? pic;
  int? parentAreaId;
  int? areaId;

  LiveFollowingItemModel({
    this.roomId,
    this.uid,
    this.uname,
    this.title,
    this.face,
    this.liveStatus,
    this.recordNum,
    this.recentRecordId,
    this.isAttention,
    this.clipNum,
    this.fansNum,
    this.areaName,
    this.areaValue,
    this.tags,
    this.recentRecordIdV2,
    this.recordNumV2,
    this.recordLiveTime,
    this.areaNameV2,
    this.roomNews,
    this.watchIcon,
    this.textSmall,
    this.cover,
    this.pic,
    this.parentAreaId,
    this.areaId,
  });

  LiveFollowingItemModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomid'];
    uid = json['uid'];
    uname = json['uname'];
    title = json['title'];
    face = json['face'];
    liveStatus = json['live_status'];
    recordNum = json['record_num'];
    recentRecordId = json['recent_record_id'];
    isAttention = json['is_attention'];
    clipNum = json['clipnum'];
    fansNum = json['fans_num'];
    areaName =
        json['area_name'] == '' ? json['area_name_v2'] : json['area_name'];
    areaValue = json['area_value'];
    tags = json['tags'];
    recentRecordIdV2 = json['recent_record_id_v2'];
    recordNumV2 = json['record_num_v2'];
    recordLiveTime = json['record_live_time'];
    areaNameV2 = json['area_name_v2'];
    roomNews = json['room_news'];
    watchIcon = json['watch_icon'];
    textSmall = json['text_small'];
    cover = json['room_cover'];
    pic = json['room_cover'];
    parentAreaId = json['parent_area_id'];
    areaId = json['area_id'];
  }
}
