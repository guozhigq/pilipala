import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/models/bangumi/info.dart';
import 'package:pilipala/pages/bangumi/widgets/bangumi_panel.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/pages/video/detail/introduction/widgets/action_item.dart';
import 'package:pilipala/pages/video/detail/introduction/widgets/fav_panel.dart';
import 'package:pilipala/plugin/pl_gallery/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';
import '../../../common/widgets/http_error.dart';
import 'controller.dart';
import 'widgets/intro_detail.dart';

class BangumiIntroPanel extends StatefulWidget {
  final int? cid;
  const BangumiIntroPanel({
    Key? key,
    this.cid,
  }) : super(key: key);

  @override
  State<BangumiIntroPanel> createState() => _BangumiIntroPanelState();
}

class _BangumiIntroPanelState extends State<BangumiIntroPanel>
    with AutomaticKeepAliveClientMixin {
  late BangumiIntroController bangumiIntroController;
  late VideoDetailController videoDetailCtr;
  BangumiInfoModel? bangumiDetail;
  late Future _futureBuilderFuture;
  late int cid;
  late String heroTag;

// 添加页面缓存
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    heroTag = Get.arguments['heroTag'];
    cid = widget.cid!;
    bangumiIntroController = Get.put(BangumiIntroController(), tag: heroTag);
    videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);
    _futureBuilderFuture = bangumiIntroController.queryBangumiIntro();
    videoDetailCtr.cid.listen((int p0) {
      cid = p0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const SliverToBoxAdapter(child: SizedBox());
          }
          if (snapshot.data['status']) {
            // 请求成功
            return Obx(
              () => BangumiInfo(
                bangumiDetail: bangumiIntroController.bangumiDetail.value,
                cid: cid,
              ),
            );
          } else {
            // 请求错误
            return HttpError(
              errMsg: snapshot.data['msg'],
              fn: () => Get.back(),
            );
          }
        } else {
          return const SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}

class BangumiInfo extends StatefulWidget {
  const BangumiInfo({
    super.key,
    this.bangumiDetail,
    this.cid,
  });

  final BangumiInfoModel? bangumiDetail;
  final int? cid;

  @override
  State<BangumiInfo> createState() => _BangumiInfoState();
}

class _BangumiInfoState extends State<BangumiInfo> {
  String heroTag = Get.arguments['heroTag'];
  late final BangumiIntroController bangumiIntroController;
  late final VideoDetailController videoDetailCtr;
  Box localCache = GStrorage.localCache;
  late double sheetHeight;
  int? cid;
  bool isProcessing = false;
  void Function()? handleState(Future Function() action) {
    return isProcessing
        ? null
        : () async {
            setState(() => isProcessing = true);
            await action();
            setState(() => isProcessing = false);
          };
  }

