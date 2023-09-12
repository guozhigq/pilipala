import 'dart:async';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_reply.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/pages/dynamics/deatil/index.dart';
import 'package:pilipala/pages/dynamics/widgets/author_panel.dart';
import 'package:pilipala/pages/video/detail/reply/widgets/reply_item.dart';
import 'package:pilipala/pages/video/detail/replyNew/index.dart';
import 'package:pilipala/pages/video/detail/replyReply/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/id_utils.dart';

import '../widgets/dynamic_panel.dart';

class DynamicDetailPage extends StatefulWidget {
  // const DynamicDetailPage({super.key});
  const DynamicDetailPage({Key? key}) : super(key: key);

  @override
  State<DynamicDetailPage> createState() => _DynamicDetailPageState();
}

class _DynamicDetailPageState extends State<DynamicDetailPage>
    with TickerProviderStateMixin {
  late DynamicDetailController _dynamicDetailController;
  late AnimationController fabAnimationCtr;
  Future? _futureBuilderFuture;
  late StreamController<bool> titleStreamC; // appBar title
  late ScrollController scrollController;
  bool _visibleTitle = false;
  String? action;
  // 回复类型
  late int type;
  bool _isFabVisible = true;

  @override
  void initState() {
    super.initState();
    int oid = 0;
    // floor 1原创 2转发
    if (Get.arguments['floor'] == 1) {
      oid = int.parse(Get.arguments['item'].basic!['comment_id_str']);
      print(oid);
    } else {
      try {
        String type = Get.arguments['item'].modules.moduleDynamic.major.type;

        /// TODO
        if (type == 'MAJOR_TYPE_OPUS') {
        } else {
          oid = Get.arguments['item'].modules.moduleDynamic.major.draw.id;
        }
      } catch (_) {}
    }
    int commentType = 11;
    try {
      commentType = Get.arguments['item'].basic!['comment_type'];
    } catch (_) {}
    type = (commentType == 0) ? 11 : commentType;

    action =
        Get.arguments.containsKey('action') ? Get.arguments['action'] : null;
    _dynamicDetailController =
        Get.put(DynamicDetailController(oid, type), tag: oid.toString());
    _futureBuilderFuture = _dynamicDetailController.queryReplyList();
    titleStreamC = StreamController<bool>();
    if (action == 'comment') {
      _visibleTitle = true;
      titleStreamC.add(true);
    }

    fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fabAnimationCtr.forward();
    // 滚动事件监听
    scrollListener();
  }

  void replyReply(replyItem) {
    int oid = replyItem.oid;
    int rpid = replyItem.rpid!;
    Get.to(
      () => Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          title: Text(
            '评论详情',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: VideoReplyReplyPanel(
          oid: oid,
          rpid: rpid,
          source: 'dynamic',
          replyType: ReplyType.values[type],
          firstFloor: replyItem,
        ),
      ),
    );
  }

  void scrollListener() {
    scrollController = _dynamicDetailController.scrollController;
    scrollController.addListener(
      () {
        // 分页加载
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          EasyThrottle.throttle('replylist', const Duration(seconds: 2), () {
            _dynamicDetailController.queryReplyList(reqType: 'onLoad');
          });
        }

        // 标题
        if (scrollController.offset > 55 && !_visibleTitle) {
          _visibleTitle = true;
          titleStreamC.add(true);
        } else if (scrollController.offset <= 55 && _visibleTitle) {
          _visibleTitle = false;
          titleStreamC.add(false);
        }

        // fab按钮
        final ScrollDirection direction =
            scrollController.position.userScrollDirection;
        if (direction == ScrollDirection.forward) {
          _showFab();
        } else if (direction == ScrollDirection.reverse) {
          _hideFab();
        }
      },
    );
  }

  void _showFab() {
    if (!_isFabVisible) {
      _isFabVisible = true;
      fabAnimationCtr.forward();
    }
  }

  void _hideFab() {
    if (_isFabVisible) {
      _isFabVisible = false;
      fabAnimationCtr.reverse();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    fabAnimationCtr.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleSpacing: 0,
        title: StreamBuilder(
          stream: titleStreamC.stream,
          initialData: false,
          builder: (context, AsyncSnapshot snapshot) {
            return AnimatedOpacity(
              opacity: snapshot.data ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: author(_dynamicDetailController!.item, context),
            );
          },
        ),
        // actions: _detailModel != null ? appBarAction() : [],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _dynamicDetailController.queryReplyList();
        },
        child: Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              slivers: [
                if (action != 'comment')
                  SliverToBoxAdapter(
                    child: DynamicPanel(
                      item: _dynamicDetailController.item,
                      source: 'detail',
                    ),
                  ),
                SliverPersistentHeader(
                  delegate: _MySliverPersistentHeaderDelegate(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border(
                          top: BorderSide(
                            width: 0.6,
                            color: Theme.of(context)
                                .dividerColor
                                .withOpacity(0.05),
                          ),
                        ),
                      ),
                      height: 45,
                      padding: const EdgeInsets.only(left: 12, right: 6),
                      child: Row(
                        children: [
                          Obx(
                            () => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    scale: animation, child: child);
                              },
                              child: Text(
                                '${_dynamicDetailController.acount.value}',
                                key: ValueKey<int>(
                                    _dynamicDetailController.acount.value),
                              ),
                            ),
                          ),
                          const Text('条回复'),
                          const Spacer(),
                          SizedBox(
                            height: 35,
                            child: TextButton.icon(
                              onPressed: () =>
                                  _dynamicDetailController.queryBySort(),
                              icon: const Icon(Icons.sort, size: 16),
                              label: Obx(() => Text(
                                    _dynamicDetailController
                                        .sortTypeLabel.value,
                                    style: const TextStyle(fontSize: 13),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  pinned: true,
                ),
                FutureBuilder(
                  future: _futureBuilderFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map data = snapshot.data as Map;
                      if (snapshot.data['status']) {
                        // 请求成功
                        return Obx(
                          () => _dynamicDetailController.replyList.isEmpty &&
                                  _dynamicDetailController.isLoadingMore
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return const VideoReplySkeleton();
                                  }, childCount: 8),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      if (index ==
                                          _dynamicDetailController
                                              .replyList.length) {
                                        return Container(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .padding
                                                  .bottom),
                                          height: MediaQuery.of(context)
                                                  .padding
                                                  .bottom +
                                              100,
                                          child: Center(
                                            child: Obx(
                                              () => Text(
                                                _dynamicDetailController
                                                    .noMore.value,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .outline,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return ReplyItem(
                                          replyItem: _dynamicDetailController
                                              .replyList[index],
                                          showReplyRow: true,
                                          replyLevel: '1',
                                          replyReply: (replyItem) =>
                                              replyReply(replyItem),
                                          replyType: ReplyType.values[type],
                                          addReply: (replyItem) {
                                            _dynamicDetailController
                                                .replyList[index].replies!
                                                .add(replyItem);
                                          },
                                        );
                                      }
                                    },
                                    childCount: _dynamicDetailController
                                            .replyList.length +
                                        1,
                                  ),
                                ),
                        );
                      } else {
                        // 请求错误
                        return HttpError(
                          errMsg: data['msg'],
                          fn: () => setState(() {}),
                        );
                      }
                    } else {
                      // 骨架屏
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return const VideoReplySkeleton();
                        }, childCount: 8),
                      );
                    }
                  },
                )
              ],
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 14,
              right: 14,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 2),
                  end: const Offset(0, 0),
                ).animate(CurvedAnimation(
                  parent: fabAnimationCtr,
                  curve: Curves.easeInOut,
                )),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    feedBack();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return VideoReplyNewDialog(
                          oid: _dynamicDetailController.oid ??
                              IdUtils.bv2av(Get.parameters['bvid']!),
                          root: 0,
                          parent: 0,
                          replyType: ReplyType.values[type],
                        );
                      },
                    ).then(
                      (value) => {
                        // 完成评论，数据添加
                        if (value != null && value['data'] != null)
                          {
                            _dynamicDetailController.replyList
                                .add(value['data']),
                            _dynamicDetailController.acount.value++
                          }
                      },
                    );
                  },
                  tooltip: '评论动态',
                  child: const Icon(Icons.reply),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double _minExtent = 45;
  final double _maxExtent = 45;
  final Widget child;

  _MySliverPersistentHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    //创建child子组件
    //shrinkOffset：child偏移值minExtent~maxExtent
    //overlapsContent：SliverPersistentHeader覆盖其他子组件返回true，否则返回false
    return child;
  }

  //SliverPersistentHeader最大高度
  @override
  double get maxExtent => _maxExtent;

  //SliverPersistentHeader最小高度
  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(covariant _MySliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
