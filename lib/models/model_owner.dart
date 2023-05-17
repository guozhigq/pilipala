import 'package:hive/hive.dart';

part 'model_owner.g.dart';

@HiveType(typeId: 3)
class Owner {
  Owner({
    this.mid,
    this.name,
    this.face,
  });
  @HiveField(0)
  int? mid;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? face;

  Owner.fromJson(Map<String, dynamic> json) {
    mid = json["mid"];
    name = json["name"];
    face = json['face'];
  }
}
