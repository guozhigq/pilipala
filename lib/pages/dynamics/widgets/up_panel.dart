import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/dynamics/up.dart';
import 'package:pilipala/pages/dynamics/controller.dart';

class UpPanel extends StatefulWidget {
  FollowUpModel? upData;
  UpPanel(this.upData, {Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    upList = widget.upData!.upList!;
    liveList = widget.upData!.liveUsers!.items!;
    upList.insert(
        0,
        UpItem(
            face: 'https://files.catbox.moe/8uc48f.png',
            uname: '全部动态',
            mid: -1));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,
      pinned: false,
      delegate: _SliverHeaderDelegate(
        height: 115,
        child: Container(
          height: 115,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).dividerColor.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 12, right: 12, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '最常访问',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 26,
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        onPressed: () => Get.toNamed('/follow'),
                        child:
                            const Text('查看全部', style: TextStyle(fontSize: 12)),
                      ),
                    )
                  ],
                ),
              ),
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
                      indent: 15,
                      endIndent: 35,
                      width: 26,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    for (int i = 0; i < upList.length; i++) ...[
                      upItemBuild(upList[i], i)
                    ],
                    const SizedBox(width: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget upItemBuild(data, i) {
    bool isCurrent = currentMid == data.mid || currentMid == -1;
    return InkWell(
      onTap: () {
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
          scrollController.animateTo(
            moveDistance,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );

          setState(() {});
        } else if (data.type == 'live') {
          SmartDialog.showToast('直播功能暂未开发');
        }
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
                textColor: Theme.of(context).colorScheme.onPrimary,
                alignment: AlignmentDirectional.bottomCenter,
                padding: const EdgeInsets.only(left: 4, right: 4),
                isLabelVisible: data.type == 'live' ||
                    (data.type == 'up' && (data.hasUpdate ?? false)),
                backgroundColor: Theme.of(context).primaryColor,
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
                    overflow: TextOverflow.fade,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '最常访问',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: ((context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                )),
          ),
        )
      ],
    );
  }
}
