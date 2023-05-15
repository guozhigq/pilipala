class FavFolderData {
  FavFolderData({
    this.count,
    this.list,
    this.hasMore,
  });

  int? count;
  List<FavFolderItemData>? list;
  bool? hasMore;

  FavFolderData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    list = json['list'] != null
        ? json['list']
            .map<FavFolderItemData>((e) => FavFolderItemData.fromJson(e))
            .toList()
        : [FavFolderItemData()];
    hasMore = json['has_more'];
  }
}

class FavFolderItemData {
  FavFolderItemData({
    this.id,
    this.fid,
    this.mid,
    this.attr,
    this.title,
    this.cover,
    this.upper,
    this.coverType,
    this.intro,
    this.ctime,
    this.mtime,
    this.state,
    this.favState,
    this.mediaCount,
    this.viewCount,
    this.vt,
    this.playSwitch,
    this.type,
    this.link,
    this.bvid,
  });

  int? id;
  int? fid;
  int? mid;
  int? attr;
  String? title;
  String? cover;
  Upper? upper;
  int? coverType;
  String? intro;
  int? ctime;
  int? mtime;
  int? state;
  int? favState;
  int? mediaCount;
  int? viewCount;
  int? vt;
  int? playSwitch;
  int? type;
  String? link;
  String? bvid;

  FavFolderItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fid = json['fid'];
    mid = json['mid'];
    attr = json['attr'];
    title = json['title'];
    cover = json['cover'];
    upper = json['upper'] != null ? Upper.fromJson(json['upper']) : Upper();
    coverType = json['cover_type'];
    intro = json['intro'];
    ctime = json['ctime'];
    mtime = json['mtime'];
    state = json['state'];
    favState = json['fav_state'];
    mediaCount = json['media_count'];
    viewCount = json['view_count'];
    vt = json['vt'];
    playSwitch = json['play_switch'];
    type = json['type'];
    link = json['link'];
    bvid = json['bvid'];
  }
}

class Upper {
  Upper({
    this.mid,
    this.name,
    this.face,
  });

  int? mid;
  String? name;
  String? face;

  Upper.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    name = json['name'];
    face = json['face'];
  }
}
