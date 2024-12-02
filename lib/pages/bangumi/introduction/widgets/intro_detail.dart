import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/drag_handle.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/utils/storage.dart';

Box localCache = GStorage.localCache;
late double sheetHeight;

class IntroDetail extends StatelessWidget {
  final dynamic bangumiDetail;

  const IntroDetail({
    Key? key,
    this.bangumiDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sheetHeight = localCache.get('sheetHeight');
    TextStyle smallTitle = TextStyle(
      fontSize: 12,
      color: Theme.of(context).colorScheme.onSurface,
    );
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      height: sheetHeight,
      child: Column(
        children: [
          const DragHandle(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bangumiDetail!.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        StatView(
                          view: bangumiDetail!.stat!['views'],
                          size: 'medium',
                        ),
                        const SizedBox(width: 6),
                        StatDanMu(
                          danmu: bangumiDetail!.stat!['danmakus'],
                          size: 'medium',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          bangumiDetail!.areas!.first['name'],
                          style: smallTitle,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          bangumiDetail!.publish!['pub_time_show'],
                          style: smallTitle,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          bangumiDetail!.newEp!['desc'],
                          style: smallTitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '简介：',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${bangumiDetail!.evaluate!}',
                      style: smallTitle.copyWith(fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '声优：',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bangumiDetail.actors,
                      style: smallTitle.copyWith(fontSize: 13),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 20)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
