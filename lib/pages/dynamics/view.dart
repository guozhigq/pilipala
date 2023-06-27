import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/dynamic_card.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/common/dynamics_type.dart';
import 'package:pilipala/models/dynamics/result.dart';

import 'controller.dart';
import 'widgets/dynamic_panel.dart';

class DynamicsPage extends StatefulWidget {
  const DynamicsPage({super.key});

  @override
  State<DynamicsPage> createState() => _DynamicsPageState();
}

class _DynamicsPageState extends State<DynamicsPage>
    with AutomaticKeepAliveClientMixin {
  final DynamicsController _dynamicsController = Get.put(DynamicsController());
  Future? _futureBuilderFuture;
  // final ScrollController scrollController = ScrollController();
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
        centerTitle: false,
        title: const Text('动态'),
        actions: [
          Obx(
            () => PopupMenuButton(
              initialValue: _dynamicsController.dynamicsType.value,
              position: PopupMenuPosition.under,
              itemBuilder: (context) => [
                for (var i in DynamicsType.values) ...[
                  PopupMenuItem(
                    value: i.values,
                    onTap: () =>
                        _dynamicsController.onSelectType(i.values, i.labels),
                    child: Text(i.labels),
                  )
                ],
              ],
              child: Row(
                children: [
                  Text(
                    _dynamicsController.dynamicsTypeLabel.value,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
            ),
          ),
          const SizedBox(width: 4)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _dynamicsController.queryFollowDynamic();
        },
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map data = snapshot.data;
              if (data['status']) {
                List<DynamicItemModel> list = _dynamicsController.dynamicsList!;
                return Obx(
                  () => ListView.builder(
                    controller: _dynamicsController.scrollController,
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, index) {
                      return DynamicPanel(item: list[index]);
                    },
                  ),
                );
              } else {
                return CustomScrollView(
                  slivers: [
                    HttpError(
                      errMsg: data['msg'],
                      fn: () => _dynamicsController.queryFollowDynamic(),
                    )
                  ],
                );
              }
            } else {
              // 骨架屏
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: ((context, index) => const DynamicCardSkeleton()),
              );
            }
          },
        ),
      ),
    );
  }
}
