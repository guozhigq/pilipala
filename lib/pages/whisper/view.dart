import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _futureBuilderFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map data = snapshot.data as Map;
                          if (data['status']) {
                            List sessionList = _whisperController.sessionList;
                            return Obx(
                              () => sessionList.isEmpty
                                  ? const SizedBox()
                                  : ListView.separated(
                                      itemCount: sessionList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (_, int i) {
                                        return ListTile(
                                          onTap: () => Get.toNamed(
                                            '/whisperDetail',
                                            parameters: {
                                              'talkerId': sessionList[i]
                                                  .talkerId
                                                  .toString(),
                                              'name': sessionList[i]
                                                  .accountInfo
                                                  .name,
                                              'face': sessionList[i]
                                                  .accountInfo
                                                  .face,
                                              'mid': sessionList[i]
                                                  .accountInfo
                                                  .mid
                                                  .toString(),
                                            },
                                          ),
                                          leading: Badge(
                                            isLabelVisible: false,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            label: Text(sessionList[i]
                                                .unreadCount
                                                .toString()),
                                            alignment: Alignment.bottomRight,
                                            child: NetworkImgLayer(
                                              width: 45,
                                              height: 45,
                                              type: 'avatar',
                                              src: sessionList[i]
                                                  .accountInfo
                                                  .face,
                                            ),
                                          ),
                                          title: Text(
                                              sessionList[i].accountInfo.name),
                                          subtitle: Text(
                                              sessionList[i]
                                                      .lastMsg
                                                      .content['text'] ??
                                                  sessionList[i]
                                                      .lastMsg
                                                      .content['content'] ??
                                                  sessionList[i]
                                                      .lastMsg
                                                      .content['title'] ??
                                                  sessionList[i]
                                                          .lastMsg
                                                          .content[
                                                      'reply_content'] ??
                                                  '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .outline)),
                                          trailing: Text(
                                            Utils.dateFormat(sessionList[i]
                                                .lastMsg
                                                .timestamp),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline),
                                          ),
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
                            return SizedBox();
                          }
                        } else {
                          // 骨架屏
                          return SizedBox();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
