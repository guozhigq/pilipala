class SearchAllModel {
  SearchAllModel({this.topTList});

  Map? topTList;

  SearchAllModel.fromJson(Map<String, dynamic> json) {
    topTList = json['top_tlist'];
  }
}
