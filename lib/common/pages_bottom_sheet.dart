import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import '../models/common/video_episode_type.dart';
import 'widgets/badge.dart';
import 'widgets/stat/danmu.dart';
import 'widgets/stat/view.dart';

class EpisodeBottomSheet {
  final List<dynamic> episodes;
  final int currentCid;
  final dynamic dataType;
  final Function changeFucCall;
  final int? cid;
  final double? sheetHeight;
  bool isFullScreen = false;
  final UgcSeason? ugcSeason;

  EpisodeBottomSheet({
    required this.episodes,
    required this.currentCid,
    required this.dataType,
    required this.changeFucCall,
    this.cid,
    this.sheetHeight,
    this.isFullScreen = false,
    this.ugcSeason,
  });

  Widget buildShowContent() {
    return PagesBottomSheet(
      episodes: episodes,
      currentCid: currentCid,
      dataType: dataType,
      changeFucCall: changeFucCall,
      cid: cid,
      sheetHeight: sheetHeight,
      isFullScreen: isFullScreen,
      ugcSeason: ugcSeason,
    );
  }

  PersistentBottomSheetController show(BuildContext context) {
    final PersistentBottomSheetController btmSheetCtr = showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return buildShowContent();
      },
    );
    return btmSheetCtr;
  }
}

class PagesBottomSheet extends StatefulWidget {
  const PagesBottomSheet({
    super.key,
    required this.episodes,
    required this.currentCid,
    required this.dataType,
    required this.changeFucCall,
    this.cid,
    this.sheetHeight,
    this.isFullScreen = false,
    this.ugcSeason,
  });

  final List<dynamic> episodes;
  final int currentCid;
  final dynamic dataType;
  final Function changeFucCall;
  final int? cid;
  final double? sheetHeight;
  final bool isFullScreen;
  final UgcSeason? ugcSeason;

  @override
  State<PagesBottomSheet> createState() => _PagesBottomSheetState();
}

