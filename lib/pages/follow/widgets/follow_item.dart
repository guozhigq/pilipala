import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

Widget followItem({item}) {
  return ListTile(
    onTap: () {},
    leading: NetworkImgLayer(
      width: 38,
      height: 38,
      type: 'avatar',
      src: item.face,
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
