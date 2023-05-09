import 'package:pilipala/common/constants.dart';
import 'package:flutter/material.dart';
import 'skeleton.dart';

class VideoCardVSkeleton extends StatelessWidget {
  const VideoCardVSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Card(
        elevation: 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: StyleString.mdRadius,
        ),
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(
                builder: (context, boxConstraints) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                },
              ),
            ),
            Padding(
              // 多列
              padding: const EdgeInsets.fromLTRB(8, 8, 6, 7),
              // 单列
              // padding: const EdgeInsets.fromLTRB(14, 10, 4, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const SizedBox(height: 6),
                  Container(
                    width: 200,
                    height: 13,
                    margin: const EdgeInsets.only(bottom: 5),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  Container(
                    width: 150,
                    height: 13,
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  Container(
                    width: 80,
                    height: 13,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
