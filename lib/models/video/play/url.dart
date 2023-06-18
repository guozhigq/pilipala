class PlayUrlModel {
  PlayUrlModel({
    this.from,
    this.result,
    this.message,
    this.quality,
    this.format,
    this.timeLength,
    this.acceptFormat,
    this.acceptDesc,
    this.acceptQuality,
    this.videoCodecid,
    this.seekParam,
    this.seekType,
    this.dash,
    this.supportFormats,
    // this.highFormat,
    this.lastPlayTime,
    this.lastPlayCid,
  });

  String? from;
  String? result;
  String? message;
  int? quality;
  String? format;
  int? timeLength;
  String? acceptFormat;
  List<dynamic>? acceptDesc;
  List<dynamic>? acceptQuality;
  int? videoCodecid;
  String? seekParam;
  String? seekType;
  Dash? dash;
  List? supportFormats;
  // String? highFormat;
  int? lastPlayTime;
  int? lastPlayCid;

  PlayUrlModel.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    result = json['result'];
    message = json['message'];
    quality = json['quality'];
    format = json['format'];
    timeLength = json['timelength'];
    acceptFormat = json['accept_format'];
    acceptDesc = json['accept_description'];
    acceptQuality = json['accept_quality'];
    videoCodecid = json['video_codecid'];
    seekParam = json['seek_param'];
    seekType = json['seek_type'];
    dash = Dash.fromJson(json['dash']);
    supportFormats = json['support_formats'];
    lastPlayTime = json['last_play_time'];
    lastPlayCid = json['last_play_cid'];
  }
}

class Dash {
  Dash({
    this.duration,
    this.minBufferTime,
    this.video,
    this.audio,
    this.dolby,
    this.flac,
  });

  int? duration;
  double? minBufferTime;
  List<VideoItem>? video;
  List<AudioItem>? audio;
  Map? dolby;
  String? flac;

  Dash.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    minBufferTime = json['minBufferTime'];
    video = json['video'].map<VideoItem>((e) => VideoItem.fromJson(e)).toList();
    audio = json['audio'].map<AudioItem>((e) => AudioItem.fromJson(e)).toList();
    dolby = json['dolby'];
    flac = json['flac'] ?? '';
  }
}

class VideoItem {
  VideoItem({
    this.id,
    this.baseUrl,
    this.backupUrl,
    this.bandWidth,
    this.mimeType,
    this.codecs,
    this.width,
    this.height,
    this.frameRate,
    this.sar,
    this.startWithSap,
    this.segmentBase,
    this.codecid,
  });

  int? id;
  String? baseUrl;
  String? backupUrl;
  int? bandWidth;
  String? mimeType;
  String? codecs;
  int? width;
  int? height;
  String? frameRate;
  String? sar;
  int? startWithSap;
  Map? segmentBase;
  int? codecid;

  VideoItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    baseUrl = json['baseUrl'];
    backupUrl = json['backupUrl'].toList().first;
    bandWidth = json['bandWidth'];
    mimeType = json['mime_type'];
    codecs = json['codecs'];
    width = json['width'];
    height = json['height'];
    frameRate = json['frameRate'];
    sar = json['sar'];
    startWithSap = json['startWithSap'];
    segmentBase = json['segmentBase'];
    codecid = json['codecid'];
  }
}

class AudioItem {
  AudioItem({
    this.id,
    this.baseUrl,
    this.backupUrl,
    this.bandWidth,
    this.mimeType,
    this.codecs,
    this.width,
    this.height,
    this.frameRate,
    this.sar,
    this.startWithSap,
    this.segmentBase,
    this.codecid,
  });

  int? id;
  String? baseUrl;
  String? backupUrl;
  int? bandWidth;
  String? mimeType;
  String? codecs;
  int? width;
  int? height;
  String? frameRate;
  String? sar;
  int? startWithSap;
  Map? segmentBase;
  int? codecid;

  AudioItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    baseUrl = json['baseUrl'];
    backupUrl = json['backupUrl'].toList().first;
    bandWidth = json['bandWidth'];
    mimeType = json['mime_type'];
    codecs = json['codecs'];
    width = json['width'];
    height = json['height'];
    frameRate = json['frameRate'];
    sar = json['sar'];
    startWithSap = json['startWithSap'];
    segmentBase = json['segmentBase'];
    codecid = json['codecid'];
  }
}
