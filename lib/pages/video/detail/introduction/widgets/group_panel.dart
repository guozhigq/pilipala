import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/member/tags.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';

class GroupPanel extends StatefulWidget {
  final int? mid;
  const GroupPanel({super.key, this.mid});

  @override
  State<GroupPanel> createState() => _GroupPanelState();
}

class _GroupPanelState extends State<GroupPanel> {
  final Box<dynamic> localCache = GStrorage.localCache;
  late double sheetHeight;
  late Future _futureBuilderFuture;
  late List<MemberTagItemModel> tagsList;
  bool showDefault = true;

  @override
  void initState() {
    super.initState();
    sheetHeight = localCache.get('sheetHeight');
    _futureBuilderFuture = MemberHttp.followUpTags();
  }

  void onSave() async {
    feedBack();
    // 是否有选中的 有选中的带id，没选使用默认0
    final bool anyHasChecked =
        tagsList.any((MemberTagItemModel e) => e.checked == true);
    late String tagids;
    if (anyHasChecked) {
      final List<MemberTagItemModel> checkedList =
          tagsList.where((MemberTagItemModel e) => e.checked == true).toList();
      final List<int> tagidList =
          checkedList.map<int>((e) => e.tagid!).toList();
      tagids = tagidList.join(',');
    } else {
      tagids = '0';
    }
    // 保存
    final res = await MemberHttp.addUsers(widget.mid, tagids);
    SmartDialog.showToast(res['msg']);
    if (res['status']) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sheetHeight,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: <Widget>[
          AppBar(
            centerTitle: false,
            elevation: 0,
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close_outlined)),
            title:
                Text('设置关注分组', style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: Material(
              child: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      tagsList = data['data'];
                      return ListView.builder(
                        itemCount: data['data'].length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              data['data'][index].checked =
                                  !data['data'][index].checked;
                              showDefault =
                                  !data['data'].any((e) => e.checked == true);
                              setState(() {});
                            },
                            dense: true,
                            leading: const Icon(Icons.group_outlined),
                            minLeadingWidth: 0,
                            title: Text(data['data'][index].name),
                            subtitle: data['data'][index].tip != ''
                                ? Text(data['data'][index].tip)
                                : null,
                            trailing: Transform.scale(
                              scale: 0.9,
                              child: Checkbox(
                                value: data['data'][index].checked,
                                onChanged: (bool? checkValue) {
                                  data['data'][index].checked = checkValue;
                                  showDefault = !data['data']
                                      .any((e) => e.checked == true);
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return HttpError(
                        errMsg: data['msg'],
                        fn: () => setState(() {}),
                      );
                    }
                  } else {
                    // 骨架屏
                    return const Text('请求中');
                  }
                },
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).disabledColor.withOpacity(0.08),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => onSave(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary, // 设置按钮背景色
                  ),
                  child: Text(showDefault ? '保存至默认分组' : '保存'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
