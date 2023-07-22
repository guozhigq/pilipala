import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

/// TODO 点击跳转
Widget addWidget(item, context, type, {floor = 1}) {
  Map<dynamic, dynamic> dynamicProperty = {
    'ADDITIONAL_TYPE_UGC': item.modules.moduleDynamic.additional.ugc,
    // 直播预约
    'ADDITIONAL_TYPE_RESERVE': item.modules.moduleDynamic.additional.reserve,
    // 商品
    'ADDITIONAL_TYPE_GOODS': item.modules.moduleDynamic.additional.goods,
    // 比赛信息
    'ADDITIONAL_TYPE_MATCH': item.modules.moduleDynamic.additional.match,
    // 游戏信息
    'ADDITIONAL_TYPE_COMMON': item.modules.moduleDynamic.additional.common,
  };
  Color bgColor = floor == 1
      ? Theme.of(context).dividerColor.withOpacity(0.08)
      : Theme.of(context).colorScheme.background;
  switch (type) {
    case 'ADDITIONAL_TYPE_UGC':
      return InkWell(
        onTap: () {},
        child: Container(
          padding:
              const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          color: bgColor,
          child: Row(
            children: [
              NetworkImgLayer(
                width: 120,
                height: 75,
                src: dynamicProperty[type].cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      dynamicProperty[type].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dynamicProperty[type].descSecond,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    case 'ADDITIONAL_TYPE_RESERVE':
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: InkWell(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 10),
            color: bgColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dynamicProperty[type].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize),
                    children: [
                      TextSpan(text: dynamicProperty[type].desc1['text']),
                      const TextSpan(text: '  '),
                      TextSpan(text: dynamicProperty[type].desc2['text']),
                    ],
                  ),
                )
              ],
            ),
            // TextButton(onPressed: () {}, child: Text('123'))
          ),
        ),
      );
    case 'ADDITIONAL_TYPE_GOODS':
      return Padding(
          padding: const EdgeInsets.only(top: 6),
          child: InkWell(
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              child: Row(
                children: [
                  NetworkImgLayer(
                    width: 75,
                    height: 75,
                    src: dynamicProperty[type].items.first.cover,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          dynamicProperty[type].items.first.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          dynamicProperty[type].items.first.brief,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .fontSize,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dynamicProperty[type].items.first.price,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
    case 'ADDITIONAL_TYPE_MATCH':
      return SizedBox();
    case 'ADDITIONAL_TYPE_COMMON':
      return SizedBox();
    case 'ADDITIONAL_TYPE_VOTE':
      return SizedBox();
    default:
      return Text('11');
  }
}
