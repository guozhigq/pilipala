import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'widgets/follow_list.dart';
import 'widgets/owner_follow_list.dart';

class FollowPage extends StatefulWidget {
  const FollowPage({super.key});

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  late String mid;
  late FollowController _followController;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    mid = Get.parameters['mid']!;
    _followController = Get.put(FollowController(), tag: mid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        title: Text(
          _followController.isOwner.value
              ? '我的关注'
              : '${_followController.name}的关注',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Obx(
        () => !_followController.isOwner.value
            ? FollowList(ctr: _followController)
            : FutureBuilder(
                future: _followController.followUpTags(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    var data = snapshot.data;
                    if (data['status']) {
                      return Column(
                        children: [
                          TabBar(
                              controller: _followController.tabController,
                              isScrollable: true,
                              tabs: [
                                for (var i in data['data']) ...[
                                  Tab(text: i.name),
                                ]
                              ]),
                          Expanded(
                            child: TabBarView(
                              controller: _followController.tabController,
                              children: [
                                for (var i = 0;
                                    i < _followController.tabController.length;
                                    i++) ...[
                                  OwnerFollowList(
                                    ctr: _followController,
                                    tagItem: _followController.followTags[i],
                                  )
                                ]
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
      ),
    );
  }
}
