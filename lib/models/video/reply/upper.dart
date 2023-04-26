import 'item.dart';

class ReplyUpper {
  ReplyUpper({
    this.mid,
    this.top,
  });

  int? mid;
  ReplyItemModel? top;

  ReplyUpper.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    top = json['top'] != null
        ? ReplyItemModel.fromJson(json['top'], json['mid'])
        : ReplyItemModel();
  }
}
