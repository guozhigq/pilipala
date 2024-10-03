import 'index.dart';

class FavHttp {
  /// 编辑收藏夹
  static Future editFolder({
    required String title,
    required String intro,
    required String mediaId,
    String? cover,
    int? privacy,
  }) async {
    var res = await Request().post(
      Api.editFavFolder,
      data: {
        'title': title,
        'intro': intro,
        'media_id': mediaId,
        'cover': cover ?? '',
        'privacy': privacy ?? 0,
        'csrf': await Request.getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  /// 新建收藏夹
  static Future addFolder({
    required String title,
    required String intro,
    String? cover,
    int? privacy,
  }) async {
    var res = await Request().post(
      Api.addFavFolder,
      data: {
        'title': title,
        'intro': intro,
        'cover': cover ?? '',
        'privacy': privacy ?? 0,
        'csrf': await Request.getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
