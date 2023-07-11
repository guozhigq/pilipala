import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/skeleton/dynamic_card.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/common/dynamics_type.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/pages/mine/index.dart';
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
  Future? _futureBuilderFuture;
  bool _isLoadingMore = false;
  Box userInfoCache = GStrorage.userInfo;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _dynamicsController.queryFollowDynamic();

    _dynamicsController.scrollController.addListener(
      () async {
        if (_dynamicsController.scrollController.position.pixels >=
            _dynamicsController.scrollController.position.maxScrollExtent -
                200) {
          if (!_isLoadingMore) {
            _isLoadingMore = true;
            await _dynamicsController.queryFollowDynamic(type: 'onLoad');
            _isLoadingMore = false;
          }
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
                  Obx(() => Visibility(
                        visible: _dynamicsController.mid.value == -1,
                        child: CustomSlidingSegmentedControl<int>(
                          initialValue: _dynamicsController.initialValue.value,
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
                            // 4: Text(
                            //   '专栏',
                            //   style: TextStyle(
                            //       fontSize: Theme.of(context)
                            //           .textTheme
                            //           .labelMedium!
                            //           .fontSize),
                            // ),
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
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceVariant
                                  .withOpacity(0.7),
                            ),
                          ),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          onValueChanged: (v) {
                            _dynamicsController.onSelectType(v);
                          },
                        ),
                      ))
                ],
              ),
              Positioned(
                right: 4,
                top: 0,
                bottom: 0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _dynamicsController.resetSearch(),
                  icon: const Icon(Icons.history, size: 21),
                ),
              ),
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: userInfoCache.get('userInfoCache') != null
                      ? GestureDetector(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (_) => const SizedBox(
                              height: 450,
                              child: MinePage(),
                            ),
                            clipBehavior: Clip.hardEdge,
                            isScrollControlled: true,
                          ),
                          child: NetworkImgLayer(
                            type: 'avatar',
                            width: 30,
                            height: 30,
                            src: userInfoCache.get('userInfoCache').face,
                          ),
                        )
                      : IconButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            builder: (_) => const SizedBox(
                              height: 450,
                              child: MinePage(),
                            ),
                            clipBehavior: Clip.hardEdge,
                            isScrollControlled: true,
                          ),
                          icon: const Icon(CupertinoIcons.person, size: 22),
                        ),
                ),
              ),
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
              future: _dynamicsController.queryFollowUp(),
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
                    height: 115,
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
                        _dynamicsController.dynamicsList!;
                    return Obx(
                      () => list.length == 1
                          ? skeleton()
                          : SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                return DynamicPanel(item: list[index]);
                              }, childCount: list.length),
                            ),
                    );
                  } else {
                    return HttpError(
                      errMsg: data['msg'],
                      fn: () => _dynamicsController.queryFollowDynamic(),
                    );
                  }
                } else {
                  // 骨架屏
                  return skeleton();
                }
              },
            ),
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
