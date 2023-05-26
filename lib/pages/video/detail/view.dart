import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/video/detail/reply/index.dart';
import 'package:pilipala/pages/video/detail/controller.dart';
import 'package:pilipala/pages/video/detail/introduction/index.dart';
import 'package:pilipala/pages/video/detail/related/index.dart';
import 'package:pilipala/pages/video/detail/replyReply/index.dart';

class VideoDetailPage extends StatefulWidget {
  const VideoDetailPage({Key? key}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  final VideoDetailController videoDetailController =
      Get.put(VideoDetailController(), tag: Get.arguments['heroTag']);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight = statusBarHeight +
        kToolbarHeight +
        MediaQuery.of(context).size.width * 9 / 16;
    return DefaultTabController(
      initialIndex: videoDetailController.tabInitialIndex,
      length: videoDetailController.tabs.length, // tab的数量.
      child: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Scaffold(
              key: videoDetailController.scaffoldKey,
              body: ExtendedNestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      title: const Text("视频详情"),
                      pinned: true,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      forceElevated: innerBoxIsScrolled,
                      expandedHeight:
                          MediaQuery.of(context).size.width * 9 / 16,
                      collapsedHeight:
                          MediaQuery.of(context).size.width * 9 / 16,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
                          child: LayoutBuilder(
                            builder: (context, boxConstraints) {
                              double maxWidth = boxConstraints.maxWidth;
                              double maxHeight = boxConstraints.maxHeight;
                              double PR =
                                  MediaQuery.of(context).devicePixelRatio;
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
                    ),
                  ];
                },
                pinnedHeaderSliverHeightBuilder: () {
                  return pinnedHeaderHeight;
                },
                onlyOneScrollInBody: true,
                body: Column(
                  children: [
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.1),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 280,
                            margin: const EdgeInsets.only(left: 20),
                            child: Obx(
                              () => TabBar(
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
                    Expanded(
                      child: TabBarView(
                        children: [
                          Builder(
                            builder: (context) {
                              return const CustomScrollView(
                                key: PageStorageKey<String>('简介'),
                                slivers: <Widget>[
                                  VideoIntroPanel(),
                                  RelatedVideoPanel(),
                                ],
                              );
                            },
                          ),
                          VideoReplyPanel()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
