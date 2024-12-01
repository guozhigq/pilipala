import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/pages/video/detail/index.dart';
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
  final int? currentEpisodeIndex;
  final int? currentIndex;

  EpisodeBottomSheet({
    required this.episodes,
    required this.currentCid,
    required this.dataType,
    required this.changeFucCall,
    this.cid,
    this.sheetHeight,
    this.isFullScreen = false,
    this.ugcSeason,
    this.currentEpisodeIndex,
    this.currentIndex,
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
      currentEpisodeIndex: currentEpisodeIndex,
      currentIndex: currentIndex,
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
    this.currentEpisodeIndex,
    this.currentIndex,
  });

  final List<dynamic> episodes;
  final int currentCid;
  final dynamic dataType;
  final Function changeFucCall;
  final int? cid;
  final double? sheetHeight;
  final bool isFullScreen;
  final UgcSeason? ugcSeason;
  final int? currentEpisodeIndex;
  final int? currentIndex;

  @override
  State<PagesBottomSheet> createState() => _PagesBottomSheetState();
}

class _PagesBottomSheetState extends State<PagesBottomSheet>
    with TickerProviderStateMixin {
  final ScrollController _listScrollController = ScrollController();
  late ListObserverController _listObserverController;
  late GridObserverController _gridObserverController;
  final ScrollController _gridScrollController = ScrollController();
  late int currentIndex;
  TabController? tabController;
  List<ListObserverController>? _listObserverControllerList;
  List<ScrollController>? _listScrollControllerList;
  final String heroTag = Get.arguments['heroTag'];
  VideoDetailController? _videoDetailController;
  RxInt isSubscribe = (-1).obs;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex ??
        widget.episodes.indexWhere((dynamic e) => e.cid == widget.currentCid);
    _scrollToInit();
    _scrollPositionInit();
    if (widget.dataType == VideoEpidoesType.videoEpisode) {
      _videoDetailController = Get.find<VideoDetailController>(tag: heroTag);
      _getSubscribeStatus();
    }
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

  // 滚动器初始化
  void _scrollToInit() {
    /// 单个
    _listObserverController =
        ListObserverController(controller: _listScrollController);

    if (widget.dataType == VideoEpidoesType.videoEpisode &&
        widget.ugcSeason?.sections != null &&
        widget.ugcSeason!.sections!.length > 1) {
      tabController = TabController(
        length: widget.ugcSeason!.sections!.length,
        vsync: this,
        initialIndex: widget.currentEpisodeIndex ?? 0,
      );

      /// 多tab
      _listScrollControllerList = List.generate(
        widget.ugcSeason!.sections!.length,
        (index) {
          return ScrollController();
        },
      );
      _listObserverControllerList = List.generate(
        widget.ugcSeason!.sections!.length,
        (index) {
          return ListObserverController(
            controller: _listScrollControllerList![index],
          );
        },
      );
    } else {
      _gridObserverController =
          GridObserverController(controller: _gridScrollController);
    }
  }

  // 滚动器位置初始化
  void _scrollPositionInit() {
    if (widget.dataType == VideoEpidoesType.videoEpisode) {
      // 单个 多tab
      if (widget.ugcSeason?.sections != null) {
        if (widget.ugcSeason!.sections!.length == 1) {
          _listObserverController.initialIndexModel =
              ObserverIndexPositionModel(
            index: currentIndex,
            isFixedHeight: true,
          );
        } else {
          _listObserverControllerList![widget.currentEpisodeIndex ?? 0]
              .initialIndexModel = ObserverIndexPositionModel(
            index: currentIndex,
            isFixedHeight: true,
          );
        }
      }
    } else {
      _gridObserverController.initialIndexModel = ObserverIndexPositionModel(
        index: currentIndex,
        isFixedHeight: false,
      );
    }
  }

  // 获取订阅状态
  void _getSubscribeStatus() async {
    var res =
        await VideoHttp.getSubscribeStatus(bvid: _videoDetailController!.bvid);
    if (res['status']) {
      isSubscribe.value = res['data']['season_fav'] ? 1 : 0;
    }
  }

  // 更改订阅状态
  void _changeSubscribeStatus() async {
    if (isSubscribe.value == -1) {
      return;
    }
    dynamic result = await VideoHttp.seasonFav(
      isFav: isSubscribe.value == 1,
      seasonId: widget.ugcSeason!.id,
    );
    if (result['status']) {
      SmartDialog.showToast(isSubscribe.value == 1 ? '取消订阅成功' : '订阅成功');
      isSubscribe.value = isSubscribe.value == 1 ? 0 : 1;
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // 更改展开状态
  void _changeVisible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void dispose() {
    try {
      _listObserverController.controller?.dispose();
      _gridObserverController.controller?.dispose();
      _listScrollController.dispose();
      _gridScrollController.dispose();
      for (var element in _listObserverControllerList!) {
        element.controller?.dispose();
      }
      for (var element in _listScrollControllerList!) {
        element.dispose();
      }
    } catch (_) {}
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
              UgcSeasonBuild(
                ugcSeason: widget.ugcSeason!,
                isSubscribe: isSubscribe,
                isVisible: isVisible,
                changeFucCall: _changeSubscribeStatus,
                changeVisible: _changeVisible,
              ),
            ],
            Expanded(
              child: Material(
                child: widget.dataType == VideoEpidoesType.videoEpisode
                    ? (widget.ugcSeason!.sections!.length == 1
                        ? ListViewObserver(
                            controller: _listObserverController,
                            child: ListView.builder(
                              controller: _listScrollController,
                              itemCount: widget.episodes.length + 1,
                              itemBuilder: (BuildContext context, int index) {
                                bool isLastItem =
                                    index == widget.episodes.length;
                                bool isCurrentIndex = currentIndex == index;
                                return isLastItem
                                    ? SizedBox(
                                        height: MediaQuery.of(context)
                                                .padding
                                                .bottom +
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
                        : buildTabBar())
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0), // 设置左右间距为12
                        child: GridViewObserver(
                          controller: _gridObserverController,
                          child: GridView.count(
                            controller: _gridScrollController,
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
            ),
          ],
        ),
      );
    });
  }

  Widget buildTabBar() {
    return Column(
      children: [
        // 背景色
        Container(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            tabAlignment: TabAlignment.start,
            splashBorderRadius: BorderRadius.circular(4),
            tabs: [
              ...widget.ugcSeason!.sections!.map((SectionItem section) {
                return Tab(
                  text: section.title,
                );
              }).toList()
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              ...widget.ugcSeason!.sections!.map((SectionItem section) {
                final int fIndex = widget.ugcSeason!.sections!.indexOf(section);
                return ListViewObserver(
                  controller: _listObserverControllerList![fIndex],
                  child: ListView.builder(
                    controller: _listScrollControllerList![fIndex],
                    itemCount: section.episodes!.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      final bool isLastItem = index == section.episodes!.length;
                      return isLastItem
                          ? SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom + 20,
                            )
                          : EpisodeListItem(
                              episode: section.episodes![index], // 调整索引
                              index: index, // 调整索引
                              isCurrentIndex: widget.currentCid ==
                                  section.episodes![index].cid,
                              dataType: widget.dataType,
                              changeFucCall: widget.changeFucCall,
                              isFullScreen: widget.isFullScreen,
                            );
                    },
                  ),
                );
              }).toList()
            ],
          ),
        ),
      ],
    );
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
      elevation: 1,
      scrolledUnderElevation: 1,
      title: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      actions: !isFullScreen
          ? [
              SizedBox(
                width: 35,
                height: 35,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 8),
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
              'assets/images/live.png',
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
  final RxInt isSubscribe;
  final bool isVisible;
  final Function changeFucCall;
  final Function changeVisible;

  const UgcSeasonBuild({
    Key? key,
    required this.ugcSeason,
    required this.isSubscribe,
    required this.isVisible,
    required this.changeFucCall,
    required this.changeVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color outline = theme.colorScheme.outline;
    final Color surface = theme.colorScheme.surface;
    final Color primary = theme.colorScheme.primary;
    final Color onPrimary = theme.colorScheme.onPrimary;
    final Color onInverseSurface = theme.colorScheme.onInverseSurface;
    final TextStyle titleMedium = theme.textTheme.titleMedium!;
    final TextStyle labelMedium = theme.textTheme.labelMedium!;
    final Color dividerColor = theme.dividerColor.withOpacity(0.1);

    return isVisible
        ? Container(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            color: surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(height: 1, thickness: 1, color: dividerColor),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '合集：${ugcSeason.title}',
                        style: titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Obx(
                      () => isSubscribe.value == -1
                          ? const SizedBox(height: 32)
                          : SizedBox(
                              height: 32,
                              child: FilledButton.tonal(
                                onPressed: () => changeFucCall.call(),
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  foregroundColor: isSubscribe.value == 1
                                      ? outline
                                      : onPrimary,
                                  backgroundColor: isSubscribe.value == 1
                                      ? onInverseSurface
                                      : primary,
                                ),
                                child:
                                    Text(isSubscribe.value == 1 ? '已订阅' : '订阅'),
                              ),
                            ),
                    ),
                  ],
                ),
                if (ugcSeason.intro != null && ugcSeason.intro != '') ...[
                  const SizedBox(height: 4),
                  Text(
                    ugcSeason.intro!,
                    style: TextStyle(color: outline, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                        fontSize: labelMedium.fontSize, color: outline),
                    children: [
                      TextSpan(
                          text: '${Utils.numFormat(ugcSeason.stat!.view)}播放'),
                      const TextSpan(text: '  ·  '),
                      TextSpan(
                          text:
                              '${Utils.numFormat(ugcSeason.stat!.danmaku)}弹幕'),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.center,
                  child: Material(
                    color: surface,
                    child: InkWell(
                      onTap: () => changeVisible.call(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 0),
                        child: Text(
                          '收起简介',
                          style: TextStyle(color: primary, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: dividerColor),
              ],
            ),
          )
        : Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () => changeVisible.call(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Text(
                  '展开简介',
                  style: TextStyle(color: primary, fontSize: 12),
                ),
              ),
            ),
          );
  }
}
