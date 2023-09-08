import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class HtmlRender extends StatelessWidget {
  String? htmlContent;
  final int? imgCount;
  final List? imgList;

  HtmlRender({
    this.htmlContent,
    this.imgCount,
    this.imgList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlContent,
      // tagsList: Html.tags..addAll(["form", "label", "input"]),
      onLinkTap: (url, buildContext, attributes) => {},
      extensions: [
        TagExtension(
          tagsToExtend: {"img"},
          builder: (extensionContext) {
            String? imgUrl = extensionContext.attributes['src'];
            if (imgUrl!.startsWith('//')) {
              imgUrl = 'https:$imgUrl';
            }
            if (imgUrl.startsWith('http://')) {
              imgUrl = imgUrl.replaceAll('http://', 'https://');
            }

            print(imgUrl);
            bool isEmote = imgUrl.contains('/emote/');
            bool isMall = imgUrl.contains('/mall/');
            if (isMall) {
              return SizedBox();
            }
            // bool inTable =
            //     extensionContext.element!.previousElementSibling == null ||
            //         extensionContext.element!.nextElementSibling == null;
            // imgUrl = Utils().imageUrl(imgUrl!);
            return Image.network(
              imgUrl,
              width: isEmote ? 22 : null,
              height: isEmote ? 22 : null,
            );
          },
        ),
      ],
      style: {
        "html": Style(
          fontSize: FontSize.medium,
          lineHeight: LineHeight.percent(140),
        ),
        "body": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        "a": Style(
          color: Theme.of(context).colorScheme.primary,
          textDecoration: TextDecoration.none,
        ),
        "p": Style(
          margin: Margins.only(bottom: 0),
        ),
        "span": Style(
          fontSize: FontSize.medium,
        ),
        "li > p": Style(
          display: Display.inline,
        ),
        "li": Style(
          padding: HtmlPaddings.only(bottom: 4),
          textAlign: TextAlign.justify,
        ),
        "image": Style(margin: Margins.only(top: 4, bottom: 4)),
        "p > img": Style(margin: Margins.only(top: 4, bottom: 4)),
        "code": Style(
            backgroundColor: Theme.of(context).colorScheme.onInverseSurface),
        "code > span": Style(textAlign: TextAlign.start),
        "hr": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          border: Border(
            top: BorderSide(
              width: 1.0,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            ),
          ),
        ),
        'table': Style(
          border: Border(
            right: BorderSide(
              width: 0.5,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            ),
            bottom: BorderSide(
              width: 0.5,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            ),
          ),
        ),
        'tr': Style(
          border: Border(
            top: BorderSide(
              width: 1.0,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            ),
            left: BorderSide(
              width: 1.0,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            ),
          ),
        ),
        'thead': Style(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        'th': Style(
          padding: HtmlPaddings.only(left: 3, right: 3),
        ),
        'td': Style(
          padding: HtmlPaddings.all(4.0),
          alignment: Alignment.center,
          textAlign: TextAlign.center,
        ),
      },
    );
  }
}
