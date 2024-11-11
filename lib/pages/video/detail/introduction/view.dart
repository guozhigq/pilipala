// import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/pages/video/detail/introduction/controller.dart';
import 'package:pilipala/pages/video/detail/widgets/ai_detail.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/global_data_cache.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/utils.dart';
import '../../../../http/user.dart';
import 'widgets/action_item.dart';
import 'widgets/fav_panel.dart';
import 'widgets/intro_detail.dart';
import 'widgets/page_panel.dart';
import 'widgets/season_panel.dart';
import 'widgets/staff_up_item.dart';

class VideoIntroPanel extends StatefulWidget {
  final String bvid;
  final String? cid;

  const VideoIntroPanel({super.key, required this.bvid, this.cid});

  @override
  State<VideoIntroPanel> createState() => _VideoIntroPanelState();
}

class _VideoIntroPanelState extends State<VideoIntroPanel>
    with AutomaticKeepAliveClientMixin {
  late String heroTag;
  late VideoIntroController videoIntroController;
  VideoDetailData? videoDetail;
  late Future? _futureBuilderFuture;

  // 添加页面缓存
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    /// fix 全屏时参数丢失
    heroTag = Get.arguments['heroTag'];
    videoIntroController =
        Get.put(VideoIntroController(bvid: widget.bvid), tag: heroTag);
    _futureBuilderFuture = videoIntroController.queryVideoIntro();
    videoIntroController.videoDetail.listen((value) {
      videoDetail = value;
    });
  }

  @override
  void dispose() {
    videoIntroController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const SliverToBoxAdapter(child: SizedBox());
          }
          if (snapshot.data['status']) {
            // 请求成功
            return Obx(
              () => VideoInfo(
                videoDetail: videoIntroController.videoDetail.value,
                heroTag: heroTag,
                bvid: widget.bvid,
              ),
            );
          } else {
            // 请求错误
            return HttpError(
              errMsg: snapshot.data['msg'],
              btnText: snapshot.data['code'] == -404 ||
                      snapshot.data['code'] == 62002
                  ? '返回上一页'
                  : null,
              fn: () => Get.back(),
            );
          }
        } else {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: Center(
                child: Lottie.asset(
                  'assets/loading.json',
                  width: 200,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class VideoInfo extends StatefulWidget {
  final VideoDetailData? videoDetail;
  final String? heroTag;
  final String bvid;

  const VideoInfo({
    Key? key,
    this.videoDetail,
    this.heroTag,
    required this.bvid,
  }) : super(key: key);

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> with TickerProviderStateMixin {
  late String heroTag;
  late final VideoIntroController videoIntroController;
  late final VideoDetailController videoDetailCtr;
  final Box<dynamic> localCache = GStorage.localCache;
  final Box<dynamic> setting = GStorage.setting;
  late double sheetHeight;
  late final dynamic owner;
  late int mid;
  late String memberHeroTag;
  late bool enableAi;
  bool isProcessing = false;
  RxBool isExpand = false.obs;
  late ExpandableController _expandableCtr;

  void Function()? handleState(Future<dynamic> Function() action) {
    return isProcessing
        ? null
        : () async {
            isProcessing = true;
            await action.call();
            isProcessing = false;
          };
  }

  @override
  void initState() {
    super.initState();
    heroTag = widget.heroTag!;
    videoIntroController =
        Get.put(VideoIntroController(bvid: widget.bvid), tag: heroTag);
    videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);
    sheetHeight = localCache.get('sheetHeight');

    owner = widget.videoDetail!.owner;
    enableAi = setting.get(SettingBoxKey.enableAi, defaultValue: true);
    _expandableCtr = ExpandableController(
        initialExpanded: GlobalDataCache().enableAutoExpand);
  }

  // 收藏
  showFavBottomSheet({type = 'tap'}) {
    if (videoIntroController.userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    final bool enableDragQuickFav =
        setting.get(SettingBoxKey.enableQuickFav, defaultValue: false);
    // 快速收藏 &
    // 点按 收藏至默认文件夹
    // 长按选择文件夹
    if (enableDragQuickFav) {
      if (type == 'tap') {
        if (!videoIntroController.hasFav.value) {
          videoIntroController.actionFavVideo(type: 'default');
        } else {
          _showFavPanel();
        }
      } else {
        _showFavPanel();
      }
    } else if (type != 'longPress') {
      _showFavPanel();
    }
  }

  void _showFavPanel() async {
    final mediaQueryData = MediaQuery.of(context);
    final contentHeight = mediaQueryData.size.height - kToolbarHeight;
    final double initialChildSize =
        (contentHeight - Get.width * 9 / 16) / contentHeight;
    await showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: 0,
          maxChildSize: 1,
          snap: true,
          expand: false,
          snapSizes: [initialChildSize],
          builder: (BuildContext context, ScrollController scrollController) {
            return FavPanel(
              ctr: videoIntroController,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  // 视频介绍
  showIntroDetail() {
    feedBack();
    isExpand.value = !(isExpand.value);
    _expandableCtr.toggle();
  }

  // 用户主页
  onPushMember() {
    feedBack();
    mid = widget.videoDetail!.owner!.mid!;
    memberHeroTag = Utils.makeHeroTag(mid);
    String face = widget.videoDetail!.owner!.face!;
    Get.toNamed('/member?mid=$mid',
        arguments: {'face': face, 'heroTag': memberHeroTag});
  }

  // ai总结
  showAiBottomSheet() {
    showBottomSheet(
      context: context,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (BuildContext context) {
        return AiDetail(modelResult: videoIntroController.modelResult);
      },
    );
  }

  @override
  void dispose() {
    _expandableCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);
    final Color outline = t.colorScheme.outline;
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: StyleString.safeSpace,
        right: StyleString.safeSpace,
        top: 16,
      ),
      sliver: SliverToBoxAdapter(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => showIntroDetail(),
            onLongPress: () async {
              feedBack();
              await Clipboard.setData(
                  ClipboardData(text: widget.videoDetail!.title!));
              SmartDialog.showToast('标题已复制');
            },
            child: ExpandablePanel(
              controller: _expandableCtr,
              collapsed: Text(
                widget.videoDetail!.title!,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              expanded: Text(
                widget.videoDetail!.title!,
                softWrap: true,
                maxLines: 10,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              theme: const ExpandableThemeData(
                animationDuration: Duration(milliseconds: 300),
                scrollAnimationDuration: Duration(milliseconds: 300),
                crossFadePoint: 0,
                fadeCurve: Curves.ease,
                sizeCurve: Curves.linear,
              ),
            ),
          ),
          Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => showIntroDetail(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 7, bottom: 6),
                  child: Row(
                    children: [
                      StatView(
                        view: widget.videoDetail!.stat!.view,
                        size: 'medium',
                      ),
                      const SizedBox(width: 10),
                      StatDanMu(
                        danmu: widget.videoDetail!.stat!.danmaku,
                        size: 'medium',
                      ),
                      const SizedBox(width: 10),
                      Text(
                        Utils.dateFormat(widget.videoDetail!.pubdate,
                            formatType: 'detail'),
                        style: TextStyle(
                          fontSize: 12,
                          color: t.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (videoIntroController.isShowOnlineTotal)
                        Obx(
                          () => Text(
                            '${videoIntroController.total.value}人在看',
                            style: TextStyle(
                              fontSize: 12,
                              color: t.colorScheme.outline,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (enableAi)
                Positioned(
                  right: 10,
                  top: 6,
                  child: GestureDetector(
                    onTap: () async {
                      final res = await videoIntroController.aiConclusion();
                      if (res['status']) {
                        showAiBottomSheet();
                      }
                    },
                    child: Image.asset('assets/images/ai.png', height: 22),
                  ),
                )
            ],
          ),

          /// 视频简介
          ExpandablePanel(
            controller: _expandableCtr,
            collapsed: const SizedBox(height: 0),
            expanded: IntroDetail(videoDetail: widget.videoDetail!),
            theme: const ExpandableThemeData(
              animationDuration: Duration(milliseconds: 300),
              scrollAnimationDuration: Duration(milliseconds: 300),
              crossFadePoint: 0,
              fadeCurve: Curves.ease,
              sizeCurve: Curves.linear,
            ),
          ),

          /// 点赞收藏转发
          Material(child: actionGrid(context, videoIntroController)),
          // 合集 videoPart 简洁
          if (widget.videoDetail!.ugcSeason != null) ...[
            Obx(
              () => SeasonPanel(
                ugcSeason: widget.videoDetail!.ugcSeason!,
                cid: videoIntroController.lastPlayCid.value != 0
                    ? videoIntroController.lastPlayCid.value
                    : widget.videoDetail!.pages!.first.cid,
                sheetHeight: videoDetailCtr.sheetHeight.value,
                changeFuc: (bvid, cid, aid, cover) =>
                    videoIntroController.changeSeasonOrbangu(
                  bvid,
                  cid,
                  aid,
                  cover,
                ),
                videoIntroCtr: videoIntroController,
              ),
            )
          ],
          // 合集 videoEpisode
          if (widget.videoDetail!.pages != null &&
              widget.videoDetail!.pages!.length > 1) ...[
            Obx(
              () => PagesPanel(
                pages: widget.videoDetail!.pages!,
                cid: videoIntroController.lastPlayCid.value,
                sheetHeight: videoDetailCtr.sheetHeight.value,
                changeFuc: (cid, cover) =>
                    videoIntroController.changeSeasonOrbangu(
                  videoIntroController.bvid,
                  cid,
                  null,
                  cover,
                ),
                videoIntroCtr: videoIntroController,
              ),
            )
          ],
          if (widget.videoDetail!.staff == null)
            GestureDetector(
              onTap: onPushMember,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Row(
                  children: [
                    NetworkImgLayer(
                      type: 'avatar',
                      src: widget.videoDetail!.owner!.face,
                      width: 34,
                      height: 34,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                    ),
                    const SizedBox(width: 10),
                    Text(widget.videoDetail!.owner!.name!,
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 6),
                    Obx(
                      () => Text(
                        Utils.numFormat(videoIntroController.follower.value),
                        style: TextStyle(
                          fontSize: t.textTheme.labelSmall!.fontSize,
                          color: outline,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () {
                        final int attr =
                            videoIntroController.followStatus['attribute'] ?? 0;
                        return videoIntroController.followStatus.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: 32,
                                child: TextButton(
                                  onPressed:
                                      videoIntroController.actionRelationMod,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
                                    foregroundColor: attr != 0
                                        ? outline
                                        : t.colorScheme.onPrimary,
                                    backgroundColor: attr != 0
                                        ? t.colorScheme.onInverseSurface
                                        : t.colorScheme.primary, // 设置按钮背景色
                                  ),
                                  child: Text(
                                    attr == 128
                                        ? '已拉黑'
                                        : attr != 0
                                            ? '已关注'
                                            : '关注',
                                    style: TextStyle(
                                      fontSize:
                                          t.textTheme.labelMedium!.fontSize,
                                    ),
                                  ),
                                ),
                              );
                      },
                    )
                  ],
                ),
              ),
            ),
          if (widget.videoDetail!.staff != null) ...[
            const SizedBox(height: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                    ),
                    children: [
                      TextSpan(
                        text: '创作团队',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const WidgetSpan(child: SizedBox(width: 6)),
                      TextSpan(
                        text: '${widget.videoDetail!.staff!.length}人',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i = 0;
                          i < widget.videoDetail!.staff!.length;
                          i++) ...[
                        StaffUpItem(item: widget.videoDetail!.staff![i])
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ]
        ],
      )),
    );
  }

  Widget actionGrid(BuildContext context, videoIntroController) {
    final actionTypeSort = GlobalDataCache().actionTypeSort;

    Map<String, Widget> menuListWidgets = {
      'like': Obx(
        () => ActionItem(
          icon: const Icon(FontAwesomeIcons.thumbsUp),
          selectIcon: const Icon(FontAwesomeIcons.solidThumbsUp),
          onTap: handleState(videoIntroController.actionLikeVideo),
          onLongPress: () => videoIntroController.oneThreeDialog(),
          selectStatus: videoIntroController.hasLike.value,
          text: widget.videoDetail!.stat!.like!.toString(),
        ),
      ),
      'coin': Obx(
        () => ActionItem(
          icon: const Icon(FontAwesomeIcons.b),
          selectIcon: const Icon(FontAwesomeIcons.b),
          onTap: handleState(videoIntroController.actionCoinVideo),
          selectStatus: videoIntroController.hasCoin.value,
          text: widget.videoDetail!.stat!.coin!.toString(),
        ),
      ),
      'collect': Obx(
        () => ActionItem(
          icon: const Icon(FontAwesomeIcons.star),
          selectIcon: const Icon(FontAwesomeIcons.solidStar),
          onTap: () => showFavBottomSheet(),
          onLongPress: () => showFavBottomSheet(type: 'longPress'),
          selectStatus: videoIntroController.hasFav.value,
          text: widget.videoDetail!.stat!.favorite!.toString(),
        ),
      ),
      'watchLater': ActionItem(
        icon: const Icon(FontAwesomeIcons.clock),
        onTap: () async {
          final res =
              await UserHttp.toViewLater(bvid: widget.videoDetail!.bvid);
          SmartDialog.showToast(res['msg']);
        },
        selectStatus: false,
        text: '稍后看',
      ),
      'share': ActionItem(
        icon: const Icon(FontAwesomeIcons.shareFromSquare),
        onTap: () => videoIntroController.actionShareVideo(),
        selectStatus: false,
        text: '分享',
      ),
      'dislike': Obx(
        () => ActionItem(
          icon: const Icon(FontAwesomeIcons.thumbsDown),
          selectIcon: const Icon(FontAwesomeIcons.solidThumbsDown),
          onTap: () {},
          selectStatus: videoIntroController.hasDisLike.value,
          text: '不喜欢',
        ),
      ),
      'downloadCover': ActionItem(
        icon: const Icon(Icons.image_outlined),
        onTap: () {},
        selectStatus: false,
        text: '下载封面',
      ),
      'copyLink': ActionItem(
        icon: const Icon(Icons.link_outlined),
        onTap: () {},
        selectStatus: false,
        text: '复制链接',
      ),
    };
    final List<Widget> list = [];
    for (var i = 0; i < actionTypeSort.length; i++) {
      list.add(menuListWidgets[actionTypeSort[i]]!);
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        margin: const EdgeInsets.only(top: 6, bottom: 4),
        height: constraints.maxWidth / 5,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: list,
        ),
      );
    });
  }
}
