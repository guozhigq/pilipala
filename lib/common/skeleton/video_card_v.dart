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
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.1),
                      ),
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
                    color: Theme.of(context).colorScheme.background,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 150,
                    height: 13,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  const SizedBox(height: 12),
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
