class FollowDataModel {
  FollowDataModel({
    this.total,
    this.list,
  });

  int? total;
  List<FollowItemModel>? list;

  FollowDataModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    list = json['list']
        .map<FollowItemModel>((e) => FollowItemModel.fromJson(e))
        .toList();
  }
}

class FollowItemModel {
  FollowItemModel({
    this.mid,
    this.attribute,
    this.mtime,
    this.tag,
    this.special,
    this.uname,
    this.face,
    this.sign,
    this.officialVerify,
  });

  int? mid;
  int? attribute;
  int? mtime;
  List? tag;
  int? special;
  String? uname;
  String? face;
  String? sign;
  Map? officialVerify;

  FollowItemModel.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    attribute = json['attribute'];
    mtime = json['mtime'];
    tag = json['tag'];
    special = json['special'];
    uname = json['uname'];
    face = json['face'];
    sign = json['sign'] == '' ? '还没有签名' : json['sign'];
    officialVerify = json['official_verify'];
  }
}
