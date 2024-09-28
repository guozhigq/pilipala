class SubTitileContentModel {
  double? from;
  double? to;
  int? location;
  String? content;

  SubTitileContentModel({
    this.from,
    this.to,
    this.location,
    this.content,
  });

  SubTitileContentModel.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
    location = json['location'];
    content = json['content'];
  }
}
