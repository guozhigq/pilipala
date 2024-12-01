import 'package:flutter/material.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'progress_bar.dart';

class BottomControl extends StatelessWidget implements PreferredSizeWidget {
  final PlPlayerController? controller;
  final Function? triggerFullScreen;
  final List<Widget>? buildBottomControl;
  const BottomControl({
    this.controller,
    this.triggerFullScreen,
    this.buildBottomControl,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 7, 6),
            child: ProgressBarWidget(controller: controller!),
          ),
          Row(children: buildBottomControl!),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
