import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

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
      onLinkTap: (url, buildContext, attributes) => {},
      extensions: [
        TagExtension(
          tagsToExtend: {"img"},
          builder: (extensionContext) {
            try {
              Map attributes = extensionContext.attributes;
              List key = attributes.keys.toList();
              String? imgUrl = key.contains('src')
                  ? attributes['src']
                  : attributes['data-src'];
              if (imgUrl!.startsWith('//')) {
                imgUrl = 'https:$imgUrl';
              }
              if (imgUrl.startsWith('http://')) {
                imgUrl = imgUrl.replaceAll('http://', 'https://');
              }
              imgUrl = imgUrl.contains('@') ? imgUrl.split('@').first : imgUrl;
              bool isEmote = imgUrl.contains('/emote/');
              bool isMall = imgUrl.contains('/mall/');
              if (isMall) {
                return const SizedBox();
              }
              // bool inTable =
              //     extensionContext.element!.previousElementSibling == null ||
              //         extensionContext.element!.nextElementSibling == null;
              // imgUrl = Utils().imageUrl(imgUrl!);
              // return Image.network(
              //   imgUrl,
              //   width: isEmote ? 22 : null,
              //   height: isEmote ? 22 : null,
              // );
              return NetworkImgLayer(
                width: isEmote ? 22 : Get.size.width - 24,
                height: isEmote ? 22 : 200,
                src: imgUrl,
              );
            } catch (err) {
              print(err);
              return const SizedBox();
            }
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
          margin: Margins.only(bottom: 10),
        ),
        "span": Style(
          fontSize: FontSize.medium,
          height: Height(1.65),
        ),
        "div": Style(height: Height.auto()),
        "li > p": Style(
          display: Display.inline,
        ),
        "li": Style(
          padding: HtmlPaddings.only(bottom: 4),
          textAlign: TextAlign.justify,
        ),
        "img": Style(margin: Margins.only(top: 4, bottom: 4)),
      },
    );
  }
}
