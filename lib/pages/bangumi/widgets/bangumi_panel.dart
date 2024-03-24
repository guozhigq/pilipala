import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/bangumi/info.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BangumiPanel extends StatefulWidget {
  const BangumiPanel({
    super.key,
    required this.pages,
    this.cid,
    this.sheetHeight,
    this.changeFuc,
    this.bangumiDetail,
  });

  final List<EpisodeItem> pages;
  final int? cid;
  final double? sheetHeight;
  final Function? changeFuc;
  final BangumiInfoModel? bangumiDetail;

  @override
  State<BangumiPanel> createState() => _BangumiPanelState();
}

class _BangumiPanelState extends State<BangumiPanel> {
  late int currentIndex;
  final ScrollController listViewScrollCtr = ScrollController();
  final ScrollController listViewScrollCtr_2 = ScrollController();
  Box userInfoCache = GStrorage.userInfo;
  dynamic userInfo;
  // 默认未开通
  int vipStatus = 0;
  late int cid;
  String heroTag = Get.arguments['heroTag'];
  late final VideoDetailController videoDetailCtr;
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    cid = widget.cid!;
    currentIndex = widget.pages.indexWhere((e) => e.cid == cid);
    scrollToIndex();
    userInfo = userInfoCache.get('userInfoCache');
    if (userInfo != null) {
      vipStatus = userInfo.vipStatus;
    }
    videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);

    videoDetailCtr.cid.listen((int p0) {
      cid = p0;
      setState(() {});
      currentIndex = widget.pages.indexWhere((EpisodeItem e) => e.cid == cid);
      scrollToIndex();
    });
  }

  @override
  void dispose() {
    listViewScrollCtr.dispose();
    listViewScrollCtr_2.dispose();
    super.dispose();
  }

  Widget buildPageListItem(
    EpisodeItem page,
    int index,
    bool isCurrentIndex,
  ) {
    Color primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      onTap: () {
        Get.back();
        setState(() {
          changeFucCall(page, index);
        });
      },
      dense: false,
      leading: isCurrentIndex
          ? Image.asset(
              'assets/images/live.gif',
              color: primary,
              height: 12,
            )
          : null,
      title: Text(
        '第${page.title}话  ${page.longTitle!}',
        style: TextStyle(
          fontSize: 14,
          color: isCurrentIndex
              ? primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: page.badge != null
          ? Text(
              page.badge!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : const SizedBox(),
    );
  }

  void showBangumiPanel() {
    showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              // await Future.delayed(const Duration(milliseconds: 200));
              // listViewScrollCtr_2.animateTo(currentIndex * 56,
              //     duration: const Duration(milliseconds: 500),
              //     curve: Curves.easeInOut);
              itemScrollController.jumpTo(index: currentIndex);
            });
            // 在这里使用 setState 更新状态
            return Container(
              height: widget.sheetHeight,
              color: Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  AppBar(
                    toolbarHeight: 45,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '合集（${widget.pages.length}）',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    titleSpacing: 10,
                  ),
                  Expanded(
                    child: Material(
                      child: ScrollablePositionedList.builder(
                        itemCount: widget.pages.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          bool isLastItem = index == widget.pages.length;
                          bool isCurrentIndex = currentIndex == index;
                          return isLastItem
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).padding.bottom +
                                          20,
                                )
                              : buildPageListItem(
                                  widget.pages[index],
                                  index,
                                  isCurrentIndex,
                                );
                        },
                        itemScrollController: itemScrollController,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void changeFucCall(item, i) async {
    if (item.badge != null && item.badge == '会员' && vipStatus != 1) {
      SmartDialog.showToast('需要大会员');
      return;
    }
    await widget.changeFuc!(
      item.bvid,
      item.cid,
      item.aid,
    );
    currentIndex = i;
    setState(() {});
    scrollToIndex();
  }

  void scrollToIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在回调函数中获取更新后的状态
      listViewScrollCtr.animateTo(currentIndex * 150,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('选集 '),
              Expanded(
                child: Text(
                  ' 正在播放：${widget.pages[currentIndex].longTitle}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 34,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () => showBangumiPanel(),
                  child: Text(
                    '${widget.bangumiDetail!.newEp!['desc']}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.builder(
            controller: listViewScrollCtr,
            scrollDirection: Axis.horizontal,
            itemCount: widget.pages.length,
            itemExtent: 150,
            itemBuilder: (BuildContext context, int i) {
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 10),
                child: Material(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  borderRadius: BorderRadius.circular(6),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () => changeFucCall(widget.pages[i], i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              if (i == currentIndex) ...<Widget>[
                                Image.asset(
                                  'assets/images/live.png',
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 12,
                                ),
                                const SizedBox(width: 6)
                              ],
                              Text(
                                '第${i + 1}话',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: i == currentIndex
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                              ),
                              const SizedBox(width: 2),
                              if (widget.pages[i].badge != null) ...[
                                const Spacer(),
                                Text(
                                  widget.pages[i].badge!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ]
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.pages[i].longTitle!,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 13,
                                color: i == currentIndex
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
