import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/skeleton.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/utils/utils.dart';

import 'controller.dart';

class WhisperPage extends StatefulWidget {
  const WhisperPage({super.key});

  @override
  State<WhisperPage> createState() => _WhisperPageState();
}

class _WhisperPageState extends State<WhisperPage> {
  late final WhisperController _whisperController =
      Get.put(WhisperController());
  late Future _futureBuilderFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _whisperController.querySessionList('init');
    _scrollController.addListener(_scrollListener);
  }

  Future _scrollListener() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      EasyThrottle.throttle('my-throttler', const Duration(milliseconds: 800),
          () async {
        await _whisperController.onLoad();
        _whisperController.isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消息'),
      ),
      body: Column(
        children: [
          // LayoutBuilder(
          //   builder: (BuildContext context, BoxConstraints constraints) {
          //     // 在这里根据父级容器的约束条件构建小部件树
          //     return Padding(
          //       padding: const EdgeInsets.only(left: 20, right: 20),
          //       child: SizedBox(
          //         height: constraints.maxWidth / 5,
          //         child: GridView.count(
          //           primary: false,
          //           crossAxisCount: 4,
          //           padding: const EdgeInsets.all(0),
          //           childAspectRatio: 1.25,
          //           children: [
          //             Column(
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 SizedBox(
          //                   width: 36,
          //                   height: 36,
          //                   child: IconButton(
          //                     style: ButtonStyle(
          //                       padding:
          //                           MaterialStateProperty.all(EdgeInsets.zero),
          //                       backgroundColor:
          //                           MaterialStateProperty.resolveWith((states) {
          //                         return Theme.of(context)
          //                             .colorScheme
          //                             .primary
          //                             .withOpacity(0.1);
          //                       }),
          //                     ),
          //                     onPressed: () {},
          //                     icon: Icon(
          //                       Icons.message_outlined,
          //                       size: 18,
          //                       color: Theme.of(context).colorScheme.primary,
          //                     ),
          //                   ),
          //                 ),
          //                 const SizedBox(height: 6),
          //                 const Text('回复我的', style: TextStyle(fontSize: 13))
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _whisperController.onRefresh();
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: FutureBuilder(
                  future: _futureBuilderFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map? data = snapshot.data;
                      if (data != null && data['status']) {
                        RxList sessionList = _whisperController.sessionList;
                        return Obx(
                          () => sessionList.isEmpty
                              ? const SizedBox()
                              : ListView.separated(
                                  itemCount: sessionList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (_, int i) {
                                    return SessionItem(
                                      sessionItem: sessionList[i],
                                      changeFucCall: () =>
                                          sessionList.refresh(),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider(
                                      indent: 72,
                                      endIndent: 20,
                                      height: 6,
                                      color: Colors.grey.withOpacity(0.1),
                                    );
                                  },
                                ),
                        );
                      } else {
                        // 请求错误
                        return Center(
                          child: Text(data?['msg'] ?? '请求异常'),
                        );
                      }
                    } else {
                      // 骨架屏
                      return ListView.builder(
                        itemCount: 15,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, int i) {
                          return Skeleton(
                            child: ListTile(
                              leading: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              title: Container(
                                width: 100,
                                height: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onInverseSurface,
                              ),
                              subtitle: Container(
                                width: 80,
                                height: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onInverseSurface,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SessionItem extends StatelessWidget {
  final dynamic sessionItem;
  final Function changeFucCall;

  const SessionItem({
    super.key,
    required this.sessionItem,
    required this.changeFucCall,
  });

  @override
  Widget build(BuildContext context) {
    final content = sessionItem.lastMsg.content;
    return ListTile(
      onTap: () {
        sessionItem.unreadCount = 0;
        changeFucCall.call();
        Get.toNamed(
          '/whisperDetail',
          parameters: {
            'talkerId': sessionItem.talkerId.toString(),
            'name': sessionItem.accountInfo.name,
            'face': sessionItem.accountInfo.face,
            'mid': sessionItem.accountInfo.mid.toString(),
          },
        );
      },
      leading: Badge(
        isLabelVisible: sessionItem.unreadCount > 0,
        label: Text(sessionItem.unreadCount.toString()),
        alignment: Alignment.topRight,
        child: NetworkImgLayer(
          width: 45,
          height: 45,
          type: 'avatar',
          src: sessionItem.accountInfo.face,
        ),
      ),
      title: Text(sessionItem.accountInfo.name),
      subtitle: Text(
          content != null && content != ''
              ? (content['text'] ??
                  content['content'] ??
                  content['title'] ??
                  content['reply_content'] ??
                  '不支持的消息类型')
              : '不支持的消息类型',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Theme.of(context).colorScheme.outline)),
      trailing: Text(
        Utils.dateFormat(sessionItem.lastMsg.timestamp),
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }
}
