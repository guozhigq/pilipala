import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/member/archive.dart';
import 'package:pilipala/models/member/info.dart';
import 'package:pilipala/utils/wbi_sign.dart';

class MemberHttp {
  static Future memberInfo({
    int? mid,
    String token = '',
  }) async {
    Map params = await WbiSign().makSign({
      'mid': mid,
      'token': token,
      'platform': 'web',
      'web_location': 1550101,
    });
    var res = await Request().get(
      Api.memberInfo,
      data: params,
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MemberInfoModel.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future memberStat({int? mid}) async {
    var res = await Request().get(Api.userStat, data: {'vmid': mid});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future memberCardInfo({int? mid}) async {
    var res = await Request()
        .get(Api.memberCardInfo, data: {'mid': mid, 'photo': true});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future memberArchive({
    int? mid,
    int ps = 30,
    int tid = 0,
    int? pn,
    String keyword = '',
    String order = 'pubdate',
    bool orderAvoided = true,
  }) async {
    Map params = await WbiSign().makSign({
      'mid': mid,
      'ps': ps,
      'tid': tid,
      'pn': pn,
      'keyword': keyword,
      'order': order,
      'platform': 'web',
      'web_location': 1550101,
      'order_avoided': orderAvoided
    });
    var res = await Request().get(
      Api.memberArchive,
      data: params,
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MemberArchiveDataModel.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
