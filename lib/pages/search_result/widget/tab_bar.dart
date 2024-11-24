import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/search_result/index.dart';

class TabBarWidget extends StatelessWidget {
  final Function(int) onTap;
  final TabController tabController;
  final SearchResultController searchResultCtr;

  const TabBarWidget({
    required this.onTap,
    required this.tabController,
    required this.searchResultCtr,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color transparent = Colors.transparent;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 8),
      color: colorScheme.surface,
      child: Theme(
        data: ThemeData(splashColor: transparent, highlightColor: transparent),
        child: Obx(
          () => TabBar(
            controller: tabController,
            tabs: [
              for (var i in searchResultCtr.searchTabs)
                Tab(text: "${i['label']} ${i['count'] ?? ''}"),
            ],
            isScrollable: true,
            indicatorPadding:
                const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
            indicator: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: colorScheme.onSecondaryContainer,
            labelStyle: const TextStyle(fontSize: 13),
            dividerColor: transparent,
            unselectedLabelColor: colorScheme.outline,
            tabAlignment: TabAlignment.start,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
