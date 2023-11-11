import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/login/index.dart';
import 'package:pilipala/utils/login.dart';
import 'package:uuid/uuid.dart';

class LoginHttp {
  static Future queryCaptcha() async {
    var res = await Request().get(Api.getCaptcha);
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': CaptchaDataModel.fromJson(res.data['data']),
      };
    } else {
      return {'status': false, 'data': res.message};
    }
  }

  static Future sendSmsCode({
    int? cid,
    required int tel,
    required String token,
    required String challenge,
    required String validate,
    required String seccode,
  }) async {
    var res = await Request().post(
      Api.appSmsCode,
      data: {
        'cid': cid,
        'tel': tel,
        "source": "main_web",
        'token': token,
        'challenge': challenge,
        'validate': validate,
        'seccode': seccode,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        // headers: {'user-agent': ApiConstants.userAgent}
      ),
    );
    print(res);
  }

  // web端验证码
  static Future sendWebSmsCode({
    int? cid,
    required int tel,
    required String token,
    required String challenge,
    required String validate,
    required String seccode,
  }) async {
    Map data = {
      'cid': cid,
      'tel': tel,
      'token': token,
      'challenge': challenge,
      'validate': validate,
      'seccode': seccode,
    };
    FormData formData = FormData.fromMap({...data});
    var res = await Request().post(
      Api.smsCode,
      data: formData,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    print(res);
  }

  // web端验证码登录
  static Future loginInByWebSmsCode() async {}

  // web端密码登录
  static Future liginInByWebPwd() async {}

  // app端验证码
  static Future sendAppSmsCode({
    int? cid,
    required int tel,
    required String token,
    required String challenge,
    required String validate,
    required String seccode,
  }) async {
    Map<String, dynamic> data = {
      'cid': cid,
      'tel': tel,
      'login_session_id': const Uuid().v4().replaceAll('-', ''),
      'recaptcha_token': token,
      'gee_challenge': challenge,
      'gee_validate': validate,
      'gee_seccode': seccode,
      'channel': 'bili',
      'buvid': buvid(),
      'local_id': buvid(),
      // 'ts': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'statistics': {
        "appId": 1,
        "platform": 3,
        "version": "7.52.0",
        "abtest": ""
      },
    };
    // FormData formData = FormData.fromMap({...data});
    var res = await Request().post(
      Api.appSmsCode,
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    print(res);
  }

  static String buvid() {
    var mac = <String>[];
    var random = Random();

    for (var i = 0; i < 6; i++) {
      var min = 0;
      var max = 0xff;
      var num = (random.nextInt(max - min + 1) + min).toRadixString(16);
      mac.add(num);
    }

    var md5Str = md5.convert(utf8.encode(mac.join(':'))).toString();
    var md5Arr = md5Str.split('');
    return 'XY${md5Arr[2]}${md5Arr[12]}${md5Arr[22]}$md5Str';
  }

  // 获取盐hash跟PubKey
  static Future getWebKey() async {
    var res = await Request().get(Api.getWebKey,
        data: {'disable_rcmd': 0, 'local_id': LoginUtils.generateBuvid()});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false, 'data': {}, 'msg': res.data['message']};
    }
  }

  // app端密码登录
  static Future loginInByMobPwd({
    required String tel,
    required String password,
    required String key,
    required String rhash,
  }) async {
    dynamic publicKey = RSAKeyParser().parse(key);
    String passwordEncryptyed =
        Encrypter(RSA(publicKey: publicKey)).encrypt(rhash + password).base64;
    Map<String, dynamic> data = {
      'username': tel,
      'password': passwordEncryptyed,
      'local_id': LoginUtils.generateBuvid(),
      'disable_rcmd': "0",
    };
    var res = await Request().post(
      Api.loginInByPwdApi,
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    print(res);
  }
}
