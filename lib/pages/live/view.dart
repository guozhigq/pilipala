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

  ScrollController? _scrollController;

  @override
  bool get wantKeepAlive => true;

  void handleScroll() {
    if (_scrollController == null) return;

    if (_scrollController!.position.pixels >=
        _scrollController!.position.maxScrollExtent - 200) {
      EasyThrottle.throttle('liveList', const Duration(milliseconds: 200), () {
        _liveController.onLoad();
      });
    }
    handleScrollEvent(_scrollController!);
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _liveController.queryLiveList('init');
    _futureBuilderFuture2 = _liveController.fetchLiveFollowing();
  }

  @override
  void didChangeDependencies() {
    _scrollController?.removeListener(handleScroll);
    _scrollController = PrimaryScrollController.of(context)
      ..addListener(handleScroll);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(handleScroll);
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
                      text: ' ${_liveController.liveFollowingList.length}',
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
            FutureBuilder(
              future: _futureBuilderFuture2,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return const SizedBox();
                  }
                  Map? data = snapshot.data;
                  if (data?['status']) {
                    RxList list = _liveController.liveFollowingList;
                    // ignore: invalid_use_of_protected_member
                    return Obx(() => LiveFollowingListView(list: list.value));
                  } else {
                    return SizedBox(
                      height: 80,
                      child: Center(
                        child: Text(
                          data?['msg'] ?? '',
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
  final List list;

  const LiveFollowingListView({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
