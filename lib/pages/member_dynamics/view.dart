import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/member_dynamics/index.dart';

import '../dynamics/widgets/dynamic_panel.dart';

class MemberDynamicsPage extends StatefulWidget {
  const MemberDynamicsPage({super.key});

  @override
  State<MemberDynamicsPage> createState() => _MemberDynamicsPageState();
}

class _MemberDynamicsPageState extends State<MemberDynamicsPage> {
  final MemberDynamicsController _memberDynamicController =
      Get.put(MemberDynamicsController());
  late Future _futureBuilderFuture;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture =
        _memberDynamicController.getMemberDynamic('onRefresh');
    scrollController = _memberDynamicController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'member_dynamics', const Duration(milliseconds: 500), () {
            _memberDynamicController.onLoad();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _memberDynamicController.scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('他的动态'),
      ),
      body: CustomScrollView(
        controller: _memberDynamicController.scrollController,
        slivers: [
          FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map data = snapshot.data as Map;
                List list = _memberDynamicController.dynamicsList;
                if (data['status']) {
                  return Obx(
                    () => list.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return DynamicPanel(item: list[index]);
                              },
                              childCount: list.length,
                            ),
                          )
                        : const SliverToBoxAdapter(),
                  );
                } else {
                  return const SliverToBoxAdapter();
                }
              } else {
                return const SliverToBoxAdapter();
              }
            },
          ),
        ],
      ),
    );
  }
}
