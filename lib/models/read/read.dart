import 'package:pilipala/models/member/info.dart';

import 'opus.dart';

class ReadDataModel {
  ReadDataModel({
    this.cvid,
    this.readInfo,
    this.readViewInfo,
    this.upInfo,
    this.catalogList,
    this.recommendInfoList,
    this.hiddenInteraction,
    this.isModern,
  });

  int? cvid;
  ReadInfo? readInfo;
  Map? readViewInfo;
  Map? upInfo;
  List<dynamic>? catalogList;
  List<dynamic>? recommendInfoList;
  bool? hiddenInteraction;
  bool? isModern;

  ReadDataModel.fromJson(Map<String, dynamic> json) {
    cvid = json['cvid'];
    readInfo =
        json['readInfo'] != null ? ReadInfo.fromJson(json['readInfo']) : null;
    readViewInfo = json['readViewInfo'];
    upInfo = json['upInfo'];
    if (json['catalogList'] != null) {
      catalogList = <dynamic>[];
      json['catalogList'].forEach((v) {
        catalogList!.add(v);
      });
    }
    if (json['recommendInfoList'] != null) {
      recommendInfoList = <dynamic>[];
      json['recommendInfoList'].forEach((v) {
        recommendInfoList!.add(v);
      });
    }
    hiddenInteraction = json['hiddenInteraction'];
    isModern = json['isModern'];
  }
}

class ReadInfo {
  ReadInfo({
    this.id,
    this.category,
    this.title,
    this.summary,
    this.bannerUrl,
    this.author,
    this.publishTime,
    this.ctime,
    this.mtime,
    this.stats,
    this.attributes,
    this.words,
    this.originImageUrls,
    this.content,
    this.opus,
    this.dynIdStr,
    this.totalArtNum,
  });

  int? id;
  Map? category;
  String? title;
  String? summary;
  String? bannerUrl;
  Author? author;
  int? publishTime;
  int? ctime;
  int? mtime;
  Map? stats;
  int? attributes;
  int? words;
  List<String>? originImageUrls;
  String? content;
  Opus? opus;
  String? dynIdStr;
  int? totalArtNum;

  ReadInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    title = json['title'];
    summary = json['summary'];
    bannerUrl = json['banner_url'];
    author = Author.fromJson(json['author']);
    publishTime = json['publish_time'];
    ctime = json['ctime'];
    mtime = json['mtime'];
    stats = json['stats'];
    attributes = json['attributes'];
    words = json['words'];
    if (json['origin_image_urls'] != null) {
      originImageUrls = <String>[];
      json['origin_image_urls'].forEach((v) {
        originImageUrls!.add(v);
      });
    }
    content = json['content'];
    opus = json['opus'] != null ? Opus.fromJson(json['opus']) : null;
    dynIdStr = json['dyn_id_str'];
    totalArtNum = json['total_art_num'];
  }
}

class Author {
  Author({
    this.mid,
    this.name,
    this.face,
    this.vip,
    this.fans,
    this.level,
  });

  int? mid;
  String? name;
  String? face;
  Vip? vip;
  int? fans;
  int? level;

  Author.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    name = json['name'];
    face = json['face'];
    vip = json['vip'] != null ? Vip.fromJson(json['vip']) : null;
    fans = json['fans'];
    level = json['level'];
  }
}

