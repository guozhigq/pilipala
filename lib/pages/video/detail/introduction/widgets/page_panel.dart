import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/pages/video/detail/introduction/index.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../../../common/pages_bottom_sheet.dart';
import '../../../../../models/common/video_episode_type.dart';

class PagesPanel extends StatefulWidget {
  const PagesPanel({
    super.key,
    required this.pages,
    required this.cid,
    this.sheetHeight,
    this.changeFuc,
    required this.videoIntroCtr,
  });
  final List<Part> pages;
  final int cid;
  final double? sheetHeight;
  final Function? changeFuc;
  final VideoIntroController videoIntroCtr;

  @override
  State<PagesPanel> createState() => _PagesPanelState();
}

class _PagesPanelState extends State<PagesPanel> {
  late List<Part> episodes;
  late int cid;
  late RxInt currentIndex = (-1).obs;
  final String heroTag = Get.arguments['heroTag'];
  late VideoDetailController _videoDetailController;
  final ScrollController listViewScrollCtr = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  late PersistentBottomSheetController? _bottomSheetController;

  @override
  void initState() {
    super.initState();
    cid = widget.cid;
    episodes = widget.pages;
    _videoDetailController = Get.find<VideoDetailController>(tag: heroTag);
    currentIndex.value = episodes.indexWhere((Part e) => e.cid == cid);
    scrollToIndex();
    _videoDetailController.cid.listen((int p0) {
      cid = p0;
      currentIndex.value = episodes.indexWhere((Part e) => e.cid == cid);
      scrollToIndex();
    });
  }

  @override
  void dispose() {
    listViewScrollCtr.dispose();
    super.dispose();
  }

  void changeFucCall(item, i) async {
    print('pages changeFucCall');
    widget.changeFuc?.call(item.cid);
    currentIndex.value = i;
    _bottomSheetController?.close();
    scrollToIndex();
  }

  void scrollToIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在回调函数中获取更新后的状态
      final double offset = min((currentIndex * 150) - 75,
          listViewScrollCtr.position.maxScrollExtent);
      listViewScrollCtr.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('视频选集 '),
              Expanded(
                child: Obx(() => Text(
                      ' 正在播放：${widget.pages[currentIndex.value].pagePart}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    )),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 34,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    widget.videoIntroCtr.bottomSheetController =
                        _bottomSheetController = EpisodeBottomSheet(
                      currentCid: cid,
                      episodes: episodes,
                      changeFucCall: changeFucCall,
                      sheetHeight: widget.sheetHeight,
                      dataType: VideoEpidoesType.videoPart,
                      context: context,
                    ).show(context);
                  },
                  child: Text(
                    '共${widget.pages.length}集',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 35,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: listViewScrollCtr,
            itemCount: widget.pages.length,
            itemExtent: 150,
            itemBuilder: (BuildContext context, int i) {
              bool isCurrentIndex = currentIndex.value == i;
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
                          vertical: 8, horizontal: 8),
                      child: Row(
                        children: <Widget>[
                          if (isCurrentIndex) ...<Widget>[
                            Image.asset(
                              'assets/images/live.gif',
                              color: Theme.of(context).colorScheme.primary,
                              height: 12,
                            ),
                            const SizedBox(width: 6)
                          ],
                          Expanded(
                              child: Text(
                            widget.pages[i].pagePart!,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 13,
                                color: isCurrentIndex
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface),
                            overflow: TextOverflow.ellipsis,
                          ))
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
