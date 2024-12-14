import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'archive.dart';
import 'controller.dart';
import 'dynamic.dart';

class MemberSearchPage extends StatefulWidget {
  const MemberSearchPage({super.key});

  @override
  State<MemberSearchPage> createState() => _MemberSearchPageState();
}

class _MemberSearchPageState extends State<MemberSearchPage>
    with SingleTickerProviderStateMixin {
  final MemberSearchController _memberSearchCtr =
      Get.put(MemberSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _memberSearchCtr.submit(),
            icon: const Icon(CupertinoIcons.search, size: 22),
          ),
          const SizedBox(width: 10)
        ],
        title: searchTextField(),
      ),
      body: Obx(
        () => _memberSearchCtr.searchKeyWord.value.isEmpty
            ? SizedBox(
                height: 300,
                child: Center(
                  child: Text('搜索「${_memberSearchCtr.uname.value}」的动态、视频'),
                ),
              )
            : Column(
                children: [
                  TabBar(
                    controller: _memberSearchCtr.tabController,
                    dividerColor: Colors.transparent,
                    splashBorderRadius: BorderRadius.circular(8),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: _memberSearchCtr.tabs.map(
                      (element) {
                        return Tab(text: element);
                      },
                    ).toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _memberSearchCtr.tabController,
                      children: [
                        SearchArchivePage(
                          searchKeyWord: _memberSearchCtr.textController.text,
                          controller: _memberSearchCtr,
                        ),
                        SearchDynamicPage(
                          searchKeyWord: _memberSearchCtr.textController.text,
                          controller: _memberSearchCtr,
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget searchTextField() {
    return TextField(
      autofocus: true,
      focusNode: _memberSearchCtr.searchFocusNode,
      controller: _memberSearchCtr.textController,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: '搜索',
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            size: 22,
            color: Theme.of(context).colorScheme.outline,
          ),
          onPressed: _memberSearchCtr.onClear,
        ),
      ),
      onSubmitted: (String value) => _memberSearchCtr.submit(),
    );
  }
}
