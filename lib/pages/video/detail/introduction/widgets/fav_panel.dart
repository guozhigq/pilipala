import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/utils/storage.dart';

class FavPanel extends StatefulWidget {
  var ctr;
  FavPanel({this.ctr});

  @override
  State<FavPanel> createState() => _FavPanelState();
}

class _FavPanelState extends State<FavPanel> {
  Box localCache = GStrorage.localCache;
  late double sheetHeight;
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    sheetHeight = localCache.get('sheetHeight');
    _futureBuilderFuture = widget.ctr!.queryVideoInFolder();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sheetHeight,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          AppBar(
            toolbarHeight: 50,
            automaticallyImplyLeading: false,
            centerTitle: false,
            elevation: 1,
            title: Text(
              '选择文件夹',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await widget.ctr!.actionFavVideo();
                  Get.back();
                },
                child: const Text('完成'),
              ),
              const SizedBox(width: 6),
            ],
          ),
          Expanded(
            child: Material(
              child: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(
                        () => ListView.builder(
                          itemCount:
                              widget.ctr!.favFolderData.value.list!.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return const SizedBox(height: 10);
                            } else {
                              return ListTile(
                                onTap: () => widget.ctr!.onChoose(
                                    widget.ctr!.favFolderData.value
                                            .list![index - 1].favState !=
                                        1,
                                    index - 1),
                                dense: true,
                                leading:
                                    const Icon(Icons.folder_special_outlined),
                                minLeadingWidth: 0,
                                title: Text(widget.ctr!.favFolderData.value
                                    .list![index - 1].title!),
                                subtitle: Text(
                                  '${widget.ctr!.favFolderData.value.list![index - 1].mediaCount}个内容',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontSize),
                                ),
                                trailing: Transform.scale(
                                  scale: 0.9,
                                  child: Checkbox(
                                    value: widget.ctr!.favFolderData.value
                                            .list![index - 1].favState ==
                                        1,
                                    onChanged: (bool? checkValue) => widget.ctr!
                                        .onChoose(checkValue!, index - 1),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () => setState(() {}),
                      );
                    }
                  } else {
                    // 骨架屏
                    return Text('请求中');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
