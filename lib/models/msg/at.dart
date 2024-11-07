class MessageAtModel {
  Cursor? cursor;
  List<MessageAtItems>? items;

  MessageAtModel({this.cursor, this.items});

  MessageAtModel.fromJson(Map<String, dynamic> json) {
    cursor = json['cursor'] != null ? Cursor.fromJson(json['cursor']) : null;
    if (json['items'] != null) {
      items = <MessageAtItems>[];
      json['items'].forEach((v) {
        items!.add(MessageAtItems.fromJson(v));
      });
    }
  }
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

  Cursor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isEnd = json['isEnd'];
    time = json['time'];
  }
}

class MessageAtItems {
  int? id;
  int? atTime;
  User? user;
  MessageAtItem? item;

  MessageAtItems({this.id, this.atTime, this.user, this.item});

  MessageAtItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    atTime = json['at_time'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    item = json['item'] != null ? MessageAtItem.fromJson(json['item']) : null;
  }
}

class MessageAtItem {
  String? type;
  String? business;
  int? businessId;
  String? title;
  String? image;
  String? uri;
  int? subjectId;
  int? rootId;
  int? targetId;
  int? sourceId;
  String? sourceContent;
  String? nativeUri;
  List<User>? atDetails;
  List<dynamic>? topicDetails;
  bool? hideReplyButton;

  MessageAtItem({
    this.type,
    this.business,
    this.businessId,
    this.title,
    this.image,
    this.uri,
    this.subjectId,
    this.rootId,
    this.targetId,
    this.sourceId,
    this.sourceContent,
    this.nativeUri,
    this.atDetails,
    this.topicDetails,
    this.hideReplyButton,
  });

  MessageAtItem.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    business = json['business'];
    businessId = json['business_id'];
    title = json['title'];
    image = json['image'];
    uri = json['uri'];
    subjectId = json['subject_id'];
    rootId = json['root_id'];
    targetId = json['target_id'];
    sourceId = json['source_id'];
    sourceContent = json['source_content'];
    nativeUri = json['native_uri'];
    if (json['at_details'] != null) {
      atDetails = <User>[];
      json['at_details'].forEach((v) {
        atDetails!.add(User.fromJson(v));
      });
    }
    if (json['topic_details'] != null) {
      topicDetails = <dynamic>[];
      json['topic_details'].forEach((v) {
        topicDetails!.add(v);
      });
    }
    hideReplyButton = json['hide_reply_button'];
  }
}

class User {
  int? mid;
  int? fans;
  String? nickname;
  String? avatar;
  String? midLink;
  bool? follow;

  User(
      {this.mid,
      this.fans,
      this.nickname,
      this.avatar,
      this.midLink,
      this.follow});

  User.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    fans = json['fans'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    midLink = json['mid_link'];
    follow = json['follow'];
  }
}
