import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/follow/result.dart';

import 'controller.dart';
import 'widgets/follow_item.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  final FollowController _followController = Get.put(FollowController());
  final ScrollController scrollController = ScrollController();
  Future? _futureBuilderFuture;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _followController.queryFollowings('init');
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          if (!_isLoadingMore) {
            _isLoadingMore = true;
            await _followController.queryFollowings('onLoad');
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
        centerTitle: false,
        title: const Text('关注的用户'),
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
                    () => list.length == 1
                        ? SizedBox()
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index) {
                              return followItem(item: list[index]);
                            },
                          ),
                  );
                } else {
                  return HttpError(
                    errMsg: data['msg'],
                    fn: () => _followController.queryFollowings('init'),
                  );
                }
              } else {
                // 骨架屏
                return SizedBox();
              }
            },
          )),
    );
  }
}
