import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/pages/search/index.dart';

import 'widgets/hotKeyword.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchController _searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.08),
            width: 1,
          ),
        ),
        titleSpacing: 0,
        title: Obx(
          () => TextField(
            autofocus: true,
            focusNode: _searchController.searchFocusNode,
            controller: _searchController.controller.value,
            textInputAction: TextInputAction.search,
            onChanged: (value) => _searchController.onChange(value),
            decoration: InputDecoration(
              hintText: '搜索',
              border: InputBorder.none,
              suffixIcon: _searchController.searchKeyWord.value.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      onPressed: () => _searchController.onClear())
                  : null,
            ),
            onSubmitted: (String value) => _searchController.submit(value),
          ),
        ),
      ),
      // body: Column(
      //   children: [hotSearch()],
      // ),
      body: hotSearch(),
      // body: DefaultTabController(
      //   length: _searchController.tabs.length,
      //   child: Column(
      //     children: [
      //       const SizedBox(height: 4),
      //       Theme(
      //         data: ThemeData(
      //           splashColor: Colors.transparent, // 点击时的水波纹颜色设置为透明
      //           highlightColor: Colors.transparent, // 点击时的背景高亮颜色设置为透明
      //         ),
      //         child: TabBar(
      //           tabs: _searchController.tabs
      //               .map((e) => Tab(text: e['label']))
      //               .toList(),
      //           isScrollable: true,
      //           indicatorWeight: 0,
      //           indicatorPadding:
      //               const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
      //           indicator: BoxDecoration(
      //             color: Theme.of(context).colorScheme.secondaryContainer,
      //             borderRadius: const BorderRadius.all(
      //               Radius.circular(16),
      //             ),
      //           ),
      //           indicatorSize: TabBarIndicatorSize.tab,
      //           labelColor: Theme.of(context).colorScheme.onSecondaryContainer,
      //           labelStyle: const TextStyle(fontSize: 13),
      //           dividerColor: Colors.transparent,
      //           unselectedLabelColor: Theme.of(context).colorScheme.outline,
      //           onTap: (index) {
      //             print(index);
      //           },
      //         ),
      //       ),
      //       Expanded(
      //         child: TabBarView(
      //           children: [
      //             Container(
      //               width: 200,
      //               height: 200,
      //               color: Colors.amber,
      //             ),
      //             Text('1'),
      //             Text('1'),
      //             Text('1'),
      //             Text('1'),
      //             Text('1'),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget hotSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 25, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            child: Text(
              '大家都在搜',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, boxConstraints) {
              final double width = boxConstraints.maxWidth;
              return FutureBuilder(
                future: _searchController.queryHotSearchList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return HotKeyword(
                        width: width,
                        hotSearchList: _searchController.hotSearchList,
                        onClick: (keyword) =>
                            _searchController.onClickKeyword(keyword),
                      );
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () => setState(() {}),
                      );
                    }
                  } else {
                    // 缓存数据
                    if (_searchController.hotSearchList.isNotEmpty) {
                      return HotKeyword(
                        width: width,
                        hotSearchList: _searchController.hotSearchList,
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
