import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

Widget addWidget(item, context, type, {floor = 1}) {
  Map<dynamic, dynamic> dynamicProperty = {
    'ADDITIONAL_TYPE_UGC': item.modules.moduleDynamic.additional.ugc,
  };
  return InkWell(
    onTap: () {},
    child: Container(
      padding: const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 8),
      color: Theme.of(context).dividerColor.withOpacity(0.08),
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
                    fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
