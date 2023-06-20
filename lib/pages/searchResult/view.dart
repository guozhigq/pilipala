import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final SearchResultController _searchResultController =
      Get.put(SearchResultController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: GestureDetector(
          onTap: () => Get.back(),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              '${_searchResultController.keyword}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: _searchResultController.tabs.length,
        child: Column(
          children: [
            Theme(
              data: ThemeData(
                splashColor: Colors.transparent, // 点击时的水波纹颜色设置为透明
                highlightColor: Colors.transparent, // 点击时的背景高亮颜色设置为透明
              ),
              child: TabBar(
                tabs: _searchResultController.tabs
                    .map((e) => Tab(text: e['label']))
                    .toList(),
                isScrollable: true,
                indicatorWeight: 0,
                indicatorPadding:
                    const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Theme.of(context).colorScheme.onSecondaryContainer,
                labelStyle: const TextStyle(fontSize: 13),
                dividerColor: Colors.transparent,
                unselectedLabelColor: Theme.of(context).colorScheme.outline,
                onTap: (index) {
                  print(index);
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    color: Colors.amber,
                  ),
                  Text('1'),
                  Text('1'),
                  Text('1'),
                  Text('1'),
                  Text('1'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
