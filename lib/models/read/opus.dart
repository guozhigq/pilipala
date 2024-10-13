class OpusDataModel {
  OpusDataModel({
    this.id,
    this.detail,
    this.type,
    this.theme,
    this.themeMode,
  });

  String? id;
  OpusDetailDataModel? detail;
  int? type;
  String? theme;
  String? themeMode;

  OpusDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    detail = json['detail'] != null
        ? OpusDetailDataModel.fromJson(json['detail'])
        : null;
    type = json['type'];
    theme = json['theme'];
    themeMode = json['themeMode'];
  }
}

class OpusDetailDataModel {
  OpusDetailDataModel({
    this.basic,
    this.idStr,
    this.modules,
    this.type,
  });

  Basic? basic;
  String? idStr;
  List<OpusModuleDataModel>? modules;
  int? type;

  OpusDetailDataModel.fromJson(Map<String, dynamic> json) {
    basic = json['basic'] != null ? Basic.fromJson(json['basic']) : null;
    idStr = json['id_str'];
    if (json['modules'] != null) {
      modules = <OpusModuleDataModel>[];
      json['modules'].forEach((v) {
        modules!.add(OpusModuleDataModel.fromJson(v));
      });
    }
    type = json['type'];
  }
}

class Basic {
  Basic({
    this.commentIdStr,
    this.commentType,
    this.ridStr,
    this.title,
    this.uid,
  });

  String? commentIdStr;
  int? commentType;
  String? ridStr;
  String? title;
  int? uid;

  Basic.fromJson(Map<String, dynamic> json) {
    commentIdStr = json['comment_id_str'];
    commentType = json['comment_type'];
    ridStr = json['rid_str'];
    title = json['title'];
    uid = json['uid'];
  }
}

class OpusModuleDataModel {
  OpusModuleDataModel({
    this.moduleTitle,
    this.moduleAuthor,
    this.moduleContent,
    this.moduleExtend,
    this.moduleBottom,
    this.moduleStat,
  });

  ModuleTop? moduleTop;
  ModuleTitle? moduleTitle;
  ModuleAuthor? moduleAuthor;
  ModuleContent? moduleContent;
  ModuleExtend? moduleExtend;
  ModuleBottom? moduleBottom;
  ModuleStat? moduleStat;

  OpusModuleDataModel.fromJson(Map<String, dynamic> json) {
    moduleTop = json['module_top'] != null
        ? ModuleTop.fromJson(json['module_top'])
        : null;
    moduleTitle = json['module_title'] != null
        ? ModuleTitle.fromJson(json['module_title'])
        : null;
    moduleAuthor = json['module_author'] != null
        ? ModuleAuthor.fromJson(json['module_author'])
        : null;
    moduleContent = json['module_content'] != null
        ? ModuleContent.fromJson(json['module_content'])
        : null;
    moduleExtend = json['module_extend'] != null
        ? ModuleExtend.fromJson(json['module_extend'])
        : null;
    moduleBottom = json['module_bottom'] != null
        ? ModuleBottom.fromJson(json['module_bottom'])
        : null;
    moduleStat = json['module_stat'] != null
        ? ModuleStat.fromJson(json['module_stat'])
        : null;
  }
}

class ModuleTop {
  ModuleTop({
    this.type,
    this.video,
  });

  int? type;
  Map? video;

  ModuleTop.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    video = json['video'];
  }
}

class ModuleTitle {
  ModuleTitle({
    this.text,
  });

  String? text;

  ModuleTitle.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }
}

class ModuleAuthor {
  ModuleAuthor({
    this.face,
    this.mid,
    this.name,
    this.pubTime,
  });

  String? face;
  int? mid;
  String? name;
  String? pubTime;

  ModuleAuthor.fromJson(Map<String, dynamic> json) {
    face = json['face'];
    mid = json['mid'];
    name = json['name'];
    pubTime = json['pub_time'];
  }
}

class ModuleContent {
  ModuleContent({
    this.paragraphs,
    this.moduleType,
  });

  List<ModuleParagraph>? paragraphs;
  String? moduleType;

  ModuleContent.fromJson(Map<String, dynamic> json) {
    if (json['paragraphs'] != null) {
      paragraphs = <ModuleParagraph>[];
      json['paragraphs'].forEach((v) {
        paragraphs!.add(ModuleParagraph.fromJson(v));
      });
    }
    moduleType = json['module_type'];
  }
}

class ModuleParagraph {
  ModuleParagraph({
    this.align,
    this.paraType,
    this.pic,
    this.text,
  });

  // 0 左对齐  1 居中  2 右对齐
  int? align;
  int? paraType;
  Pics? pic;
  ModuleParagraphText? text;
  LinkCard? linkCard;

  ModuleParagraph.fromJson(Map<String, dynamic> json) {
    align = json['align'];
    paraType = json['para_type'] == null && json['link_card'] != null
        ? 3
        : json['para_type'];
    pic = json['pic'] != null ? Pics.fromJson(json['pic']) : null;
    text = json['text'] != null
        ? ModuleParagraphText.fromJson(json['text'])
        : null;
    linkCard =
        json['link_card'] != null ? LinkCard.fromJson(json['link_card']) : null;
  }
}

class Pics {
  Pics({
    this.pics,
    this.style,
  });

  List<Pic>? pics;
  int? style;

