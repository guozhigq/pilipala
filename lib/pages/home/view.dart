import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_v.dart';
import 'package:pilipala/common/widgets/animated_dialog.dart';
import 'package:pilipala/common/widgets/overlay_pop.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/video_card_v.dart';
import './controller.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/pages/home/widgets/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final HomeController _homeController = Get.put(HomeController());
  Future? _futureBuilderFuture;
  List videoList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _homeController.queryRcmdFeed('init');
    _homeController.videoList.listen((value) {
      videoList = value;
      setState(() {});
    });

    _homeController.scrollController.addListener(
      () {
        if (_homeController.scrollController.position.pixels >=
            _homeController.scrollController.position.maxScrollExtent - 200) {
          if (!_homeController.isLoadingMore) {
            _homeController.isLoadingMore = true;
            _homeController.onLoad();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // body: NestedScrollView(
      //   headerSliverBuilder: (context, innerBoxIsScrolled) => [
      //     const HomeAppBar()
      //   ],
      body: RefreshIndicator(
        displacement: kToolbarHeight + MediaQuery.of(context).padding.top,
        onRefresh: () async {
          return await _homeController.onRefresh();
        },
        child: CustomScrollView(
          controller: _homeController.scrollController,
          slivers: [
            const HomeAppBar(),
            // SliverPersistentHeader(
            //   delegate: MySliverPersistentHeaderDelegate(),
            //   pinned: true,
            // ),
            SliverPadding(
              // 单列布局 EdgeInsets.zero
              padding: _homeController.crossAxisCount == 1
                  ? EdgeInsets.zero
                  : const EdgeInsets.fromLTRB(
                      StyleString.cardSpace, 0, StyleString.cardSpace, 8),
              sliver: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(() => contentGrid(
                          _homeController, _homeController.videoList));
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () => setState(() {}),
                      );
                    }
                  } else {
                    // 骨架屏
                    return contentGrid(_homeController, []);
                  }
                },
              ),
            ),
            const LoadingMore()
          ],
        ),
      ),
      // ),
    );
  }

  OverlayEntry _createPopupDialog(videoItem) {
    return OverlayEntry(
        builder: (context) => AnimatedDialog(
              child: OverlayPop(videoItem: videoItem),
            ));
  }

  Widget contentGrid(ctr, videoList) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 行间距
        mainAxisSpacing: StyleString.cardSpace,
        // 列间距
        crossAxisSpacing: StyleString.cardSpace,
        // 列数
        crossAxisCount: ctr.crossAxisCount,
        mainAxisExtent: MediaQuery.of(context).size.width /
                ctr.crossAxisCount /
                StyleString.aspectRatio +
            70,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return videoList!.isNotEmpty
              ?
              // VideoCardV(videoItem: videoList![index])
              VideoCardV(
                  videoItem: videoList[index],
                  longPress: () {
                    _homeController.popupDialog =
                        _createPopupDialog(videoList[index]);
                    Overlay.of(context).insert(_homeController.popupDialog!);
                  },
                  longPressEnd: () {
                    _homeController.popupDialog?.remove();
                  },
                )
              : const VideoCardVSkeleton();
        },
        childCount: videoList!.isNotEmpty ? videoList!.length : 10,
      ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
          )),
      child: const Text(
        '我是一个SliverPersistentHeader',
      ),
    );
  }

  @override
  double get maxExtent => 55.0;

  @override
  double get minExtent => 55.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) =>
      true; // 如果内容需要更新，设置为true
}

// loading more
class LoadingMore extends StatelessWidget {
  const LoadingMore({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).padding.bottom + 80,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Center(
          child: Text(
            '加载中...',
            style: TextStyle(
                color: Theme.of(context).colorScheme.outline, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
