import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/pages/later/index.dart';
import 'package:pilipala/utils/route_push.dart';

class LaterPage extends StatefulWidget {
  const LaterPage({super.key});

  @override
  State<LaterPage> createState() => _LaterPageState();
}

class _LaterPageState extends State<LaterPage> {
  final LaterController _laterController = Get.put(LaterController());
  Future? _futureBuilderFuture;

  @override
  void initState() {
    _futureBuilderFuture = _laterController.queryLaterList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Obx(
          () => _laterController.laterList.isNotEmpty
              ? Text(
                  '稍后再看 (${_laterController.laterList.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              : Text(
                  '稍后再看',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
        ),
        actions: [
          Obx(
            () => _laterController.laterList.isNotEmpty
                ? TextButton(
                    onPressed: () => _laterController.toViewDel(),
                    child: const Text('移除已看'),
                  )
                : const SizedBox(),
          ),
          Obx(
            () => _laterController.laterList.isNotEmpty
                ? IconButton(
                    tooltip: '一键清空',
                    onPressed: () => _laterController.toViewClear(),
                    icon: Icon(
                      Icons.clear_all_outlined,
                      size: 21,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : const SizedBox(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _laterController.queryLaterList(type: 'onRefresh');
        },
        child: CustomScrollView(
          controller: _laterController.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map? data = snapshot.data;
                  if (data != null && data['status']) {
                    return Obx(
                      () => _laterController.laterList.isNotEmpty &&
                              !_laterController.isLoading.value
                          ? SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                var videoItem =
                                    _laterController.laterList[index];
                                return VideoCardH(
                                    videoItem: videoItem,
                                    source: 'later',
                                    onPressedFn: () => _laterController
                                        .toViewDel(aid: videoItem.aid));
                              }, childCount: _laterController.laterList.length),
                            )
                          : _laterController.isLoading.value
                              ? const SliverToBoxAdapter(
                                  child: Center(child: Text('加载中')),
                                )
                              : const NoData(),
                    );
                  } else {
                    return HttpError(
                      errMsg: data?['msg'] ?? '请求异常',
                      btnText: data?['code'] == -101 ? '去登录' : null,
                      fn: () {
                        if (data?['code'] == -101) {
                          RoutePush.loginRedirectPush();
                        } else {
                          setState(() {
                            _futureBuilderFuture =
                                _laterController.queryLaterList();
                          });
                        }
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
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).padding.bottom + 80,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => _laterController.laterList.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: _laterController.toViewPlayAll,
                label: const Text('播放全部'),
                icon: const Icon(Icons.playlist_play),
              )
            : const SizedBox(),
      ),
    );
  }
}
