import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/mine/view.dart';
import 'package:pilipala/utils/storage.dart';

Box userInfoCache = GStrorage.userInfo;

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    var userInfo = userInfoCache.get('userInfoCache');
    return SliverAppBar(
      // forceElevated: true,
      scrolledUnderElevation: 0,
      toolbarHeight: MediaQuery.of(context).padding.top,
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
                    Hero(
                      tag: 'searchTag',
                      child: IconButton(
                        onPressed: () {
                          Get.toNamed('/search');
                        },
                        icon: const Icon(CupertinoIcons.search, size: 22),
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: const Icon(CupertinoIcons.bell, size: 22),
                    // ),
                    const SizedBox(width: 6),

                    /// TODO
                    if (userInfo != null) ...[
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => const SizedBox(
                            height: 450,
                            child: MinePage(),
                          ),
                          clipBehavior: Clip.hardEdge,
                          isScrollControlled: true,
                        ),
                        child: NetworkImgLayer(
                          type: 'avatar',
                          width: 32,
                          height: 32,
                          src: userInfo.face,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ] else ...[
                      IconButton(
                        onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => const SizedBox(
                            height: 450,
                            child: MinePage(),
                          ),
                          clipBehavior: Clip.hardEdge,
                          isScrollControlled: true,
                        ),
                        icon: const Icon(CupertinoIcons.person, size: 22),
                      ),
                    ],

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
