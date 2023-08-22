import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/fans/result.dart';

import 'controller.dart';
import 'widgets/fan_item.dart';

class FansPage extends StatefulWidget {
  const FansPage({super.key});

  @override
  State<FansPage> createState() => _FansPageState();
}

class _FansPageState extends State<FansPage> {
  final FansController _fansController = Get.put(FansController());
  final ScrollController scrollController = ScrollController();
  Future? _futureBuilderFuture;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _fansController.queryFans('init');
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          if (!_isLoadingMore) {
            _isLoadingMore = true;
            await _fansController.queryFans('onLoad');
            _isLoadingMore = false;
          }
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          '${_fansController.name}的粉丝',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _fansController.queryFans('init'),
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data;
              if (data['status']) {
                List<FansItemModel> list = _fansController.fansList;
                return Obx(
                  () => list.length == 1
                      ? const SizedBox()
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return fanItem(item: list[index]);
                          },
                        ),
                );
              } else {
                return HttpError(
                  errMsg: data['msg'],
                  fn: () => _fansController.queryFans('init'),
                );
              }
            } else {
              // 骨架屏
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
