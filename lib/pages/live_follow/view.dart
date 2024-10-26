import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/skeleton/video_card_v.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/pages/live/widgets/live_item.dart';

import 'controller.dart';

class LiveFollowPage extends StatefulWidget {
  const LiveFollowPage({super.key});

  @override
  State<LiveFollowPage> createState() => _LiveFollowPageState();
}

class _LiveFollowPageState extends State<LiveFollowPage> {
  late Future _futureBuilderFuture;
  final ScrollController scrollController = ScrollController();
  final LiveFollowController _liveFollowController =
      Get.put(LiveFollowController());

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _liveFollowController.queryLiveFollowList('init');
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'liveFollowList', const Duration(milliseconds: 200), () {
            _liveFollowController.onLoad();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          centerTitle: false,
          title: Obx(() => Text(
                '${_liveFollowController.liveFollowingCount}人正在直播中',
                style: Theme.of(context).textTheme.titleMedium,
              )),
        ),
        body: Container(
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.only(
              left: StyleString.safeSpace, right: StyleString.safeSpace),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(StyleString.imgRadius),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              return await _liveFollowController.onRefresh();
            },
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
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
                            return Obx(
                              () => contentGrid(_liveFollowController,
                                  _liveFollowController.liveFollowingList),
                            );
                          });
                        } else {
                          return HttpError(
                            errMsg: data['msg'],
                            fn: () {
                              setState(() {
                                _futureBuilderFuture = _liveFollowController
                                    .queryLiveFollowList('init');
                              });
                            },
                          );
                        }
                      } else {
                        return contentGrid(_liveFollowController, []);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget contentGrid(ctr, liveList) {
    int crossAxisCount = ctr.crossAxisCount.value;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: StyleString.safeSpace,
        crossAxisSpacing: StyleString.safeSpace,
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
}
