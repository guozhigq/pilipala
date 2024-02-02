import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

import 'controller.dart';

class LikeMePage extends StatefulWidget {
  const LikeMePage({super.key});

  @override
  State<LikeMePage> createState() => _LikeMePageState();
}

class _LikeMePageState extends State<LikeMePage> {
  late final LikeMeController _likeMeController = Get.put(LikeMeController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _likeMeController.queryMsgFeedLikeMe();
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  Future _scrollListener() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      EasyThrottle.throttle('my-throttler', const Duration(milliseconds: 800),
          () async {
        await _likeMeController.onLoad();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('收到的赞'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _likeMeController.onRefresh();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Obx(
              () {
                if (_likeMeController.msgFeedLikeMeList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.separated(
                  itemCount: _likeMeController.msgFeedLikeMeList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, int i) {
                    return ListTile(
                      onTap: () {
                        String nativeUri = _likeMeController
                                .msgFeedLikeMeList[i].item?.nativeUri ??
                            "";
                        SmartDialog.showToast("跳转至：$nativeUri（暂未实现）");
                      },
                      leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: Stack(
                            children: [
                              for (var j = 0;
                                  j <
                                          _likeMeController.msgFeedLikeMeList[i]
                                              .users!.length &&
                                      j < 4;
                                  j++) ...<Widget>[
                                Positioned(
                                    left: 15 * (j % 2).toDouble(),
                                    top: 15 * (j ~/ 2).toDouble(),
                                    child: NetworkImgLayer(
                                      width: _likeMeController
                                                  .msgFeedLikeMeList[i]
                                                  .users!
                                                  .length >
                                              1
                                          ? 30
                                          : 45,
                                      height: _likeMeController
                                                  .msgFeedLikeMeList[i]
                                                  .users!
                                                  .length >
                                              1
                                          ? 30
                                          : 45,
                                      type: 'avatar',
                                      src: _likeMeController
                                          .msgFeedLikeMeList[i]
                                          .users![j]
                                          .avatar,
                                    )),
                              ]
                            ],
                          )),
                      title: Text(
                        "${_likeMeController.msgFeedLikeMeList[i].users!.map((e) => e.nickname).join("、")}  "
                        "赞了我的${_likeMeController.msgFeedLikeMeList[i].item?.business}",
                        style: Theme.of(context).textTheme.bodyMedium!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle:
                          _likeMeController.msgFeedLikeMeList[i].item?.title !=
                                      null &&
                                  _likeMeController
                                          .msgFeedLikeMeList[i].item?.title !=
                                      ""
                              ? Text(
                                  _likeMeController
                                          .msgFeedLikeMeList[i].item?.title ??
                                      "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline))
                              : null,
                      trailing:
                          _likeMeController.msgFeedLikeMeList[i].item?.image !=
                                      null &&
                                  _likeMeController
                                          .msgFeedLikeMeList[i].item?.image !=
                                      ""
                              ? NetworkImgLayer(
                                  width: 45,
                                  height: 45,
                                  type: 'cover',
                                  src: _likeMeController
                                      .msgFeedLikeMeList[i].item?.image,
                                )
                              : null,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      indent: 72,
                      endIndent: 20,
                      height: 6,
                      color: Colors.grey.withOpacity(0.1),
                    );
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
