class MsgFeedReplyMe {
  Cursor? cursor;
  List<ReplyMeItems>? items;
  int? lastViewAt;

  MsgFeedReplyMe({this.cursor, this.items, this.lastViewAt});

  MsgFeedReplyMe.fromJson(Map<String, dynamic> json) {
    cursor =
    json['cursor'] != null ? Cursor.fromJson(json['cursor']) : null;
    if (json['items'] != null) {
      items = <ReplyMeItems>[];
      json['items'].forEach((v) {
        items!.add(ReplyMeItems.fromJson(v));
      });
    }
    lastViewAt = json['last_view_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cursor'] = cursor?.toJson();
    data['items'] = items?.map((v) => v.toJson()).toList();
    data['last_view_at'] = lastViewAt;
    return data;
  }
}

class Cursor {
  bool? isEnd;
  int? id;
  int? time;

  Cursor({this.isEnd, this.id, this.time});

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

class ReplyMeItems {
  int? id;
  User? user;
  Item? item;
  int? counts;
  int? isMulti;
  int? replyTime;

  ReplyMeItems(
      {this.id,
        this.user,
        this.item,
        this.counts,
        this.isMulti,
        this.replyTime});

  ReplyMeItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
    counts = json['counts'];
    isMulti = json['is_multi'];
    replyTime = json['reply_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (item != null) {
      data['item'] = item!.toJson();
    }
    data['counts'] = counts;
    data['is_multi'] = isMulti;
    data['reply_time'] = replyTime;
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
  int? subjectId;
  int? rootId;
  int? sourceId;
  int? targetId;
  String? type;
  int? businessId;
  String? business;
  String? title;
  String? desc;
  String? image;
  String? uri;
  String? nativeUri;
  String? detailTitle;
  String? rootReplyContent;
  String? sourceContent;
  String? targetReplyContent;
  List<AtDetails>? atDetails;
  List? topicDetails;
  bool? hideReplyButton;
  bool? hideLikeButton;
  int? likeState;
  dynamic danmu;
  String? message;

  Item(
      {this.subjectId,
        this.rootId,
        this.sourceId,
        this.targetId,
        this.type,
        this.businessId,
        this.business,
        this.title,
        this.desc,
        this.image,
        this.uri,
        this.nativeUri,
        this.detailTitle,
        this.rootReplyContent,
        this.sourceContent,
        this.targetReplyContent,
        this.atDetails,
        this.topicDetails,
        this.hideReplyButton,
        this.hideLikeButton,
        this.likeState,
        this.danmu,
        this.message});

  Item.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    rootId = json['root_id'];
    sourceId = json['source_id'];
    targetId = json['target_id'];
    type = json['type'];
    businessId = json['business_id'];
    business = json['business'];
    title = json['title'];
    desc = json['desc'];
    image = json['image'];
    uri = json['uri'];
    nativeUri = json['native_uri'];
    detailTitle = json['detail_title'];
    rootReplyContent = json['root_reply_content'];
    sourceContent = json['source_content'];
    targetReplyContent = json['target_reply_content'];
    if (json['at_details'] != null) {
      atDetails = <AtDetails>[];
      json['at_details'].forEach((v) {
        atDetails!.add(AtDetails.fromJson(v));
      });
    }
    topicDetails = json['topic_details'];
    hideReplyButton = json['hide_reply_button'];
    hideLikeButton = json['hide_like_button'];
    likeState = json['like_state'];
    danmu = json['danmu'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subjectId;
    data['root_id'] = rootId;
    data['source_id'] = sourceId;
    data['target_id'] = targetId;
    data['type'] = type;
    data['business_id'] = businessId;
    data['business'] = business;
    data['title'] = title;
    data['desc'] = desc;
    data['image'] = image;
    data['uri'] = uri;
    data['native_uri'] = nativeUri;
    data['detail_title'] = detailTitle;
    data['root_reply_content'] = rootReplyContent;
    data['source_content'] = sourceContent;
    data['target_reply_content'] = targetReplyContent;
    data['at_details'] = atDetails?.map((v) => v.toJson()).toList();
    data['topic_details'] = topicDetails?.map((v) => v.toJson()).toList();
    data['hide_reply_button'] = hideReplyButton;
    data['hide_like_button'] = hideLikeButton;
    data['like_state'] = likeState;
    data['danmu'] = danmu;
    data['message'] = message;
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
