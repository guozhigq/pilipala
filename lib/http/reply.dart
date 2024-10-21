import 'dart:convert';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../models/video/reply/data.dart';
import '../models/video/reply/emote.dart';
import 'api.dart';
import 'init.dart';

class ReplyHttp {
  static Future replyList({
    required int oid,
    required String nextOffset,
    required int type,
    int? ps,
    int sort = 1,
  }) async {
    var res = await Request().get(Api.replyList, data: {
      'oid': oid,
      'type': type,
      'pagination_str': jsonEncode({'offset': nextOffset}),
      'mode': sort + 2,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': ReplyData.fromJson(res.data['data']),
        'code': 200,
      };
    } else {
      return {
        'status': false,
        'date': [],
        'code': res.data['code'],
        'msg': res.data['message'],
      };
    }
  }

  static Future replyReplyList({
    required int oid,
    required String root,
    required int pageNum,
    required int type,
    int sort = 1,
  }) async {
    var res = await Request().get(Api.replyReplyList, data: {
      'oid': oid,
      'root': root,
      'pn': pageNum,
      'type': type,
      'sort': 1,
      'csrf': await Request.getCsrf(),
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': ReplyReplyData.fromJson(res.data['data']),
      };
    } else {
      return {
        'status': false,
        'date': [],
        'msg': res.data['message'],
      };
    }
  }

  // 评论点赞
  static Future likeReply({
    required int type,
    required int oid,
    required int rpid,
    required int action,
  }) async {
    var res = await Request().post(
      Api.likeReply,
      data: {
        'type': type,
        'oid': oid,
        'rpid': rpid,
        'action': action,
        'csrf': await Request.getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {
        'status': false,
        'date': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future getEmoteList({String? business}) async {
    var res = await Request().get(Api.emojiList, data: {
      'business': business ?? 'reply',
      'web_location': '333.1245',
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': EmoteModelData.fromJson(res.data['data']),
      };
    } else {
      return {
        'status': false,
        'date': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future replyDel({
    required int type, //replyType
    required int oid,
    required int rpid,
  }) async {
    var res = await Request().post(
      Api.replyDel,
      queryParameters: {
        'type': type, //type.index
        'oid': oid,
        'rpid': rpid,
        'csrf': await Request.getCsrf(),
      },
    );
    if (res.data['code'] == 0) {
      return {'status': true, 'msg': '删除成功'};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  // 图片上传
  static Future uploadImage({required XFile xFile, String type = 'im'}) async {
    var formData = FormData.fromMap({
      'file_up': await xFileToMultipartFile(xFile),
      'biz': type,
      'csrf': await Request.getCsrf(),
      'build': 0,
      'mobi_app': 'web',
    });
    var res = await Request().post(
      Api.uploadImage,
      data: formData,
    );
    if (res.data['code'] == 0) {
      var data = res.data['data'];
      data['img_src'] = data['image_url'];
      data['img_width'] = data['image_width'];
      data['img_height'] = data['image_height'];
      data.remove('image_url');
      data.remove('image_width');
      data.remove('image_height');
      return {
        'status': true,
        'data': data,
      };
    } else {
      return {
        'status': false,
        'date': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future<MultipartFile> xFileToMultipartFile(XFile xFile) async {
    var file = File(xFile.path);
    var bytes = await file.readAsBytes();
    return MultipartFile.fromBytes(bytes, filename: xFile.name);
  }
}
