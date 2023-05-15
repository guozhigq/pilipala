import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

class OverlayPop extends StatelessWidget {
  var videoItem;
  OverlayPop({super.key, this.videoItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkImgLayer(
              width: (MediaQuery.of(context).size.width - 16),
              height: (MediaQuery.of(context).size.width - 16) /
                  StyleString.aspectRatio,
              src: videoItem.pic!,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 15, 10, 15),
              child: Text(
                videoItem.title!,
                // maxLines: 1,
                // overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
