import 'package:flutter/material.dart';
import '../constants.dart';

class UserListSkeleton extends StatelessWidget {
  const UserListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Theme.of(context).colorScheme.onInverseSurface;
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: StyleString.safeSpace, vertical: 7),
        child: Row(
          children: [
            ClipOval(
              child: Container(width: 42, height: 42, color: bgColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(color: bgColor, width: 60, height: 13),
                      const SizedBox(width: 10),
                      Container(color: bgColor, width: 40, height: 13),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    color: bgColor,
                    width: 100,
                    height: 13,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
