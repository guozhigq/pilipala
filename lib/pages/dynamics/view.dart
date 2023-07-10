import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/dynamic_card.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/common/dynamics_type.dart';
import 'package:pilipala/models/dynamics/result.dart';

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
          height: 36,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => SegmentedButton<DynamicsType>(
                      showSelectedIcon: false,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10)),
                        side: MaterialStateProperty.all(
                          BorderSide(
                              color: Theme.of(context).hintColor, width: 0.5),
                        ),
                      ),
                      segments: <ButtonSegment<DynamicsType>>[
                        for (var i in _dynamicsController.filterTypeList) ...[
                          ButtonSegment<DynamicsType>(
                            value: i['value'],
                            label: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(i['label']),
                            ),
                            enabled: i['enabled'],
                          ),
                        ]
                      ],
                      selected: <DynamicsType>{
                        _dynamicsController.dynamicsType.value
                      },
                      onSelectionChanged: (Set<DynamicsType> newSelection) {
                        _dynamicsController.dynamicsType.value =
                            newSelection.first;
                        _dynamicsController.onSelectType(newSelection.first);
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _dynamicsController.mid = -1;
                    _dynamicsController.dynamicsType.value =
                        DynamicsType.values[0];
                    SmartDialog.showToast('还原默认加载',
                        alignment: Alignment.topCenter);
                    _dynamicsController.queryFollowDynamic();
                  },
                  icon: const Icon(Icons.history),
                ),
              )
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
                      () => SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
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
