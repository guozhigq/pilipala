import 'package:flutter/material.dart';
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
                SelectableText('标题：${videoInfo.title}', style: textStyle),
                SelectableText('作者：${videoInfo.author}', style: textStyle),
                SelectableText('创建时间：${videoInfo.createdAt}', style: textStyle),
                SelectableText('上次更新时间：${videoInfo.lastupdate}',
                    style: textStyle),
                SelectableText('分类：${videoInfo.typename}', style: textStyle),
                SelectableText('投币：${videoInfo.coins}', style: textStyle),
                SelectableText('收藏：${videoInfo.favorites}', style: textStyle),
                SelectableText('标签：${videoInfo.tag}', style: textStyle),
              ],
            ),
          );
        },
      ),
    );
  }
}
