class AiConclusionModel {
  AiConclusionModel({
    this.code,
    this.modelResult,
    this.stid,
    this.status,
    this.likeNum,
    this.dislikeNum,
  });

  int? code;
  ModelResult? modelResult;
  String? stid;
  int? status;
  int? likeNum;
  int? dislikeNum;

  AiConclusionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    modelResult = ModelResult.fromJson(json['model_result']);
    stid = json['stid'];
    status = json['status'];
    likeNum = json['like_num'];
    dislikeNum = json['dislike_num'];
  }
}

class ModelResult {
  ModelResult({
    this.resultType,
    this.summary,
    this.outline,
  });

  int? resultType;
  String? summary;
  List<OutlineItem>? outline;

  ModelResult.fromJson(Map<String, dynamic> json) {
    resultType = json['result_type'];
    summary = json['summary'];
    outline = json['result_type'] == 2
        ? json['outline']
            .map<OutlineItem>((e) => OutlineItem.fromJson(e))
            .toList()
        : <OutlineItem>[];
  }
}

class OutlineItem {
  OutlineItem({
    this.title,
    this.partOutline,
  });

  String? title;
  List<PartOutline>? partOutline;

  OutlineItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    partOutline = json['part_outline']
        .map<PartOutline>((e) => PartOutline.fromJson(e))
        .toList();
  }
}

class PartOutline {
  PartOutline({
    this.timestamp,
    this.content,
  });

  int? timestamp;
  String? content;

  PartOutline.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    content = json['content'];
  }
}
