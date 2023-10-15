class AccountListModel {
  AccountListModel({
    this.mid,
    this.name,
    this.sex,
    this.face,
    this.sign,
    this.rank,
    this.level,
    this.silence,
    this.vip,
    this.pendant,
    this.nameplate,
    this.official,
    this.birthday,
    this.isFakeAccount,
    this.isDeleted,
    this.inRegAudit,
    this.faceNft,
    this.faceNftNew,
    this.isSeniorMember,
    this.digitalId,
    this.digitalType,
    this.attestation,
    this.expertInfo,
    this.honours,
  });

  int? mid;
  String? name;
  String? sex;
  String? face;
  String? sign;
  int? rank;
  int? level;
  int? silence;
  Map? vip;
  Map? pendant;
  Map? nameplate;
  Map? official;
  int? birthday;
  int? isFakeAccount;
  int? isDeleted;
  int? inRegAudit;
  int? faceNft;
  int? faceNftNew;
  int? isSeniorMember;
  String? digitalId;
  int? digitalType;
  Map? attestation;
  Map? expertInfo;
  Map? honours;

  AccountListModel.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    name = json['name'] ?? '';
    sex = json['sex'];
    face = json['face'];
    sign = json['sign'];
    rank = json['rank'];
    level = json['level'];
    silence = json['silence'];
    vip = json['vip'];
    pendant = json['pendant'];
    nameplate = json['nameplate'];
    official = json['official'];
    birthday = json['birthday'];
    isFakeAccount = json['is_fake_account'];
    isDeleted = json['is_deleted'];
    inRegAudit = json['in_reg_audit'];
    faceNft = json['face_nft'];
    faceNftNew = json['face_nft_new'];
    isSeniorMember = json['is_senior_member'];
    digitalId = json['digital_id'];
    digitalType = json['digital_type'];
    attestation = json['attestation'];
    expertInfo = json['expert_info'];
    honours = json['honours'];
  }
}
