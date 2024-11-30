import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/models/video/tags.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/utils.dart';

class IntroDetail extends StatelessWidget {
  const IntroDetail({
    super.key,
    this.videoDetail,
    this.videoTags,
  });

  final dynamic videoDetail;
  final RxList<VideoTagItem>? videoTags;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
    );
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 4),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  feedBack();
                  Clipboard.setData(ClipboardData(text: videoDetail!.bvid!));
                  SmartDialog.showToast('已复制');
                },
                child: Text(videoDetail!.bvid!, style: textStyle),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  feedBack();
                  Clipboard.setData(
                      ClipboardData(text: videoDetail!.aid!.toString()));
                  SmartDialog.showToast('已复制');
                },
                child: Text(videoDetail!.aid!.toString(), style: textStyle),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  feedBack();
                  String videoUrl =
                      '${HttpString.baseUrl}/video/${videoDetail!.bvid!}';
                  Clipboard.setData(ClipboardData(text: videoUrl));
                  SmartDialog.showToast('已复制视频链接');
                },
                child: Text('复制链接', style: textStyle),
              )
            ],
          ),
          if (videoDetail!.descV2.isNotEmpty) ...[
            const SizedBox(height: 4),
            SelectableRegion(
              focusNode: FocusNode(),
              selectionControls: MaterialTextSelectionControls(),
              child: Text.rich(
                style: TextStyle(
                    height: 1.4, color: Theme.of(context).colorScheme.outline),
                TextSpan(
                  children: [
                    buildContent(context, videoDetail!),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Obx(() => null != videoTags && videoTags!.isNotEmpty
              ? _buildTags(context, videoTags)
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  InlineSpan buildContent(BuildContext context, content) {
    final List descV2 = content.descV2;
    // type
    // 1 普通文本
    // 2 @用户
    final List<TextSpan> spanChilds = List.generate(descV2.length, (index) {
      final currentDesc = descV2[index];
      switch (currentDesc.type) {
        case 1:
          final List<InlineSpan> spanChildren = <InlineSpan>[];
          final RegExp urlRegExp = RegExp(r'https?://\S+\b');
          final Iterable<Match> matches =
              urlRegExp.allMatches(currentDesc.rawText);

          int previousEndIndex = 0;
          for (final Match match in matches) {
            if (match.start > previousEndIndex) {
              spanChildren.add(TextSpan(
                  text: currentDesc.rawText
                      .substring(previousEndIndex, match.start)));
            }
            spanChildren.add(
              TextSpan(
                text: match.group(0),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary), // 设置颜色为蓝色
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // 处理点击事件
                    try {
                      Get.toNamed(
                        '/webview',
                        parameters: {
                          'url': match.group(0)!,
                          'type': 'url',
                          'pageTitle': match.group(0)!,
                        },
                      );
                    } catch (err) {
                      SmartDialog.showToast(err.toString());
                    }
                  },
              ),
            );
            previousEndIndex = match.end;
          }

          if (previousEndIndex < currentDesc.rawText.length) {
            spanChildren.add(TextSpan(
                text: currentDesc.rawText.substring(previousEndIndex)));
          }

          final TextSpan result = TextSpan(children: spanChildren);
          return result;
        case 2:
          final Color colorSchemePrimary =
              Theme.of(context).colorScheme.primary;
          final String heroTag = Utils.makeHeroTag(currentDesc.bizId);
          return TextSpan(
            text: '@${currentDesc.rawText}',
            style: TextStyle(color: colorSchemePrimary),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(
                  '/member?mid=${currentDesc.bizId}',
                  arguments: {'face': '', 'heroTag': heroTag},
                );
              },
          );
        default:
          return const TextSpan();
      }
    });
    return TextSpan(children: spanChilds);
  }

  Widget _buildTags(BuildContext context, List<VideoTagItem>? videoTags) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      direction: Axis.horizontal,
      textDirection: TextDirection.ltr,
      children: videoTags!.map((tag) {
        return InkWell(
          onTap: () {
            Get.toNamed('/searchResult', parameters: {'keyword': tag.tagName!});
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: Text(
              tag.tagName!,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
