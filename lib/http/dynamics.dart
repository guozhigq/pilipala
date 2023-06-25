import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/dynamics/result.dart';

class DynamicsHttp {
  static Future followDynamic({
    String? type,
    int? page,
    String? offset,
  }) async {
    var res = await Request().get(Api.followDynamic, data: {
      'type': type ?? 'all',
      'page': page ?? 1,
      'timezone_offset': '-480',
      'offset': page == 1 ? '' : offset,
      'features': 'itemOpusStyle'
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': DynamicsDataModel.fromJson(res.data['data']),
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': '请求错误 🙅',
      };
    }
  }
}
