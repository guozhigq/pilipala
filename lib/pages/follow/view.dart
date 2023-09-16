import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/models/follow/result.dart';

import 'controller.dart';
import 'widgets/follow_item.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  late String mid;
  late FollowController _followController;
  final ScrollController scrollController = ScrollController();
  Future? _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    mid = Get.parameters['mid']!;
    _followController = Get.put(FollowController(), tag: mid);
    _futureBuilderFuture = _followController.queryFollowings('init');
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle('follow', const Duration(seconds: 1), () {
            _followController.queryFollowings('onLoad');
          });
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
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          '${_followController.name}的关注',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async =>
              await _followController.queryFollowings('init'),
          child: FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var data = snapshot.data;
                if (data['status']) {
                  List<FollowItemModel> list = _followController.followList;
                  return Obx(
                    () => list.isNotEmpty
                        ? ListView.builder(
                            controller: scrollController,
                            itemCount: list.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == list.length) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).padding.bottom +
                                          60,
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .padding
                                          .bottom),
                                  child: Center(
                                    child: Obx(
                                      () => Text(
                                        _followController.loadingText.value,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return followItem(item: list[index]);
                              }
                            },
                          )
                        : const CustomScrollView(
                            slivers: [NoData()],
                          ),
                  );
                } else {
                  return CustomScrollView(
                    slivers: [
                      HttpError(
                        errMsg: data['msg'],
                        fn: () => _followController.queryFollowings('init'),
                      )
                    ],
                  );
                }
              } else {
                // 骨架屏
                return const SizedBox();
              }
            },
          )),
    );
  }
}
