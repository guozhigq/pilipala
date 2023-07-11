class RoomInfoModel {
  RoomInfoModel({
    this.roomId,
    this.liveStatus,
    this.liveTime,
    this.playurlInfo,
  });
  int? roomId;
  int? liveStatus;
  int? liveTime;
  PlayurlInfo? playurlInfo;

  RoomInfoModel.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    liveStatus = json['live_status'];
    liveTime = json['live_time'];
    playurlInfo = PlayurlInfo.fromJson(json['playurl_info']);
  }
}

class PlayurlInfo {
  PlayurlInfo({
    this.playurl,
  });

  Playurl? playurl;

  PlayurlInfo.fromJson(Map<String, dynamic> json) {
    playurl = Playurl.fromJson(json['playurl']);
  }
}

class Playurl {
  Playurl({
    this.cid,
    this.gQnDesc,
    this.stream,
  });

  int? cid;
  List<GQnDesc>? gQnDesc;
  List<Streams>? stream;

  Playurl.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    gQnDesc =
        json['g_qn_desc'].map<GQnDesc>((e) => GQnDesc.fromJson(e)).toList();
    stream = json['stream'].map<Streams>((e) => Streams.fromJson(e)).toList();
  }
}

class GQnDesc {
  GQnDesc({
    this.qn,
    this.desc,
    this.hdrDesc,
    this.attrDesc,
  });

  int? qn;
  String? desc;
  String? hdrDesc;
  String? attrDesc;

  GQnDesc.fromJson(Map<String, dynamic> json) {
    qn = json['qn'];
    desc = json['desc'];
    hdrDesc = json['hedr_desc'];
    attrDesc = json['attr_desc'];
  }
}

class Streams {
  Streams({
    this.protocolName,
    this.format,
  });

  String? protocolName;
  List<FormatItem>? format;

  Streams.fromJson(Map<String, dynamic> json) {
    protocolName = json['protocol_name'];
    format =
        json['format'].map<FormatItem>((e) => FormatItem.fromJson(e)).toList();
  }
}

class FormatItem {
  FormatItem({
    this.formatName,
    this.codec,
  });

  String? formatName;
  List<CodecItem>? codec;

  FormatItem.fromJson(Map<String, dynamic> json) {
    formatName = json['format_name'];
    codec = json['codec'].map<CodecItem>((e) => CodecItem.fromJson(e)).toList();
  }
}

class CodecItem {
  CodecItem({
    this.codecName,
    this.currentQn,
    this.acceptQn,
    this.baseUrl,
    this.urlInfo,
    this.hdrQn,
    this.dolbyType,
    this.attrName,
  });

  String? codecName;
  int? currentQn;
  List? acceptQn;
  String? baseUrl;
  List<UrlInfoItem>? urlInfo;
  String? hdrQn;
  int? dolbyType;
  String? attrName;

  CodecItem.fromJson(Map<String, dynamic> json) {
    codecName = json['codec_name'];
    currentQn = json['current_qn'];
    acceptQn = json['accept_qn'];
    baseUrl = json['base_url'];
    urlInfo = json['url_info']
        .map<UrlInfoItem>((e) => UrlInfoItem.fromJson(e))
        .toList();
    hdrQn = json['hdr_n'];
    dolbyType = json['dolby_type'];
    attrName = json['attr_name'];
  }
}

class UrlInfoItem {
  UrlInfoItem({
    this.host,
    this.extra,
    this.streamTtl,
  });

  String? host;
  String? extra;
  int? streamTtl;

  UrlInfoItem.fromJson(Map<String, dynamic> json) {
    host = json['host'];
    extra = json['extra'];
    streamTtl = json['stream_ttl'];
  }
}
