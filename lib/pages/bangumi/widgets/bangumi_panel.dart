import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/bangumi/info.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../common/pages_bottom_sheet.dart';
import '../../../models/common/video_episode_type.dart';
import '../introduction/controller.dart';

class BangumiPanel extends StatefulWidget {
  const BangumiPanel({
    super.key,
    required this.pages,
    required this.cid,
    this.sheetHeight,
    this.changeFuc,
    this.bangumiDetail,
    this.bangumiIntroController,
  });

  final List<EpisodeItem> pages;
  final int cid;
  final double? sheetHeight;
  final Function? changeFuc;
  final BangumiInfoModel? bangumiDetail;
  final BangumiIntroController? bangumiIntroController;

  @override
  State<BangumiPanel> createState() => _BangumiPanelState();
}

class _BangumiPanelState extends State<BangumiPanel> {
  late RxInt currentIndex = (-1).obs;
  final ScrollController listViewScrollCtr = ScrollController();
  Box userInfoCache = GStrorage.userInfo;
  dynamic userInfo;
  // 默认未开通
  int vipStatus = 0;
  late int cid;
  String heroTag = Get.arguments['heroTag'];
  late final VideoDetailController videoDetailCtr;
  final ItemScrollController itemScrollController = ItemScrollController();
  late PersistentBottomSheetController? _bottomSheetController;

  @override
  void initState() {
    super.initState();
    cid = widget.cid;
    videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);
    currentIndex.value =
        widget.pages.indexWhere((EpisodeItem e) => e.cid == cid);
    scrollToIndex();
    videoDetailCtr.cid.listen((int p0) {
      cid = p0;
      currentIndex.value =
          widget.pages.indexWhere((EpisodeItem e) => e.cid == cid);
      scrollToIndex();
    });

    /// 获取大会员状态
    userInfo = userInfoCache.get('userInfoCache');
    if (userInfo != null) {
      vipStatus = userInfo.vipStatus;
    }
  }

  @override
  void dispose() {
    listViewScrollCtr.dispose();
    super.dispose();
  }

  void changeFucCall(item, i) async {
    if (item.badge != null && item.badge == '会员' && vipStatus != 1) {
      SmartDialog.showToast('需要大会员');
      return;
    }
    widget.changeFuc?.call(
      item.bvid,
      item.cid,
      item.aid,
      item.cover,
    );
    if (_bottomSheetController != null) {
      _bottomSheetController?.close();
    }
    currentIndex.value = i;
    scrollToIndex();
  }

  void scrollToIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在回调函数中获取更新后的状态
      final double offset = min((currentIndex * 150) - 75,
          listViewScrollCtr.position.maxScrollExtent);
      if (currentIndex.value == 0) {
        listViewScrollCtr.jumpTo(0);
      } else {
        listViewScrollCtr.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('选集 '),
              Expanded(
                child: Obx(
                  () => Text(
                    ' 正在播放：${widget.pages[currentIndex.value].longTitle}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 34,
                child: TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    widget.bangumiIntroController?.bottomSheetController =
                        _bottomSheetController = EpisodeBottomSheet(
                      currentCid: cid,
                      episodes: widget.pages,
                      changeFucCall: changeFucCall,
                      sheetHeight: widget.sheetHeight,
                      dataType: VideoEpidoesType.bangumiEpisode,
                      context: context,
                    ).show(context);
                  },
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
              var page = widget.pages[i];
              bool isSelected = i == currentIndex.value;
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 10),
                child: Material(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  borderRadius: BorderRadius.circular(6),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () => changeFucCall(page, i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              if (isSelected) ...<Widget>[
                                Image.asset('assets/images/live.png',
                                    color: primary, height: 12),
                                const SizedBox(width: 6)
                              ],
                              Text(
                                '第${i + 1}话',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isSelected ? primary : onSurface,
                                ),
                              ),
                              const SizedBox(width: 2),
                              if (page.badge != null) ...[
                                const Spacer(),
                                Text(
                                  page.badge!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: primary,
                                  ),
                                ),
                              ]
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            page.longTitle!,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? primary : onSurface,
                            ),
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
