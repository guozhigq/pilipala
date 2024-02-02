import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

import 'controller.dart';

class ReplyMePage extends StatefulWidget {
  const ReplyMePage({super.key});

  @override
  State<ReplyMePage> createState() => _ReplyMePageState();
}

class _ReplyMePageState extends State<ReplyMePage> {
  late final ReplyMeController _replyMeController =
      Get.put(ReplyMeController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _replyMeController.queryMsgFeedReplyMe();
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  Future _scrollListener() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      EasyThrottle.throttle('my-throttler', const Duration(milliseconds: 800),
          () async {
        await _replyMeController.onLoad();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('回复我的'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _replyMeController.onRefresh();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Obx(
              () {
                if (_replyMeController.msgFeedReplyMeList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.separated(
                  itemCount: _replyMeController.msgFeedReplyMeList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, int i) {
                    return ListTile(
                      onTap: () {
                        String nativeUri = _replyMeController
                                .msgFeedReplyMeList[i].item?.nativeUri ??
                            "";
                        SmartDialog.showToast("跳转至：$nativeUri（暂未实现）");
                      },
                      leading: NetworkImgLayer(
                        width: 45,
                        height: 45,
                        type: 'avatar',
                        src: _replyMeController
                            .msgFeedReplyMeList[i].user?.avatar,
                      ),
                      title: Text(
                        "${_replyMeController.msgFeedReplyMeList[i].user?.nickname}  "
                        "回复了我的${_replyMeController.msgFeedReplyMeList[i].item?.business}",
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                      subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                                _replyMeController.msgFeedReplyMeList[i].item
                                        ?.sourceContent ??
                                    "",
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 4),
                            if (_replyMeController.msgFeedReplyMeList[i].item
                                        ?.targetReplyContent !=
                                    null &&
                                _replyMeController.msgFeedReplyMeList[i].item
                                        ?.targetReplyContent !=
                                    "")
                              Text(
                                  "| ${_replyMeController.msgFeedReplyMeList[i].item?.targetReplyContent}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                          height: 1.5)),
                            if (_replyMeController.msgFeedReplyMeList[i].item
                                        ?.rootReplyContent !=
                                    null &&
                                _replyMeController.msgFeedReplyMeList[i].item
                                        ?.rootReplyContent !=
                                    "")
                              Text(
                                  " | ${_replyMeController.msgFeedReplyMeList[i].item?.rootReplyContent}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                      height: 1.5)),
                          ]),
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
