import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/utils/utils.dart';

class SetCookie {
  static onSet(List cookiesList, String url) async {
    // domain url
    List<Cookie> jarCookies = [];
    if (cookiesList.isNotEmpty) {
      for (var i in cookiesList) {
        Cookie jarCookie = Cookie(i.name, i.value);
        jarCookies.add(jarCookie);
      }
    }
    String cookiePath = await Utils.getCookiePath();
    PersistCookieJar cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage(cookiePath),
    );
    await cookieJar.saveFromResponse(Uri.parse(url), jarCookies);
    // 重新设置 cookie
    Request.setCookie();
    Request.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(url), jarCookies);
    return true;
  }
}