class _PagesBottomSheetState extends State<PagesBottomSheet> {
  final ScrollController _listScrollController = ScrollController();
  late ListObserverController _listObserverController;
  final ScrollController _scrollController = ScrollController();
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex =
        widget.episodes.indexWhere((dynamic e) => e.cid == widget.currentCid);
    _listObserverController =
        ListObserverController(controller: _listScrollController);
    if (widget.dataType == VideoEpidoesType.videoEpisode) {
      _listObserverController.initialIndexModel = ObserverIndexPositionModel(
        index: currentIndex,
        isFixedHeight: true,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.dataType != VideoEpidoesType.videoEpisode) {
        double itemHeight = (widget.isFullScreen
                ? 400
                : Get.size.width - 3 * StyleString.safeSpace) /
            5.2;
        double offset = ((currentIndex - 1) / 2).ceil() * itemHeight;
        _scrollController.jumpTo(offset);
      }
    });
  }

  String prefix() {
    switch (widget.dataType) {
      case VideoEpidoesType.videoEpisode:
        return '选集';
      case VideoEpidoesType.videoPart:
        return '分集';
      case VideoEpidoesType.bangumiEpisode:
        return '选集';
    }
    return '选集';
  }

  @override
  void dispose() {
    _listObserverController.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SizedBox(
        height: widget.sheetHeight,
        child: Column(
          children: [
            TitleBar(
              title: '${prefix()}（${widget.episodes.length}）',
              isFullScreen: widget.isFullScreen,
            ),
            if (widget.ugcSeason != null) ...[
              UgcSeasonBuild(ugcSeason: widget.ugcSeason!),
            ],
            Expanded(
              child: Material(
                child: widget.dataType == VideoEpidoesType.videoEpisode
                    ? ListViewObserver(
                        controller: _listObserverController,
                        child: ListView.builder(
                          controller: _listScrollController,
                          itemCount: widget.episodes.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            bool isLastItem = index == widget.episodes.length;
                            bool isCurrentIndex = currentIndex == index;
                            return isLastItem
                                ? SizedBox(
                                    height:
                                        MediaQuery.of(context).padding.bottom +
                                            20,
                                  )
                                : EpisodeListItem(
                                    episode: widget.episodes[index],
                                    index: index,
                                    isCurrentIndex: isCurrentIndex,
                                    dataType: widget.dataType,
                                    changeFucCall: widget.changeFucCall,
                                    isFullScreen: widget.isFullScreen,
                                  );
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0), // 设置左右间距为12
                        child: GridView.count(
                          controller: _scrollController,
                          crossAxisCount: 2,
                          crossAxisSpacing: StyleString.safeSpace,
                          childAspectRatio: 2.6,
                          children: List.generate(
                            widget.episodes.length,
                            (index) {
                              bool isCurrentIndex = currentIndex == index;
                              return EpisodeGridItem(
                                episode: widget.episodes[index],
                                index: index,
                                isCurrentIndex: isCurrentIndex,
                                dataType: widget.dataType,
                                changeFucCall: widget.changeFucCall,
                                isFullScreen: widget.isFullScreen,
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class TitleBar extends StatelessWidget {
  final String title;
  final bool isFullScreen;

  const TitleBar({
    Key? key,
    required this.title,
    required this.isFullScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 45,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(
        title,
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
}

class EpisodeListItem extends StatelessWidget {
  final dynamic episode;
  final int index;
  final bool isCurrentIndex;
  final dynamic dataType;
  final Function changeFucCall;
  final bool isFullScreen;

  const EpisodeListItem({
    Key? key,
    required this.episode,
    required this.index,
    required this.isCurrentIndex,
    required this.dataType,
    required this.changeFucCall,
    required this.isFullScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ? _buildListTile(context, title, primary, onSurface)
        : _buildInkWell(context, title, primary, onSurface);
  }

  Widget _buildListTile(
      BuildContext context, String title, Color primary, Color onSurface) {
    return ListTile(
      onTap: () {
        if (isCurrentIndex) {
          return;
        }
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
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: isCurrentIndex ? primary : onSurface,
        ),
      ),
    );
  }

  Widget _buildInkWell(
      BuildContext context, String title, Color primary, Color onSurface) {
    return InkWell(
      onTap: () {
        if (isCurrentIndex) {
          return;
        }
        SmartDialog.showToast('切换至「$title」');
        changeFucCall.call(episode, index);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            StyleString.safeSpace, 6, StyleString.safeSpace, 6),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
            const double width = 160;
            return Container(
              constraints: const BoxConstraints(minHeight: 88),
              height: width / StyleString.aspectRatio,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: StyleString.aspectRatio,
                    child: LayoutBuilder(
                      builder: (BuildContext context,
                          BoxConstraints boxConstraints) {
                        final double maxWidth = boxConstraints.maxWidth;
                        final double maxHeight = boxConstraints.maxHeight;
                        return Stack(
                          children: [
                            NetworkImgLayer(
                              src: episode?.cover ?? '',
                              width: maxWidth,
                              height: maxHeight,
                            ),
                            if (episode.duration != 0)
                              PBadge(
                                text: Utils.timeFormat(episode.duration!),
                                right: 6.0,
                                bottom: 6.0,
                                type: 'gray',
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 2, 6, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            episode.title as String,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isCurrentIndex ? primary : onSurface,
                            ),
                          ),
                          const Spacer(),
                          if (dataType != VideoEpidoesType.videoPart) ...[
                            if (episode?.pubdate != null ||
                                episode.pubTime != null)
                              Text(
                                Utils.dateFormat(
                                    episode?.pubdate ?? episode.pubTime),
                                style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        Theme.of(context).colorScheme.outline),
                              ),
                            const SizedBox(height: 2),
                            if (episode.stat != null)
                              Row(
                                children: [
                                  StatView(view: episode.stat.view),
                                  const SizedBox(width: 8),
                                  StatDanMu(danmu: episode.stat.danmaku),
                                  const Spacer(),
                                ],
                              ),
                            const SizedBox(height: 4),
                          ]
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class EpisodeGridItem extends StatelessWidget {
  final dynamic episode;
  final int index;
  final bool isCurrentIndex;
  final dynamic dataType;
  final Function changeFucCall;
  final bool isFullScreen;

  const EpisodeGridItem({
    Key? key,
    required this.episode,
    required this.index,
    required this.isCurrentIndex,
    required this.dataType,
    required this.changeFucCall,
    required this.isFullScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TextStyle textStyle = TextStyle(
      color: isCurrentIndex ? colorScheme.primary : colorScheme.onSurface,
      fontSize: 14,
    );
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: StyleString.safeSpace),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isCurrentIndex
                ? colorScheme.primaryContainer.withOpacity(0.6)
                : colorScheme.onInverseSurface.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCurrentIndex
                  ? colorScheme.primary.withOpacity(0.8)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              if (isCurrentIndex) {
                return;
              }
              SmartDialog.showToast('切换至「${episode.title}」');
              changeFucCall.call(episode, index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                      dataType == VideoEpidoesType.bangumiEpisode
                          ? '第${index + 1}话'
                          : '第${index + 1}p',
                      style: textStyle),
                  const SizedBox(height: 1),
                  Text(
                    episode.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (dataType == VideoEpidoesType.bangumiEpisode &&
            episode.badge != '' &&
            episode.badge != null)
          Positioned(
            right: 8,
            top: 18,
            child: Text(
              episode.badge,
              style: const TextStyle(fontSize: 11, color: Color(0xFFFF6699)),
            ),
          )
      ],
    );
  }
}

class UgcSeasonBuild extends StatelessWidget {
  final UgcSeason ugcSeason;

  const UgcSeasonBuild({
    Key? key,
    required this.ugcSeason,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
          const SizedBox(height: 10),
          Text(
            '合集：${ugcSeason.title}',
            style: Theme.of(context).textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
          if (ugcSeason.intro != null && ugcSeason.intro != '') ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(ugcSeason.intro ?? '',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline)),
                ),
                // SizedBox(
                //   height: 32,
                //   child: FilledButton.tonal(
                //     onPressed: () {},
                //     style: ButtonStyle(
                //       padding: MaterialStateProperty.all(EdgeInsets.zero),
                //     ),
                //     child: const Text('订阅'),
                //   ),
                // ),
                // const SizedBox(width: 6),
              ],
            ),
          ],
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
                color: Theme.of(context).colorScheme.outline,
              ),
              children: [
                TextSpan(text: '${Utils.numFormat(ugcSeason.stat!.view)}播放'),
                const TextSpan(text: '  ·  '),
                TextSpan(text: '${Utils.numFormat(ugcSeason.stat!.danmaku)}弹幕'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ],
      ),
    );
  }
}
