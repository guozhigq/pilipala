import 'dart:developer';

import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/models/search/hot.dart';
import 'package:pilipala/models/search/result.dart';
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
        'data': [],
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
        'data': [],
        'msg': '请求错误 🙅',
      };
    }
  }

  // 分类搜索
  static Future searchByType({
    required SearchType searchType,
    required String keyword,
    required page,
  }) async {
    var res = await Request().get(Api.searchByType, data: {
      'search_type': searchType.type,
      'keyword': keyword,
      'order_sort': 0,
      'user_type': 0,
      'page': page
    });
    if (res.data['code'] == 0 && res.data['data']['numPages'] > 0) {
      var data;
      switch (searchType) {
        case SearchType.video:
          data = SearchVideoModel.fromJson(res.data['data']);
          break;
        case SearchType.live_room:
          data = SearchLiveModel.fromJson(res.data['data']);
          break;
        case SearchType.bili_user:
          data = SearchUserModel.fromJson(res.data['data']);
          break;
      }
      return {
        'status': true,
        'data': data,
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['data']['numPages'] == 0 ? '没有相关数据' : '请求错误 🙅',
      };
    }
  }
}
