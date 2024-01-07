import 'package:flutter/material.dart';
import '../../utils/download.dart';
import '../constants.dart';
import 'network_img_layer.dart';

class OverlayPop extends StatelessWidget {
  const OverlayPop({super.key, this.videoItem, this.closeFn});

  final dynamic videoItem;
  final Function? closeFn;

  @override
  Widget build(BuildContext context) {
    final double imgWidth = MediaQuery.sizeOf(context).width - 8 * 2;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              NetworkImgLayer(
                width: imgWidth,
                height: imgWidth / StyleString.aspectRatio,
                src: videoItem.pic! as String,
                quality: 100,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: IconButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () => closeFn!(),
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      videoItem.title! as String,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: '保存封面图',
                    onPressed: () async {
                      await DownloadUtils.downloadImg(
                        videoItem.pic != null
                            ? videoItem.pic as String
                            : videoItem.cover as String,
                      );
                      // closeFn!();
                    },
                    icon: const Icon(Icons.download, size: 20),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
