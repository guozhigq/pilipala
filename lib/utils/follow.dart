import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pilipala/common/widgets/drag_handle.dart';
import 'package:pilipala/common/widgets/group_panel.dart';
import 'package:pilipala/http/video.dart';

class FollowUtils {
  final BuildContext context;
  final int followStatus;
  final int mid;

  FollowUtils({
    required this.context,
    required this.followStatus,
    required this.mid,
  });

  // static final Map<int, Map<String, dynamic>> followMap = {
  //   // 未关注
  //   0: {
  //     'desc': '确定关注UP主?',
  //     // 1 关注 5 拉黑
  //     'act': 1,
  //   },
  //   // 已关注
  //   2: {
  //     'desc': '确定取消关注UP主?',
  //     'act': 2,
  //   },
  //   // 已互粉
  //   6: {
  //     'desc': '确定取消关注UP主?',
  //     'act': 2,
  //   },
  //   // 已拉黑
  //   128: {
  //     'desc': '确定从黑名单移除UP主?',
  //     'act': 6,
  //   },
  // };

  static final Map<String, Map<String, dynamic>> actionTypeMap = {
    'remove': {
      'desc': '确定从黑名单移除UP主?',
      'tips': '已从黑名单移除',
      'act': 6,
      'followStatus': 0,
    },
    'unFollow': {
      'desc': '确定取消关注UP主?',
      'tips': '已取消关注',
      'act': 2,
      'followStatus': 0,
    },
    'follow': {
      'desc': '确定关注UP主?',
      'tips': '关注成功',
      'act': 1,
      'followStatus': 2,
    },
    'block': {
      'desc': '确定拉黑UP主?',
      'tips': '已拉黑',
      'act': 5,
      'followStatus': 128,
    },
  };

  Future<int> showFollowSheet() async {
    var res = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DragHandle(),
              if (followStatus == 128) ...[
                ListTile(
                  leading: const Icon(Icons.remove_circle_outline_rounded),
                  onTap: () => modifyRelation('remove'),
                  title: const Text('从黑名单移除'),
                ),
              ],
              if ([2, 6].contains(followStatus)) ...[
                ListTile(
                  leading: const Icon(Icons.group_add_outlined),
                  onTap: () {
                    Navigator.of(context).pop();
                    setFollowGroup();
                  },
                  title: const Text('设置分组'),
                ),
                ListTile(
                  leading: const Icon(Icons.heart_broken_outlined),
                  onTap: () => modifyRelation('unFollow'),
                  title: const Text('取消关注'),
                ),
              ],
              if (followStatus == 0) ...[
                ListTile(
                  leading: const Icon(Icons.favorite_border_rounded),
                  onTap: () => modifyRelation('follow'),
                  title: const Text('关注up主'),
                ),
                ListTile(
                  leading: const Icon(Icons.block_rounded),
                  onTap: () => modifyRelation('block'),
                  title: const Text('拉黑up主'),
                ),
              ],
            ],
          ),
        );
      },
    );
    return res ?? followStatus;
  }

  // 操作用户关系
  Future modifyRelation(String actionType) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final Color outline = Theme.of(context).colorScheme.outline;
        return AlertDialog(
          title: const Text('提示'),
          content: Text(actionTypeMap[actionType]!['desc']),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text('点错了', style: TextStyle(color: outline)),
            ),
            TextButton(
              onPressed: () => modifyRelationFetch(actionType),
              child: const Text('确定'),
            )
          ],
        );
      },
    );
  }

  // 操作用户关系Future
  Future<int> modifyRelationFetch(String actionType, {bool? isDirect}) async {
    if (isDirect != true) {
      Navigator.of(context).pop();
    }

    SmartDialog.showLoading(msg: '请求中');
    var res = await VideoHttp.relationMod(
      mid: mid,
      act: actionTypeMap[actionType]!['act'],
      reSrc: 11,
    );
    SmartDialog.dismiss();
    if (res['status']) {
      final int newFollowStatus = actionTypeMap[actionType]!['followStatus'];
      SmartDialog.showToast(actionTypeMap[actionType]!['tips']);
      if (context.mounted) {
        if (isDirect != true) {
          Navigator.of(context).pop(newFollowStatus);
        }
      }
      return newFollowStatus;
    } else {
      SmartDialog.showToast(res['msg']);
      if (context.mounted && isDirect != true) {
        Navigator.of(context).pop(-1);
      }
      return -1;
    }
  }

  // 设置分组
  Future setFollowGroup() async {
    final size = MediaQuery.sizeOf(context);
    final contentHeight = size.height - kToolbarHeight;
    final double initialChildSize =
        (contentHeight - size.width * 9 / 16) / contentHeight;
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: 0,
          maxChildSize: 1,
          snap: true,
          expand: false,
          snapSizes: [initialChildSize],
          builder: (BuildContext context, ScrollController scrollController) {
            return GroupPanel(
              mid: mid,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }
}
