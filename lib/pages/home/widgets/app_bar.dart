import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontFamily: 'ArchivoNarrow',
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        size: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.envelope,
                        size: 20,
                      ),
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
