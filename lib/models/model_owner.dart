class Owner {
  Owner({
    this.mid,
    this.name,
    this.face,
  });

  int? mid;
  String? name;
  String? face;

  Owner.fromJson(Map<String, dynamic> json) {
    mid = json["mid"];
    name = json["name"];
    face = json['face'];
  }
}
