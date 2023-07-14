class MemberInfoModel {
  MemberInfoModel({
    this.mid,
    this.name,
    this.sex,
    this.face,
    this.sign,
    this.level,
    this.isFollowed,
    this.topPhoto,
    this.official,
    this.vip,
  });

  int? mid;
  String? name;
  String? sex;
  String? face;
  String? sign;
  int? level;
  bool? isFollowed;
  String? topPhoto;
  Map? official;
  Vip? vip;
  LiveRoom? liveRoom;

  MemberInfoModel.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    name = json['name'];
    sex = json['sex'];
    face = json['face'];
    sign = json['sign'] == '' ? '该用户还没有签名' : json['sign'];
    level = json['level'];
    isFollowed = json['is_followed'];
    topPhoto = json['top_photo'];
    official = json['official'];
    vip = Vip.fromJson(json['vip']);
    liveRoom = LiveRoom.fromJson(json['live_room']);
  }
}

class Vip {
  Vip({
    this.type,
    this.status,
    this.dueDate,
    this.label,
  });

  int? type;
  int? status;
  int? dueDate;
  Map? label;

  Vip.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    status = json['status'];
    dueDate = json['due_date'];
    label = json['label'];
  }
}

class LiveRoom {
  LiveRoom({
    this.roomStatus,
    this.liveStatus,
    this.url,
    this.title,
    this.cover,
    this.roomId,
    this.roundStatus,
  });

  int? roomStatus;
  int? liveStatus;
  String? url;
  String? title;
  String? cover;
  int? roomId;
  int? roundStatus;

  LiveRoom.fromJson(Map<String, dynamic> json) {
    roomStatus = json['room_status'];
    liveStatus = json['live_status'];
    url = json['url'];
    title = json['title'];
    cover = json['cover'];
    roomId = json['room_id'];
    roundStatus = json['round_status'];
  }
}
