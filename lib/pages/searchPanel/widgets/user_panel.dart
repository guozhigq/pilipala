import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

Widget searchUserPanel(BuildContext context, ctr, list) {
  TextStyle style = TextStyle(
      fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
      color: Theme.of(context).colorScheme.outline);
  return ListView.builder(
    controller: ctr!.scrollController,
    addAutomaticKeepAlives: false,
    addRepaintBoundaries: false,
    itemCount: list!.length,
    itemBuilder: (context, index) {
      var i = list![index];
      return InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              NetworkImgLayer(
                width: 42,
                height: 42,
                src: i.upic,
                type: 'avatar',
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        i!.uname,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium!.fontSize,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Image.asset(
                        'assets/images/lv/lv${i!.level}.png',
                        height: 11,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('粉丝：${i.fans} ', style: style),
                      Text(' 视频：${i.videos}', style: style)
                    ],
                  ),
                  if (i.officialVerify['desc'] != '')
                    Text(
                      i.officialVerify['desc'],
                      style: style,
                    ),
                ],
              )
            ],
          ),
        ),
      );
      ;
    },
  );
}
