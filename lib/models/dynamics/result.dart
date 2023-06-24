class DynamicsDataModel {
  DynamicsDataModel({
    this.hasMore,
    this.items,
    this.offset,
  });
  bool? hasMore;
  List<DynamicItemModel>? items;
  String? offset;

  DynamicsDataModel.fromJson(Map<String, dynamic> json) {
    hasMore = json['has_more'];
    items = json['items']
        .map<DynamicItemModel>((e) => DynamicItemModel.fromJson(e))
        .toList();
    offset = json['offset'];
  }
}

// 单个动态
class DynamicItemModel {
  DynamicItemModel({
    // this.basic,
    this.idStr,
    this.modules,
    this.orig,
    this.type,
    this.visible,
  });

  // Map? basic;
  String? idStr;
  ItemModulesModel? modules;
  ItemOrigModel? orig;
  String? type;
  bool? visible;

  DynamicItemModel.fromJson(Map<String, dynamic> json) {
    // basic = json['basic'];
    idStr = json['id_str'];
    modules = ItemModulesModel.fromJson(json['modules']);
    orig = json['orig'] != null ? ItemOrigModel.fromJson(json['orig']) : null;
    type = json['type'];
    visible = json['visible'];
  }
}

class ItemOrigModel {
  ItemOrigModel({
    this.basic,
    this.isStr,
    this.modules,
    this.type,
    this.visible,
  });

  Map? basic;
  String? isStr;
  ItemModulesModel? modules;
  String? type;
  bool? visible;

  ItemOrigModel.fromJson(Map<String, dynamic> json) {
    basic = json['basic'];
    isStr = json['is_str'];
    modules = ItemModulesModel.fromJson(json['modules']);
    type = json['type'];
    visible = json['visible'];
  }
}

// 单个动态详情
class ItemModulesModel {
  ItemModulesModel({
    this.moduleAuthor,
    this.moduleDynamic,
    // this.moduleInter,
    this.moduleStat,
  });

  ModuleAuthorModel? moduleAuthor;
  ModuleDynamicModel? moduleDynamic;
  // ModuleInterModel? moduleInter;
  ModuleStatModel? moduleStat;

  ItemModulesModel.fromJson(Map<String, dynamic> json) {
    moduleAuthor = json['module_author'] != null
        ? ModuleAuthorModel.fromJson(json['module_author'])
        : null;
    moduleDynamic = json['module_dynamic'] != null
        ? ModuleDynamicModel.fromJson(json['module_dynamic'])
        : null;
    // moduleInter = ModuleInterModel.fromJson(json['module_interaction']);
    moduleStat = json['module_stat'] != null
        ? ModuleStatModel.fromJson(json['module_stat'])
        : null;
  }
}

// 单个动态详情 - 作者信息
class ModuleAuthorModel {
  ModuleAuthorModel({
    // this.avatar,
    // this.decorate,
    this.face,
    this.following,
    this.jumpUrl,
    this.label,
    this.mid,
    this.name,
    // this.officialVerify,
    // this.pandant,
    this.pubAction,
    // this.pubLocationText,
    this.pubTime,
    this.pubTs,
    this.type,
    // this.vip,
  });

  String? face;
  bool? following;
  String? jumpUrl;
  String? label;
  int? mid;
  String? name;
  String? pubAction;
  String? pubTime;
  int? pubTs;
  String? type;

  ModuleAuthorModel.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    following = json['following'];
    jumpUrl = json['jump_url'];
    label = json['label'];
    mid = json['mid'];
    name = json['name'];
    pubAction = json['pub_action'];
    pubTime = json['pub_time'];
    pubTs = json['pub_ts'];
    type = json['type'];
  }
}

// 单个动态详情 - 动态信息
class ModuleDynamicModel {
  ModuleDynamicModel({
    // this.additional,
    this.desc,
    this.major,
    this.topic,
  });

  String? additional;
  DynamicDescModel? desc;
  DynamicMajorModel? major;
  Map? topic;

  ModuleDynamicModel.fromJson(Map<String, dynamic> json) {
    desc =
        json['desc'] != null ? DynamicDescModel.fromJson(json['desc']) : null;
    if (json['major'] != null) {
      major = DynamicMajorModel.fromJson(json['major']);
    }
    topic = json['topic'];
  }
}

// 单个动态详情 - 评论？信息
// class ModuleInterModel {
//   ModuleInterModel({

//   });

//   ModuleInterModel.fromJson(Map<String, dynamic> json) {

//   }
// }

class DynamicDescModel {
  DynamicDescModel({
    this.richTextNode,
    this.text,
  });

  List? richTextNode;
  String? text;

  DynamicDescModel.fromJson(Map<String, dynamic> json) {
    richTextNode = json['rich_text_nodes'];
    text = json['text'];
  }
}

