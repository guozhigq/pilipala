import 'package:flutter/material.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

class UserPanel extends StatelessWidget {
  var userItem;
  UserPanel({super.key, this.userItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            NetworkImgLayer(
              width: 42,
              height: 42,
              src: userItem.upic,
              type: 'avatar',
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      userItem!.uname,
                      style: TextStyle(
                        // color: replyItem!.isUp! ||
                        //         replyItem!.member!.vip!['vipType'] > 0
                        //     ? Theme.of(context).colorScheme.primary
                        // : Theme.of(context).colorScheme.outline,
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      'assets/images/lv/lv${userItem!.level}.png',
                      height: 11,
                    ),
                  ],
                ),
                if (userItem.officialVerify['desc'] != '')
                  Text(
                    userItem.officialVerify['desc'],
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelSmall!.fontSize,
                        color: Theme.of(context).colorScheme.outline),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
