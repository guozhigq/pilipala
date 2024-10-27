import 'dart:convert';
import '../models/bangumi/list.dart';
import 'index.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

class BangumiHttp {
  static Future bangumiList({int? page}) async {
    var res = await Request().get(Api.bangumiList, data: {'page': page});
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': BangumiListDataModel.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future bangumiFollow({int? mid}) async {
    var res = await Request().get(Api.bangumiFollow, data: {'vmid': mid});
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': BangumiListDataModel.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取追番状态
  static Future bangumiStatus({required int seasonId}) async {
    var res = await Request()
        .get('https://www.bilibili.com/bangumi/play/ss$seasonId');
    html_dom.Document document = html_parser.parse(res.data);
    // 查找 id 为 __NEXT_DATA__ 的 script 元素
    html_dom.Element? scriptElement =
        document.querySelector('script#\\__NEXT_DATA__');
    if (scriptElement != null) {
      // 提取 script 元素的内容
      String scriptContent = scriptElement.text;
      final dynamic scriptContentJson = jsonDecode(scriptContent);
      Map followState = scriptContentJson['props']['pageProps']['followState'];
      return {
        'status': true,
        'data': {
          'isFollowed': followState['isFollowed'],
          'followStatus': followState['followStatus']
        }
      };
    } else {
      print('Script element with id "__NEXT_DATA__" not found.');
    }
  }

  // 更新追番状态
  static Future updateBangumiStatus({
    required int seasonId,
    required int status,
  }) async {
    var res = await Request().post(Api.updateBangumiStatus, data: {
      'season_id': seasonId,
      'status': status,
    });
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
}