  Pics.fromJson(Map<String, dynamic> json) {
    if (json['pics'] != null) {
      pics = <Pic>[];
      json['pics'].forEach((v) {
        pics!.add(Pic.fromJson(v));
      });
    }
    style = json['style'];
  }
}

class Pic {
  Pic({
    this.height,
    this.size,
    this.url,
    this.width,
    this.aspectRatio,
    this.scale,
  });

  int? height;
  double? size;
  String? url;
  int? width;
  double? aspectRatio;
  double? scale;

  Pic.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    size = json['size'];
    url = json['url'];
    width = json['width'];
    aspectRatio = json['width'] / json['height'];
    scale = customDivision(json['width'], 600);
  }
}

class LinkCard {
  LinkCard({
    this.cover,
    this.descSecond,
    this.duration,
    this.jumpUrl,
    this.title,
  });

  String? cover;
  String? descSecond;
  String? duration;
  String? jumpUrl;
  String? title;

  LinkCard.fromJson(Map<String, dynamic> json) {
    cover = json['card']['cover'];
    descSecond = json['card']['desc_second'];
    duration = json['card']['duration'];
    jumpUrl = json['card']['jump_url'];
    title = json['card']['title'];
  }
}

class ModuleParagraphText {
  ModuleParagraphText({
    this.nodes,
  });

  List<ModuleParagraphTextNode>? nodes;

  ModuleParagraphText.fromJson(Map<String, dynamic> json) {
    if (json['nodes'] != null) {
      nodes = <ModuleParagraphTextNode>[];
      json['nodes'].forEach((v) {
        nodes!.add(ModuleParagraphTextNode.fromJson(v));
      });
    }
  }
}

class ModuleParagraphTextNode {
  ModuleParagraphTextNode({
    this.type,
    this.nodeType,
    this.word,
  });

  String? type;
  int? nodeType;
  ModuleParagraphTextNodeWord? word;

  ModuleParagraphTextNode.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    nodeType = json['node_type'];
    word = json['word'] != null
        ? ModuleParagraphTextNodeWord.fromJson(json['word'])
        : null;
  }
}

class ModuleParagraphTextNodeWord {
  ModuleParagraphTextNodeWord({
    this.color,
    this.fontSize,
    this.style,
    this.words,
  });

  String? color;
  int? fontSize;
  ModuleParagraphTextNodeWordStyle? style;
  String? words;

  ModuleParagraphTextNodeWord.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    fontSize = json['font_size'];
    style = json['style'] != null
        ? ModuleParagraphTextNodeWordStyle.fromJson(json['style'])
        : null;
    words = json['words'];
  }
}

class ModuleParagraphTextNodeWordStyle {
  ModuleParagraphTextNodeWordStyle({
    this.bold,
  });

  bool? bold;

  ModuleParagraphTextNodeWordStyle.fromJson(Map<String, dynamic> json) {
    bold = json['bold'];
  }
}

class ModuleExtend {
  ModuleExtend({
    this.items,
  });

  List<ModuleExtendItem>? items;

  ModuleExtend.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ModuleExtendItem>[];
      json['items'].forEach((v) {
        items!.add(ModuleExtendItem.fromJson(v));
      });
    }
  }
}

class ModuleExtendItem {
  ModuleExtendItem({
    this.bizId,
    this.bizType,
    this.icon,
    this.jumpUrl,
    this.text,
  });

  dynamic bizId;
  int? bizType;
  dynamic icon;
  String? jumpUrl;
  String? text;

  ModuleExtendItem.fromJson(Map<String, dynamic> json) {
    bizId = json['biz_id'];
    bizType = json['biz_type'];
    icon = json['icon'];
    jumpUrl = json['jump_url'];
    text = json['text'];
  }
}

class ModuleBottom {
  ModuleBottom({
    this.shareInfo,
  });

  ShareInfo? shareInfo;

  ModuleBottom.fromJson(Map<String, dynamic> json) {
    shareInfo = json['share_info'] != null
        ? ShareInfo.fromJson(json['share_info'])
        : null;
  }
}

class ShareInfo {
  ShareInfo({
    this.pic,
    this.summary,
    this.title,
  });

  String? pic;
  String? summary;
  String? title;

  ShareInfo.fromJson(Map<String, dynamic> json) {
    pic = json['pic'];
    summary = json['summary'];
    title = json['title'];
  }
}

class ModuleStat {
  ModuleStat({
    this.coin,
    this.comment,
    this.favorite,
    this.forward,
    this.like,
  });

  StatItem? coin;
  StatItem? comment;
  StatItem? favorite;
  StatItem? forward;
  StatItem? like;

  ModuleStat.fromJson(Map<String, dynamic> json) {
    coin = json['coin'] != null ? StatItem.fromJson(json['coin']) : null;
    comment =
        json['comment'] != null ? StatItem.fromJson(json['comment']) : null;
    favorite =
        json['favorite'] != null ? StatItem.fromJson(json['favorite']) : null;
    forward =
        json['forward'] != null ? StatItem.fromJson(json['forward']) : null;
    like = json['like'] != null ? StatItem.fromJson(json['like']) : null;
  }
}

class StatItem {
  StatItem({
    this.count,
    this.forbidden,
    this.status,
  });

  int? count;
  bool? forbidden;
  bool? status;

  StatItem.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    forbidden = json['forbidden'];
    status = json['status'];
  }
}

double customDivision(int a, int b) {
  double result = a / b;
  if (result < 1) {
    return result;
  } else {
    return 1.0;
  }
}
