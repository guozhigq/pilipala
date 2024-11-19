class InvalidVideoModel {
  final int? id;
  final int? ver;
  final int? aid;
  final String? lastupdate;
  final int? lastupdatets;
  final String? title;
  final String? description;
  final String? pic;
  final int? tid;
  final String? typename;
  final int? created;
  final String? createdAt;
  final String? author;
  final int? mid;
  final String? play;
  final String? coins;
  final String? review;
  final String? videoReview;
  final String? favorites;
  final String? tag;
  final List<String>? tagList;

  InvalidVideoModel({
    this.id,
    this.ver,
    this.aid,
    this.lastupdate,
    this.lastupdatets,
    this.title,
    this.description,
    this.pic,
    this.tid,
    this.typename,
    this.created,
    this.createdAt,
    this.author,
    this.mid,
    this.play,
    this.coins,
    this.review,
    this.videoReview,
    this.favorites,
    this.tag,
    this.tagList,
  });

  factory InvalidVideoModel.fromJson(Map<String, dynamic> json) {
    return InvalidVideoModel(
      id: json['id'],
      ver: json['ver'],
      aid: json['aid'],
      lastupdate: json['lastupdate'],
      lastupdatets: json['lastupdatets'],
      title: json['title'],
      description: json['description'],
      pic: json['pic'],
      tid: json['tid'],
      typename: json['typename'],
      created: json['created'],
      createdAt: json['created_at'],
      author: json['author'],
      mid: json['mid'],
      play: json['play'],
      coins: json['coins'],
      review: json['review'],
      videoReview: json['video_review'],
      favorites: json['favorites'],
      tag: json['tag'],
      tagList: json['tag'].toString().split(',').toList(),
    );
  }
}
