import 'package:pilipala/models/video/reply/item.dart';

import 'config.dart';
import 'page.dart';
import 'upper.dart';

class ReplyData {
  ReplyData({
    this.cursor,
    this.config,
    this.replies,
    this.topReplies,
    this.upper,
  });

  ReplyCursor? cursor;
  ReplyConfig? config;
  late List<ReplyItemModel>? replies;
  late List<ReplyItemModel>? topReplies;
  ReplyUpper? upper;

  ReplyData.fromJson(Map<String, dynamic> json) {
    cursor = ReplyCursor.fromJson(json['cursor']);
    config = ReplyConfig.fromJson(json['config']);
    replies = json['replies'] != null
        ? json['replies']
            .map<ReplyItemModel>(
                (item) => ReplyItemModel.fromJson(item, json['upper']['mid']))
            .toList()
        : [];
    topReplies = json['top_replies'] != null
        ? json['top_replies']
            .map<ReplyItemModel>((item) => ReplyItemModel.fromJson(
                item, json['upper']['mid'],
                isTopStatus: true))
            .toList()
        : [];
    upper = ReplyUpper.fromJson(json['upper']);
  }
}

class ReplyCursor {
  ReplyCursor({
    this.isBegin,
    this.prev,
    this.next,
    this.isEnd,
    this.mode,
    this.modeText,
    this.allCount,
    this.supportMode,
    this.name,
    this.paginationReply,
    this.sessionId,
  });

  bool? isBegin;
  int? prev;
  int? next;
  bool? isEnd;
  int? mode;
  String? modeText;
  int? allCount;
  List<int>? supportMode;
  String? name;
  PaginationReply? paginationReply;
  String? sessionId;

  ReplyCursor.fromJson(Map<String, dynamic> json) {
    isBegin = json['is_begin'];
    prev = json['prev'];
    next = json['next'];
    isEnd = json['is_end'];
    mode = json['mode'];
    modeText = json['mode_text'];
    allCount = json['all_count'];
    supportMode = json['support_mode'].cast<int>();
    name = json['name'];
    paginationReply = json['pagination_reply'] != null
        ? PaginationReply.fromJson(json['pagination_reply'])
        : null;
    sessionId = json['session_id'];
  }
}

class PaginationReply {
  PaginationReply({
    this.nextOffset,
    this.prevOffset,
  });
  String? nextOffset;
  String? prevOffset;
  PaginationReply.fromJson(Map<String, dynamic> json) {
    nextOffset = json['next_offset'];
    prevOffset = json['prev_offset'];
  }
}

class ReplyReplyData {
  ReplyReplyData({
    this.page,
    this.config,
    this.replies,
    this.topReplies,
    this.upper,
  });

  ReplyPage? page;
  ReplyConfig? config;
  late List<ReplyItemModel>? replies;
  late List<ReplyItemModel>? topReplies;
  ReplyUpper? upper;

  ReplyReplyData.fromJson(Map<String, dynamic> json) {
    page = ReplyPage.fromJson(json['page']);
    config = ReplyConfig.fromJson(json['config']);
    replies = json['replies'] != null
        ? json['replies']
            .map<ReplyItemModel>(
                (item) => ReplyItemModel.fromJson(item, json['upper']['mid']))
            .toList()
        : [];
    topReplies = json['top_replies'] != null
        ? json['top_replies']
            .map<ReplyItemModel>((item) => ReplyItemModel.fromJson(
                item, json['upper']['mid'],
                isTopStatus: true))
            .toList()
        : [];
    upper = ReplyUpper.fromJson(json['upper']);
  }
}
