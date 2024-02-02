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
      body: RefreshIndicator(
        onRefresh: () async {
          await _whisperController.onRefresh();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                // 在这里根据父级容器的约束条件构建小部件树
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SizedBox(
                    height: constraints.maxWidth / 4,
                    child: Obx(
                      () => GridView.count(
                        primary: false,
                        crossAxisCount: 4,
                        padding: const EdgeInsets.all(0),
                        childAspectRatio: 1.25,
                        children: _whisperController.msgFeedTop.map((item) {
                          return GestureDetector(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Badge(
                                  isLabelVisible: item['value'] > 0,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  textColor: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
                                  label: Text(" ${item['value']} "),
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .onInverseSurface,
                                    child: Icon(
                                      item['icon'],
                                      size: 20,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(item['name'],
                                    style: const TextStyle(fontSize: 13))
                              ],
                            ),
                            onTap: () => Get.toNamed(item['route']),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              }),
              FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      List sessionList = _whisperController.sessionList;
                      return Obx(
                        () => sessionList.isEmpty
                            ? const SizedBox()
                            : ListView.separated(
                                itemCount: sessionList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (_, int i) {
                                  return ListTile(
                                    onTap: () => Get.toNamed(
                                      '/whisperDetail',
                                      parameters: {
                                        'talkerId':
                                            sessionList[i].talkerId.toString(),
                                        'name': sessionList[i].accountInfo.name,
                                        'face': sessionList[i].accountInfo.face,
                                        'mid': sessionList[i]
                                            .accountInfo
                                            .mid
                                            .toString(),
                                      },
                                    ),
                            );
                          } else {
                            // 请求错误
                            return const SizedBox();
                          }
                        } else {
                          // 骨架屏
                          return const SizedBox();
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
