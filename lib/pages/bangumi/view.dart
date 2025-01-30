import 'dart:async';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/utils/main_stream.dart';

import 'controller.dart';
import 'widgets/bangumu_card_v.dart';

class BangumiPage extends StatefulWidget {
  const BangumiPage({super.key});

  @override
  State<BangumiPage> createState() => _BangumiPageState();
}

class _BangumiPageState extends State<BangumiPage>
    with AutomaticKeepAliveClientMixin {
  final BangumiController _bangumidController = Get.put(BangumiController());
  late Future? _futureBuilderFuture;
  late Future? _futureBuilderFutureFollow;
  ScrollController? _scrollController;

  @override
  bool get wantKeepAlive => true;

  void handleScroll() {
    if (_scrollController == null) return;

    if (_scrollController!.position.pixels >=
        _scrollController!.position.maxScrollExtent - 200) {
      EasyThrottle.throttle('my-throttler', const Duration(seconds: 1), () {
        _bangumidController.isLoadingMore = true;
        _bangumidController.onLoad();
      });
      handleScrollEvent(_scrollController!);
    }
  }

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _bangumidController.queryBangumiListFeed();
    _futureBuilderFutureFollow = _bangumidController.queryBangumiFollow();
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
        await _bangumidController.queryBangumiListFeed();
        return _bangumidController.queryBangumiFollow();
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Obx(
              () => Visibility(
                visible: _bangumidController.userLogin.value,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: StyleString.safeSpace, bottom: 10, left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '最近追番',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _futureBuilderFutureFollow =
                                    _bangumidController.queryBangumiFollow();
                              });
                            },
                            icon: const Icon(
                              Icons.refresh,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.size.width / 3 / 0.75 +
                          MediaQuery.textScalerOf(context).scale(50.0),
                      child: FutureBuilder(
                        future: _futureBuilderFutureFollow,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data == null) {
                              return const SizedBox();
                            }
                            Map data = snapshot.data as Map;
                            List list = _bangumidController.bangumiFollowList;
                            if (data['status']) {
                              return Obx(
                                () => list.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: Get.size.width / 3,
                                            margin: EdgeInsets.only(
                                                left: StyleString.safeSpace,
                                                right: index ==
                                                        _bangumidController
                                                                .bangumiFollowList
                                                                .length -
                                                            1
                                                    ? StyleString.safeSpace
                                                    : 0),
                                            child: BangumiCardV(
                                              bangumiItem: _bangumidController
                                                  .bangumiFollowList[index],
                                            ),
                                          );
                                        },
                                      )
                                    : const SizedBox(
                                        child: Center(
                                          child: Text('还没有追番'),
                                        ),
                                      ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '推荐',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                StyleString.safeSpace, 0, StyleString.safeSpace, 0),
            sliver: FutureBuilder(
              future: _futureBuilderFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map data = snapshot.data as Map;
                  if (data['status']) {
                    return Obx(() => contentGrid(
                        _bangumidController, _bangumidController.bangumiList));
                  } else {
                    return HttpError(
                      errMsg: data['msg'],
                      fn: () {
                        _futureBuilderFuture =
                            _bangumidController.queryBangumiListFeed();
                      },
                    );
                  }
                } else {
                  return contentGrid(_bangumidController, []);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget contentGrid(ctr, bangumiList) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 行间距
        mainAxisSpacing: StyleString.cardSpace - 2,
        // 列间距
        crossAxisSpacing: StyleString.cardSpace,
        // 列数
        crossAxisCount: 3,
        mainAxisExtent: Get.size.width / 3 / 0.75 +
            MediaQuery.textScalerOf(context).scale(42.0),
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return bangumiList!.isNotEmpty
              ? BangumiCardV(bangumiItem: bangumiList[index])
              : const SizedBox();
        },
        childCount: bangumiList!.isNotEmpty ? bangumiList!.length : 10,
      ),
    );
  }
}
