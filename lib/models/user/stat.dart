class UserStat {
  UserStat({
    this.following,
    this.follower,
    this.dynamicCount,
  });

  int? following;
  int? follower;
  int? dynamicCount;

  UserStat.fromJson(Map<String, dynamic> json) {
    following = json['following'];
    follower = json['follower'];
    dynamicCount = json['dynamic_count'];
  }
}
