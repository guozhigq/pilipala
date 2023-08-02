// ignore: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HotKeyword extends StatelessWidget {
  final double? width;
  final List? hotSearchList;
  final Function? onClick;
  const HotKeyword({
    this.width,
    this.hotSearchList,
    this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 0.4,
      spacing: 5.0,
      children: [
        for (var i in hotSearchList!)
          SizedBox(
            width: width! / 2 - 4,
            child: Material(
              borderRadius: BorderRadius.circular(3),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => onClick!(i.keyword),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 2,
                      right: hotSearchList!.indexOf(i) % 2 == 1 ? 10 : 0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(6, 5, 4, 5),
                          child: Text(
                            i.keyword!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      if (i.icon != null && i.icon != '')
                        SizedBox(
                          height: 15,
                          child: CachedNetworkImage(
                              imageUrl: i.icon!, height: 15.0),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
