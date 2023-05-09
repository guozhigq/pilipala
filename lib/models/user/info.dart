class UserInfoData {
  UserInfoData({
    this.isLogin,
    this.emailVerified,
    this.face,
    this.levelInfo,
    this.mid,
    this.mobileVerified,
    this.money,
    this.moral,
    this.official,
    this.officialVerify,
    this.pendant,
    this.scores,
    this.uname,
    this.vipDueDate,
    this.vipStatus,
    this.vipType,
    this.vipPayType,
    this.vipThemeType,
    this.vipLabel,
    this.vipAvatarSub,
    this.vipNicknameColor,
    this.wallet,
    this.hasShop,
    this.shopUrl,
  });

  bool? isLogin;
  int? emailVerified;
  String? face;
  Map? levelInfo;
  int? mid;
  int? mobileVerified;
  int? money;
  int? moral;
  Map? official;
  Map? officialVerify;
  Map? pendant;
  int? scores;
  String? uname;
  int? vipDueDate;
  int? vipStatus;
  int? vipType;
  int? vipPayType;
  int? vipThemeType;
  Map? vipLabel;
  int? vipAvatarSub;
  String? vipNicknameColor;
  Map? wallet;
  bool? hasShop;
  String? shopUrl;

  UserInfoData.fromJson(Map<String, dynamic> json) {
    isLogin = json['isLogin'] ?? false;
    emailVerified = json['email_verified'];
    face = json['face'];
    levelInfo = json['level_info'];
    mid = json['mid'];
    mobileVerified = json['mobile_verified'];
    money = json['money'];
    moral = json['moral'];
    official = json['official'];
    officialVerify = json['officialVerify'];
    pendant = json['pendant'];
    scores = json['scores'];
    uname = json['uname'];
    vipDueDate = json['vipDueDate'];
    vipStatus = json['vipStatus'];
    vipType = json['vipType'];
    vipPayType = json['vip_pay_type'];
    vipThemeType = json['vip_theme_type'];
    vipLabel = json['vip_label'];
    vipAvatarSub = json['vip_avatar_subscript'];
    vipNicknameColor = json['vip_nickname_color'];
    wallet = json['wallet'];
    hasShop = json['has_shop'];
    shopUrl = json['shop_url'];
  }
}
