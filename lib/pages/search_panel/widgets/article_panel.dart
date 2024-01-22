import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/utils.dart';

Widget searchArticlePanel(BuildContext context, ctr, list) {
  TextStyle textStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
      color: Theme.of(context).colorScheme.outline);
  return ListView.builder(
    controller: ctr!.scrollController,
    itemCount: list.length,
    itemBuilder: (context, index) {
      return InkWell(
        onTap: () {
          Get.toNamed('/htmlRender', parameters: {
            'url': 'www.bilibili.com/read/cv${list[index].id}',
            'title': list[index].subTitle,
            'id': 'cv${list[index].id}',
            'dynamicType': 'read'
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              StyleString.safeSpace, 5, StyleString.safeSpace, 5),
          child: LayoutBuilder(builder: (context, boxConstraints) {
            double width = (boxConstraints.maxWidth -
                StyleString.cardSpace *
                    6 /
                    MediaQuery.textScalerOf(context).scale(2.0));
            return Container(
              constraints: const BoxConstraints(minHeight: 88),
              height: width / StyleString.aspectRatio,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (list[index].imageUrls != null &&
                      list[index].imageUrls.isNotEmpty)
                    AspectRatio(
                      aspectRatio: StyleString.aspectRatio,
                      child: LayoutBuilder(builder: (context, boxConstraints) {
                        double maxWidth = boxConstraints.maxWidth;
                        double maxHeight = boxConstraints.maxHeight;
                        return NetworkImgLayer(
                          width: maxWidth,
                          height: maxHeight,
                          src: list[index].imageUrls.first,
                        );
                      }),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 2, 6, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            maxLines: 2,
                            text: TextSpan(
                              children: [
                                for (var i in list[index].title) ...[
                                  TextSpan(
                                    text: i['text'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                      color: i['type'] == 'em'
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                              Utils.dateFormat(list[index].pubTime,
                                  formatType: 'detail'),
                              style: textStyle),
                          Row(
                            children: [
                              Text('${list[index].view}浏览', style: textStyle),
                              Text(' • ', style: textStyle),
                              Text('${list[index].reply}评论', style: textStyle),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      );
    },
  );
}
