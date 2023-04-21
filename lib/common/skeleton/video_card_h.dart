import 'package:pilipala/common/constants.dart';
import 'package:flutter/material.dart';
import 'skeleton.dart';

class VideoCardHSkeleton extends StatefulWidget {
  const VideoCardHSkeleton({super.key});

  @override
  State<VideoCardHSkeleton> createState() => _VideoCardHSkeletonState();
}

class _VideoCardHSkeletonState extends State<VideoCardHSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                StyleString.cardSpace, 7, StyleString.cardSpace, 7),
            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                double width =
                    (boxConstraints.maxWidth - StyleString.cardSpace * 6) / 2;
                return SizedBox(
                  height: width / StyleString.aspectRatio,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: StyleString.aspectRatio,
                        child: LayoutBuilder(
                          builder: (context, boxConstraints) {
                            double maxWidth = boxConstraints.maxWidth;
                            double maxHeight = boxConstraints.maxHeight;
                            double PR = MediaQuery.of(context).devicePixelRatio;
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onInverseSurface,
                                borderRadius: BorderRadius.circular(
                                    StyleString.imgRadius.x),
                              ),
                            );
                          },
                        ),
                      ),
                      // VideoContent(videoItem: videoItem)
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 4, 6, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                              width: 200,
                              height: 13,
                              margin: const EdgeInsets.only(bottom: 5),
                            ),
                            Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                              width: 150,
                              height: 13,
                            ),
                            const Spacer(),
                            Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                              width: 100,
                              height: 13,
                              margin: const EdgeInsets.only(bottom: 5),
                            ),
                            Row(
                              children: [
                                Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
                                  width: 40,
                                  height: 13,
                                  margin: const EdgeInsets.only(right: 8),
                                ),
                                Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
                                  width: 40,
                                  height: 13,
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 1,
            indent: 8,
            endIndent: 12,
            color: Theme.of(context).dividerColor.withOpacity(0.08),
          )
        ],
      ),
    );
  }
}