  @override
  void initState() {
    super.initState();
    bangumiIntroController = Get.put(BangumiIntroController(), tag: heroTag);
    videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);
    sheetHeight = localCache.get('sheetHeight');
    cid = widget.cid!;
    videoDetailCtr.cid.listen((p0) {
      cid = p0;
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // 收藏
  showFavBottomSheet() async {
    if (bangumiIntroController.userInfo.mid == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    final mediaQueryData = MediaQuery.of(context);
    final contentHeight = mediaQueryData.size.height - kToolbarHeight;
    final double initialChildSize =
        (contentHeight - Get.width * 9 / 16) / contentHeight;
    await showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
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
              ctr: bangumiIntroController,
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
    showBottomSheet(
      context: context,
      enableDrag: true,
      builder: (BuildContext context) {
        return IntroDetail(bangumiDetail: widget.bangumiDetail!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.only(
          left: StyleString.safeSpace, right: StyleString.safeSpace, top: 20),
      sliver: SliverToBoxAdapter(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        HeroDialogRoute<void>(
                          builder: (BuildContext context) =>
                              InteractiveviewerGallery(
                            sources: [widget.bangumiDetail!.cover!],
                            initIndex: 0,
                            onPageChanged: (int pageIndex) {},
                          ),
                        ),
                      );
                    },
                    child: NetworkImgLayer(
                      width: 115,
                      height: 115 / 0.75,
                      src: widget.bangumiDetail!.cover!,
                    ),
                  ),
                  PBadge(
                    text:
                        '评分 ${widget.bangumiDetail?.rating?['score']! ?? '暂无'}',
                    top: null,
                    right: 6,
                    bottom: 6,
                    left: null,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => showIntroDetail(),
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 115 / 0.75,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 4, 6, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.bangumiDetail!.title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Obx(
                                () => BangumiStatusWidget(
                                  ctr: bangumiIntroController,
                                  isFollowed:
                                      bangumiIntroController.isFollowed.value,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              StatView(
                                view: widget.bangumiDetail!.stat!['views'],
                                size: 'medium',
                              ),
                              const SizedBox(width: 6),
                              StatDanMu(
                                danmu: widget.bangumiDetail!.stat!['danmakus'],
                                size: 'medium',
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '简介：${widget.bangumiDetail!.evaluate!}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: t.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          /// 点赞收藏转发
          actionGrid(context, bangumiIntroController),
          // 番剧分p
          if (widget.bangumiDetail!.episodes!.isNotEmpty) ...[
            BangumiPanel(
              pages: widget.bangumiDetail!.episodes!,
              cid: cid! ?? widget.bangumiDetail!.episodes!.first.cid!,
              sheetHeight: sheetHeight,
              changeFuc: (bvid, cid, aid, cover) => bangumiIntroController
                  .changeSeasonOrbangu(bvid, cid, aid, cover),
              bangumiDetail: bangumiIntroController.bangumiDetail.value,
              bangumiIntroController: bangumiIntroController,
            )
          ],
        ],
      )),
    );
  }

  Widget actionGrid(BuildContext context, bangumiIntroController) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Material(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: SizedBox(
            height: constraints.maxWidth / 5 * 0.8,
            child: GridView.count(
              primary: false,
              padding: EdgeInsets.zero,
              crossAxisCount: 5,
              childAspectRatio: 1.25,
              children: <Widget>[
                Obx(
                  () => ActionItem(
                    icon: const Icon(FontAwesomeIcons.thumbsUp),
                    selectIcon: const Icon(FontAwesomeIcons.solidThumbsUp),
                    onTap: handleState(bangumiIntroController.actionLikeVideo),
                    selectStatus: bangumiIntroController.hasLike.value,
                    text: widget.bangumiDetail!.stat!['likes']!.toString(),
                  ),
                ),
                Obx(
                  () => ActionItem(
                    icon: const Icon(FontAwesomeIcons.b),
                    selectIcon: const Icon(FontAwesomeIcons.b),
                    onTap: handleState(bangumiIntroController.actionCoinVideo),
                    selectStatus: bangumiIntroController.hasCoin.value,
                    text: widget.bangumiDetail!.stat!['coins']!.toString(),
                  ),
                ),
                Obx(
                  () => ActionItem(
                    icon: const Icon(FontAwesomeIcons.star),
                    selectIcon: const Icon(FontAwesomeIcons.solidStar),
                    onTap: () => showFavBottomSheet(),
                    selectStatus: bangumiIntroController.hasFav.value,
                    text: widget.bangumiDetail!.stat!['favorite']!.toString(),
                  ),
                ),
                ActionItem(
                  icon: const Icon(FontAwesomeIcons.comment),
                  selectIcon: const Icon(FontAwesomeIcons.reply),
                  onTap: () => videoDetailCtr.tabCtr.animateTo(1),
                  selectStatus: false,
                  text: widget.bangumiDetail!.stat!['reply']!.toString(),
                ),
                ActionItem(
                  icon: const Icon(FontAwesomeIcons.shareFromSquare),
                  onTap: () => bangumiIntroController.actionShareVideo(),
                  selectStatus: false,
                  text: widget.bangumiDetail!.stat!['share']!.toString(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// 追番状态
class BangumiStatusWidget extends StatelessWidget {
  final BangumiIntroController ctr;
  final bool isFollowed;

  const BangumiStatusWidget({
    Key? key,
    required this.ctr,
    required this.isFollowed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    void updateFollowStatus() {
      showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        builder: (context) {
          return morePanel(context, ctr);
        },
      );
    }

    return Obx(
      () => SizedBox(
        width: 34,
        height: 34,
        child: IconButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            backgroundColor:
                MaterialStateProperty.resolveWith((Set<MaterialState> states) {
              return ctr.isFollowed.value
                  ? colorScheme.primaryContainer.withOpacity(0.7)
                  : colorScheme.outlineVariant.withOpacity(0.7);
            }),
          ),
          onPressed:
              isFollowed ? () => updateFollowStatus() : () => ctr.bangumiAdd(),
          icon: Icon(
            ctr.isFollowed.value
                ? Icons.favorite
                : Icons.favorite_border_rounded,
            color: ctr.isFollowed.value
                ? colorScheme.primary
                : colorScheme.outline,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget morePanel(BuildContext context, BangumiIntroController ctr) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              height: 35,
              padding: const EdgeInsets.only(bottom: 2),
              child: Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                ),
              ),
            ),
          ),
          ...ctr.followStatusList
              .map(
                (e) => ListTile(
                  onTap: () => ctr.updateBangumiStatus(e['status']),
                  selected: ctr.followStatus == e['status'],
                  title: Text(e['title']),
                ),
              )
              .toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
