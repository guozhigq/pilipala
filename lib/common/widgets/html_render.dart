import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pilipala/plugin/pl_gallery/hero_dialog_route.dart';
import 'package:pilipala/plugin/pl_gallery/interactiveviewer_gallery.dart';
import 'package:pilipala/utils/highlight.dart';

import '../../utils/global_data_cache.dart';

// ignore: must_be_immutable
class HtmlRender extends StatelessWidget {
  const HtmlRender({
    this.htmlContent,
    this.imgCount,
    this.imgList,
    super.key,
  });

  final String? htmlContent;
  final int? imgCount;
  final List<String>? imgList;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlContent,
      onLinkTap: (String? url, Map<String, String> buildContext, attributes) {},
      extensions: [
        TagExtension(
          tagsToExtend: <String>{'pre'},
          builder: (ExtensionContext extensionContext) {
            final Map<String, dynamic> attributes = extensionContext.attributes;
            final String lang = attributes['data-lang'] as String;
            final String code = attributes['codecontent'] as String;
            List<String> selectedLanguages = [lang.split('@').first];
            TextSpan? result = highlightExistingText(code, selectedLanguages);
            if (result == null) {
              return const Center(child: Text('代码块渲染失败'));
            }
            return SelectableText.rich(result);
          },
        ),
        TagExtension(
          tagsToExtend: <String>{'img'},
          builder: (ExtensionContext extensionContext) {
            int defaultImgQuality = 10;
            defaultImgQuality = GlobalDataCache.imgQuality;
            try {
              final Map<String, dynamic> attributes =
                  extensionContext.attributes;
              final List<dynamic> key = attributes.keys.toList();
              String imgUrl = key.contains('src')
                  ? attributes['src'] as String
                  : attributes['data-src'] as String;
              if (imgUrl.startsWith('//')) {
                imgUrl = 'https:$imgUrl';
              }
              if (imgUrl.startsWith('http://')) {
                imgUrl = imgUrl.replaceAll('http://', 'https://');
              }
              imgUrl = imgUrl.contains('@') ? imgUrl.split('@').first : imgUrl;
              final bool isEmote = imgUrl.contains('/emote/');
              final bool isMall = imgUrl.contains('/mall/');
              if (isMall) {
                return const SizedBox();
              }
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    HeroDialogRoute<void>(
                      builder: (BuildContext context) =>
                          InteractiveviewerGallery(
                        sources: imgList ?? [imgUrl],
                        initIndex: imgList?.indexOf(imgUrl) ?? 0,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                          bool isFocus,
                          bool enablePageView,
                        ) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (enablePageView) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Center(
                              child: Hero(
                                tag: imgList?[index] ?? imgUrl,
                                child: CachedNetworkImage(
                                  fadeInDuration:
                                      const Duration(milliseconds: 0),
                                  imageUrl: imgList?[index] ?? imgUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                        onPageChanged: (int pageIndex) {},
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: '$imgUrl@${defaultImgQuality}q.webp',
                  ),
                ),
              );
            } catch (err) {
              return const SizedBox();
            }
          },
        ),
      ],
      style: {
        'html': Style(
          fontSize: FontSize.large,
          lineHeight: LineHeight.percent(140),
        ),
        'body': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        'a': Style(
          color: Theme.of(context).colorScheme.primary,
          textDecoration: TextDecoration.none,
        ),
        'p': Style(
          margin: Margins.only(bottom: 10),
        ),
        'span': Style(
          fontSize: FontSize.large,
          height: Height(1.65),
        ),
        'div': Style(height: Height.auto()),
        'li > p': Style(
          display: Display.inline,
        ),
        'li': Style(
          padding: HtmlPaddings.only(bottom: 4),
          textAlign: TextAlign.justify,
        ),
        'img': Style(margin: Margins.only(top: 4, bottom: 4)),
        'figcaption': Style(
          textAlign: TextAlign.center,
          margin: Margins.only(top: 8, bottom: 20),
          color: Theme.of(context).colorScheme.secondary,
        ),
        'figure': Style(
          margin: Margins.zero,
        ),
      },
    );
  }
}
