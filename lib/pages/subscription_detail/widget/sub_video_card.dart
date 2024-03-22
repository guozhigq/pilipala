import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import '../../../common/widgets/badge.dart';
import '../../../models/user/sub_detail.dart';

// 收藏视频卡片 - 水平布局
class SubVideoCardH extends StatelessWidget {
  final SubDetailMediaItem videoItem;
  final int? searchType;

  const SubVideoCardH({
    Key? key,
    required this.videoItem,
    this.searchType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int id = videoItem.id!;
    String bvid = videoItem.bvid!;
    String heroTag = Utils.makeHeroTag(id);
    return InkWell(
      onTap: () async {
        int cid = await SearchHttp.ab2c(bvid: bvid);
        Map<String, String> parameters = {
          'bvid': bvid,
          'cid': cid.toString(),
        };

        Get.toNamed('/video', parameters: parameters, arguments: {
          'videoItem': videoItem,
          'heroTag': heroTag,
          'videoType': SearchType.video,
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                StyleString.safeSpace, 5, StyleString.safeSpace, 5),
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
                            return Stack(
                              children: [
                                Hero(
                                  tag: heroTag,
                                  child: NetworkImgLayer(
                                    src: videoItem.cover,
                                    width: maxWidth,
                                    height: maxHeight,
                                  ),
                                ),
                                PBadge(
                                  text: Utils.timeFormat(videoItem.duration!),
                                  right: 6.0,
                                  bottom: 6.0,
                                  type: 'gray',
                                ),
                                // if (videoItem.ogv != null) ...[
                                //   PBadge(
                                //     text: videoItem.ogv['type_name'],
                                //     top: 6.0,
                                //     right: 6.0,
                                //     bottom: null,
                                //     left: null,
                                //   ),
                                // ],
                              ],
                            );
                          },
                        ),
                      ),
                      VideoContent(
                        videoItem: videoItem,
                        searchType: searchType,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoContent extends StatelessWidget {
  final dynamic videoItem;
  final int? searchType;
  const VideoContent({
    super.key,
    required this.videoItem,
    this.searchType,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 2, 6, 0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videoItem.title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Text(
                  Utils.dateFormat(videoItem.pubtime),
                  style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.outline),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      StatView(
                        theme: 'gray',
                        view: videoItem.cntInfo['play'],
                      ),
                      const SizedBox(width: 8),
                      StatDanMu(
                          theme: 'gray', danmu: videoItem.cntInfo['danmaku']),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
