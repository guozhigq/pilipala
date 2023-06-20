import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/search/hot.dart';

class SearchHttp {
  static Future hotSearchList() async {
    var res = await Request().get(Api.hotSearchList);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': HotSearchModel.fromJson(res.data),
      };
    } else {
      return {
        'status': false,
        'date': [],
        'msg': '请求错误 🙅',
      };
    }
  }
}
