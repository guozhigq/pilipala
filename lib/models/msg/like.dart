class MessageLikeModel {
  MessageLikeModel({
    this.latest,
    this.total,
  });

  Latest? latest;
  Total? total;

  factory MessageLikeModel.fromJson(Map<String, dynamic> json) =>
      MessageLikeModel(
        latest: json["latest"] == null ? null : Latest.fromJson(json["latest"]),
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
      );
}

class Latest {
  Latest({
    this.items,
    this.lastViewAt,
  });

  List? items;
  int? lastViewAt;

  factory Latest.fromJson(Map<String, dynamic> json) => Latest(
        items: json["items"],
        lastViewAt: json["last_view_at"],
      );
}

class Total {
  Total({
    this.cursor,
    this.items,
  });

  Cursor? cursor;
  List<MessageLikeItem>? items;

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        cursor: Cursor.fromJson(json['cursor']),
        items: json["items"] == null
            ? []
            : json["items"].map<MessageLikeItem>((e) {
                return MessageLikeItem.fromJson(e);
              }).toList(),
      );
}

class Cursor {
  Cursor({
    this.id,
    this.isEnd,
    this.time,
  });

  int? id;
  bool? isEnd;
  int? time;

  factory Cursor.fromJson(Map<String, dynamic> json) => Cursor(
        id: json['id'],
        isEnd: json['is_end'],
        time: json['time'],
      );
}

class MessageLikeItem {
  MessageLikeItem({
    this.id,
    this.users,
    this.item,
    this.counts,
    this.likeTime,
    this.noticeState,
    this.isExpand = false,
  });

  int? id;
  List<MessageLikeUser>? users;
  MessageLikeItemItem? item;
  int? counts;
  int? likeTime;
  int? noticeState;
  bool isExpand;

  factory MessageLikeItem.fromJson(Map<String, dynamic> json) =>
      MessageLikeItem(
        id: json["id"],
        users: json["users"] == null
            ? []
            : json["users"].map<MessageLikeUser>((e) {
                return MessageLikeUser.fromJson(e);
              }).toList(),
        item: json["item"] == null
            ? null
            : MessageLikeItemItem.fromJson(json["item"]),
        counts: json["counts"],
        likeTime: json["like_time"],
        noticeState: json["notice_state"],
      );
}

class MessageLikeUser {
  MessageLikeUser({
    this.mid,
    this.fans,
    this.nickname,
    this.avatar,
    this.midLink,
    this.follow,
  });

  int? mid;
  int? fans;
  String? nickname;
  String? avatar;
  String? midLink;
  bool? follow;

  factory MessageLikeUser.fromJson(Map<String, dynamic> json) =>
      MessageLikeUser(
        mid: json["mid"],
        fans: json["fans"],
        nickname: json["nickname"],
        avatar: json["avatar"],
        midLink: json["mid_link"],
        follow: json["follow"],
      );
}

class MessageLikeItemItem {
  MessageLikeItemItem({
    this.itemId,
    this.pid,
    this.type,
    this.business,
    this.businessId,
    this.replyBusinessId,
    this.likeBusinessId,
    this.title,
    this.desc,
    this.image,
    this.uri,
    this.detailName,
    this.nativeUri,
    this.ctime,
  });

  int? itemId;
  int? pid;
  String? type;
  String? business;
  int? businessId;
  int? replyBusinessId;
  int? likeBusinessId;
  String? title;
  String? desc;
  String? image;
  String? uri;
  String? detailName;
  String? nativeUri;
  int? ctime;

  factory MessageLikeItemItem.fromJson(Map<String, dynamic> json) =>
      MessageLikeItemItem(
        itemId: json["item_id"],
        pid: json["pid"],
        type: json["type"],
        business: json["business"],
        businessId: json["business_id"],
        replyBusinessId: json["reply_business_id"],
        likeBusinessId: json["like_business_id"],
        title: json["title"],
        desc: json["desc"],
        image: json["image"],
        uri: json["uri"],
        detailName: json["detail_name"],
        nativeUri: json["native_uri"],
        ctime: json["ctime"],
      );
}
