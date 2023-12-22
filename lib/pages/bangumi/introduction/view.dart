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
import 'package:pilipala/pages/video/detail/introduction/widgets/action_row_item.dart';
import 'package:pilipala/pages/video/detail/introduction/widgets/fav_panel.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';

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
    bangumiIntroController.bangumiDetail.listen((value) {
      bangumiDetail = value;
    });
    _futureBuilderFuture = bangumiIntroController.queryBangumiIntro();
    videoDetailCtr.cid.listen((p0) {
      print('🐶🐶$p0');
      cid = p0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data['status']) {
            // 请求成功

            return BangumiInfo(
              loadingStatus: false,
              bangumiDetail: bangumiDetail,
              cid: cid,
            );
          } else {
            // 请求错误
            // return HttpError(
            //   errMsg: snapshot.data['msg'],
            //   fn: () => Get.back(),
            // );
            return SizedBox();
          }
        } else {
          return BangumiInfo(
            loadingStatus: true,
            bangumiDetail: bangumiDetail,
            cid: cid,
          );
        }
      },
    );
  }
}

class BangumiInfo extends StatefulWidget {
  final bool loadingStatus;
  final BangumiInfoModel? bangumiDetail;
  final int? cid;

  const BangumiInfo({
    Key? key,
    this.loadingStatus = false,
    this.bangumiDetail,
    this.cid,
  }) : super(key: key);

  @override
  State<BangumiInfo> createState() => _BangumiInfoState();
}

class _BangumiInfoState extends State<BangumiInfo> {
  String heroTag = Get.arguments['heroTag'];
  late final BangumiIntroController bangumiIntroController;
  late final VideoDetailController videoDetailCtr;
  Box localCache = GStrorage.localCache;
  late final BangumiInfoModel? bangumiItem;
  late double sheetHeight;
  int? cid;
  bool isProcessing = false;
  VoidCallback handleState(Future Function() action) {
    return () async {
      if (!isProcessing) {
        setState(() => isProcessing = true);
        await action();
        setState(() => isProcessing = false);
      }
    };
  }
  @override
  void initState() {
    super.initState();
    bangumiIntroController = Get.put(BangumiIntroController(), tag: heroTag);
    videoDetailCtr = Get.find<VideoDetailController>(tag: heroTag);
    bangumiItem = bangumiIntroController.bangumiItem;
    sheetHeight = localCache.get('sheetHeight');
    cid = widget.cid!;
    print('cid:  $cid');
    videoDetailCtr.cid.listen((p0) {
      cid = p0;
      print('cid:  $cid');
      setState(() {});
    });
  }

