import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/utils.dart';

Box localCache = GStrorage.localCache;
late double sheetHeight;

class IntroDetail extends StatelessWidget {
  final dynamic videoDetail;

  const IntroDetail({
    Key? key,
    this.videoDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sheetHeight = localCache.get('sheetHeight');
    return Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.only(left: 14, right: 14),
        height: sheetHeight,
        child: Column(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                height: 35,
                padding: const EdgeInsets.only(bottom: 2),
                child: Center(
                  child: Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3))),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      videoDetail!.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        StatView(
                          theme: 'gray',
                          view: videoDetail!.stat!.view,
                          size: 'medium',
                        ),
                        const SizedBox(width: 10),
                        StatDanMu(
                          theme: 'gray',
                          danmu: videoDetail!.stat!.danmaku,
                          size: 'medium',
                        ),
                        const SizedBox(width: 10),
                        Text(
                          Utils.dateFormat(videoDetail!.pubdate,
                              formatType: 'detail'),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: SelectableRegion(
                        magnifierConfiguration:
                            const TextMagnifierConfiguration(),
                        focusNode: FocusNode(),
                        selectionControls: MaterialTextSelectionControls(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              videoDetail!.bvid!,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text.rich(
                              style: const TextStyle(
                                height: 1.4,
                                fontSize: 13,
                              ),
                              TextSpan(
                                children: [
                                  buildContent(context, videoDetail!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  InlineSpan buildContent(BuildContext context, content) {
    List descV2 = content.descV2;
    // type
    // 1 普通文本
    // 2 @用户
    List<TextSpan> spanChilds = List.generate(descV2.length, (index) {
      final currentDesc = descV2[index];
      switch (currentDesc.type) {
        case 1:
          return TextSpan(text: currentDesc.rawText);
        case 2:
          final colorSchemePrimary = Theme.of(context).colorScheme.primary;
          final heroTag = Utils.makeHeroTag(currentDesc.bizId);
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
}
