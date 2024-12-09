import 'dart:async';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/skeleton/video_card_v.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/live/follow.dart';
import 'package:pilipala/utils/main_stream.dart';

import 'controller.dart';
import 'widgets/live_item.dart';

class LivePage extends StatefulWidget {
  const LivePage({super.key});

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage>
    with AutomaticKeepAliveClientMixin {
  final LiveController _liveController = Get.put(LiveController());
  late Future _futureBuilderFuture;
  late Future _futureBuilderFuture2;
  late ScrollController scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _liveController.queryLiveList('init');
    _futureBuilderFuture2 = _liveController.fetchLiveFollowing();
    scrollController = _liveController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle('liveList', const Duration(milliseconds: 200),
              () {
            _liveController.onLoad();
          });
        }
        handleScrollEvent(scrollController);
      },
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(
          left: StyleString.safeSpace, right: StyleString.safeSpace),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(StyleString.imgRadius),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          return await _liveController.onRefresh();
        },
        child: CustomScrollView(
          controller: _liveController.scrollController,
          slivers: [
            buildFollowingList(),
            SliverPadding(
              // 单列布局 EdgeInsets.zero
              padding:
                  const EdgeInsets.fromLTRB(0, StyleString.safeSpace, 0, 0),
              sliver: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const SliverToBoxAdapter(child: SizedBox());
                    }
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return SliverLayoutBuilder(
                          builder: (context, boxConstraints) {
                        return Obx(() => contentGrid(
                            _liveController, _liveController.liveList));
                      });
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () {
                          setState(() {
                            _futureBuilderFuture =
                                _liveController.queryLiveList('init');
                          });
                        },
                      );
                    }
                  } else {
                    return contentGrid(_liveController, []);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentGrid(ctr, liveList) {
    // double maxWidth = Get.size.width;
    // int baseWidth = 500;
    // int step = 300;
    // int crossAxisCount =
    //     maxWidth > baseWidth ? 2 + ((maxWidth - baseWidth) / step).ceil() : 2;
    // if (maxWidth < 300) {
    //   crossAxisCount = 1;
    // }
    int crossAxisCount = ctr.crossAxisCount.value;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 行间距
        mainAxisSpacing: StyleString.safeSpace,
        // 列间距
        crossAxisSpacing: StyleString.safeSpace,
        // 列数
        crossAxisCount: crossAxisCount,
        mainAxisExtent:
            Get.size.width / crossAxisCount / StyleString.aspectRatio +
                MediaQuery.textScalerOf(context).scale(
                  (crossAxisCount == 1 ? 48 : 68),
                ),
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return liveList!.isNotEmpty
              ? LiveCardV(
                  liveItem: liveList[index],
                  crossAxisCount: crossAxisCount,
                )
              : const VideoCardVSkeleton();
        },
        childCount: liveList!.isNotEmpty ? liveList!.length : 10,
      ),
    );
  }

  // 关注的up直播
  Widget buildFollowingList() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: ' 我的关注 ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: ' ${_liveController.liveFollowingCount}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text: '人正在直播',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: _liveController.liveFollowingCount.value > 0,
                    child: InkWell(
                      onTap: () {
                        Get.toNamed('/liveFollowing');
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Row(
                        children: [
                          Text(
                            '查看更多',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: _futureBuilderFuture2,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map? data = snapshot.data;
                  if (data != null && data['status']) {
                    RxList list = _liveController.liveFollowingList;
                    return list.isNotEmpty
                        ? LiveFollowingListView(list: list)
                        : const Center(child: Text('没有人在直播'));
                  } else {
                    return SizedBox(
                      height: 80,
                      child: Center(
                        child: Text(
                          data?['msg'] ?? '请求异常',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LiveFollowingListView extends StatelessWidget {
  final RxList list;

  const LiveFollowingListView({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final LiveFollowingItemModel item = list[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(3, 12, 3, 0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed(
                        '/liveRoom?roomid=${item.roomId}',
                        arguments: {
                          'liveItem': item,
                          'heroTag': item.roomId.toString()
                        },
                      );
                    },
                    onLongPress: () {
                      Get.toNamed(
                        '/member?mid=${list[index].uid}',
                        arguments: {
                          'face': list[index].face,
                          'heroTag': list[index].uid.toString(),
                        },
                      );
                    },
                    child: Container(
                      width: 54,
                      height: 54,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      child: NetworkImgLayer(
                        width: 50,
                        height: 50,
                        type: 'avatar',
                        src: list[index].face,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 62,
                    child: Text(
                      list[index].uname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: list.length,
        ),
      ),
    );
  }
}
