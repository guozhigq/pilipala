class ReplyConfig {
  ReplyConfig({
    this.showtopic,
    this.showUpFlag,
    this.readOnly,
  });

  int? showtopic;
  bool? showUpFlag;
  bool? readOnly;

  ReplyConfig.fromJson(Map<String, dynamic> json) {
    showtopic = json['showtopic'];
    showUpFlag = json['show_up_flag'];
    readOnly = json['read_only'];
  }
}
