import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/search/hot.dart';
import 'package:pilipala/models/search/suggest.dart';

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

  // 获取搜索建议
  static Future searchSuggest({required term}) async {
    var res = await Request().get(Api.serachSuggest,
        data: {'term': term, 'main_ver': 'v1', 'highlight': term});
    if (res.data['code'] == 0) {
      res.data['result']['term'] = term;
      return {
        'status': true,
        'data': SearchSuggestModel.fromJson(res.data['result']),
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
