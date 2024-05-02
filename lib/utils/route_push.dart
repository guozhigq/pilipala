import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/bangumi/info.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/utils/utils.dart';

class RoutePush {
  // 番剧跳转
  static Future<void> bangumiPush(int? seasonId, int? epId,
      {String? heroTag}) async {
    SmartDialog.showLoading<dynamic>(msg: '获取中...');
    try {
      var result = await SearchHttp.bangumiInfo(seasonId: seasonId, epId: epId);
      await SmartDialog.dismiss();
      if (result['status']) {
        if (result['data'].episodes.isEmpty) {
          SmartDialog.showToast('资源获取失败');
          return;
        }
        final BangumiInfoModel bangumiDetail = result['data'];
        final EpisodeItem episode = bangumiDetail.episodes!.first;
        final int epId = episode.id!;
        final int cid = episode.cid!;
        final String bvid = episode.bvid!;
        final String cover = episode.cover!;
        final Map arguments = <String, dynamic>{
          'pic': cover,
          'videoType': SearchType.media_bangumi,
          // 'bangumiItem': bangumiDetail,
        };
        arguments['heroTag'] = heroTag ?? Utils.makeHeroTag(cid);
        Get.toNamed(
          '/video?bvid=$bvid&cid=$cid&epId=$epId',
          arguments: arguments,
        );
      } else {
        SmartDialog.showToast(result['msg']);
      }
    } catch (e) {
      SmartDialog.showToast('番剧获取失败：$e');
    }
  }
}
