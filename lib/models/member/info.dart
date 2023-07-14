class MemberInfoModel {
  MemberInfoModel({
    this.mid,
    this.name,
    this.sex,
    this.face,
    this.sign,
    this.level,
    this.isFollowed,
  });

  int? mid;
  String? name;
  String? sex;
  String? face;
  String? sign;
  int? level;
  bool? isFollowed;

  MemberInfoModel.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    name = json['name'];
    sex = json['sex'];
    face = json['face'];
    sign = json['sign'];
    level = json['level'];
    isFollowed = json['is_followed'];
  }
}
