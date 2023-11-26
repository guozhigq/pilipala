import 'dart:ffi';

import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/models/follow/result.dart';
import 'package:pilipala/models/member/archive.dart';
import 'package:pilipala/models/member/coin.dart';
import 'package:pilipala/models/member/info.dart';
import 'package:pilipala/models/member/seasons.dart';
import 'package:pilipala/models/member/tags.dart';
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
      extra: {'ua': 'pc'},
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
    String? keyword,
    String order = 'pubdate',
    bool orderAvoided = true,
  }) async {
    Map params = await WbiSign().makSign({
      'mid': mid,
      'ps': ps,
      'tid': tid,
      'pn': pn,
      'keyword': keyword ?? '',
      'order': order,
      'platform': 'web',
      'web_location': 1550101,
      'order_avoided': orderAvoided
    });
    var res = await Request().get(
      Api.memberArchive,
      data: params,
      extra: {'ua': 'pc'},
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

  // 用户动态
  static Future memberDynamic({String? offset, int? mid}) async {
    var res = await Request().get(Api.memberDynamic, data: {
      'offset': offset ?? '',
      'host_mid': mid,
      'timezone_offset': '-480',
      'features': 'itemOpusStyle',
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
        'msg': res.data['message'],
      };
    }
  }

  // 搜索用户动态
  static Future memberDynamicSearch({int? pn, int? ps, int? mid}) async {
    var res = await Request().get(Api.memberDynamic, data: {
      'keyword': '海拔',
      'mid': mid,
      'pn': pn,
      'ps': ps,
      'platform': 'web'
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
        'msg': res.data['message'],
      };
    }
  }

  // 查询分组
  static Future followUpTags() async {
    var res = await Request().get(Api.followUpTag);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']
            .map<MemberTagItemModel>((e) => MemberTagItemModel.fromJson(e))
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

  // 设置分组
  static Future addUsers(int? fids, String? tagids) async {
    var res = await Request().post(Api.addUsers, queryParameters: {
      'fids': fids,
      'tagids': tagids ?? '0',
      'csrf': await Request.getCsrf(),
    }, data: {
      'cross_domain': true
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': [], 'msg': '操作成功'};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 获取某分组下的up
  static Future followUpGroup(
    int? mid,
    int? tagid,
    int? pn,
    int? ps,
  ) async {
    var res = await Request().get(Api.followUpGroup, data: {
      'mid': mid,
      'tagid': tagid,
      'pn': pn,
      'ps': ps,
    });
    if (res.data['code'] == 0) {
      // FollowItemModel
      return {
        'status': true,
        'data': res.data['data']
            .map<FollowItemModel>((e) => FollowItemModel.fromJson(e))
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

  // 获取up置顶
  static Future getTopVideo(String? vmid) async {
    var res = await Request().get(Api.getTopVideoApi);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']
            .map<MemberTagItemModel>((e) => MemberTagItemModel.fromJson(e))
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

  // 获取uo专栏
  static Future getMemberSeasons(int? mid, int? pn, int? ps) async {
    var res = await Request().get(Api.getMemberSeasonsApi, data: {
      'mid': mid,
      'page_num': pn,
      'page_size': ps,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MemberSeasonsDataModel.fromJson(res.data['data']['items_lists'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 最近投币
  static Future getRecentCoinVideo({required int mid}) async {
    Map params = await WbiSign().makSign({
      'mid': mid,
      'gaia_source': 'main_web',
      'web_location': 333.999,
    });
    var res = await Request().get(
      Api.getRecentCoinVideoApi,
      data: {
        'vmid': mid,
        'gaia_source': 'main_web',
        'web_location': 333.999,
        'w_rid': params['w_rid'],
        'wts': params['wts'],
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data']
            .map<MemberCoinsDataModel>((e) => MemberCoinsDataModel.fromJson(e))
            .toList(),
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 最近点赞
  static Future getRecentLikeVideo({required int mid}) async {
    Map params = await WbiSign().makSign({
      'mid': mid,
      'gaia_source': 'main_web',
      'web_location': 333.999,
    });
    var res = await Request().get(
      Api.getRecentLikeVideoApi,
      data: {
        'vmid': mid,
        'gaia_source': 'main_web',
        'web_location': 333.999,
        'w_rid': params['w_rid'],
        'wts': params['wts'],
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': MemberSeasonsDataModel.fromJson(res.data['data']['items_lists'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  // 查看某个专栏
  static Future getSeasonDetail({
    required int mid,
    required int seasonId,
    bool sortReverse = false,
    required int pn,
    required int ps,
  }) async {
    var res = await Request().get(
      Api.getSeasonDetailApi,
      data: {
        'mid': mid,
        'season_id': seasonId,
        'sort_reverse': sortReverse,
        'page_num': pn,
        'page_size': ps,
      },
    );
    if (res.data['code'] == 0) {
      try {
        return {
          'status': true,
          'data': MemberSeasonsList.fromJson(res.data['data'])
        };
      } catch (err) {
        print(err);
      }
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
