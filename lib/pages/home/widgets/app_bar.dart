import 'dart:io';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // forceElevated: true,
      scrolledUnderElevation: 0,
      toolbarHeight: Platform.isAndroid
          ? (MediaQuery.of(context).padding.top + 6)
          : Platform.isIOS
              ? MediaQuery.of(context).padding.top - 2
              : kToolbarHeight,
      expandedHeight: kToolbarHeight + MediaQuery.of(context).padding.top,
      automaticallyImplyLeading: false,
      pinned: true,
      floating: true,
      primary: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          return FlexibleSpaceBar(
            background: Column(
              children: [
                AppBar(
                  centerTitle: false,
                  title: const Text(
                    'PiLiPaLa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search_rounded),
                    ),
                    const SizedBox(width: 10)
                  ],
                  elevation: 0,
                  scrolledUnderElevation: 0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
