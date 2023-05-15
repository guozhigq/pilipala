class ReplyPage {
  ReplyPage({
    this.num,
    this.size,
    this.count,
    this.acount,
  });

  int? num;
  int? size;
  int? count;
  int? acount;

  ReplyPage.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    size = json['size'];
    count = json['count'];
    acount = json['acount'];
  }
}
