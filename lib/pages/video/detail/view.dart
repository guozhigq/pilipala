import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/video/detail/reply/index.dart';
import 'package:pilipala/pages/video/detail/controller.dart';
import 'package:pilipala/pages/video/detail/introduction/index.dart';
import 'package:pilipala/pages/video/detail/related/index.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({Key? key}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  final VideoDetailController videoDetailController =
      Get.put(VideoDetailController(), tag: Get.arguments['heroTag']);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: videoDetailController.tabInitialIndex,
      length: videoDetailController.tabs.length, // tab的数量.
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    title: const Text("视频详情"),
                    // floating: true,
                    // snap: true,
                    pinned: true,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    forceElevated: innerBoxIsScrolled,
                    expandedHeight: MediaQuery.of(context).size.width * 9 / 16,
                    collapsedHeight: MediaQuery.of(context).size.width * 9 / 16,
                    toolbarHeight: kToolbarHeight,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Padding(
                        padding: EdgeInsets.only(
                            bottom: 50,
                            top: MediaQuery.of(context).padding.top),
                        child: LayoutBuilder(
                          builder: (context, boxConstraints) {
                            double maxWidth = boxConstraints.maxWidth;
                            double maxHeight = boxConstraints.maxHeight;
                            double PR = MediaQuery.of(context).devicePixelRatio;
                            return Hero(
                              tag: videoDetailController.heroTag,
                              child: NetworkImgLayer(
                                src: videoDetailController.videoItem['pic'],
                                width: maxWidth,
                                height: maxHeight,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(50.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.1)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: 280,
                              margin: const EdgeInsets.only(left: 20),
                              child: Obx(
                                () => TabBar(
                                  splashBorderRadius: BorderRadius.circular(6),
                                  dividerColor: Colors.transparent,
                                  tabs: videoDetailController.tabs
                                      .map((String name) => Tab(text: name))
                                      .toList(),
                                ),
                              ),
                            ),
                            // 弹幕开关
                            // const Spacer(),
                            // Flexible(
                            //   flex: 2,
                            //   child: Container(
                            //     height: 50,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                Builder(builder: (context) {
                  return CustomScrollView(
                    key: const PageStorageKey<String>('简介'),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      const VideoIntroPanel(),
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 8, bottom: 5),
                        sliver: SliverToBoxAdapter(
                          child: Divider(
                            height: 1,
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.1),
                          ),
                        ),
                      ),
                      const RelatedVideoPanel(),
                    ],
                  );
                }),
                Builder(builder: (context) {
                  return CustomScrollView(
                    key: const PageStorageKey<String>('评论'),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      const VideoReplyPanel()
                    ],
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
