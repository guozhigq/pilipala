import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/pages/later/index.dart';

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
          () => Text(
            '稍后再看 (${_laterController.laterList.length}/100)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _laterController.toViewDel(),
            child: const Text('移除已看'),
          ),
          // IconButton(
          //   tooltip: '一键清空',
          //   onPressed: () {},
          //   icon: Icon(
          //     Icons.clear_all_outlined,
          //     size: 21,
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          // ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        controller: _laterController.scrollController,
        slivers: [
          FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map data = snapshot.data as Map;
                if (data['status']) {
                  return Obx(
                    () => SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return VideoCardH(
                          videoItem: _laterController.laterList[index],
                          source: 'later',
                        );
                      }, childCount: _laterController.laterList.length),
                    ),
                  );
                } else {
                  return HttpError(
                    errMsg: data['msg'],
                    fn: () => setState(() {}),
                  );
                }
              } else {
                // 骨架屏
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return const VideoCardHSkeleton();
                  }, childCount: 5),
                );
              }
            },
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
