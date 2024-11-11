import 'package:pilipala/models/sponsor_block/segment.dart';

import 'index.dart';

class CommonHttp {
  static Future unReadDynamic() async {
    var res = await Request().get(Api.getUnreadDynamic,
        data: {'alltype_offset': 0, 'video_offset': '', 'article_offset': 0});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']['dyn_basic_infos']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future querySkipSegments({required String bvid}) async {
    var res = await Request().getWithoutCookie(Api.getSkipSegments, data: {
      'videoID': bvid,
    });
    if (res.data is List && res.data.isNotEmpty) {
      try {
        return {
          'status': true,
          'data': res.data
              .map<SegmentDataModel>((e) => SegmentDataModel.fromJson(e))
              .toList(),
        };
      } catch (err) {
        return {
          'status': false,
          'data': [],
          'msg': 'sponsorBlock数据解析失败: $err',
        };
      }
    } else {
      return {
        'status': false,
        'data': [],
      };
    }
  }
}
