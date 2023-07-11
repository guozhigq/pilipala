class LiveItemModel {
  LiveItemModel({
    this.roomId,
    this.uid,
    this.title,
    this.uname,
    this.online,
    this.userCover,
    this.userCoverFlag,
    this.systemCover,
    this.cover,
    this.pic,
    this.link,
    this.face,
    this.parentId,
    this.parentName,
    this.areaId,
    this.areaName,
    this.sessionId,
    this.groupId,
    this.pkId,
    this.verify,
    this.headBox,
    this.headBoxType,
    this.watchedShow,
  });

  int? roomId;
  int? uid;
  String? title;
  String? uname;
  int? online;
  String? userCover;
  int? userCoverFlag;
  String? systemCover;
  String? cover;
  String? pic;
  String? link;
  String? face;
  int? parentId;
  String? parentName;
  int? areaId;
  String? areaName;
  String? sessionId;
  int? groupId;
  int? pkId;
  Map? verify;
  Map? headBox;
  int? headBoxType;
  Map? watchedShow;

  LiveItemModel.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    uid = json['uid'];
    title = json['title'];
    uname = json['uname'];
    online = json['online'];
    userCover = json['user_cover'];
    userCoverFlag = json['user_cover_flag'];
    systemCover = json['system_cover'];
    cover = json['cover'];
    pic = json['cover'];
    link = json['link'];
    face = json['face'];
    parentId = json['parent_id'];
    parentName = json['parent_name'];
    areaId = json['area_id'];
    areaName = json['area_name'];
    sessionId = json['session_id'];
    groupId = json['group_id'];
    pkId = json['pk_id'];
    verify = json['verify'];
    headBox = json['head_box'];
    headBoxType = json['head_box_type'];
    watchedShow = json['watched_show'];
  }
}
