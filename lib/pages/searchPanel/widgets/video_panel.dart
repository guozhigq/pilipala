import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';

Widget searchVideoPanel(BuildContext context, ctr, list) {
  return ListView.builder(
    controller: ctr!.scrollController,
    addAutomaticKeepAlives: false,
    addRepaintBoundaries: false,
    itemCount: list!.length,
    itemBuilder: (context, index) {
      var i = list![index];
      return VideoCardH(videoItem: i);
    },
  );
}
