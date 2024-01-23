import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../http/user.dart';
import '../../http/video.dart';
import '../../pages/mine/controller.dart';

class VideoPopupMenu extends StatelessWidget {
  final double? size;
  final double? iconSize;
  final dynamic videoItem;
  final double menuItemHeight = 50;

  const VideoPopupMenu({
    Key? key,
    required this.size,
    required this.iconSize,
    required this.videoItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_vert_outlined,
          color: Theme.of(context).colorScheme.outline,
          size: iconSize,
        ),
        position: PopupMenuPosition.under,
        onSelected: (String type) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            onTap: () async {
              var res =
                  await UserHttp.toViewLater(bvid: videoItem.bvid as String);
              SmartDialog.showToast(res['msg']);
            },
            value: 'pause',
            height: menuItemHeight,
            child: const Row(
              children: [
                Icon(Icons.watch_later_outlined, size: 16),
                SizedBox(width: 6),
                Text('稍后再看', style: TextStyle(fontSize: 13))
              ],
            ),
          ),
          PopupMenuItem<String>(
            onTap: () async {
              SmartDialog.show(
                useSystem: true,
                animationType: SmartAnimationType.centerFade_otherSlide,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('提示'),
                    content: Text(
                        '确定拉黑:${videoItem.owner.name}(${videoItem.owner.mid})?'
                        '\n\n注：被拉黑的Up可以在隐私设置-黑名单管理中解除'),
                    actions: [
                      TextButton(
                        onPressed: () => SmartDialog.dismiss(),
                        child: Text(
                          '点错了',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          var res = await VideoHttp.relationMod(
                            mid: videoItem.owner.mid,
                            act: 5,
                            reSrc: 11,
                          );
                          SmartDialog.dismiss();
                          SmartDialog.showToast(res['msg'] ?? '成功');
                        },
                        child: const Text('确认'),
                      )
                    ],
                  );
                },
              );
            },
            value: 'block',
            height: menuItemHeight,
            child: Row(
              children: [
                const Icon(Icons.block, size: 16),
                const SizedBox(width: 6),
                Text('拉黑：${videoItem.owner.name}',
                    style: const TextStyle(fontSize: 13))
              ],
            ),
          ),
          // PopupMenuItem<String>(
          //   onTap: () async {
          //     SmartDialog.showToast("还没做");
          //   },
          //   value: 'anonymize',
          //   height: menuItemHeight,
          //   child: const Row(
          //     children: [
          //       Icon(Icons.visibility_off_outlined, size: 16),
          //       SizedBox(width: 6),
          //       Text('无痕播放',
          //           style: TextStyle(fontSize: 13))
          //     ],
          //   ),
          // ),
          PopupMenuItem<String>(
            onTap: () {
              MineController.onChangeAnonymity(context);
            },
            value: 'anonymous',
            height: menuItemHeight,
            child: Row(
              children: [
                Icon(
                  MineController.anonymity
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(MineController.anonymity ? '退出无痕模式' : '进入无痕模式',
                    style: const TextStyle(fontSize: 13))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