//
class DynamicMajorModel {
  DynamicMajorModel({
    this.archive,
    this.draw,
    this.ugcSeason,
    this.type,
  });

  DynamicArchiveModel? archive;
  DynamicDrawModel? draw;
  DynamicArchiveModel? ugcSeason;
  DynamicOpusModel? opus;
  // MAJOR_TYPE_DRAW 图片
  // MAJOR_TYPE_ARCHIVE 视频
  // MAJOR_TYPE_OPUS 图文/文章
  String? type;

  DynamicMajorModel.fromJson(Map<String, dynamic> json) {
    archive = json['archive'] != null
        ? DynamicArchiveModel.fromJson(json['archive'])
        : null;
    draw =
        json['draw'] != null ? DynamicDrawModel.fromJson(json['draw']) : null;
    ugcSeason = json['ugc_season'] != null
        ? DynamicArchiveModel.fromJson(json['ugc_season'])
        : null;
    opus =
        json['opus'] != null ? DynamicOpusModel.fromJson(json['opus']) : null;
    type = json['type'];
  }
}

class DynamicArchiveModel {
  DynamicArchiveModel({
    this.aid,
    this.badge,
    this.bvid,
    this.cover,
    this.desc,
    this.disablePreview,
    this.durationText,
    this.jumpUrl,
    this.stat,
    this.title,
    this.type,
  });

  int? aid;
  Map? badge;
  String? bvid;
  String? cover;
  String? desc;
  int? disablePreview;
  String? durationText;
  String? jumpUrl;
  Stat? stat;
  String? title;
  int? type;

  DynamicArchiveModel.fromJson(Map<String, dynamic> json) {
    aid = json['aid'] is String ? int.parse(json['aid']) : json['aid'];
    badge = json['badge'];
    bvid = json['bvid'];
    cover = json['cover'];
    disablePreview = json['disable_preview'];
    durationText = json['duration_text'];
    jumpUrl = json['jump_url'];
    stat = json['stat'] != null ? Stat.fromJson(json['stat']) : null;
    title = json['title'];
    type = json['type'];
  }
}

class DynamicDrawModel {
  DynamicDrawModel({
    this.id,
    this.items,
  });

  int? id;
  List<DynamicDrawItemModel>? items;

  DynamicDrawModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // ignore: prefer_null_aware_operators
    items = json['items'] != null
        ? json['items']
            .map<DynamicDrawItemModel>((e) => DynamicDrawItemModel.fromJson(e))
            .toList()
        : null;
  }
}

class DynamicOpusModel {
  DynamicOpusModel({
    this.jumpUrl,
    this.pics,
    this.summary,
    this.title,
  });

  String? jumpUrl;
  List? pics;
  Map? summary;
  String? title;
  DynamicOpusModel.fromJson(Map<String, dynamic> json) {
    jumpUrl = json['jump_url'];
    pics = json['pics'];
    summary = json['summary'];
    title = json['title'];
  }
}

class OpusPicsModel {
  OpusPicsModel({
    this.width,
    this.height,
    this.size,
    this.src,
  });

  int? width;
  int? height;
  int? size;
  String? src;

  OpusPicsModel.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    size = json['size'];
    src = json['src'];
  }
}

class DynamicDrawItemModel {
  DynamicDrawItemModel({
    this.height,
    this.size,
    this.src,
    this.tags,
    this.width,
  });
  int? height;
  double? size;
  String? src;
  List? tags;
  int? width;
  DynamicDrawItemModel.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    size = json['size'];
    src = json['src'];
    tags = json['tags'];
    width = json['width'];
  }
}

// 动态状态 转发、评论、点赞
class ModuleStatModel {
  ModuleStatModel({
    this.comment,
    this.forward,
    this.like,
  });

  Comment? comment;
  Map? forward;
  Like? like;

  ModuleStatModel.fromJson(Map<String, dynamic> json) {
    comment = Comment.fromJson(json['comment']);
    forward = json['forward'];
    like = Like.fromJson(json['like']);
  }
}

// 动态状态 评论
class Comment {
  Comment({
    this.count,
    this.forbidden,
  });

  String? count;
  bool? forbidden;

  Comment.fromJson(Map<String, dynamic> json) {
    count = json['count'].toString();
    forbidden = json['forbidden'];
  }
}

// 动态状态 点赞
class Like {
  Like({
    this.count,
    this.forbidden,
    this.status,
  });

  String? count;
  bool? forbidden;
  bool? status;

  Like.fromJson(Map<String, dynamic> json) {
    count = json['count'].toString();
    forbidden = json['forbidden'];
    status = json['status'];
  }
}

class Stat {
  Stat({
    this.danmaku,
    this.play,
  });

  String? danmaku;
  String? play;

  Stat.fromJson(Map<String, dynamic> json) {
    danmaku = json['danmaku'];
    play = json['play'];
  }
}
