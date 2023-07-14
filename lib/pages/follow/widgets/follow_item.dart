import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/utils.dart';

Widget followItem({item}) {
  String heroTag = Utils.makeHeroTag(item!.mid);
  return ListTile(
    onTap: () => Get.toNamed('/member?mid=${item.mid}',
        arguments: {'face': item.face, 'heroTag': heroTag}),
    leading: Hero(
      tag: heroTag,
      child: NetworkImgLayer(
        width: 38,
        height: 38,
        type: 'avatar',
        src: item.face,
      ),
    ),
    title: Text(item.uname),
    subtitle: Text(
      item.sign,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    dense: true,
    trailing: const SizedBox(width: 6),
  );
}
