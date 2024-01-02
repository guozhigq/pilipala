import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'controller.dart';
import 'widgets/item.dart';

class MemberSeasonsPage extends StatefulWidget {
  const MemberSeasonsPage({super.key});

  @override
  State<MemberSeasonsPage> createState() => _MemberSeasonsPageState();
}

class _MemberSeasonsPageState extends State<MemberSeasonsPage> {
  final MemberSeasonsController _memberSeasonsController =
      Get.put(MemberSeasonsController());
  late Future _futureBuilderFuture;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture =
        _memberSeasonsController.getSeasonDetail('onRefresh');
    scrollController = _memberSeasonsController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'member_archives', const Duration(milliseconds: 500), () {
            _memberSeasonsController.onLoad();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Text('他的专栏', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: StyleString.safeSpace,
          right: StyleString.safeSpace,
        ),
        child: SingleChildScrollView(
          controller: _memberSeasonsController.scrollController,
          child: FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  Map data = snapshot.data as Map;
                  List list = _memberSeasonsController.seasonsList;
                  if (data['status']) {
                    return Obx(
                      () => list.isNotEmpty
                          ? LayoutBuilder(
                              builder: (context, boxConstraints) {
                                return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: StyleString.safeSpace,
                                    mainAxisSpacing: StyleString.safeSpace,
                                    childAspectRatio: 0.94,
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _memberSeasonsController
                                      .seasonsList.length,
                                  itemBuilder: (context, i) {
                                    return MemberSeasonsItem(
                                      seasonItem: _memberSeasonsController
                                          .seasonsList[i],
                                    );
                                  },
                                );
                              },
                            )
                          : const SizedBox(),
                    );
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return const SizedBox();
                }
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}
