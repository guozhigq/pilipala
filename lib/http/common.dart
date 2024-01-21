import 'index.dart';

class CommonHttp {
  static Future unReadDynamic() async {
    var res = await Request().get(Api.getUnreadDynamic,
        data: {'alltype_offset': 0, 'video_offset': '', 'article_offset': 0});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']['dyn_basic_infos']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
