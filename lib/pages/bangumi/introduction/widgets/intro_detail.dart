import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/utils/storage.dart';

Box localCache = GStrorage.localCache;
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
      color: Theme.of(context).colorScheme.onBackground,
    );
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.only(left: 14, right: 14),
      height: sheetHeight,
      child: Column(
        children: [
          Container(
            height: 35,
            padding: const EdgeInsets.only(bottom: 2),
            child: Center(
              child: Container(
                width: 32,
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
                        theme: 'gray',
                        view: bangumiDetail!.stat!['views'],
                        size: 'medium',
                      ),
                      const SizedBox(width: 6),
                      StatDanMu(
                        theme: 'gray',
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
          )
        ],
      ),
    );
  }
}
