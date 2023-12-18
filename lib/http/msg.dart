import 'package:pilipala/http/api.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/msg/account.dart';
import 'package:pilipala/models/msg/session.dart';
import 'package:pilipala/utils/wbi_sign.dart';

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
      return {
        'status': true,
        'data': SessionDataModel.fromJson(res.data['data']),
      };
    } else {
      return {
        'status': false,
        'date': [],
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
      return {
        'status': true,
        'data': res.data['data']
            .map<AccountListModel>((e) => AccountListModel.fromJson(e))
            .toList(),
      };
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
}
