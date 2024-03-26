class LatestDataModel {
  LatestDataModel({
    this.url,
    this.tagName,
    this.createdAt,
    this.assets,
    this.body,
  });

  String? url;
  String? tagName;
  String? createdAt;
  List? assets;
  String? body;

  LatestDataModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    tagName = json['tag_name'];
    createdAt = json['created_at'];
    assets = json['assets'] != null
        ? json['assets'].map<AssetItem>((e) => AssetItem.fromJson(e)).toList()
        : [];
    body = json['body'];
  }
}

class AssetItem {
  AssetItem({
    this.url,
    this.name,
    this.size,
    this.downloadCount,
    this.downloadUrl,
  });

  String? url;
  String? name;
  int? size;
  int? downloadCount;
  String? downloadUrl;

  AssetItem.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
    size = json['size'];
    downloadCount = json['download_count'];
    downloadUrl = json['browser_download_url'];
  }
}
