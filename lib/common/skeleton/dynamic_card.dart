import 'package:flutter/material.dart';
import 'skeleton.dart';

class DynamicCardSkeleton extends StatelessWidget {
  const DynamicCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 8,
              color: Theme.of(context).dividerColor.withOpacity(0.05),
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      width: 100,
                      height: 13,
                      margin: const EdgeInsets.only(bottom: 5),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      width: 50,
                      height: 11,
                    ),
                  ],
                )
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    width: double.infinity,
                    height: 13,
                    margin: const EdgeInsets.only(bottom: 7),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    width: double.infinity,
                    height: 13,
                    margin: const EdgeInsets.only(bottom: 7),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    width: 300,
                    height: 13,
                    margin: const EdgeInsets.only(bottom: 7),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    width: 250,
                    height: 13,
                    margin: const EdgeInsets.only(bottom: 7),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    width: 100,
                    height: 13,
                    margin: const EdgeInsets.only(bottom: 7),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i = 0; i < 3; i++)
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.radio_button_unchecked_outlined,
                      size: 20,
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      foregroundColor: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                    ),
                    label: Text(
                      i == 0
                          ? '转发'
                          : i == 1
                              ? '评论'
                              : '点赞',
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
