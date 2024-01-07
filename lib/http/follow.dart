import '../models/follow/result.dart';
import 'index.dart';

class FollowHttp {
  static Future followings(
      {int? vmid, int? pn, int? ps, String? orderType}) async {
    var res = await Request().get(Api.followings, data: {
      'vmid': vmid,
      'pn': pn,
      'ps': ps,
      'order': 'desc',
      'order_type': orderType,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': FollowDataModel.fromJson(res.data['data'])
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
