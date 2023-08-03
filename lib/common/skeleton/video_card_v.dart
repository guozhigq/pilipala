import 'package:pilipala/common/constants.dart';
import 'package:flutter/material.dart';
import 'skeleton.dart';

class VideoCardVSkeleton extends StatelessWidget {
  const VideoCardVSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: StyleString.aspectRatio,
            child: LayoutBuilder(
              builder: (context, boxConstraints) {
                return Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      borderRadius:
                          BorderRadius.circular(StyleString.imgRadius.x)),
                );
              },
            ),
          ),
          Padding(
            // 多列
            padding: const EdgeInsets.fromLTRB(4, 5, 6, 6),
            // 单列
            // padding: const EdgeInsets.fromLTRB(14, 10, 4, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const SizedBox(height: 6),
                Container(
                  width: 200,
                  height: 13,
                  margin: const EdgeInsets.only(bottom: 5),
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
                Container(
                  width: 150,
                  height: 13,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
                Container(
                  width: 80,
                  height: 12,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