class Opus {
  // "opus_id": 976625853207150600,
  // "opus_source": 2,
  // "title": "真的很想骂人 但又没什么好骂的",
  // "content": {
  //     "paragraphs": [{
  //         "para_type": 1,
  //         "text": {
  //             "nodes": [{
  //                 "node_type": 1,
  //                 "word": {
  //                     "words": "21年玩到今年4月的号没了  ow1的时候45的号 玩了三年  后面第9赛季一个英杰5的号（虽然是偷的 但我任何违规行为都没有还是给我封了）  最近玩的号叫velleity  只和队友打天梯以及训练赛 又没了 连带着我一个一把没玩过只玩过一场训练赛的小号也没了  实在是无话可说了...",
  //                     "font_size": 17,
  //                     "style": {},
  //                     "font_level": "regular"
  //                 }
  //             }]
  //         }
  //     }, {
  //         "para_type": 2,
  //         "pic": {
  //             "pics": [{
  //                 "url": "https:\u002F\u002Fi0.hdslb.com\u002Fbfs\u002Fnew_dyn\u002Fba4e57459451fe74dcb70fd20bde9823316082117.jpg",
  //                 "width": 1600,
  //                 "height": 1000,
  //                 "size": 588.482421875
  //             }],
  //             "style": 1
  //         }
  //     }, {
  //         "para_type": 1,
  //         "text": {
  //             "nodes": [{
  //                 "node_type": 1,
  //                 "word": {
  //                     "words": "\n",
  //                     "font_size": 17,
  //                     "style": {},
  //                     "font_level": "regular"
  //                 }
  //             }]
  //         }
  //     }, {
  //         "para_type": 2,
  //         "pic": {
  //             "pics": [{
  //                 "url": "https:\u002F\u002Fi0.hdslb.com\u002Fbfs\u002Fnew_dyn\u002F0945be6b621091ddb8189482a87a36fb316082117.jpg",
  //                 "width": 1600,
  //                 "height": 1002,
  //                 "size": 665.7861328125
  //             }],
  //             "style": 1
  //         }
  //     }, {
  //         "para_type": 1,
  //         "text": {
  //             "nodes": [{
  //                 "node_type": 1,
  //                 "word": {
  //                     "words": "\n",
  //                     "font_size": 17,
  //                     "style": {},
  //                     "font_level": "regular"
  //                 }
  //             }]
  //         }
  //     }, {
  //         "para_type": 2,
  //         "pic": {
  //             "pics": [{
  //                 "url": "https:\u002F\u002Fi0.hdslb.com\u002Fbfs\u002Fnew_dyn\u002Ffa60649f8786578a764a1e68a2c5d23f316082117.jpg",
  //                 "width": 1600,
  //                 "height": 999,
  //                 "size": 332.970703125
  //             }],
  //             "style": 1
  //         }
  //     }, {
  //         "para_type": 1,
  //         "text": {
  //             "nodes": [{
  //                 "node_type": 1,
  //                 "word": {
  //                     "words": "\n",
  //                     "font_size": 17,
  //                     "style": {},
  //                     "font_level": "regular"
  //                 }
  //             }]
  //         }
  //     }]
  // },
  // "pub_info": {
  //     "uid": 316082117,
  //     "pub_time": 1726226826
  // },
  // "article": {
  //     "category_id": 15,
  //     "cover": [{
  //         "url": "https:\u002F\u002Fi0.hdslb.com\u002Fbfs\u002Fnew_dyn\u002Fbanner\u002Feb10074186a62f98c18e1b5b9deb38be316082117.png",
  //         "width": 1071,
  //         "height": 315,
  //         "size": 225.625
  //     }]
  // },
  // "version": {
  //     "cvid": 38660379,
  //     "version_id": 101683514411343360
  // }
  Opus({
    this.opusId,
    this.opusSource,
    this.title,
    this.content,
  });

  int? opusId;
  int? opusSource;
  String? title;
  Content? content;

  Opus.fromJson(Map<String, dynamic> json) {
    opusId = json['opus_id'];
    opusSource = json['opus_source'];
    title = json['title'];
    content =
        json['content'] != null ? Content.fromJson(json['content']) : null;
  }
}

class Content {
  Content({
    this.paragraphs,
  });

  List<ModuleParagraph>? paragraphs;

  Content.fromJson(Map<String, dynamic> json) {
    if (json['paragraphs'] != null) {
      paragraphs = <ModuleParagraph>[];
      json['paragraphs'].forEach((v) {
        paragraphs!.add(ModuleParagraph.fromJson(v));
      });
    }
  }
}
