import 'package:flutter/material.dart';
import 'package:pilipala/models/video_detail_res.dart';

Widget seasonPanel(UgcSeason ugcSeason, cid, sheetHeight) {
  return Builder(builder: (context) {
    List<EpisodeItem> episodes = ugcSeason.sections!.first.episodes!;
    int currentIndex = episodes.indexWhere((e) => e.cid == cid);
    return Container(
      margin: const EdgeInsets.only(
        top: 15,
        left: 2,
        right: 2,
      ),
      child: Material(
        color: Theme.of(context).colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => showBottomSheet(
            context: context,
            builder: (_) => Container(
              height: sheetHeight,
              color: Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  Container(
                    height: 45,
                    padding: const EdgeInsets.only(left: 14, right: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '合集（${episodes.length}）',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).dividerColor.withOpacity(0.1),
                  ),
                  Expanded(
                    child: Material(
                      child: ListView.builder(
                        itemCount: episodes.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 15, right: 15),
                              child: Text(
                                episodes[index].title!,
                                style: TextStyle(
                                    color: index == currentIndex
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '合集：${ugcSeason.title!}',
                    style: Theme.of(context).textTheme.labelMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 15),
                Image.asset(
                  'assets/images/live.gif',
                  color: Theme.of(context).colorScheme.primary,
                  height: 11,
                ),
                const SizedBox(width: 4),
                Text(
                  '${currentIndex + 1} / ${ugcSeason.epCount}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 13,
                )
              ],
            ),
          ),
        ),
      ),
    );
  });
}
