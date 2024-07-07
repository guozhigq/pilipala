import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pilipala/utils/feed_back.dart';
import './controller.dart';

class RankPage extends StatefulWidget {
  const RankPage({Key? key}) : super(key: key);

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final RankController _rankController = Get.put(RankController());
  List videoList = [];
  late Stream<bool> stream;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    stream = _rankController.searchBarStream.stream;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          const CustomAppBar(),
          if (_rankController.tabs.length > 1) ...[
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: Align(
                alignment: Alignment.center,
                child: TabBar(
                  controller: _rankController.tabController,
                  tabs: [
                    for (var i in _rankController.tabs) Tab(text: i['label'])
                  ],
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  enableFeedback: true,
                  splashBorderRadius: BorderRadius.circular(10),
                  tabAlignment: TabAlignment.center,
                  onTap: (value) {
                    feedBack();
                    if (_rankController.initialIndex.value == value) {
                      _rankController.tabsCtrList[value].animateToTop();
                    }
                    _rankController.initialIndex.value = value;
                  },
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 6),
          ],
          Expanded(
            child: TabBarView(
              controller: _rankController.tabController,
              children: _rankController.tabsPageList,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;

  const CustomAppBar({
    super.key,
    this.height = kToolbarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top,
      color: Colors.transparent,
    );
  }
}
