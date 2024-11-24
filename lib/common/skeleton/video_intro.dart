import 'package:flutter/material.dart';
import '../constants.dart';
import 'skeleton.dart';

class VideoIntroSkeleton extends StatelessWidget {
  const VideoIntroSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).colorScheme.onInverseSurface;
    return Skeleton(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 20,
              margin: const EdgeInsets.only(bottom: 6),
              color: bgColor,
            ),
            Container(
              width: 220,
              height: 20,
              margin: const EdgeInsets.only(bottom: 12),
              color: bgColor,
            ),
            Row(
              children: [
                Container(
                  width: 45,
                  height: 14,
                  color: bgColor,
                ),
                const SizedBox(width: 8),
                Container(
                  width: 45,
                  height: 14,
                  color: bgColor,
                ),
                const SizedBox(width: 8),
                Container(
                  width: 45,
                  height: 14,
                  color: bgColor,
                ),
                const Spacer(),
                Container(
                  width: 35,
                  height: 14,
                  color: bgColor,
                ),
                const SizedBox(width: 4),
              ],
            ),
            const SizedBox(height: 30),
            LayoutBuilder(builder: (context, constraints) {
              // 并列5个正方形
              double width = (constraints.maxWidth - 30) / 5;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  return Container(
                    width: width - 24,
                    height: width - 24,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                }),
              );
            }),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ClipOval(
                  child: Container(
                    width: 44,
                    height: 44,
                    color: bgColor,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 50,
                  height: 14,
                  color: bgColor,
                ),
                const SizedBox(width: 8),
                Container(
                  width: 35,
                  height: 14,
                  color: bgColor,
                ),
                const Spacer(),
                Container(
                  width: 55,
                  height: 30,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(width: 2)
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
