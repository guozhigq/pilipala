import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

import 'controller.dart';

class AtMePage extends StatefulWidget {
  const AtMePage({super.key});

  @override
  State<AtMePage> createState() => _AtMePageState();
}

class _AtMePageState extends State<AtMePage> {
  late final AtMeController _atMeController = Get.put(AtMeController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _atMeController.queryMsgFeedAtMe();
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  Future _scrollListener() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      EasyThrottle.throttle('my-throttler', const Duration(milliseconds: 800),
          () async {
        await _atMeController.onLoad();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('@我的'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _atMeController.onRefresh();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Obx(
              () {
                if (_atMeController.msgFeedAtMeList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.separated(
                  itemCount: _atMeController.msgFeedAtMeList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, int i) {
                    return ListTile(
                      onTap: () {
                        String nativeUri = _atMeController
                                .msgFeedAtMeList[i].item?.nativeUri ??
                            "";
                        SmartDialog.showToast("跳转至：$nativeUri（暂未实现）");
                      },
                      leading: NetworkImgLayer(
                        width: 45,
                        height: 45,
                        type: 'avatar',
                        src: _atMeController.msgFeedAtMeList[i].user?.avatar,
                      ),
                      title: Text(
                        "${_atMeController.msgFeedAtMeList[i].user?.nickname}  "
                        "在${_atMeController.msgFeedAtMeList[i].item?.business}中@了我",
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                      subtitle: Text(
                          _atMeController
                                  .msgFeedAtMeList[i].item?.sourceContent ??
                              "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.outline)),
                      trailing: _atMeController
                                      .msgFeedAtMeList[i].item?.image !=
                                  null &&
                              _atMeController.msgFeedAtMeList[i].item?.image !=
                                  ""
                          ? NetworkImgLayer(
                              width: 45,
                              height: 45,
                              type: 'cover',
                              src: _atMeController
                                  .msgFeedAtMeList[i].item?.image,
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
