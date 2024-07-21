import 'package:easy_debounce/easy_throttle.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/dynamics/up.dart';
import 'package:pilipala/utils/feed_back.dart';
import '../controller.dart';
import 'index.dart';

class OverlayPanel extends StatefulWidget {
  const OverlayPanel({super.key, required this.ctr, required this.upInfo});

  final DynamicsController ctr;
  final UpItem upInfo;

  @override
  State<OverlayPanel> createState() => _OverlayPanelState();
}

class _OverlayPanelState extends State<OverlayPanel>
    with SingleTickerProviderStateMixin {
  static const itemPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 0);
  final PageController pageController = PageController();
  late double contentWidth = 50;
  late List<UpItem> upList;
  late RxInt currentMid = (-1).obs;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    upList = widget.ctr.upData.value.upList!
        .map<UpItem>((element) => element)
        .toList();
    upList.removeAt(0);
    _tabController = TabController(length: upList.length, vsync: this);

    currentMid.value = widget.upInfo.mid!;

    pageController.addListener(() {
      int index = pageController.page!.round();
      int mid = upList[index].mid!;
      if (mid != currentMid.value) {
        currentMid.value = mid;
        _tabController?.animateTo(index,
            duration: Duration.zero, curve: Curves.linear);
        onClickUp(upList[index], index, type: 'pageChange');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      int index =
          upList.indexWhere((element) => element.mid == widget.upInfo.mid);
      pageController.jumpToPage(index);
      onClickUp(widget.upInfo, index);
      _tabController?.animateTo(index,
          duration: Duration.zero, curve: Curves.linear);
      onClickUp(upList[index], index, type: 'pageChange');
    });
  }

  void onClickUp(data, i, {type = 'click'}) {
    if (type == 'click') {
      pageController.jumpToPage(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(context).padding.top + 4,
        0,
        MediaQuery.of(context).padding.bottom + 4,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              automaticIndicatorColorAdjustment: false,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.only(left: 12, right: 12),
              indicatorPadding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: const BoxDecoration(),
              labelPadding: itemPadding,
              indicatorWeight: 1,
              isScrollable: true,
              tabs: upList.map((e) => Tab(child: upItemBuild(e))).toList(),
              onTap: (index) {
                feedBack();
                EasyThrottle.throttle(
                    'follow', const Duration(milliseconds: 200), () {
                  onClickUp(upList[index], index);
                });
              },
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: upList.length,
              controller: pageController,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: UpDyanmicsPage(upInfo: upList[index], ctr: widget.ctr),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget upItemBuild(data) {
    return Obx(
      () => AnimatedOpacity(
        opacity: currentMid == data.mid ? 1 : 0.3,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: currentMid == data.mid ? 1 : 0.9,
          child: NetworkImgLayer(
            width: contentWidth,
            height: contentWidth,
            src: data.face,
            type: 'avatar',
          ),
        ),
      ),
    );
  }
}
