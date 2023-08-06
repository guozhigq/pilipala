import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';

import 'skeleton.dart';

class MediaBangumiSkeleton extends StatefulWidget {
  const MediaBangumiSkeleton({super.key});

  @override
  State<MediaBangumiSkeleton> createState() => _MediaBangumiSkeletonState();
}

class _MediaBangumiSkeletonState extends State<MediaBangumiSkeleton> {
  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).colorScheme.onInverseSurface;
    return Skeleton(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            StyleString.safeSpace, 7, StyleString.safeSpace, 7),
        child: Row(
          children: [
            Container(
              width: 111,
              height: 148,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  color: bgColor),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 148,
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      width: 200,
                      height: 20,
                      margin: const EdgeInsets.only(bottom: 15),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      width: 150,
                      height: 13,
                      margin: const EdgeInsets.only(bottom: 5),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      width: 150,
                      height: 13,
                      margin: const EdgeInsets.only(bottom: 5),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      width: 150,
                      height: 13,
                    ),
                    const Spacer(),
                    Container(
                      width: 90,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
