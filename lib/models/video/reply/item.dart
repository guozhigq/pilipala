import 'content.dart';
import 'member.dart';

class ReplyItemModel {
  ReplyItemModel({
    this.rpid,
    this.oid,
    this.type,
    this.mid,
    this.root,
    this.parent,
    this.dialog,
    this.count,
    this.floor,
    this.state,
    this.fansgrade,
    this.attr,
    this.ctime,
    this.rpidStr,
    this.rootStr,
    this.parentStr,
    this.like,
    this.action,
    this.member,
    this.content,
    this.replies,
    this.assist,
    this.upAction,
    this.invisible,
    this.replyControl,
  });

  int? rpid;
  int? oid;
  int? type;
  int? mid;
  int? root;
  int? parent;
  int? dialog;
  int? count;
  int? floor;
  int? state;
  int? fansgrade;
  int? attr;
  int? ctime;
  String? rpidStr;
  String? rootStr;
  String? parentStr;
  int? like;
  int? action;
  ReplyMember? member;
  ReplyContent? content;
  List? replies;
  int? assist;
  UpAction? upAction;
  bool? invisible;
  ReplyControl? replyControl;

  ReplyItemModel.fromJson(Map<String, dynamic> json) {
    rpid = json['rpid'];
    oid = json['oid'];
    type = json['type'];
    mid = json['mid'];
    root = json['root'];
    parent = json['parent'];
    dialog = json['dialog'];
    count = json['count'];
    floor = json['floor'];
    state = json['state'];
    fansgrade = json['fansgrade'];
    attr = json['attr'];
    ctime = json['ctime'];
    rpidStr = json['rpid_str'];
    rootStr = json['root_str'];
    parentStr = json['parent_str'];
    like = json['like'];
    action = json['action'];
    member = ReplyMember.fromJson(json['member']);
    content = ReplyContent.fromJson(json['content']);
    replies = json['replies'];
    assist = json['assist'];
    upAction = UpAction.fromJson(json['up_action']);
    invisible = json['invisible'];
    replyControl = ReplyControl.fromJson(json['reply_control']);
  }
}

class UpAction {
  UpAction({this.like, this.reply});

  bool? like;
  bool? reply;

  UpAction.fromJson(Map<String, dynamic> json) {
    like = json['like'];
    reply = json['reply'];
  }
}

class ReplyControl {
  ReplyControl({
    this.upReply,
    this.isUpTop,
    this.entryText,
    this.titleText,
    this.time,
    this.location,
  });

  bool? upReply;
  bool? isUpTop;
  String? entryText;
  String? titleText;
  String? time;
  String? location;

  ReplyControl.fromJson(Map<String, dynamic> json) {
    upReply = json['up_reply'];
    isUpTop = json['is_up_top'];
    entryText = json['sub_reply_entry_text'];
    titleText = json['sub_reply_title_text'];
    time = json['time_desc'];
    location = json['location'];
  }
}
