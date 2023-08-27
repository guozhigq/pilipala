import 'package:appscheme/appscheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/common/search_type.dart';

import 'id_utils.dart';
import 'utils.dart';

class PiliSchame {
  static AppScheme appScheme = AppSchemeImpl.getInstance() as AppScheme;
  static void init() async {
    ///
    SchemeEntity? value = await appScheme.getInitScheme();
    if (value != null) {
      _routePush(value);
    }

    ///
    appScheme.getLatestScheme().then((value) {
      if (value != null) {}
    });

    /// 注册从外部打开的Scheme监听信息 #
    appScheme.registerSchemeListener().listen((event) {
      if (event != null) {
        _routePush(event);
      }
    });
  }

  /// 路由跳转
  static void _routePush(value) async {
    String scheme = value.scheme;
    String host = value.host;
    String path = value.path;

    if (scheme == 'bilibili') {
      // bilibili://root
      if (host == 'root') {
        Navigator.popUntil(Get.context!, (route) => route.isFirst);
      }

      // bilibili://space/{uid}
      else if (host == 'space') {
        var mid = path.split('/').last;
        Get.toNamed(
          '/member?mid=$mid',
          arguments: {'face': null},
        );
      }

      // bilibili://video/{aid}
      else if (host == 'video') {
        var pathQuery = path.split('/').last;
        int aid = int.parse(pathQuery);
        String bvid = IdUtils.av2bv(aid);
        int cid = await SearchHttp.ab2c(bvid: bvid);
        String heroTag = Utils.makeHeroTag(aid);
        Get.toNamed('/video?bvid=$bvid&cid=$cid', arguments: {
          'pic': null,
          'heroTag': heroTag,
        });
      }

      // bilibili://live/{roomid}
      else if (host == 'live') {
        var roomId = path.split('/').last;
        Get.toNamed('/liveRoom?roomid=$roomId',
            arguments: {'liveItem': null, 'heroTag': roomId.toString()});
      }

      // bilibili://bangumi/season/${ssid}
      else if (host == 'bangumi') {
        if (path.startsWith('/season')) {
          SmartDialog.showLoading(msg: '获取中...');
          try {
            var seasonId = path.split('/').last;
            var result = await SearchHttp.bangumiInfo(
                seasonId: int.parse(seasonId), epId: null);
            if (result['status']) {
              var bangumiDetail = result['data'];
              int cid = bangumiDetail.episodes!.first.cid;
              String bvid = IdUtils.av2bv(bangumiDetail.episodes!.first.aid);
              String heroTag = Utils.makeHeroTag(cid);
              var epId = bangumiDetail.episodes!.first.id;
              SmartDialog.dismiss().then(
                (e) => Get.toNamed(
                  '/video?bvid=$bvid&cid=$cid&epId=$epId',
                  arguments: {
                    'pic': bangumiDetail.cover,
                    'heroTag': heroTag,
                    'videoType': SearchType.media_bangumi,
                  },
                ),
              );
            }
          } catch (e) {
            SmartDialog.showToast('失败：${e.toString()}');
          }
        }
      }
    }
  }
}
