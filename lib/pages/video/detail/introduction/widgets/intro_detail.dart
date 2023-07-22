import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/utils/utils.dart';

class IntroDetail extends StatelessWidget {
  var videoDetail;

  IntroDetail({
    Key? key,
    this.videoDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.only(left: 14, right: 14),
        height: 570,
        child: Column(
          children: [
            Container(
              height: 25,
              padding: const EdgeInsets.only(bottom: 2),
              child: Center(
                child: Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer
                          .withOpacity(0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
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
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          letterSpacing: 0.5, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 2),
                        StatView(
                          theme: 'black',
                          view: videoDetail!.stat!.view,
                          size: 'medium',
                        ),
                        const SizedBox(width: 10),
                        StatDanMu(
                          theme: 'black',
                          danmu: videoDetail!.stat!.danmaku,
                          size: 'medium',
                        ),
                        const SizedBox(width: 10),
                        Text(
                          Utils.dateFormat(videoDetail!.pubdate,
                              formatType: 'detail'),
                          style: const TextStyle(fontSize: 12),
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
                            Text(videoDetail!.bvid!),
                            const SizedBox(height: 4),
                            Text.rich(
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
    String desc = content.desc;
    List descV2 = content.descV2;
    // type
    // 1 普通文本
    // 2 @用户
    List<InlineSpan> spanChilds = [];
    if (descV2.isNotEmpty) {
      for (var i = 0; i < descV2.length; i++) {
        if (descV2[i].type == 1) {
          spanChilds.add(TextSpan(text: descV2[i].rawText));
        } else if (descV2[i].type == 2) {
          spanChilds.add(
            TextSpan(
              text: '@${descV2[i].rawText}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  String heroTag = Utils.makeHeroTag(descV2[i].bizId);
                  Get.toNamed(
                    '/member?mid=${descV2[i].bizId}',
                    arguments: {'face': '', 'heroTag': heroTag},
                  );
                },
            ),
          );
        }
      }
    } else {
      spanChilds.add(TextSpan(text: desc));
    }
    return TextSpan(children: spanChilds);
  }
}
