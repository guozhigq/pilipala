import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/utils.dart';

Widget searchLivePanel(BuildContext context, ctr, list) {
  return Padding(
    padding: const EdgeInsets.only(
        left: StyleString.cardSpace, right: StyleString.cardSpace),
    child: GridView.builder(
      primary: false,
      controller: ctr!.scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: StyleString.cardSpace,
        mainAxisSpacing: StyleString.cardSpace,
        mainAxisExtent:
            MediaQuery.of(context).size.width / 2 / StyleString.aspectRatio +
                65,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        var i = list![index];
        return Card(
          elevation: 0.8,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: StyleString.mdRadius,
          ),
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () {},
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: StyleString.aspectRatio,
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    double maxWidth = boxConstraints.maxWidth;
                    double maxHeight = boxConstraints.maxHeight;
                    double PR = MediaQuery.of(context).devicePixelRatio;
                    return Stack(
                      children: [
                        Hero(
                          tag: Utils.makeHeroTag(i.roomid),
                          child: NetworkImgLayer(
                            // 指定图片尺寸
                            // src: videoItem.pic + '@${(maxWidth * 2).toInt()}w',
                            src: i.cover + '@.webp',
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
                              online: i.online,
                              cateName: i.cateName,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                LiveContent(liveItem: i)
              ],
            ),
          ),
        );
      },
    ),
  );
}

class LiveContent extends StatelessWidget {
  final liveItem;
  const LiveContent({Key? key, required this.liveItem}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 6, 7),
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
