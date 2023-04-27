class ReplyContent {
  ReplyContent({
    this.message,
    this.atNameToMid, // @的用户的mid null
    this.memebers, // 被@的用户List 如果有的话 []
    this.emote, // 表情包 如果有的话 null
    this.jumpUrl, // {}
    this.pictures, // {}
  });

  String? message;
  Map? atNameToMid;
  List? memebers;
  Map? emote;
  Map? jumpUrl;
  List? pictures;

  ReplyContent.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    atNameToMid = json['at_name_to_mid'] ?? {};
    memebers = json['memebers'] ?? [];
    emote = json['emote'] ?? {};
    jumpUrl = json['jump_url'] ?? {};
    pictures = json['pictures'] ?? [];
  }
}
