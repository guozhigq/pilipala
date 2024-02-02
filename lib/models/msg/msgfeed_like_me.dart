class MsgFeedLikeMe {
  Latest? latest;
  Total? total;

  MsgFeedLikeMe({latest, total});

  MsgFeedLikeMe.fromJson(Map<String, dynamic> json) {
    latest =
    json['latest'] != null ? Latest.fromJson(json['latest']) : null;
    total = json['total'] != null ? Total.fromJson(json['total']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latest'] = latest?.toJson();
    data['total'] = total?.toJson();
    return data;
  }
}

class Latest {
  List<LikeMeItems>? items;
  int? lastViewAt;

  Latest({items, lastViewAt});

  Latest.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <LikeMeItems>[];
      json['items'].forEach((v) {
        items!.add(LikeMeItems.fromJson(v));
      });
    }
    lastViewAt = json['last_view_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items'] = items?.map((v) => v.toJson()).toList();
    data['last_view_at'] = lastViewAt;
    return data;
  }
}

class LikeMeItems {
  int? id;
  List<Users>? users;
  Item? item;
  int? counts;
  int? likeTime;
  int? noticeState;

  LikeMeItems(
      {id,
        users,
        item,
        counts,
        likeTime,
        noticeState});

  LikeMeItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
    counts = json['counts'];
    likeTime = json['like_time'];
    noticeState = json['notice_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['users'] = users?.map((v) => v.toJson()).toList();
    data['item'] = item?.toJson();
    data['counts'] = counts;
    data['like_time'] = likeTime;
    data['notice_state'] = noticeState;
    return data;
  }
}

class Users {
  int? mid;
  int? fans;
  String? nickname;
  String? avatar;
  String? midLink;
  bool? follow;

  Users(
      {mid,
        fans,
        nickname,
        avatar,
        midLink,
        follow});

  Users.fromJson(Map<String, dynamic> json) {
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

  Item(
      {itemId,
        pid,
        type,
        business,
        businessId,
        replyBusinessId,
        likeBusinessId,
        title,
        desc,
        image,
        uri,
        detailName,
        nativeUri,
        ctime});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    pid = json['pid'];
    type = json['type'];
    business = json['business'];
    businessId = json['business_id'];
    replyBusinessId = json['reply_business_id'];
    likeBusinessId = json['like_business_id'];
    title = json['title'];
    desc = json['desc'];
    image = json['image'];
    uri = json['uri'];
    detailName = json['detail_name'];
    nativeUri = json['native_uri'];
    ctime = json['ctime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['pid'] = pid;
    data['type'] = type;
    data['business'] = business;
    data['business_id'] = businessId;
    data['reply_business_id'] = replyBusinessId;
    data['like_business_id'] = likeBusinessId;
    data['title'] = title;
    data['desc'] = desc;
    data['image'] = image;
    data['uri'] = uri;
    data['detail_name'] = detailName;
    data['native_uri'] = nativeUri;
    data['ctime'] = ctime;
    return data;
  }
}

class Total {
  Cursor? cursor;
  List<LikeMeItems>? items;

  Total({cursor, items});

  Total.fromJson(Map<String, dynamic> json) {
    cursor =
    json['cursor'] != null ? Cursor.fromJson(json['cursor']) : null;
    if (json['items'] != null) {
      items = <LikeMeItems>[];
      json['items'].forEach((v) {
        items!.add(LikeMeItems.fromJson(v));
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