import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/whisperDetail/controller.dart';

import 'widget/chat_item.dart';

class WhisperDetailPage extends StatefulWidget {
  const WhisperDetailPage({super.key});

  @override
  State<WhisperDetailPage> createState() => _WhisperDetailPageState();
}

class _WhisperDetailPageState extends State<WhisperDetailPage> {
  final WhisperDetailController _whisperDetailController =
      Get.put(WhisperDetailController());
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _whisperDetailController.querySessionMsg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 34,
                height: 34,
                child: IconButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      return Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.6);
                    }),
                  ),
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Obx(
                () => Text(
                  _whisperDetailController.name.value,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 36, height: 36),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map data = snapshot.data as Map;
            if (data['status']) {
              List messageList = _whisperDetailController.messageList;
              return Obx(
                () => messageList.isEmpty
                    ? const SizedBox()
                    : ListView.builder(
                        itemCount: messageList.length,
                        shrinkWrap: true,
                        reverse: true,
                        itemBuilder: (_, int i) {
                          if (i == 0) {
                            return Column(
                              children: [
                                ChatItem(item: messageList[i]),
                                const SizedBox(height: 12),
                              ],
                            );
                          } else {
                            return ChatItem(item: messageList[i]);
                          }
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
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: MediaQuery.of(context).padding.bottom + 70,
        padding: EdgeInsets.only(
          left: 8,
          right: 12,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              width: 4,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.add_circle_outline,
            //     color: Theme.of(context).colorScheme.outline,
            //   ),
            // ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.emoji_emotions_outlined,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            // Expanded(
            //   child: Container(
            //     height: 42,
            //     decoration: BoxDecoration(
            //       color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            //       borderRadius: BorderRadius.circular(40.0),
            //     ),
            //     child: TextField(
            //       readOnly: true,
            //       style: Theme.of(context).textTheme.titleMedium,
            //       decoration: const InputDecoration(
            //         border: InputBorder.none, // 移除默认边框
            //         hintText: '请输入内容', // 提示文本
            //         contentPadding: EdgeInsets.symmetric(
            //             horizontal: 12.0, vertical: 12.0), // 内边距
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
