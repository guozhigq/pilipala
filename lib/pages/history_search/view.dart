import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/pages/history/widgets/item.dart';

import 'controller.dart';

class HistorySearchPage extends StatefulWidget {
  const HistorySearchPage({super.key});

  @override
  State<HistorySearchPage> createState() => _HistorySearchPageState();
}

class _HistorySearchPageState extends State<HistorySearchPage> {
  final HistorySearchController _hisCtr = Get.put(HistorySearchController());
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = _hisCtr.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          EasyThrottle.throttle('history', const Duration(seconds: 1), () {
            _hisCtr.onLoad();
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
              onPressed: () => _hisCtr.submit(),
              icon: const Icon(Icons.search_outlined, size: 22)),
          const SizedBox(width: 10)
        ],
        title: Obx(
          () => TextField(
            autofocus: true,
            focusNode: _hisCtr.searchFocusNode,
            controller: _hisCtr.controller.value,
            textInputAction: TextInputAction.search,
            onChanged: (value) => _hisCtr.onChange(value),
            decoration: InputDecoration(
              hintText: _hisCtr.hintText,
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 22,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onPressed: () => _hisCtr.onClear(),
              ),
            ),
            onSubmitted: (String value) => _hisCtr.submit(),
          ),
        ),
      ),
      body: Obx(
        () {
          return _hisCtr.loadingStatus.value && _hisCtr.historyList.isEmpty
              ? ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const VideoCardHSkeleton();
                  },
                )
              : _hisCtr.historyList.isNotEmpty
                  ? ListView.builder(
                      controller: scrollController,
                      itemCount: _hisCtr.historyList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _hisCtr.historyList.length) {
                          return Container(
                            height: MediaQuery.of(context).padding.bottom + 60,
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom),
                            child: Center(
                              child: Obx(
                                () => Text(
                                  _hisCtr.loadingText.value,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return HistoryItem(
                            videoItem: _hisCtr.historyList[index],
                            ctr: _hisCtr,
                            onChoose: null,
                            onUpdateMultiple: () => null,
                          );
                        }
                      },
                    )
                  : const CustomScrollView(
                      slivers: <Widget>[
                        NoData(),
                      ],
                    );
        },
      ),
    );
  }
}
