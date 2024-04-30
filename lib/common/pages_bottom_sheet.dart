import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../models/common/video_episode_type.dart';

class EpisodeBottomSheet {
  final List<dynamic> episodes;
  final int currentCid;
  final dynamic dataType;
  final BuildContext context;
  final Function changeFucCall;
  final int? cid;
  final double? sheetHeight;
  bool isFullScreen = false;

  EpisodeBottomSheet({
    required this.episodes,
    required this.currentCid,
    required this.dataType,
    required this.context,
    required this.changeFucCall,
    this.cid,
    this.sheetHeight,
    this.isFullScreen = false,
  });

  Widget buildEpisodeListItem(
    dynamic episode,
    int index,
    bool isCurrentIndex,
  ) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    String title = '';
    switch (dataType) {
      case VideoEpidoesType.videoEpisode:
        title = episode.title;
        break;
      case VideoEpidoesType.videoPart:
        title = episode.pagePart;
        break;
      case VideoEpidoesType.bangumiEpisode:
        title = '第${episode.title}话  ${episode.longTitle!}';
        break;
    }
    return isFullScreen || episode?.cover == null || episode?.cover == ''
        ? ListTile(
            onTap: () {
              SmartDialog.showToast('切换至「$title」');
              changeFucCall.call(episode, index);
            },
            dense: false,
            leading: isCurrentIndex
                ? Image.asset(
                    'assets/images/live.gif',
                    color: primary,
                    height: 12,
                  )
                : null,
            title: Text(title,
                style: TextStyle(
                  fontSize: 14,
                  color: isCurrentIndex ? primary : onSurface,
                )))
        : InkWell(
            onTap: () {
              SmartDialog.showToast('切换至「$title」');
              changeFucCall.call(episode, index);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
              child: Row(
                children: [
                  NetworkImgLayer(
                      width: 130, height: 75, src: episode?.cover ?? ''),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14,
                        color: isCurrentIndex ? primary : onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget buildTitle() {
    return AppBar(
      toolbarHeight: 45,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(
        '合集（${episodes.length}）',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: !isFullScreen
          ? [
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 14),
            ]
          : null,
    );
  }

  Widget buildShowContent(BuildContext context) {
    final ItemScrollController itemScrollController = ItemScrollController();
    int currentIndex = episodes.indexWhere((dynamic e) => e.cid == currentCid);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        itemScrollController.jumpTo(index: currentIndex);
      });
      return Container(
        height: sheetHeight,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            buildTitle(),
            Expanded(
              child: Material(
                child: PageStorage(
                  bucket: PageStorageBucket(),
                  child: ScrollablePositionedList.builder(
                    itemScrollController: itemScrollController,
                    itemCount: episodes.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      bool isLastItem = index == episodes.length;
                      bool isCurrentIndex = currentIndex == index;
                      return isLastItem
                          ? SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom + 20,
                            )
                          : buildEpisodeListItem(
                              episodes[index],
                              index,
                              isCurrentIndex,
                            );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// The [BuildContext] of the widget that calls the bottom sheet.
  PersistentBottomSheetController show(BuildContext context) {
    final PersistentBottomSheetController btmSheetCtr = showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return buildShowContent(context);
      },
    );
    return btmSheetCtr;
  }
}
