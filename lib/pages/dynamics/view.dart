import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/dynamics/result.dart';

import 'controller.dart';
import 'widgets/dynamic_panel.dart';

class DynamicsPage extends StatefulWidget {
  const DynamicsPage({super.key});

  @override
  State<DynamicsPage> createState() => _DynamicsPageState();
}

class _DynamicsPageState extends State<DynamicsPage> {
  DynamicsController _dynamicsController = Get.put(DynamicsController());
  Future? _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _dynamicsController.queryFollowDynamic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('动态'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
          const SizedBox(width: 10)
        ],
      ),
      body: FutureBuilder(
        future: _dynamicsController.queryFollowDynamic(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map data = snapshot.data;
            if (data['status']) {
              List<DynamicItemModel> list = _dynamicsController.dynamicsList!;
              return Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, index) {
                    return DynamicPanel(item: list[index]);
                  },
                ),
              );
            } else {
              return CustomScrollView(
                slivers: [
                  HttpError(
                    errMsg: data['msg'],
                    fn: () => setState(() {}),
                  )
                ],
              );
            }
          } else {
            // 骨架屏
            // return SliverList(
            //   delegate: SliverChildBuilderDelegate((context, index) {
            //     return const VideoCardHSkeleton();
            //   }, childCount: 10),
            // );
            return Text('加载中');
          }
        },
      ),
    );
  }
}
