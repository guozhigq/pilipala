import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:pilipala/models/msg/like.dart';
import 'package:pilipala/models/msg/reply.dart';
import 'package:pilipala/models/msg/system.dart';
import '../models/msg/account.dart';
import '../models/msg/session.dart';
import '../utils/wbi_sign.dart';
import 'api.dart';
import 'init.dart';

class MsgHttp {
  // 会话列表
  static Future sessionList({int? endTs}) async {
    Map<String, dynamic> params = {
      'session_type': 1,
      'group_fold': 1,
      'unfollow_fold': 0,
      'sort_rule': 2,
      'build': 0,
      'mobi_app': 'web',
    };
    if (endTs != null) {
      params['end_ts'] = endTs;
    }

    Map signParams = await WbiSign().makSign(params);
    var res = await Request().get(Api.sessionList, data: signParams);
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': SessionDataModel.fromJson(res.data['data']),
        };
      } catch (err) {
        return {
          'status': false,
          'data': [],
          'msg': err.toString(),
        };
      }
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future accountList(uids) async {
    var res = await Request().get(Api.sessionAccountList, data: {
      'uids': uids,
      'build': 0,
      'mobi_app': 'web',
    });
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': res.data['data']
              .map<AccountListModel>((e) => AccountListModel.fromJson(e))
              .toList(),
        };
      } catch (err) {
        print('err🔟: $err');
      }
    } else {
      return {
        'status': false,
        'date': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future sessionMsg({
    int? talkerId,
  }) async {
    Map params = await WbiSign().makSign({
      'talker_id': talkerId,
      'session_type': 1,
      'size': 20,
      'sender_device_id': 1,
      'build': 0,
      'mobi_app': 'web',
    });
    var res = await Request().get(Api.sessionMsg, data: params);
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': SessionMsgDataModel.fromJson(res.data['data']),
        };
      } catch (err) {
        print(err);
      }
    } else {
      return {
        'status': false,
        'date': [],
        'msg': res.data['message'],
      };
    }
  }

  // 消息标记已读
  static Future ackSessionMsg({
    int? talkerId,
    int? ackSeqno,
  }) async {
    String csrf = await Request.getCsrf();
    Map params = await WbiSign().makSign({
      'talker_id': talkerId,
      'session_type': 1,
      'ack_seqno': ackSeqno,
      'build': 0,
      'mobi_app': 'web',
      'csrf_token': csrf,
      'csrf': csrf
    });
    var res = await Request().get(Api.ackSessionMsg, data: params);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {'status': false, 'date': [], 'msg': res.data['message']};
    }
  }

  // 发送私信
  static Future sendMsg({
    required int senderUid,
    required int receiverId,
    int? receiverType,
    int? msgType,
    dynamic content,
  }) async {
    String csrf = await Request.getCsrf();
    var res = await Request().post(
      Api.sendMsg,
      data: {
        'msg[sender_uid]': senderUid,
        'msg[receiver_id]': receiverId,
        'msg[receiver_type]': 1,
        'msg[msg_type]': 1,
        'msg[msg_status]': 0,
        'msg[content]': jsonEncode(content),
        'msg[timestamp]': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'msg[new_face_version]': 1,
        'msg[dev_id]': getDevId(),
        'from_firework': 0,
        'build': 0,
        'mobi_app': 'web',
        'csrf_token': csrf,
        'csrf': csrf,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {'status': false, 'date': [], 'msg': res.data['message']};
    }
  }

  static String getDevId() {
    final List<String> b = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F'
    ];
    final List<String> s = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".split('');
    for (int i = 0; i < s.length; i++) {
      if ('-' == s[i] || '4' == s[i]) {
        continue;
      }
      final int randomInt = Random().nextInt(16);
      if ('x' == s[i]) {
        s[i] = b[randomInt];
      } else {
        s[i] = b[3 & randomInt | 8];
      }
    }
    return s.join();
  }

  static Future removeSession({
    int? talkerId,
  }) async {
    String csrf = await Request.getCsrf();
    Map params = await WbiSign().makSign({
      'talker_id': talkerId,
      'session_type': 1,
      'build': 0,
      'mobi_app': 'web',
      'csrf_token': csrf,
      'csrf': csrf
    });
    var res = await Request().get(Api.removeSession, data: params);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {'status': false, 'date': [], 'msg': res.data['message']};
    }
  }

  static Future unread() async {
    var res = await Request().get(Api.unread);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {'status': false, 'date': [], 'msg': res.data['message']};
    }
  }

  // 回复我的
  static Future messageReply({
    int? id,
    int? replyTime,
  }) async {
    var params = {
      if (id != null) 'id': id,
      if (replyTime != null) 'reply_time': replyTime,
    };
    var res = await Request().get(Api.messageReplyAPi, data: params);
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': MessageReplyModel.fromJson(res.data['data']),
        };
      } catch (err) {
        return {'status': false, 'date': [], 'msg': err.toString()};
      }
    } else {
      return {'status': false, 'date': [], 'msg': res.data['message']};
    }
  }

  // 收到的赞
  static Future messageLike({
    int? id,
    int? likeTime,
  }) async {
    var params = {
      if (id != null) 'id': id,
      if (likeTime != null) 'like_time': likeTime,
    };
    var res = await Request().get(Api.messageLikeAPi, data: params);
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': MessageLikeModel.fromJson(res.data['data']),
        };
      } catch (err) {
        return {'status': false, 'date': [], 'msg': err.toString()};
      }
    } else {
      return {'status': false, 'date': [], 'msg': res.data['message']};
    }
  }

  static Future messageSystem() async {
    var res = await Request().get(Api.messageSystemAPi, data: {
      'csrf': await Request.getCsrf(),
      'page_size': 20,
      'build': 0,
      'mobi_app': 'web',
    });
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': res.data['data']['system_notify_list']
              .map<MessageSystemModel>((e) => MessageSystemModel.fromJson(e))
              .toList(),
        };
      } catch (err) {
        return {'status': false, 'date': [], 'msg': err.toString()};
      }
    } else {
      return {'status': false, 'date': [], 'msg': res.data['message']};
    }
  }

  // 系统消息标记已读
  static Future systemMarkRead(int cursor) async {
    String csrf = await Request.getCsrf();
    var res = await Request().get(Api.systemMarkRead, data: {
      'csrf': csrf,
      'cursor': cursor,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
      };
    } else {
      return {
        'status': false,
        'msg': res.data['message'],
      };
    }
  }
}
