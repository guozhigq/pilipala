import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/utils/feed_back.dart';

class ActionItem extends StatelessWidget {
  final dynamic icon;
  final Icon? selectIcon;
  final Function? onTap;
  final Function? onLongPress;
  final String? text;
  final bool selectStatus;

  const ActionItem({
    Key? key,
    this.icon,
    this.selectIcon,
    this.onTap,
    this.onLongPress,
    this.text,
    this.selectStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        feedBack(),
        onTap!(),
      },
      onLongPress: () => {
        if (onLongPress != null) {onLongPress!()}
      },
      borderRadius: StyleString.mdRadius,
      child: SizedBox(
        width: (Get.size.width - 24) / 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 4),
            icon is Icon
                ? Icon(
                    selectStatus ? selectIcon!.icon ?? icon!.icon : icon!.icon,
                    color: selectStatus
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  )
                : Image.asset(
                    'assets/images/coin.png',
                    width: 25,
                    color: selectStatus
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
            const SizedBox(height: 6),
            Text(
              text ?? '',
              style: TextStyle(
                color:
                    selectStatus ? Theme.of(context).colorScheme.primary : null,
                fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
              ),
            )
          ],
        ),
      ),
    );
  }
}
