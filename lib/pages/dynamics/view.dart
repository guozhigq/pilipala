import 'dart:async';

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/skeleton/dynamic_card.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/pages/main/index.dart';
import 'package:pilipala/utils/event_bus.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';

import 'controller.dart';
import 'widgets/dynamic_panel.dart';
import 'widgets/up_panel.dart';

class DynamicsPage extends StatefulWidget {
  const DynamicsPage({super.key});

  @override
  State<DynamicsPage> createState() => _DynamicsPageState();
}

class _DynamicsPageState extends State<DynamicsPage>
    with AutomaticKeepAliveClientMixin {
  final DynamicsController _dynamicsController = Get.put(DynamicsController());
  late Future _futureBuilderFuture;
  late Future _futureBuilderFutureUp;
  Box userInfoCache = GStrorage.userInfo;
  EventBus eventBus = EventBus();
  late ScrollController scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _dynamicsController.queryFollowDynamic();
    _futureBuilderFutureUp = _dynamicsController.queryFollowUp();
    scrollController = _dynamicsController.scrollController;
    StreamController<bool> mainStream =
        Get.find<MainController>().bottomBarStream;
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'queryFollowDynamic', const Duration(seconds: 1), () {
            _dynamicsController.queryFollowDynamic(type: 'onLoad');
          });
        }

        final ScrollDirection direction =
            scrollController.position.userScrollDirection;
        if (direction == ScrollDirection.forward) {
          mainStream.add(true);
        } else if (direction == ScrollDirection.reverse) {
          mainStream.add(false);
        }
      },
    );

    eventBus.on(EventName.loginEvent, (args) {
      _dynamicsController.userLogin.value = args['status'];
      setState(() {
        _futureBuilderFuture = _dynamicsController.queryFollowDynamic();
        _futureBuilderFutureUp = _dynamicsController.queryFollowUp();
      });
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: SizedBox(
          height: 34,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    if (_dynamicsController.mid.value != -1 &&
                        _dynamicsController.upInfo.value.uname != null) {
                      return SizedBox(
                        height: 36,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Text(
                              '${_dynamicsController.upInfo.value.uname!}的动态',
                              key: ValueKey<String>(
                                  _dynamicsController.upInfo.value.uname!),
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .fontSize,
                              )),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                  Obx(
                    () => _dynamicsController.userLogin.value
                        ? Visibility(
                            visible: _dynamicsController.mid.value == -1,
                            child: CustomSlidingSegmentedControl<int>(
                              initialValue:
                                  _dynamicsController.initialValue.value,
                              children: {
                                1: Text(
                                  '全部',
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .fontSize),
                                ),
                                2: Text('投稿',
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .fontSize)),
                                3: Text('番剧',
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .fontSize)),
                                4: Text('专栏',
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .fontSize)),
                              },
                              padding: 13.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant
                                    .withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              thumbDecoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              onValueChanged: (v) {
                                feedBack();
                                _dynamicsController.onSelectType(v);
                              },
                            ),
                          )
                        : Text('动态',
                            style: Theme.of(context).textTheme.titleMedium),
                  )
                ],
              ),
              // Obx(
              //   () => Visibility(
              //     visible: _dynamicsController.userLogin.value,
              //     child: Positioned(
              //       right: 4,
              //       top: 0,
              //       bottom: 0,
              //       child: IconButton(
              //         padding: EdgeInsets.zero,
              //         onPressed: () =>
              //             {feedBack(), _dynamicsController.resetSearch()},
              //         icon: const Icon(Icons.history, size: 21),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _dynamicsController.onRefresh(),
        child: CustomScrollView(
          controller: _dynamicsController.scrollController,
          slivers: [
            FutureBuilder(
              future: _futureBuilderFutureUp,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map data = snapshot.data;
                  if (data['status']) {
                    return Obx(() => UpPanel(_dynamicsController.upData.value));
                  } else {
                    return const SliverToBoxAdapter(
                        child: SizedBox(height: 80));
                  }
                } else {
                  return const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 90,
                    child: UpPanelSkeleton(),
                  ));
                }
              },
            ),
            FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map data = snapshot.data;
                  if (data['status']) {
                    List<DynamicItemModel> list =
                        _dynamicsController.dynamicsList;
                    return Obx(
                      () {
                        if (list.isEmpty) {
                          if (_dynamicsController.isLoadingDynamic.value) {
                            return skeleton();
                          } else {
                            return const NoData();
                          }
                        } else {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return DynamicPanel(item: list[index]);
                              },
                              childCount: list.length,
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return HttpError(
                      errMsg: data['msg'],
                      fn: () {
                        setState(() {
                          _futureBuilderFuture =
                              _dynamicsController.queryFollowDynamic();
                          _futureBuilderFutureUp =
                              _dynamicsController.queryFollowUp();
                        });
                      },
                    );
                  }
                } else {
                  // 骨架屏
                  return skeleton();
                }
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40))
          ],
        ),
      ),
    );
  }

  Widget skeleton() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return const DynamicCardSkeleton();
      }, childCount: 5),
    );
  }
}
