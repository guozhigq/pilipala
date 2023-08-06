import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/utils.dart';

Widget searchLivePanel(BuildContext context, ctr, list) {
  return Padding(
    padding: const EdgeInsets.only(
        left: StyleString.safeSpace, right: StyleString.safeSpace),
    child: GridView.builder(
      primary: false,
      controller: ctr!.scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: StyleString.cardSpace + 2,
        mainAxisSpacing: StyleString.cardSpace + 3,
        mainAxisExtent:
            MediaQuery.of(context).size.width / 2 / StyleString.aspectRatio +
                60,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return LiveItem(liveItem: list![index]);
      },
    ),
  );
}

class LiveItem extends StatelessWidget {
  final dynamic liveItem;
  const LiveItem({Key? key, required this.liveItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: StyleString.mdRadius,
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: StyleString.imgRadius,
                topRight: StyleString.imgRadius,
                bottomLeft: StyleString.imgRadius,
                bottomRight: StyleString.imgRadius,
              ),
              child: AspectRatio(
                aspectRatio: StyleString.aspectRatio,
                child: LayoutBuilder(builder: (context, boxConstraints) {
                  double maxWidth = boxConstraints.maxWidth;
                  double maxHeight = boxConstraints.maxHeight;
                  return Stack(
                    children: [
                      Hero(
                        tag: Utils.makeHeroTag(liveItem.roomid),
                        child: NetworkImgLayer(
                          src: liveItem.cover,
                          type: 'emote',
                          width: maxWidth,
                          height: maxHeight,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: AnimatedOpacity(
                          opacity: 1,
                          duration: const Duration(milliseconds: 200),
                          child: LiveStat(
                            online: liveItem.online,
                            cateName: liveItem.cateName,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            LiveContent(liveItem: liveItem)
          ],
        ),
      ),
    );
  }
}

class LiveContent extends StatelessWidget {
  final dynamic liveItem;
  const LiveContent({Key? key, required this.liveItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 5, 6, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  for (var i in liveItem.title) ...[
                    TextSpan(
                      text: i['text'],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                        color: i['type'] == 'em'
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                liveItem.uname,
                maxLines: 1,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveStat extends StatelessWidget {
  final int? online;
  final String? cateName;

  const LiveStat({Key? key, required this.online, this.cateName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.only(top: 22, left: 8, right: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            Colors.black54,
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            cateName!,
            style: const TextStyle(fontSize: 11, color: Colors.white),
          ),
          Text(
            '围观:${online.toString()}',
            style: const TextStyle(fontSize: 11, color: Colors.white),
          )
        ],
      ),
    );
  }
}
