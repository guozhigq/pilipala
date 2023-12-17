import 'dart:convert';

import 'package:pilipala/models/msg/account.dart';

class SessionDataModel {
  SessionDataModel({
    this.sessionList,
    this.hasMore,
  });

  List? sessionList;
  int? hasMore;

  SessionDataModel.fromJson(Map<String, dynamic> json) {
    sessionList = json['session_list']
        ?.map<SessionList>((e) => SessionList.fromJson(e))
        .toList();
    hasMore = json['has_more'];
  }
}

class SessionList {
  SessionList({
    this.talkerId,
    this.sessionType,
    this.atSeqno,
    this.topTs,
    this.groupName,
    this.groupCover,
    this.isFollow,
    this.isDnd,
    this.ackSeqno,
    this.ackTs,
    this.sessionTs,
    this.unreadCount,
    this.lastMsg,
    this.groupType,
    this.canFold,
    this.status,
    this.maxSeqno,
    this.newPushMsg,
    this.setting,
    this.isGuardian,
    this.isIntercept,
    this.isTrust,
    this.systemMsgType,
    this.liveStatus,
    this.bizMsgUnreadCount,
    // this.userLabel,
  });

  int? talkerId;
  int? sessionType;
  int? atSeqno;
  int? topTs;
  String? groupName;
  String? groupCover;
  int? isFollow;
  int? isDnd;
  int? ackSeqno;
  int? ackTs;
  int? sessionTs;
  int? unreadCount;
  LastMsg? lastMsg;
  int? groupType;
  int? canFold;
  int? status;
  int? maxSeqno;
  int? newPushMsg;
  int? setting;
  int? isGuardian;
  int? isIntercept;
  int? isTrust;
  int? systemMsgType;
  int? liveStatus;
  int? bizMsgUnreadCount;
  // int? userLabel;
  AccountListModel? accountInfo;

  SessionList.fromJson(Map<String, dynamic> json) {
    talkerId = json["talker_id"];
    sessionType = json["session_type"];
    atSeqno = json["at_seqno"];
    topTs = json["top_ts"];
    groupName = json["group_name"];
    groupCover = json["group_cover"];
    isFollow = json["is_follow"];
    isDnd = json["is_dnd"];
    ackSeqno = json["ack_seqno"];
    ackTs = json["ack_ts"];
    sessionTs = json["session_ts"];
    unreadCount = json["unread_count"];
    lastMsg =
        json["last_msg"] != null ? LastMsg.fromJson(json["last_msg"]) : null;
    groupType = json["group_type"];
    canFold = json["can_fold"];
    status = json["status"];
    maxSeqno = json["max_seqno"];
    newPushMsg = json["new_push_msg"];
    setting = json["setting"];
    isGuardian = json["is_guardian"];
    isIntercept = json["is_intercept"];
    isTrust = json["is_trust"];
    systemMsgType = json["system_msg_type"];
    liveStatus = json["live_status"];
    bizMsgUnreadCount = json["biz_msg_unread_count"];
    // userLabel = json["user_label"];
  }
}

class LastMsg {
  LastMsg({
    this.senderIid,
    this.receiverType,
    this.receiverId,
    this.msgType,
    this.content,
    this.msgSeqno,
    this.timestamp,
    this.atUids,
    this.msgKey,
    this.msgStatus,
    this.notifyCode,
    this.newFaceVersion,
  });

  int? senderIid;
  int? receiverType;
  int? receiverId;
  int? msgType;
  Map? content;
  int? msgSeqno;
  int? timestamp;
  String? atUids;
  int? msgKey;
  int? msgStatus;
  String? notifyCode;
  int? newFaceVersion;

  LastMsg.fromJson(Map<String, dynamic> json) {
    senderIid = json['sender_uid'];
    receiverType = json['receiver_type'];
    receiverId = json['receiver_id'];
    msgType = json['msg_type'];
    content = jsonDecode(json['content']);
    msgSeqno = json['msg_seqno'];
    timestamp = json['timestamp'];
    atUids = json['at_uids'];
    msgKey = json['msg_key'];
    msgStatus = json['msg_status'];
    notifyCode = json['notify_code'];
    newFaceVersion = json['new_face_version'];
  }
}

class SessionMsgDataModel {
  SessionMsgDataModel({
    this.messages,
    this.hasMore,
    this.minSeqno,
    this.maxSeqno,
    this.eInfos,
  });

  List<MessageItem>? messages;
  int? hasMore;
  int? minSeqno;
  int? maxSeqno;
  List? eInfos;

  SessionMsgDataModel.fromJson(Map<String, dynamic> json) {
    messages = json['messages']
        .map<MessageItem>((e) => MessageItem.fromJson(e))
        .toList();
    hasMore = json['has_more'];
    minSeqno = json['min_seqno'];
    maxSeqno = json['max_seqno'];
    eInfos = json['e_infos'];
  }
}

class MessageItem {
  MessageItem({
    this.senderUid,
    this.receiverType,
    this.receiverId,
    this.msgType,
    this.content,
    this.msgSeqno,
    this.timestamp,
    this.atUids,
    this.msgKey,
    this.msgStatus,
    this.notifyCode,
    this.newFaceVersion,
  });

  int? senderUid;
  int? receiverType;
  int? receiverId;
  int? msgType;
  Map? content;
  int? msgSeqno;
  int? timestamp;
  List? atUids;
  int? msgKey;
  int? msgStatus;
  String? notifyCode;
  int? newFaceVersion;

  MessageItem.fromJson(Map<String, dynamic> json) {
    senderUid = json['sender_uid'];
    receiverType = json['receiver_type'];
    receiverId = json['receiver_id'];
    // 1 文本 2 图片 18 系统提示 10 系统通知
    msgType = json['msg_type'];
    content = jsonDecode(json['content']);
    msgSeqno = json['msg_seqno'];
    timestamp = json['timestamp'];
    atUids = json['at_uids'];
    msgKey = json['msg_key'];
    msgStatus = json['msg_status'];
    notifyCode = json['notify_code'];
    newFaceVersion = json['new_face_version'];
  }
}
