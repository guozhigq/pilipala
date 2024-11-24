import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
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
  late String category;

  @override
  void initState() {
    super.initState();
    category = Get.parameters['category']!;
    _futureBuilderFuture = _memberSeasonsController.onRefresh();
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
      appBar: AppBar(title: Text(Get.parameters['seasonName']!)),
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
                  Map? data = snapshot.data;
                  List list = _memberSeasonsController.seasonsList;
                  if (data?['status']) {
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
                          : const HttpError(
                              errMsg: '没有数据',
                              isInSliver: false,
                              isShowBtn: false,
                            ),
                    );
                  } else {
                    return HttpError(
                      errMsg: snapshot.data['msg'],
                      isInSliver: false,
                      fn: () {
                        setState(() {
                          _futureBuilderFuture =
                              _memberSeasonsController.onRefresh();
                        });
                      },
                    );
                  }
                } else {
                  return HttpError(
                    errMsg: snapshot.data['msg'] ?? '请求异常',
                    isInSliver: false,
                    fn: () {
                      setState(() {
                        _futureBuilderFuture =
                            _memberSeasonsController.onRefresh();
                      });
                    },
                  );
                }
              } else {
                return ListView.builder(
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return const VideoCardHSkeleton();
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
