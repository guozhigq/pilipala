import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/pages/history/widgets/item.dart';

import 'controller.dart';

class HistorySearchPage extends StatefulWidget {
  const HistorySearchPage({super.key});

  @override
  State<HistorySearchPage> createState() => _HistorySearchPageState();
}

class _HistorySearchPageState extends State<HistorySearchPage> {
  final HistorySearchController _historySearchCtr =
      Get.put(HistorySearchController());
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = _historySearchCtr.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          EasyThrottle.throttle('history', const Duration(seconds: 1), () {
            _historySearchCtr.onLoad();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        actions: [
          IconButton(
              onPressed: () => _historySearchCtr.submit(),
              icon: const Icon(Icons.search_outlined, size: 22)),
          const SizedBox(width: 10)
        ],
        title: Obx(
          () => TextField(
            autofocus: true,
            focusNode: _historySearchCtr.searchFocusNode,
            controller: _historySearchCtr.controller.value,
            textInputAction: TextInputAction.search,
            onChanged: (value) => _historySearchCtr.onChange(value),
            decoration: InputDecoration(
              hintText: _historySearchCtr.hintText,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 22,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onPressed: () => _historySearchCtr.onClear(),
              ),
            ),
            onSubmitted: (String value) => _historySearchCtr.submit(),
          ),
        ),
      ),
      body: Obx(
        () => Column(
          children: _historySearchCtr.loadingStatus.value == 'init'
              ? [const SizedBox()]
              : [
                  Expanded(
                    child: FutureBuilder(
                      future: _historySearchCtr.searchHistories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map data = snapshot.data as Map;
                          if (data['status']) {
                            return Obx(
                              () => _historySearchCtr.historyList.isNotEmpty
                                  ? ListView.builder(
                                      controller: scrollController,
                                      itemCount:
                                          _historySearchCtr.historyList.length +
                                              1,
                                      itemBuilder: (context, index) {
                                        if (index ==
                                            _historySearchCtr
                                                .historyList.length) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                    .padding
                                                    .bottom +
                                                60,
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .padding
                                                    .bottom),
                                            child: Center(
                                              child: Obx(
                                                () => Text(
                                                  _historySearchCtr
                                                      .loadingText.value,
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
                                          return HistoryItem(
                                            videoItem: _historySearchCtr
                                                .historyList[index],
                                            ctr: _historySearchCtr,
                                            onChoose: null,
                                            onUpdateMultiple: () => null,
                                          );
                                          ;
                                        }
                                      },
                                    )
                                  : _historySearchCtr.loadingStatus.value ==
                                          'loading'
                                      ? const SizedBox(child: Text('加载中...'))
                                      : const CustomScrollView(
                                          slivers: <Widget>[
                                            NoData(),
                                          ],
                                        ),
                            );
                          } else {
                            return CustomScrollView(
                              slivers: <Widget>[
                                HttpError(
                                  errMsg: data['msg'],
                                  fn: () => setState(() {}),
                                )
                              ],
                            );
                          }
                        } else {
                          // 骨架屏
                          return ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return const VideoCardHSkeleton();
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
