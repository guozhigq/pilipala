import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/bangumi/info.dart';
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
    String? order,
    int? duration,
  }) async {
    var reqData = {
      'search_type': searchType.type,
      'keyword': keyword,
      // 'order_sort': 0,
      // 'user_type': 0,
      'page': page,
      if (order != null) 'order': order,
      if (duration != null) 'duration': duration,
    };
    var res = await Request().get(Api.searchByType, data: reqData);
    if (res.data['code'] == 0 && res.data['data']['numPages'] > 0) {
      Object data;
      try {
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
          case SearchType.media_bangumi:
            data = SearchMBangumiModel.fromJson(res.data['data']);
            break;
          case SearchType.article:
            data = SearchArticleModel.fromJson(res.data['data']);
            break;
        }
        return {
          'status': true,
          'data': data,
        };
      } catch (err) {
        print(err);
      }
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['data']['numPages'] == 0 ? '没有相关数据' : '请求错误 🙅',
      };
    }
  }

  static Future ab2c({int? aid, String? bvid}) async {
    Map<String, dynamic> data = {};
    if (aid != null) {
      data['aid'] = aid;
    } else if (bvid != null) {
      data['bvid'] = bvid;
    }
    var res = await Request().get(Api.ab2c, data: {...data});
    return res.data['data'].first['cid'];
  }

  static Future bangumiInfo({int? seasonId, int? epId}) async {
    Map<String, dynamic> data = {};
    if (seasonId != null) {
      data['season_id'] = seasonId;
    } else if (epId != null) {
      data['ep_id'] = epId;
    }
    var res = await Request().get(Api.bangumiInfo, data: {...data});
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': BangumiInfoModel.fromJson(res.data['result']),
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
