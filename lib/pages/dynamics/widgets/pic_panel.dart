import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

Widget picWidget(item, context) {
  String type = item.modules.moduleDynamic.major.type;
  List pictures = [];
  if (type == 'MAJOR_TYPE_OPUS') {
    pictures = item.modules.moduleDynamic.major.opus.pics;
  }
  if (type == 'MAJOR_TYPE_DRAW') {
    pictures = item.modules.moduleDynamic.major.draw.items;
  }
  int len = pictures.length;
  List picList = [];

  List<Widget> list = [];
  for (var i = 0; i < len; i++) {
    picList.add(pictures[i].src ?? pictures[i].url);
    list.add(
      LayoutBuilder(
        builder: (context, BoxConstraints box) {
          return GestureDetector(
            onTap: () {
              Get.toNamed('/preview',
                  arguments: {'initialPage': i, 'imgList': picList});
            },
            child: Hero(
              tag: pictures[i].src,
              child: NetworkImgLayer(
                src: pictures[i].src ?? pictures[i].url,
                width: box.maxWidth,
                height: box.maxWidth,
              ),
            ),
          );
        },
      ),
    );
  }
  return LayoutBuilder(
    builder: (context, BoxConstraints box) {
      double maxWidth = box.maxWidth;
      double aspectRatio = 1.1;
      double crossCount = len == 1
          ? 1
          : len < 3
              ? 2
              : 3;

      double height = 0.0;
      if (len == 1) {
        aspectRatio = pictures.first.width / pictures.first.height;
        height = pictures.first.height * maxWidth / pictures.first.width;
      } else {
        aspectRatio = 1;
        height = maxWidth /
                crossCount *
                (len % crossCount == 0
                    ? len ~/ crossCount
                    : len ~/ crossCount + 1) +
            6;
      }

      return Container(
        padding: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(StyleString.imgRadius.x),
        ),
        clipBehavior: Clip.hardEdge,
        height: height,
        child: GridView.count(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossCount.toInt(),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: aspectRatio,
          children: list,
        ),
      );
    },
  );
}
