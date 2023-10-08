import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/pages/history/index.dart';

import 'widgets/item.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryController _historyController = Get.put(HistoryController());
  Future? _futureBuilderFuture;
  late ScrollController scrollController;

  @override
  void initState() {
    _futureBuilderFuture = _historyController.queryHistoryList();
    super.initState();
    scrollController = _historyController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          if (!_historyController.isLoadingMore.value) {
            EasyThrottle.throttle('history', const Duration(seconds: 1), () {
              _historyController.onLoad();
            });
          }
        }
      },
    );
    _historyController.enableMultiple.listen((p0) {
      setState(() {});
    });
  }

  // 选中
  onChoose(index) {
    _historyController.historyList[index].checked =
        !_historyController.historyList[index].checked!;
    _historyController.checkedCount.value =
        _historyController.historyList.where((item) => item.checked!).length;
    _historyController.historyList.refresh();
  }

  // 更新多选状态
  onUpdateMultiple() {
    setState(() {});
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        visible: _historyController.enableMultiple.value,
        child1: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          title: Text(
            '观看记录',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            IconButton(
              onPressed: () => Get.toNamed('/historySearch'),
              icon: const Icon(Icons.search_outlined),
            ),
            PopupMenuButton<String>(
              onSelected: (String type) {
                // 处理菜单项选择的逻辑
                switch (type) {
                  case 'pause':
                    _historyController.onPauseHistory();
                    break;
                  case 'clear':
                    _historyController.onClearHistory();
                    break;
                  case 'del':
                    _historyController.onDelHistory();
                    break;
                  case 'multiple':
                    _historyController.enableMultiple.value = true;
                    setState(() {});
                    break;
                  default:
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'pause',
                  child: Obx(
                    () => Text(!_historyController.pauseStatus.value
                        ? '暂停观看记录'
                        : '恢复观看记录'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'clear',
                  child: Text('清空观看记录'),
                ),
                const PopupMenuItem<String>(
                  value: 'del',
                  child: Text('删除已看记录'),
                ),
                const PopupMenuItem<String>(
                  value: 'multiple',
                  child: Text('多选删除'),
                ),
              ],
            ),
            const SizedBox(width: 6),
          ],
        ),
        child2: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              _historyController.enableMultiple.value = false;
              for (var item in _historyController.historyList) {
                item.checked = false;
              }
              _historyController.checkedCount.value = 0;
              setState(() {});
            },
            icon: const Icon(Icons.close_outlined),
          ),
          title: Obx(
            () => Text(
              '已选择${_historyController.checkedCount.value}项',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                for (var item in _historyController.historyList) {
                  item.checked = true;
                }
                _historyController.checkedCount.value =
                    _historyController.historyList.length;
                _historyController.historyList.refresh();
              },
              child: const Text('全选'),
            ),
            TextButton(
              onPressed: () => _historyController.onDelCheckedHistory(),
              child: Text(
                '删除',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _historyController.onRefresh();
          return;
        },
        child: CustomScrollView(
          controller: _historyController.scrollController,
          slivers: [
            FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return const SliverToBoxAdapter(child: SizedBox());
                  }
                  Map data = snapshot.data;
                  if (data['status']) {
                    return Obx(
                      () => _historyController.historyList.isNotEmpty
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                return HistoryItem(
                                  videoItem:
                                      _historyController.historyList[index],
                                  ctr: _historyController,
                                  onChoose: () => onChoose(index),
                                  onUpdateMultiple: () => onUpdateMultiple(),
                                );
                              },
                                  childCount:
                                      _historyController.historyList.length),
                            )
                          : _historyController.isLoadingMore.value
                              ? const SliverToBoxAdapter(
                                  child: Center(child: Text('加载中')),
                                )
                              : const NoData(),
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
                    }, childCount: 10),
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
      ),
      // bottomNavigationBar: BottomAppBar(),
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    required this.child1,
    required this.child2,
    required this.visible,
    Key? key,
  }) : super(key: key);

  final PreferredSizeWidget child1;
  final PreferredSizeWidget child2;
  final bool visible;
  @override
  Size get preferredSize => child1.preferredSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: !visible ? child1 : child2,
    );
  }
}
