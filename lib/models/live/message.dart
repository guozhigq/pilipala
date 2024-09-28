class LiveMessageModel {
  // 消息类型
  final LiveMessageType type;

  // 用户名
  final String userName;

  // 信息
  final String? message;

  // 数据
  final dynamic data;

  final String? face;
  final int? uid;
  final Map<String, dynamic>? emots;

  // 颜色
  final LiveMessageColor color;

  LiveMessageModel({
    required this.type,
    required this.userName,
    required this.message,
    required this.color,
    this.data,
    this.face,
    this.uid,
    this.emots,
  });
}

class LiveSuperChatMessage {
  final String backgroundBottomColor;
  final String backgroundColor;
  final DateTime endTime;
  final String face;
  final String message;
  final String price;
  final DateTime startTime;
  final String userName;

  LiveSuperChatMessage({
    required this.backgroundBottomColor,
    required this.backgroundColor,
    required this.endTime,
    required this.face,
    required this.message,
    required this.price,
    required this.startTime,
    required this.userName,
  });
}

enum LiveMessageType {
  // 普通留言
  chat,
  // 醒目留言
  superChat,
  //
  online,
  // 加入
  join,
  // 关注
  follow,
}

class LiveMessageColor {
  final int r, g, b;
  LiveMessageColor(this.r, this.g, this.b);
  static LiveMessageColor get white => LiveMessageColor(255, 255, 255);
  static LiveMessageColor numberToColor(int intColor) {
    var obj = intColor.toRadixString(16);

    LiveMessageColor color = LiveMessageColor.white;
    if (obj.length == 4) {
      obj = "00$obj";
    }
    if (obj.length == 6) {
      var R = int.parse(obj.substring(0, 2), radix: 16);
      var G = int.parse(obj.substring(2, 4), radix: 16);
      var B = int.parse(obj.substring(4, 6), radix: 16);

      color = LiveMessageColor(R, G, B);
    }
    if (obj.length == 8) {
      var R = int.parse(obj.substring(2, 4), radix: 16);
      var G = int.parse(obj.substring(4, 6), radix: 16);
      var B = int.parse(obj.substring(6, 8), radix: 16);
      //var A = int.parse(obj.substring(0, 2), radix: 16);
      color = LiveMessageColor(R, G, B);
    }

    return color;
  }

  @override
  String toString() {
    return "#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}";
  }
}
