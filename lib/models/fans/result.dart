class FansDataModel {
  FansDataModel({
    this.total,
    this.list,
  });

  int? total;
  List<FansItemModel>? list;

  FansDataModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    list = json['list']
        .map<FansItemModel>((e) => FansItemModel.fromJson(e))
        .toList();
  }
}

class FansItemModel {
  FansItemModel({
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

  FansItemModel.fromJson(Map<String, dynamic> json) {
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
