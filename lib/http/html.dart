import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:pilipala/http/index.dart';

class HtmlHttp {
  // article
  static Future reqHtml(id, dynamicType) async {
    var response = await Request().get(
      "https://www.bilibili.com/opus/$id",
      extra: {'ua': 'pc'},
    );
    Document rootTree = parse(response.data);
    Element body = rootTree.body!;
    Element appDom = body.querySelector('#app')!;
    Element authorHeader = appDom.querySelector('.fixed-author-header')!;
    // 头像
    String avatar = authorHeader.querySelector('img')!.attributes['src']!;
    avatar = 'https:${avatar.split('@')[0]}';
    String uname =
        authorHeader.querySelector('.fixed-author-header__author__name')!.text;
    // 动态详情
    Element opusDetail = appDom.querySelector('.opus-detail')!;
    // 发布时间
    String updateTime =
        opusDetail.querySelector('.opus-module-author__pub__text')!.text;
    //
    String opusContent =
        opusDetail.querySelector('.opus-module-content')!.innerHtml;
    String commentId = opusDetail
        .querySelector('.bili-comment-container')!
        .className
        .split(' ')[1]
        .split('-')[2];
    // List imgList = opusDetail.querySelectorAll('bili-album__preview__picture__img');
    return {
      'status': true,
      'avatar': avatar,
      'uname': uname,
      'updateTime': updateTime,
      'content': opusContent,
      'commentId': int.parse(commentId)
    };
  }

  // read
  static Future reqReadHtml(id, dynamicType) async {
    var response = await Request().get(
      "https://www.bilibili.com/$dynamicType/$id/",
      extra: {'ua': 'pc'},
    );
    Document rootTree = parse(response.data);
    Element body = rootTree.body!;
    Element appDom = body.querySelector('#app')!;
    Element authorHeader = appDom.querySelector('.up-left')!;
    // 头像
    // String avatar =
    //     authorHeader.querySelector('.bili-avatar-img')!.attributes['data-src']!;
    // print(avatar);
    // avatar = 'https:${avatar.split('@')[0]}';
    String uname = authorHeader.querySelector('.up-name')!.text.trim();
    // 动态详情
    Element opusDetail = appDom.querySelector('.article-content')!;
    // 发布时间
    // String updateTime =
    //     opusDetail.querySelector('.opus-module-author__pub__text')!.text;
    // print(updateTime);

    //
    String opusContent =
        opusDetail.querySelector('#read-article-holder')!.innerHtml;
    RegExp digitRegExp = RegExp(r'\d+');
    Iterable<Match> matches = digitRegExp.allMatches(id);
    String number = matches.first.group(0)!;
    return {
      'status': true,
      'avatar': '',
      'uname': uname,
      'updateTime': '',
      'content': opusContent,
      'commentId': int.parse(number)
    };
  }
}
