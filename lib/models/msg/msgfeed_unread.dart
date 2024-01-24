class MsgFeedUnread {
  MsgFeedUnread({
    this.at = 0,
    this.chat = 0,
    this.like = 0,
    this.reply = 0,
    this.sys_msg = 0,
    this.up = 0,
  });

  int at = 0;
  int chat = 0;
  int like = 0;
  int reply = 0;
  int sys_msg = 0;
  int up = 0;

  MsgFeedUnread.fromJson(Map<String, dynamic> json) {
    at = json['at'] ?? 0;
    chat = json['chat'] ?? 0;
    like = json['like'] ?? 0;
    reply = json['reply'] ?? 0;
    sys_msg = json['sys_msg'] ?? 0;
    up = json['up'] ?? 0;
  }
}
