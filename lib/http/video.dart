import 'package:pilipala/http/api.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/video_detail_res.dart';

class VideoHttp {
  // 视频信息 标题、简介
  static Future videoDetail(data) async {
    var res = await Request().get(Api.videoDetail, data: data);
    VideoDetailResponse result = VideoDetailResponse.fromJson(res.data);
    if (result.code == 0) {
      return {'status': true, 'data': result.data!};
    } else {
      Map errMap = {
        -400: '请求错误',
        -403: '权限不足',
        -404: '无视频',
        62002: '稿件不可见',
        62004: '稿件审核中',
      };
      return {
        'status': false,
        'data': null,
        'msg': errMap[result.code] ?? '请求异常'
      };
    }
  }

  static Future videoRecommend(data) async {
    var res = await Request().get(Api.relatedList, data: data);
    return res;
  }
}
