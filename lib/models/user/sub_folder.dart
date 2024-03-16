class SubFolderModelData {
  final int? count;
  final List<SubFolderItemData>? list;

  SubFolderModelData({
    this.count,
    this.list,
  });

  factory SubFolderModelData.fromJson(Map<String, dynamic> json) {
    return SubFolderModelData(
      count: json['count'],
      list: json['list'] != null
          ? (json['list'] as List)
              .map<SubFolderItemData>((i) => SubFolderItemData.fromJson(i))
              .toList()
          : null,
    );
  }
}

class SubFolderItemData {
  final int? id;
  final int? fid;
  final int? mid;
  final int? attr;
  final String? title;
  final String? cover;
  final Upper? upper;
  final int? coverType;
  final String? intro;
  final int? ctime;
  final int? mtime;
  final int? state;
  final int? favState;
  final int? mediaCount;
  final int? viewCount;
  final int? vt;
  final int? playSwitch;
  final int? type;
  final String? link;
  final String? bvid;

  SubFolderItemData({
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

  factory SubFolderItemData.fromJson(Map<String, dynamic> json) {
    return SubFolderItemData(
      id: json['id'],
      fid: json['fid'],
      mid: json['mid'],
      attr: json['attr'],
      title: json['title'],
      cover: json['cover'],
      upper: json['upper'] != null ? Upper.fromJson(json['upper']) : null,
      coverType: json['cover_type'],
      intro: json['intro'],
      ctime: json['ctime'],
      mtime: json['mtime'],
      state: json['state'],
      favState: json['fav_state'],
      mediaCount: json['media_count'],
      viewCount: json['view_count'],
      vt: json['vt'],
      playSwitch: json['play_switch'],
      type: json['type'],
      link: json['link'],
      bvid: json['bvid'],
    );
  }
}

class Upper {
  final int? mid;
  final String? name;
  final String? face;

  Upper({
    this.mid,
    this.name,
    this.face,
  });

  factory Upper.fromJson(Map<String, dynamic> json) {
    return Upper(
      mid: json['mid'],
      name: json['name'],
      face: json['face'],
    );
  }
}
