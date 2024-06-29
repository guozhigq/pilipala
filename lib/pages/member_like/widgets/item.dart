import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/member/like.dart';
import 'package:pilipala/utils/utils.dart';

class MemberLikeItem extends StatelessWidget {
  final MemberLikeDataModel likeItem;

  const MemberLikeItem({
    Key? key,
    required this.likeItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(likeItem.aid);
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () async {
          int cid =
              await SearchHttp.ab2c(aid: likeItem.aid, bvid: likeItem.bvid);
          Get.toNamed('/video?bvid=${likeItem.bvid}&cid=$cid',
              arguments: {'videoItem': likeItem, 'heroTag': heroTag});
        },
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: StyleString.aspectRatio,
              child: LayoutBuilder(builder: (context, boxConstraints) {
                double maxWidth = boxConstraints.maxWidth;
                double maxHeight = boxConstraints.maxHeight;
                return Stack(
                  children: [
                    NetworkImgLayer(
                      src: likeItem.pic,
                      width: maxWidth,
                      height: maxHeight,
                    ),
                    if (likeItem.duration != null)
                      PBadge(
                        bottom: 6,
                        right: 6,
                        type: 'gray',
                        text: Utils.timeFormat(likeItem.duration),
                      )
                  ],
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 6, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    likeItem.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      StatView(
                        view: likeItem.stat!.view,
                        theme: 'gray',
                      ),
                      const Spacer(),
                      Text(
                        Utils.CustomStamp_str(
                            timestamp: likeItem.pubdate, date: 'MM-DD'),
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(width: 6)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
