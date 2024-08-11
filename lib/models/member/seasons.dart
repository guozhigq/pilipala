class MemberSeasonsDataModel {
  MemberSeasonsDataModel({
    this.page,
    this.seasonsList,
    this.seriesList,
  });

  Map? page;
  List<MemberSeasonsList>? seasonsList;
  List<MemberArchiveItem>? seriesList;

  MemberSeasonsDataModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    var tempList1 = json['seasons_list'] != null
        ? json['seasons_list']
            .map<MemberSeasonsList>((e) => MemberSeasonsList.fromJson(e))
            .toList()
        : [];
    var tempList2 = json['series_list'] != null
        ? json['series_list']
            .map<MemberSeasonsList>((e) => MemberSeasonsList.fromJson(e))
            .toList()
        : [];
    seriesList = json['archives'] != null
        ? json['archives']
            .map<MemberArchiveItem>((e) => MemberArchiveItem.fromJson(e))
            .toList()
        : [];

    seasonsList = [...tempList1, ...tempList2];
  }
}

class MemberSeasonsList {
  MemberSeasonsList({
    this.archives,
    this.meta,
    this.recentAids,
    this.page,
  });

  List<MemberArchiveItem>? archives;
  MamberMeta? meta;
  List? recentAids;
  Map? page;

  MemberSeasonsList.fromJson(Map<String, dynamic> json) {
    archives = json['archives'] != null
        ? json['archives']
            .map<MemberArchiveItem>((e) => MemberArchiveItem.fromJson(e))
            .toList()
        : [];
    meta = MamberMeta.fromJson(json['meta']);
    page = json['page'];
  }
}

class MemberArchiveItem {
  MemberArchiveItem({
    this.aid,
    this.bvid,
    this.ctime,
    this.duration,
    this.pic,
    this.cover,
    this.pubdate,
    this.view,
    this.title,
  });

  int? aid;
  String? bvid;
  int? ctime;
  int? duration;
  String? pic;
  String? cover;
  int? pubdate;
  int? view;
  String? title;

  MemberArchiveItem.fromJson(Map<String, dynamic> json) {
    aid = json['aid'];
    bvid = json['bvid'];
    ctime = json['ctime'];
    duration = json['duration'];
    pic = json['pic'];
    cover = json['pic'];
    pubdate = json['pubdate'];
    view = json['stat']['view'];
    title = json['title'];
  }
}

class MamberMeta {
  MamberMeta({
    this.cover,
    this.description,
    this.mid,
    this.name,
    this.ptime,
    this.seasonId,
    this.total,
    this.seriesId,
    this.category,
  });

  String? cover;
  String? description;
  int? mid;
  String? name;
  int? ptime;
  int? seasonId;
  int? total;
  int? seriesId;
  int? category;

  MamberMeta.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    description = json['description'];
    mid = json['mid'];
    name = json['name'];
    ptime = json['ptime'];
    seasonId = json['season_id'];
    total = json['total'];
    seriesId = json['series_id'];
    category = json['category'];
  }
}
