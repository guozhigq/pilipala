import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/utils/route_push.dart';
import 'controller.dart';
import 'widgets/item.dart';

class SubPage extends StatefulWidget {
  const SubPage({super.key});

  @override
  State<SubPage> createState() => _SubPageState();
}

class _SubPageState extends State<SubPage> {
  final SubController _subController = Get.put(SubController());
  late Future _futureBuilderFuture;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _subController.querySubFolder();
    scrollController = _subController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          EasyThrottle.throttle('history', const Duration(seconds: 1), () {
            _subController.onLoad();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Obx(() => Text('${_subController.isOwner.value ? '我' : 'Ta'}的订阅')),
      ),
      body: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map? data = snapshot.data;
            if (data != null && data['status']) {
              if (_subController.subFolderData.value.list!.isNotEmpty) {
                return Obx(
                  () => ListView.builder(
                    controller: scrollController,
                    itemCount: _subController.subFolderData.value.list!.length,
                    itemBuilder: (context, index) {
                      return SubItem(
                          subFolderItem:
                              _subController.subFolderData.value.list![index],
                          isOwner: _subController.isOwner.value,
                          cancelSub: _subController.cancelSub);
                    },
                  ),
                );
              } else {
                return const HttpError(
                  errMsg: '',
                  btnText: '没有数据',
                  fn: null,
                  isInSliver: false,
                );
              }
            } else {
              return HttpError(
                errMsg: data?['msg'] ?? '请求异常',
                btnText: data?['code'] == -101 ? '去登录' : null,
                fn: () {
                  if (data?['code'] == -101) {
                    RoutePush.loginRedirectPush();
                  } else {
                    setState(() {
                      _futureBuilderFuture = _subController.querySubFolder();
                    });
                  }
                },
                isInSliver: false,
              );
            }
          } else {
            // 骨架屏
            return ListView.builder(
              itemBuilder: (context, index) {
                return const VideoCardHSkeleton();
              },
              itemCount: 10,
            );
          }
        },
      ),
    );
  }
}
