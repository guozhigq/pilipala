import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../common/constants.dart';
import '../models/model_hot_video_item.dart';
import '../models/user/fav_detail.dart';
import '../models/user/fav_folder.dart';
import '../models/user/history.dart';
import '../models/user/info.dart';
import '../models/user/stat.dart';
import '../models/user/sub_detail.dart';
import '../models/user/sub_folder.dart';
import 'api.dart';
import 'init.dart';

class UserHttp {
  static Future<dynamic> userStat({required int mid}) async {
    var res = await Request().get(Api.userStat, data: {'vmid': mid});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false};
    }
  }

  static Future<dynamic> userInfo() async {
    var res = await Request().get(Api.userInfo);
    if (res.data['code'] == 0) {
      UserInfoData data = UserInfoData.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<dynamic> userStatOwner() async {
    var res = await Request().get(Api.userStatOwner);
    if (res.data['code'] == 0) {
      UserStat data = UserStat.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  // 收藏夹
  static Future<dynamic> userfavFolder({
    required int pn,
    required int ps,
    required int mid,
  }) async {
    var res = await Request().get(Api.userFavFolder, data: {
      'pn': pn,
      'ps': ps,
      'up_mid': mid,
    });
    if (res.data['code'] == 0) {
      late FavFolderData data;
      if (res.data['data'] != null) {
        data = FavFolderData.fromJson(res.data['data']);
        return {'status': true, 'data': data};
      }
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'] ?? '账号未登录'
      };
    }
  }

  static Future<dynamic> userFavFolderDetail(
      {required int mediaId,
      required int pn,
      required int ps,
      String keyword = '',
      String order = 'mtime',
      int type = 0}) async {
    var res = await Request().get(Api.userFavFolderDetail, data: {
      'media_id': mediaId,
      'pn': pn,
      'ps': ps,
      'keyword': keyword,
      'order': order,
      'type': type,
      'tid': 0,
      'platform': 'web'
    });
    if (res.data['code'] == 0) {
      FavDetailData data = FavDetailData.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  // 稍后再看
  static Future<dynamic> seeYouLater() async {
    var res = await Request().get(Api.seeYouLater);
    if (res.data['code'] == 0) {
      if (res.data['data']['count'] == 0) {
        return {
          'status': true,
          'data': {'list': [], 'count': 0}
        };
      }
      List<HotVideoItemModel> list = [];
      for (var i in res.data['data']['list']) {
        list.add(HotVideoItemModel.fromJson(i));
      }
      return {
        'status': true,
        'data': {'list': list, 'count': res.data['data']['count']}
      };
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  // 观看历史
  static Future historyList(int? max, int? viewAt) async {
    var res = await Request().get(Api.historyList, data: {
      'type': 'all',
      'ps': 20,
      'max': max ?? 0,
      'view_at': viewAt ?? 0,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': HistoryData.fromJson(res.data['data'])};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  // 暂停观看历史
  static Future pauseHistory(bool switchStatus) async {
    // 暂停switchStatus传true 否则false
    var res = await Request().post(
      Api.pauseHistory,
      queryParameters: {
        'switch': switchStatus,
        'jsonp': 'jsonp',
        'csrf': await Request.getCsrf(),
      },
    );
    return res;
  }

  // 观看历史暂停状态
  static Future historyStatus() async {
    var res = await Request().get(Api.historyStatus);
    return res;
  }

  // 清空历史记录
  static Future clearHistory() async {
    var res = await Request().post(
      Api.clearHistory,
      queryParameters: {
        'jsonp': 'jsonp',
        'csrf': await Request.getCsrf(),
      },
    );
    return res;
  }

  // 稍后再看
  static Future toViewLater({String? bvid, dynamic aid}) async {
    var data = {'csrf': await Request.getCsrf()};
    if (bvid != null) {
      data['bvid'] = bvid;
    } else if (aid != null) {
      data['aid'] = aid;
    }
    var res = await Request().post(
      Api.toViewLater,
      queryParameters: data,
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': 'yeah！稍后再看'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 移除已观看
  static Future toViewDel({int? aid}) async {
    final Map<String, dynamic> params = {
      'jsonp': 'jsonp',
      'csrf': await Request.getCsrf(),
    };

    params[aid != null ? 'aid' : 'viewed'] = aid ?? true;
    var res = await Request().post(
      Api.toViewDel,
      queryParameters: params,
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': 'yeah！成功移除'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 获取用户凭证 失效
  static Future thirdLogin() async {
    var res = await Request().get(
      'https://passport.bilibili.com/login/app/third',
      data: {
        'appkey': Constants.appKey,
        'api': Constants.thirdApi,
        'sign': Constants.thirdSign,
      },
    );
    try {
      if (res.data['code'] == 0 && res.data['data']['has_login'] == 1) {
        Request().get(res.data['data']['confirm_uri']);
      }
    } catch (err) {
      SmartDialog.showNotify(msg: '获取用户凭证: $err', notifyType: NotifyType.error);
    }
  }

  // 清空稍后再看
  static Future toViewClear() async {
    var res = await Request().post(
      Api.toViewClear,
      queryParameters: {
        'jsonp': 'jsonp',
        'csrf': await Request.getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': '操作完成'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 删除历史记录
  static Future delHistory(kid) async {
    var res = await Request().post(
      Api.delHistory,
      queryParameters: {
        'kid': kid,
        'jsonp': 'jsonp',
        'csrf': await Request.getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': '已删除'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future hasFollow(int mid) async {
    var res = await Request().get(
      Api.hasFollow,
      data: {
        'fid': mid,
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }
  // // 相互关系查询
  // static Future relationSearch(int mid) async {
  //   Map params = await WbiSign().makSign({
  //     'mid': mid,
  //     'token': '',
  //     'platform': 'web',
  //     'web_location': 1550101,
  //   });
  //   var res = await Request().get(
  //     Api.relationSearch,
  //     data: {
  //       'mid': mid,
  //       'w_rid': params['w_rid'],
  //       'wts': params['wts'],
  //     },
  //   );
  //   if (res.data['code'] == 0) {
  //     // relation 主动状态
  //     // 被动状态
  //     return {'status': true, 'data': res.data['data']};
  //   } else {
  //     return {'status': false, 'msg': res.data['message']};
  //   }
  // }

  // 搜索历史记录
  static Future searchHistory(
      {required int pn, required String keyword}) async {
    var res = await Request().get(
      Api.searchHistory,
      data: {
        'pn': pn,
        'keyword': keyword,
        'business': 'all',
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': HistoryData.fromJson(res.data['data'])};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 我的订阅
  static Future userSubFolder({
    required int mid,
    required int pn,
    required int ps,
  }) async {
    var res = await Request().get(Api.userSubFolder, data: {
      'up_mid': mid,
      'ps': ps,
      'pn': pn,
      'platform': 'web',
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': SubFolderModelData.fromJson(res.data['data'])
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future userSubFolderDetail({
    required int seasonId,
    required int pn,
    required int ps,
  }) async {
    var res = await Request().get(Api.userSubFolderDetail, data: {
      'season_id': seasonId,
      'ps': ps,
      'pn': pn,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': SubDetailModelData.fromJson(res.data['data'])
      };
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }
}
