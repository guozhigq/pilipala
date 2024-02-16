class MsgFeedAtMe {
  Cursor? cursor;
  List<AtMeItems>? items;

  MsgFeedAtMe({cursor, items});

  MsgFeedAtMe.fromJson(Map<String, dynamic> json) {
    cursor = json['cursor'] != null ? Cursor.fromJson(json['cursor']) : null;
    if (json['items'] != null) {
      items = <AtMeItems>[];
      json['items'].forEach((v) {
        items!.add(AtMeItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cursor'] = cursor?.toJson();
    data['items'] = items?.map((v) => v.toJson()).toList();
    return data;
  }
}

class Cursor {
  bool? isEnd;
  int? id;
  int? time;

  Cursor({isEnd, id, time});

  Cursor.fromJson(Map<String, dynamic> json) {
    isEnd = json['is_end'];
    id = json['id'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_end'] = isEnd;
    data['id'] = id;
    data['time'] = time;
    return data;
  }
}

class AtMeItems {
  int? id;
  User? user;
  Item? item;
  int? atTime;

  AtMeItems({id, user, item, atTime});

  AtMeItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
    atTime = json['at_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user'] = user?.toJson();
    data['item'] = item?.toJson();
    data['at_time'] = atTime;
    return data;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mid'] = mid;
    data['fans'] = fans;
    data['nickname'] = nickname;
    data['avatar'] = avatar;
    data['mid_link'] = midLink;
    data['follow'] = follow;
    return data;
  }
}

class Item {
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
  List<AtDetails>? atDetails;
  List? topicDetails;
  bool? hideReplyButton;

  Item(
      {this.type,
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
      this.hideReplyButton});

  Item.fromJson(Map<String, dynamic> json) {
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
      atDetails = <AtDetails>[];
      json['at_details'].forEach((v) {
        atDetails!.add(AtDetails.fromJson(v));
      });
    }
    topicDetails = json['topic_details'];
    hideReplyButton = json['hide_reply_button'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['business'] = business;
    data['business_id'] = businessId;
    data['title'] = title;
    data['image'] = image;
    data['uri'] = uri;
    data['subject_id'] = subjectId;
    data['root_id'] = rootId;
    data['target_id'] = targetId;
    data['source_id'] = sourceId;
    data['source_content'] = sourceContent;
    data['native_uri'] = nativeUri;
    data['at_details'] = atDetails?.map((v) => v.toJson()).toList();
    data['topic_details'] = topicDetails?.map((v) => v.toJson()).toList();
    data['hide_reply_button'] = hideReplyButton;
    return data;
  }
}

class AtDetails {
  int? mid;
  int? fans;
  String? nickname;
  String? avatar;
  String? midLink;
  bool? follow;

  AtDetails(
      {this.mid,
      this.fans,
      this.nickname,
      this.avatar,
      this.midLink,
      this.follow});

  AtDetails.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    fans = json['fans'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    midLink = json['mid_link'];
    follow = json['follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mid'] = mid;
    data['fans'] = fans;
    data['nickname'] = nickname;
    data['avatar'] = avatar;
    data['mid_link'] = midLink;
    data['follow'] = follow;
    return data;
  }
}
