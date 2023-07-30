import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

import 'common_btn.dart';

class HeaderControl extends StatelessWidget implements PreferredSizeWidget {
  final PlPlayerController? controller;
  const HeaderControl({this.controller, Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    final _ = controller!;
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      primary: false,
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 14,
      title: Row(
        children: [
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.arrowLeft,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => Get.back(),
          ),
          const SizedBox(width: 4),
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.house,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => Get.back(),
          ),
          const Spacer(),
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.cropSimple,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => _.screenshot(),
          ),
          const SizedBox(width: 4),
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.sliders,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => _.screenshot(),
          ),
        ],
      ),
    );
  }
}
