import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/download.dart';

Future imageSaveDialog(context, videoItem, closeFn) {
  final double imgWidth =
      MediaQuery.sizeOf(context).width - StyleString.safeSpace * 2;
  return SmartDialog.show(
    animationType: SmartAnimationType.centerScale_otherSlide,
    builder: (context) => Container(
      margin: const EdgeInsets.symmetric(horizontal: StyleString.safeSpace),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: '保存封面图',
                  onPressed: () async {
                    bool saveStatus = await DownloadUtils.downloadImg(
                      videoItem.pic != null
                          ? videoItem.pic as String
                          : videoItem.cover as String,
                    );
                    // 保存成功，自动关闭弹窗
                    if (saveStatus) {
                      closeFn?.call();
                    }
                  },
                  icon: const Icon(Icons.download, size: 20),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
