import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/follow/result.dart';
import 'package:pilipala/pages/video/detail/introduction/widgets/group_panel.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/utils.dart';

class FollowItem extends StatelessWidget {
  final FollowItemModel item;
  const FollowItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(item!.mid);
    return ListTile(
      onTap: () {
        feedBack();
        Get.toNamed('/member?mid=${item.mid}',
            arguments: {'face': item.face, 'heroTag': heroTag});
      },
      leading: Hero(
        tag: heroTag,
        child: NetworkImgLayer(
          width: 45,
          height: 45,
          type: 'avatar',
          src: item.face,
        ),
      ),
      title: Text(
        item.uname!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        item.sign!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      dense: true,
      trailing: SizedBox(
        height: 34,
        child: TextButton(
          onPressed: () async {
            await Get.bottomSheet(
              GroupPanel(mid: item.mid!),
              isScrollControlled: true,
            );
            SmartDialog.showToast('重进页面查看效果');
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            foregroundColor: Theme.of(context).colorScheme.outline,
            backgroundColor:
                Theme.of(context).colorScheme.onInverseSurface, // 设置按钮背景色
          ),
          child: const Text(
            '已关注',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
