import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/common/invalid_video.dart';

class InvalidVideoCard extends StatelessWidget {
  const InvalidVideoCard({required this.videoInfo, Key? key}) : super(key: key);
  final InvalidVideoModel videoInfo;

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(fontSize: 14.0);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        14,
        12,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          double maxHeight = maxWidth * 9 / 16;
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NetworkImgLayer(
                  width: maxWidth,
                  height: maxHeight,
                  src: videoInfo.pic,
                  radius: 20,
                ),
                const SizedBox(height: 10),
                SelectableText(
                  videoInfo.title!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                SelectableText(videoInfo.author!, style: textStyle),
                const SizedBox(height: 2),
                SelectableText('创建时间：${videoInfo.createdAt}', style: textStyle),
                SelectableText('更新时间：${videoInfo.lastupdate}',
                    style: textStyle),
                SelectableText('分类：${videoInfo.typename}', style: textStyle),
                SelectableText(
                    '投币：${videoInfo.coins}  收藏：${videoInfo.favorites}',
                    style: textStyle),
                if (videoInfo.tagList != null &&
                    videoInfo.tagList!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  _buildTags(context, videoInfo.tagList),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTags(BuildContext context, List<String>? videoTags) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      direction: Axis.horizontal,
      textDirection: TextDirection.ltr,
      children: videoTags!.map((tag) {
        return InkWell(
          onTap: () {
            Get.toNamed('/searchResult', parameters: {'keyword': tag});
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: Text(
              tag,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
