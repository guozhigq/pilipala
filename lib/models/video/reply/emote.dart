class EmoteModelData {
  final List<PackageItem>? packages;

  EmoteModelData({
    required this.packages,
  });

  factory EmoteModelData.fromJson(Map<String, dynamic> jsonRes) {
    final List<PackageItem>? packages =
        jsonRes['packages'] is List ? <PackageItem>[] : null;
    if (packages != null) {
      for (final dynamic item in jsonRes['packages']!) {
        if (item != null) {
          try {
            packages.add(PackageItem.fromJson(item));
          } catch (_) {}
        }
      }
    }
    return EmoteModelData(
      packages: packages,
    );
  }
}

class PackageItem {
  final int? id;
  final String? text;
  final String? url;
  final int? mtime;
  final int? type;
  final int? attr;
  final Meta? meta;
  final List<Emote>? emote;

  PackageItem({
    required this.id,
    required this.text,
    required this.url,
    required this.mtime,
    required this.type,
    required this.attr,
    required this.meta,
    required this.emote,
  });

  factory PackageItem.fromJson(Map<String, dynamic> jsonRes) {
    final List<Emote>? emote = jsonRes['emote'] is List ? <Emote>[] : null;
    if (emote != null) {
      for (final dynamic item in jsonRes['emote']!) {
        if (item != null) {
          try {
            emote.add(Emote.fromJson(item));
          } catch (_) {}
        }
      }
    }
    return PackageItem(
      id: jsonRes['id'],
      text: jsonRes['text'],
      url: jsonRes['url'],
      mtime: jsonRes['mtime'],
      type: jsonRes['type'],
      attr: jsonRes['attr'],
      meta: Meta.fromJson(jsonRes['meta']),
      emote: emote,
    );
  }
}

class Meta {
  final int? size;
  final List<String>? suggest;

  Meta({
    required this.size,
    required this.suggest,
  });

  factory Meta.fromJson(Map<String, dynamic> jsonRes) => Meta(
        size: jsonRes['size'],
        suggest: jsonRes['suggest'] is List ? <String>[] : null,
      );
}

class Emote {
  final int? id;
  final int? packageId;
  final String? text;
  final String? url;
  final int? mtime;
  final int? type;
  final int? attr;
  final Meta? meta;
  final dynamic activity;

  Emote({
    required this.id,
    required this.packageId,
    required this.text,
    required this.url,
    required this.mtime,
    required this.type,
    required this.attr,
    required this.meta,
    required this.activity,
  });

  factory Emote.fromJson(Map<String, dynamic> jsonRes) => Emote(
        id: jsonRes['id'],
        packageId: jsonRes['package_id'],
        text: jsonRes['text'],
        url: jsonRes['url'],
        mtime: jsonRes['mtime'],
        type: jsonRes['type'],
        attr: jsonRes['attr'],
        meta: Meta.fromJson(jsonRes['meta']),
        activity: jsonRes['activity'],
      );
}
