import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/dynamics/up.dart';
import 'package:pilipala/models/live/item.dart';
import 'package:pilipala/pages/dynamics/controller.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/utils.dart';

class UpPanel extends StatefulWidget {
  final FollowUpModel? upData;
  const UpPanel(this.upData, {Key? key}) : super(key: key);

  @override
  State<UpPanel> createState() => _UpPanelState();
}

class _UpPanelState extends State<UpPanel> {
  final ScrollController scrollController = ScrollController();
  int currentMid = -1;
  late double contentWidth = 56;
  List<UpItem> upList = [];
  List<LiveUserItem> liveList = [];
  static const itemPadding = EdgeInsets.symmetric(horizontal: 5, vertical: 0);
  Box userInfoCache = GStrorage.userInfo;
  var userInfo;

  @override
  void initState() {
    super.initState();
    upList = widget.upData!.upList!;
    liveList = widget.upData!.liveUsers!.items!;
    upList.insert(
      0,
      UpItem(
          face: 'https://files.catbox.moe/8uc48f.png', uname: '全部动态', mid: -1),
    );
    userInfo = userInfoCache.get('userInfoCache');
    upList.insert(
      1,
      UpItem(
        face: userInfo.face,
        uname: '我',
        mid: userInfo.mid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,
      pinned: false,
      delegate: _SliverHeaderDelegate(
        height: 90,
        child: Container(
            height: 90,
            color: Theme.of(context).colorScheme.background,
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    children: [
                      const SizedBox(width: 10),
                      for (int i = 0; i < liveList.length; i++) ...[
                        upItemBuild(liveList[i], i)
                      ],
                      VerticalDivider(
                        indent: 20,
                        endIndent: 40,
                        width: 26,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                      for (int i = 0; i < upList.length; i++) ...[
                        upItemBuild(upList[i], i)
                      ],
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () => {feedBack(), Get.toNamed('/follow')},
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withOpacity(0.3),
                      child: Center(
                        child: Text(
                          '全部',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget upItemBuild(data, i) {
    bool isCurrent = currentMid == data.mid || currentMid == -1;
    return InkWell(
      onTap: () {
        feedBack();
        if (data.type == 'up') {
          currentMid = data.mid;
          Get.find<DynamicsController>().mid.value = data.mid;
          Get.find<DynamicsController>().upInfo.value = data;
          Get.find<DynamicsController>().onSelectUp(data.mid);
          int liveLen = liveList.length;
          int upLen = upList.length;
          double itemWidth = contentWidth + itemPadding.horizontal;
          double screenWidth = MediaQuery.of(context).size.width;
          double moveDistance = 0.0;
          if ((upLen - i - 0.5) * itemWidth > screenWidth / 2) {
            moveDistance =
                (i + liveLen + 0.5) * itemWidth + 46 - screenWidth / 2;
          } else {
            moveDistance = (upLen + liveLen) * itemWidth + 46 - screenWidth;
          }
          data.hasUpdate = false;
          scrollController.animateTo(
            moveDistance,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );

          setState(() {});
        } else if (data.type == 'live') {
          LiveItemModel liveItem = LiveItemModel.fromJson({
            'title': data.title,
            'uname': data.uname,
            'face': data.face,
            'roomid': data.roomId,
          });
          Get.toNamed(
            '/liveRoom?roomid=${data.roomId}',
            arguments: {'liveItem': liveItem},
          );
        }
      },
      onLongPress: () {
        feedBack();
        String heroTag = Utils.makeHeroTag(data.mid);
        Get.toNamed('/member?mid=${data.mid}',
            arguments: {'face': data.face, 'heroTag': heroTag});
      },
      child: Padding(
        padding: itemPadding,
        child: AnimatedOpacity(
          opacity: isCurrent ? 1 : 0.3,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Badge(
                smallSize: 8,
                label: data.type == 'live' ? const Text('Live') : null,
                textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                alignment: data.type == 'live'
                    ? AlignmentDirectional.topCenter
                    : AlignmentDirectional.topEnd,
                padding: const EdgeInsets.only(left: 6, right: 6),
                isLabelVisible: data.type == 'live' ||
                    (data.type == 'up' && (data.hasUpdate ?? false)),
                backgroundColor: data.type == 'live'
                    ? Theme.of(context).colorScheme.secondaryContainer
                    : Theme.of(context).colorScheme.primary,
                child: NetworkImgLayer(
                  width: 49,
                  height: 49,
                  src: data.face,
                  type: 'avatar',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SizedBox(
                  width: contentWidth,
                  child: Text(
                    data.uname,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: currentMid == data.mid
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        fontSize:
                            Theme.of(context).textTheme.labelMedium!.fontSize),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverHeaderDelegate({required this.height, required this.child});

  final double height;
  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class UpPanelSkeleton extends StatelessWidget {
  const UpPanelSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 49,
                height: 49,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 45,
                height: 12,
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ],
          ),
        );
      }),
    );
  }
}
