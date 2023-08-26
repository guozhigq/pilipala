import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/utils.dart';

class FavItem extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final favFolderItem;
  const FavItem({super.key, required this.favFolderItem});

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(favFolderItem.fid);
    return InkWell(
      onTap: () => Get.toNamed(
        '/favDetail',
        arguments: favFolderItem,
        parameters: {
          'heroTag': heroTag,
          'mediaId': favFolderItem.id.toString(),
        },
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 7),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            double width =
                (boxConstraints.maxWidth - StyleString.cardSpace * 6) / 2;
            return SizedBox(
              height: width / StyleString.aspectRatio,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: StyleString.aspectRatio,
                    child: LayoutBuilder(
                      builder: (context, boxConstraints) {
                        double maxWidth = boxConstraints.maxWidth;
                        double maxHeight = boxConstraints.maxHeight;
                        return Hero(
                          tag: heroTag,
                          child: NetworkImgLayer(
                            src: favFolderItem.cover,
                            width: maxWidth,
                            height: maxHeight,
                          ),
                        );
                      },
                    ),
                  ),
                  VideoContent(favFolderItem: favFolderItem)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  final dynamic favFolderItem;
  const VideoContent({super.key, required this.favFolderItem});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 6, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              favFolderItem.title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              '${favFolderItem.mediaCount}个内容',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
