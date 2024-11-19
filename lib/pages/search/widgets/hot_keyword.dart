import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HotKeyword extends StatelessWidget {
  final double width;
  final List hotSearchList;
  final Function onClick;

  const HotKeyword({
    required this.width,
    required this.hotSearchList,
    required this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 0.4,
      spacing: 5.0,
      children: hotSearchList.map((item) {
        return HotKeywordItem(
          width: width,
          item: item,
          onClick: onClick,
          isRightPadding: hotSearchList.indexOf(item) % 2 == 1,
        );
      }).toList(),
    );
  }
}

class HotKeywordItem extends StatelessWidget {
  final double width;
  final dynamic item;
  final Function onClick;
  final bool isRightPadding;

  const HotKeywordItem({
    required this.width,
    required this.item,
    required this.onClick,
    required this.isRightPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width / 2 - 4,
      child: Material(
        borderRadius: BorderRadius.circular(4),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => onClick.call(item.keyword),
          child: Padding(
            padding: EdgeInsets.only(left: 2, right: isRightPadding ? 10 : 0),
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 5, 4, 5),
                    child: Text(
                      item.keyword,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                if (item.icon != null && item.icon != '')
                  SizedBox(
                    height: 15,
                    child:
                        CachedNetworkImage(imageUrl: item.icon!, height: 15.0),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
