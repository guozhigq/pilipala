import 'package:hive/hive.dart';

part 'stat.g.dart';

@HiveType(typeId: 1)
class UserStat {
  UserStat({
    this.following,
    this.follower,
    this.dynamicCount,
  });

  @HiveField(0)
  int? following;
  @HiveField(1)
  int? follower;
  @HiveField(2)
  int? dynamicCount;

  UserStat.fromJson(Map<String, dynamic> json) {
    following = json['following'];
    follower = json['follower'];
    dynamicCount = json['dynamic_count'];
  }
}