  // 收藏
  showFavBottomSheet() {
    if (bangumiIntroController.userInfo.mid == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return FavPanel(ctr: bangumiIntroController);
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
    ThemeData t = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.only(
          left: StyleString.safeSpace, right: StyleString.safeSpace, top: 20),
      sliver: SliverToBoxAdapter(
        child: !widget.loadingStatus || bangumiItem != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          NetworkImgLayer(
                            width: 105,
                            height: 160,
                            src: !widget.loadingStatus
                                ? widget.bangumiDetail!.cover!
                                : bangumiItem!.cover!,
                          ),
                          if (bangumiItem != null &&
                              bangumiItem!.rating != null)
                            PBadge(
                              text:
                                  '评分 ${!widget.loadingStatus ? widget.bangumiDetail!.rating!['score']! : bangumiItem!.rating!['score']!}',
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
                          child: SizedBox(
                            height: 158,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        !widget.loadingStatus
                                            ? widget.bangumiDetail!.title!
                                            : bangumiItem!.title!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 34,
                                      height: 34,
                                      child: IconButton(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) {
                                            return t
                                                .colorScheme.primaryContainer
                                                .withOpacity(0.7);
                                          }),
                                        ),
                                        onPressed: () =>
                                            bangumiIntroController.bangumiAdd(),
                                        icon: Icon(
                                          Icons.favorite_border_rounded,
                                          color: t.colorScheme.primary,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    StatView(
                                      theme: 'gray',
                                      view: !widget.loadingStatus
                                          ? widget.bangumiDetail!.stat!['views']
                                          : bangumiItem!.stat!['views'],
                                      size: 'medium',
                                    ),
                                    const SizedBox(width: 6),
                                    StatDanMu(
                                      theme: 'gray',
                                      danmu: !widget.loadingStatus
                                          ? widget
                                              .bangumiDetail!.stat!['danmakus']
                                          : bangumiItem!.stat!['danmakus'],
                                      size: 'medium',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      !widget.loadingStatus
                                          ? (widget.bangumiDetail!.areas!
                                                  .isNotEmpty
                                              ? widget.bangumiDetail!.areas!
                                                  .first['name']
                                              : '')
                                          : (bangumiItem!.areas!.isNotEmpty
                                              ? bangumiItem!
                                                  .areas!.first['name']
                                              : ''),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: t.colorScheme.outline,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      !widget.loadingStatus
                                          ? widget.bangumiDetail!
                                              .publish!['pub_time_show']
                                          : bangumiItem!
                                              .publish!['pub_time_show'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: t.colorScheme.outline,
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(height: 4),
                                Text(
                                  !widget.loadingStatus
                                      ? widget.bangumiDetail!.newEp!['desc']
                                      : bangumiItem!.newEp!['desc'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: t.colorScheme.outline,
                                  ),
                                ),
                                // const SizedBox(height: 10),
                                const Spacer(),
                                Text(
                                  '简介：${!widget.loadingStatus ? widget.bangumiDetail!.evaluate! : bangumiItem!.evaluate!}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: t.colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // 点赞收藏转发 布局样式1
                  // SingleChildScrollView(
                  //   padding: const EdgeInsets.only(top: 7, bottom: 7),
                  //   scrollDirection: Axis.horizontal,
                  //   child: actionRow(
                  //     context,
                  //     bangumiIntroController,
                  //     videoDetailCtr,
                  //   ),
                  // ),
                  // 点赞收藏转发 布局样式2
                  actionGrid(context, bangumiIntroController),
                  // 番剧分p
                  if ((!widget.loadingStatus &&
                          widget.bangumiDetail!.episodes!.isNotEmpty) ||
                      bangumiItem != null &&
                          bangumiItem!.episodes!.isNotEmpty) ...[
                    BangumiPanel(
                      pages: bangumiItem != null
                          ? bangumiItem!.episodes!
                          : widget.bangumiDetail!.episodes!,
                      cid: cid ??
                          (bangumiItem != null
                              ? bangumiItem!.episodes!.first.cid
                              : widget.bangumiDetail!.episodes!.first.cid),
                      sheetHeight: sheetHeight,
                      changeFuc: (bvid, cid, aid) => bangumiIntroController
                          .changeSeasonOrbangu(bvid, cid, aid),
                    )
                  ],
                ],
              )
            : const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }

  Widget actionGrid(BuildContext context, bangumiIntroController) {
    return LayoutBuilder(builder: (context, constraints) {
      return Material(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: SizedBox(
            height: constraints.maxWidth / 5 * 0.8,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(0),
              crossAxisCount: 5,
              childAspectRatio: 1.25,
              children: <Widget>[
                Obx(
                  () => ActionItem(
                      icon: const Icon(FontAwesomeIcons.thumbsUp),
                      selectIcon: const Icon(FontAwesomeIcons.solidThumbsUp),
                      onTap: handleState(bangumiIntroController.actionLikeVideo),
                      selectStatus: bangumiIntroController.hasLike.value,
                      loadingStatus: false,
                      text: !widget.loadingStatus
                          ? widget.bangumiDetail!.stat!['likes']!.toString()
                          : bangumiItem!.stat!['likes']!.toString()),
                ),
                Obx(
                  () => ActionItem(
                      icon: const Icon(FontAwesomeIcons.b),
                      selectIcon: const Icon(FontAwesomeIcons.b),
                      onTap: handleState(bangumiIntroController.actionCoinVideo),
                      selectStatus: bangumiIntroController.hasCoin.value,
                      loadingStatus: false,
                      text: !widget.loadingStatus
                          ? widget.bangumiDetail!.stat!['coins']!.toString()
                          : bangumiItem!.stat!['coins']!.toString()),
                ),
                Obx(
                  () => ActionItem(
                      icon: const Icon(FontAwesomeIcons.star),
                      selectIcon: const Icon(FontAwesomeIcons.solidStar),
                      onTap: () => showFavBottomSheet(),
                      selectStatus: bangumiIntroController.hasFav.value,
                      loadingStatus: false,
                      text: !widget.loadingStatus
                          ? widget.bangumiDetail!.stat!['favorite']!.toString()
                          : bangumiItem!.stat!['favorite']!.toString()),
                ),
                ActionItem(
                  icon: const Icon(FontAwesomeIcons.comment),
                  selectIcon: const Icon(FontAwesomeIcons.reply),
                  onTap: () => videoDetailCtr.tabCtr.animateTo(1),
                  selectStatus: false,
                  loadingStatus: false,
                  text: !widget.loadingStatus
                      ? widget.bangumiDetail!.stat!['reply']!.toString()
                      : bangumiItem!.stat!['reply']!.toString(),
                ),
                ActionItem(
                    icon: const Icon(FontAwesomeIcons.shareFromSquare),
                    onTap: () => bangumiIntroController.actionShareVideo(),
                    selectStatus: false,
                    loadingStatus: false,
                    text: !widget.loadingStatus
                        ? widget.bangumiDetail!.stat!['share']!.toString()
                        : bangumiItem!.stat!['share']!.toString()),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget actionRow(BuildContext context, videoIntroController, videoDetailCtr) {
    return Row(children: [
      Obx(
        () => ActionRowItem(
          icon: const Icon(FontAwesomeIcons.thumbsUp),
          onTap: handleState(videoIntroController.actionLikeVideo),
          selectStatus: videoIntroController.hasLike.value,
          loadingStatus: widget.loadingStatus,
          text: !widget.loadingStatus
              ? widget.bangumiDetail!.stat!['likes']!.toString()
              : '-',
        ),
      ),
      const SizedBox(width: 8),
      Obx(
        () => ActionRowItem(
          icon: const Icon(FontAwesomeIcons.b),
          onTap: handleState(videoIntroController.actionCoinVideo),
          selectStatus: videoIntroController.hasCoin.value,
          loadingStatus: widget.loadingStatus,
          text: !widget.loadingStatus
              ? widget.bangumiDetail!.stat!['coins']!.toString()
              : '-',
        ),
      ),
      const SizedBox(width: 8),
      Obx(
        () => ActionRowItem(
          icon: const Icon(FontAwesomeIcons.heart),
          onTap: () => showFavBottomSheet(),
          selectStatus: videoIntroController.hasFav.value,
          loadingStatus: widget.loadingStatus,
          text: !widget.loadingStatus
              ? widget.bangumiDetail!.stat!['favorite']!.toString()
              : '-',
        ),
      ),
      const SizedBox(width: 8),
      ActionRowItem(
        icon: const Icon(FontAwesomeIcons.comment),
        onTap: () {
          videoDetailCtr.tabCtr.animateTo(1);
        },
        selectStatus: false,
        loadingStatus: widget.loadingStatus,
        text: !widget.loadingStatus
            ? widget.bangumiDetail!.stat!['reply']!.toString()
            : '-',
      ),
      const SizedBox(width: 8),
      ActionRowItem(
          icon: const Icon(FontAwesomeIcons.share),
          onTap: () => videoIntroController.actionShareVideo(),
          selectStatus: false,
          loadingStatus: widget.loadingStatus,
          text: '转发'),
    ]);
  }
}
