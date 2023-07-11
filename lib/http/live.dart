import 'package:pilipala/http/api.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/live/item.dart';
import 'package:pilipala/models/live/room_info.dart';

class LiveHttp {
  static Future liveList(
      {int? vmid, int? pn, int? ps, String? orderType}) async {
    var res = await Request().get(Api.liveList,
        data: {'page': pn, 'page_size': 30, 'platform': 'web'});
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']['list']
            .map<LiveItemModel>((e) => LiveItemModel.fromJson(e))
            .toList()
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future liveRoomInfo({roomId, qn}) async {
    var res = await Request().get(Api.liveRoomInfo, data: {
      'room_id': roomId,
      'protocol': '0, 1',
      'format': '0, 1, 2',
      'codec': '0, 1',
      'qn': qn,
      'platform': 'web',
      'ptype': 8,
      'dolby': 5,
      'panorama': 1,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': RoomInfoModel.fromJson(res.data['data'])};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
