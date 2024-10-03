import 'dart:convert';

class MessageSystemModel {
  int? id;
  int? cursor;
  int? type;
  String? title;
  dynamic content;
  Source? source;
  String? timeAt;
  int? cardType;
  String? cardBrief;
  String? cardMsgBrief;
  String? cardCover;
  String? cardStoryTitle;
  String? cardLink;
  String? mc;
  int? isStation;
  int? isSend;
  int? notifyCursor;

  MessageSystemModel({
    this.id,
    this.cursor,
    this.type,
    this.title,
    this.content,
    this.source,
    this.timeAt,
    this.cardType,
    this.cardBrief,
    this.cardMsgBrief,
    this.cardCover,
    this.cardStoryTitle,
    this.cardLink,
    this.mc,
    this.isStation,
    this.isSend,
    this.notifyCursor,
  });

  factory MessageSystemModel.fromJson(Map<String, dynamic> jsons) =>
      MessageSystemModel(
        id: jsons["id"],
        cursor: jsons["cursor"],
        type: jsons["type"],
        title: jsons["title"],
        content: isValidJson(jsons["content"])
            ? json.decode(jsons["content"])
            : jsons["content"],
        source: Source.fromJson(jsons["source"]),
        timeAt: jsons["time_at"],
        cardType: jsons["card_type"],
        cardBrief: jsons["card_brief"],
        cardMsgBrief: jsons["card_msg_brief"],
        cardCover: jsons["card_cover"],
        cardStoryTitle: jsons["card_story_title"],
        cardLink: jsons["card_link"],
        mc: jsons["mc"],
        isStation: jsons["is_station"],
        isSend: jsons["is_send"],
        notifyCursor: jsons["notify_cursor"],
      );
}

class Source {
  String? name;
  String? logo;

  Source({
    this.name,
    this.logo,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        name: json["name"],
        logo: json["logo"],
      );
}

bool isValidJson(String str) {
  try {
    json.decode(str);
  } catch (e) {
    return false;
  }
  return true;
}
