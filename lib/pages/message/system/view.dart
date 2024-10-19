import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/msg/system.dart';
import 'controller.dart';

class MessageSystemPage extends StatefulWidget {
  const MessageSystemPage({super.key});

  @override
  State<MessageSystemPage> createState() => _MessageSystemPageState();
}

class _MessageSystemPageState extends State<MessageSystemPage> {
  final MessageSystemController _messageSystemCtr =
      Get.put(MessageSystemController());
  late Future _futureBuilderFuture;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _messageSystemCtr.queryAndProcessMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('系统通知'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _messageSystemCtr.queryAndProcessMessages();
        },
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return const SizedBox();
              }
              if (snapshot.data['status']) {
                final systemItems = _messageSystemCtr.systemItems;
                return Obx(
                  () => ListView.separated(
                    controller: scrollController,
                    itemBuilder: (context, index) => SystemItem(
                      item: systemItems[index],
                      index: index,
                      messageSystemCtr: _messageSystemCtr,
                    ),
                    itemCount: systemItems.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        indent: 14,
                        endIndent: 14,
                        height: 1,
                        color: Colors.grey.withOpacity(0.1),
                      );
                    },
                  ),
                );
              } else {
                // 请求错误
                return HttpError(
                  errMsg: snapshot.data['msg'],
                  fn: () {
                    setState(() {
                      _futureBuilderFuture =
                          _messageSystemCtr.queryMessageSystem();
                    });
                  },
                  isInSliver: false,
                );
              }
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class SystemItem extends StatelessWidget {
  final MessageSystemModel item;
  final int index;
  final MessageSystemController messageSystemCtr;

  const SystemItem(
      {super.key,
      required this.item,
      required this.index,
      required this.messageSystemCtr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title!,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            item.timeAt!,
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: 6),
          Text(item.content is String ? item.content : item.content!['web']),
        ],
      ),
    );
  }
}
