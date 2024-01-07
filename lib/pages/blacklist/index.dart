import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/black.dart';
import 'package:pilipala/models/user/black.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/utils.dart';

class BlackListPage extends StatefulWidget {
  const BlackListPage({super.key});

  @override
  State<BlackListPage> createState() => _BlackListPageState();
}

class _BlackListPageState extends State<BlackListPage> {
  final BlackListController _blackListController =
      Get.put(BlackListController());
  final ScrollController scrollController = ScrollController();
  Future? _futureBuilderFuture;
  bool _isLoadingMore = false;
  Box setting = GStrorage.setting;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _blackListController.queryBlacklist();
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          if (!_isLoadingMore) {
            _isLoadingMore = true;
            await _blackListController.queryBlacklist(type: 'onLoad');
            _isLoadingMore = false;
          }
        }
      },
    );
  }

  @override
  void dispose() {
    List<int> blackMidsList =
        _blackListController.blackList.map<int>((e) => e.mid!).toList();
    setting.put(SettingBoxKey.blackMidsList, blackMidsList);
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        title: Obx(
          () => Text(
            '黑名单管理 - ${_blackListController.total.value}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _blackListController.queryBlacklist(),
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data;
              if (data['status']) {
                List<BlackListItem> list = _blackListController.blackList;
                return Obx(
                  () => list.length == 1
                      ? const SizedBox()
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {},
                              leading: NetworkImgLayer(
                                width: 45,
                                height: 45,
                                type: 'avatar',
                                src: list[index].face,
                              ),
                              title: Text(
                                list[index].uname!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                Utils.dateFormat(list[index].mtime),
                                maxLines: 1,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline),
                                overflow: TextOverflow.ellipsis,
                              ),
                              dense: true,
                              trailing: TextButton(
                                onPressed: () => _blackListController
                                    .removeBlack(list[index].mid),
                                child: const Text('移除'),
                              ),
                            );
                          },
                        ),
                );
              } else {
                return CustomScrollView(
                  slivers: [
                    HttpError(
                      errMsg: data['msg'],
                      fn: () => _blackListController.queryBlacklist(),
                    )
                  ],
                );
              }
            } else {
              // 骨架屏
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class BlackListController extends GetxController {
  int currentPage = 1;
  int pageSize = 50;
  RxInt total = 0.obs;
  RxList<BlackListItem> blackList = [BlackListItem()].obs;

  Future queryBlacklist({type = 'init'}) async {
    if (type == 'init') {
      currentPage = 1;
    }
    var result = await BlackHttp.blackList(pn: currentPage, ps: pageSize);
    if (result['status']) {
      if (type == 'init') {
        blackList.value = result['data'].list;
        total.value = result['data'].total;
      } else {
        blackList.addAll(result['data'].list);
      }

      currentPage += 1;
    }
    return result;
  }

  Future removeBlack(mid) async {
    var result = await BlackHttp.removeBlack(fid: mid);
    if (result['status']) {
      blackList.removeWhere((e) => e.mid == mid);
      total.value = total.value - 1;
      SmartDialog.showToast(result['msg']);
    }
  }
}
