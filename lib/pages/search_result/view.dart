import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/pages/search_panel/index.dart';
import 'controller.dart';
import 'widget/tab_bar.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  late SearchResultController _searchResultController;
  late TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _searchResultController = Get.put(SearchResultController(),
        tag: DateTime.now().millisecondsSinceEpoch.toString());

    _tabController = TabController(
      vsync: this,
      length: SearchType.values.length,
      initialIndex: _searchResultController.tabIndex,
    );
  }

  // tab点击事件
  void _onTap(int index) {
    if (index == _searchResultController.tabIndex) {
      Get.find<SearchPanelController>(
              tag: SearchType.values[index].type +
                  _searchResultController.keyword!)
          .animateToTop();
    }
    _searchResultController.tabIndex = index;
  }

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
      body: Column(
        children: [
          const SizedBox(height: 4),
          TabBarWidget(
            onTap: _onTap,
            tabController: _tabController!,
            searchResultCtr: _searchResultController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (var i in SearchType.values) ...{
                  SearchPanel(
                    keyword: _searchResultController.keyword,
                    searchType: i,
                    tag: DateTime.now().millisecondsSinceEpoch.toString(),
                  )
                }
              ],
            ),
          ),
        ],
      ),
    );
  }
}
