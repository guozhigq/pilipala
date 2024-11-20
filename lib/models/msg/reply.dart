class MessageReplyModel {
  MessageReplyModel({
    this.cursor,
    this.items,
  });

  Cursor? cursor;
  List<MessageReplyItem>? items;

  MessageReplyModel.fromJson(Map<String, dynamic> json) {
    cursor = Cursor.fromJson(json['cursor']);
    items = json["items"] != null
        ? json["items"].map<MessageReplyItem>((e) {
            return MessageReplyItem.fromJson(e);
          }).toList()
        : [];
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
    isEnd = json['is_end'];
    time = json['time'];
  }
}

class MessageReplyItem {
  MessageReplyItem({
    this.count,
    this.id,
    this.isMulti,
    this.item,
    this.replyTime,
    this.user,
  });

  int? count;
  int? id;
  int? isMulti;
  ReplyContentItem? item;
  int? replyTime;
  ReplyUser? user;

  MessageReplyItem.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    id = json['id'];
    isMulti = json['is_multi'];
    item = ReplyContentItem.fromJson(json["item"]);
    replyTime = json['reply_time'];
    user = ReplyUser.fromJson(json['user']);
  }
}

class ReplyContentItem {
  ReplyContentItem({
    this.subjectId,
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
    this.message,
  });

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
  List? atDetails;
  List? topicDetails;
  bool? hideReplyButton;
  bool? hideLikeButton;
  int? likeState;
  String? danmu;
  String? message;

  ReplyContentItem.fromJson(Map<String, dynamic> json) {
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
    atDetails = json['at_details'];
    topicDetails = json['topic_details'];
    hideReplyButton = json['hide_reply_button'];
    hideLikeButton = json['hide_like_button'];
    likeState = json['like_state'];
    danmu = json['danmu'];
    message = json['message'];
  }
}

class ReplyUser {
  ReplyUser({
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

  ReplyUser.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    fans = json['fans'];
    nickname = json['nickname'];
    avatar = json['avatar'];
    midLink = json['mid_link'];
    follow = json['follow'];
  }
}
