import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:brotli/brotli.dart';
import 'package:pilipala/models/live/message.dart';
import 'package:pilipala/utils/binary_writer.dart';

class LiveUtils {
  static List<int> encodeData(String msg, int action) {
    var data = utf8.encode(msg);
    //头部长度固定16
    var length = data.length + 16;
    var buffer = Uint8List(length);

    var writer = BinaryWriter([]);

    //数据包长度
    writer.writeInt(buffer.length, 4);
    //数据包头部长度,固定16
    writer.writeInt(16, 2);

    //协议版本，0=JSON,1=Int32,2=Buffer
    writer.writeInt(0, 2);

    //操作类型
    writer.writeInt(action, 4);

    //数据包头部长度,固定1

    writer.writeInt(1, 4);

    writer.writeBytes(data);

    return writer.buffer;
  }

  static List<LiveMessageModel>? decodeMessage(List<int> data) {
    try {
      //操作类型。3=心跳回应，内容为房间人气值；5=通知，弹幕、广播等全部信息；8=进房回应，空
      int operation = readInt(data, 8, 4);
      //内容
      var body = data.skip(16).toList();
      if (operation == 3) {
        var online = readInt(body, 0, 4);
        final LiveMessageModel liveMsg = LiveMessageModel(
          type: LiveMessageType.online,
          userName: '',
          message: '',
          color: LiveMessageColor.white,
          data: online,
        );
        return [liveMsg];
      } else if (operation == 5) {
        //协议版本。0为JSON，可以直接解析；1为房间人气值,Body为4位Int32；2为压缩过Buffer，需要解压再处理
        int protocolVersion = readInt(data, 6, 2);
        if (protocolVersion == 2) {
          body = zlib.decode(body);
        } else if (protocolVersion == 3) {
          body = brotli.decode(body);
        }

        var text = utf8.decode(body, allowMalformed: true);

        var group =
            text.split(RegExp(r"[\x00-\x1f]+", unicode: true, multiLine: true));
        List<LiveMessageModel> messages = [];
        for (var item
            in group.where((x) => x.length > 2 && x.startsWith('{'))) {
          if (parseMessage(item) is LiveMessageModel) {
            messages.add(parseMessage(item)!);
          }
        }
        return messages;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static LiveMessageModel? parseMessage(String jsonMessage) {
    try {
      var obj = json.decode(jsonMessage);
      var cmd = obj["cmd"].toString();
      if (cmd.contains("DANMU_MSG")) {
        if (obj["info"] != null && obj["info"].length != 0) {
          var message = obj["info"][1].toString();
          var color = asT<int?>(obj["info"][0][3]) ?? 0;
          if (obj["info"][2] != null && obj["info"][2].length != 0) {
            var extra = obj["info"][0][15]['extra'];
            var user = obj["info"][0][15]['user']['base'];
            Map<String, dynamic> extraMap = jsonDecode(extra);
            final int userId = obj["info"][2][0];
            final LiveMessageModel liveMsg = LiveMessageModel(
              type: LiveMessageType.chat,
              userName: user['name'],
              message: message,
              color: color == 0
                  ? LiveMessageColor.white
                  : LiveMessageColor.numberToColor(color),
              face: user['face'],
              uid: userId,
              emots: extraMap['emots'],
            );
            return liveMsg;
          }
        }
      } else if (cmd == "SUPER_CHAT_MESSAGE") {
        if (obj["data"] == null) {
          return null;
        }
        final data = obj["data"];
        final userInfo = data["user_info"];
        final String backgroundBottomColor =
            data["background_bottom_color"].toString();
        final String backgroundColor = data["background_color"].toString();
        final DateTime endTime =
            DateTime.fromMillisecondsSinceEpoch(data["end_time"] * 1000);
        final String face = "${userInfo["face"]}@200w.jpg";
        final String message = data["message"].toString();
        final String price = data["price"];
        final DateTime startTime =
            DateTime.fromMillisecondsSinceEpoch(data["start_time"] * 1000);
        final String userName = userInfo["uname"].toString();

        final LiveMessageModel liveMsg = LiveMessageModel(
          type: LiveMessageType.superChat,
          userName: "SUPER_CHAT_MESSAGE",
          message: "SUPER_CHAT_MESSAGE",
          color: LiveMessageColor.white,
          data: {
            "backgroundBottomColor": backgroundBottomColor,
            "backgroundColor": backgroundColor,
            "endTime": endTime,
            "face": face,
            "message": message,
            "price": price,
            "startTime": startTime,
            "userName": userName,
          },
        );
        return liveMsg;
      } else if (cmd == 'INTERACT_WORD') {
        if (obj["data"] == null) {
          return null;
        }
        final data = obj["data"];
        final String userName = data['uname'];
        final int msgType = data['msg_type'];
        final LiveMessageModel liveMsg = LiveMessageModel(
          type: msgType == 1 ? LiveMessageType.join : LiveMessageType.follow,
          userName: userName,
          message: msgType == 1 ? '进入直播间' : '关注了主播',
          color: LiveMessageColor.white,
        );
        return liveMsg;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  static T? asT<T>(dynamic value) {
    if (value is T) {
      return value;
    }
    return null;
  }

  static int readInt(List<int> buffer, int start, int len) {
    var data = _getByteData(buffer, start, len);
    return _readIntFromByteData(data, len);
  }

  static ByteData _getByteData(List<int> buffer, int start, int len) {
    var bytes =
        Uint8List.fromList(buffer.getRange(start, start + len).toList());
    return ByteData.view(bytes.buffer);
  }

  static int _readIntFromByteData(ByteData data, int len) {
    switch (len) {
      case 1:
        return data.getUint8(0);
      case 2:
        return data.getInt16(0, Endian.big);
      case 4:
        return data.getInt32(0, Endian.big);
      case 8:
        return data.getInt64(0, Endian.big);
      default:
        throw ArgumentError('Invalid length: $len');
    }
  }
}
