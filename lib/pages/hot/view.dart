import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/pages/hot/controller.dart';
import 'package:pilipala/utils/main_stream.dart';

class HotPage extends StatefulWidget {
  const HotPage({Key? key}) : super(key: key);

  @override
  State<HotPage> createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> with AutomaticKeepAliveClientMixin {
  final HotController _hotController = Get.put(HotController());
  List videoList = [];
  Future? _futureBuilderFuture;
  ScrollController? _scrollController;

  @override
  bool get wantKeepAlive => true;

  void handleScroll() {
    if (_scrollController == null) return;

    if (_scrollController!.position.pixels >=
        _scrollController!.position.maxScrollExtent - 200) {
      if (!_hotController.isLoadingMore) {
        _hotController.isLoadingMore = true;
        _hotController.onLoad();
      }
    }
    handleScrollEvent(_scrollController!);
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _hotController.queryHotFeed('init');
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
    return RefreshIndicator(
      onRefresh: () async {
        return await _hotController.onRefresh();
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            // 单列布局 EdgeInsets.zero
            padding:
                const EdgeInsets.fromLTRB(0, StyleString.safeSpace - 5, 0, 0),
            sliver: FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map data = snapshot.data as Map;
                  if (data['status']) {
                    return Obx(
                      () => SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return VideoCardH(
                            videoItem: _hotController.videoList[index],
                            showPubdate: true,
                          );
                        }, childCount: _hotController.videoList.length),
                      ),
                    );
                  } else {
                    return HttpError(
                      errMsg: data['msg'],
                      fn: () {
                        setState(() {
                          _futureBuilderFuture =
                              _hotController.queryHotFeed('init');
                        });
                      },
                    );
                  }
                } else {
                  // 骨架屏
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return const VideoCardHSkeleton();
                    }, childCount: 10),
                  );
                }
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom + 10,
            ),
          )
        ],
      ),
    );
  }
}
