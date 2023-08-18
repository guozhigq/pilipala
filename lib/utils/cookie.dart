import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/init.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class SetCookie {
  static onSet() async {
    var cookies = await WebviewCookieManager().getCookies(HttpString.baseUrl);
    await Request.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.baseUrl), cookies);

    cookies = await WebviewCookieManager().getCookies(HttpString.baseApiUrl);
    await Request.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.baseApiUrl), cookies);

    cookies = await WebviewCookieManager().getCookies(HttpString.tUrl);
    await Request.cookieManager.cookieJar
        .saveFromResponse(Uri.parse(HttpString.tUrl), cookies);
  }
}
