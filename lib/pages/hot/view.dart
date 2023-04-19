import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/pages/hot/controller.dart';
import 'package:pilipala/pages/home/widgets/app_bar.dart';

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> with AutomaticKeepAliveClientMixin {
  final HotController _hotController = Get.put(HotController());
  List videoList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _hotController.videoList.listen((value) {
      videoList = value;
      setState(() {});
    });

    _hotController.scrollController.addListener(
      () {
        if (_hotController.scrollController.position.pixels >=
            _hotController.scrollController.position.maxScrollExtent - 200) {
          if (!_hotController.isLoadingMore) {
            _hotController.isLoadingMore = true;
            _hotController.onLoad();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        displacement: kToolbarHeight + MediaQuery.of(context).padding.top,
        onRefresh: () async {
          return await _hotController.onRefresh();
        },
        child: CustomScrollView(
          controller: _hotController.scrollController,
          slivers: [
            const HomeAppBar(),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return VideoCardH(
                videoItem: videoList[index],
              );
            }, childCount: videoList.length)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
