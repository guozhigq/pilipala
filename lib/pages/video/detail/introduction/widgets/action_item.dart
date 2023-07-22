import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';

class ActionItem extends StatelessWidget {
  Icon? icon;
  Icon? selectIcon;
  Function? onTap;
  bool? loadingStatus;
  String? text;
  bool selectStatus = false;

  ActionItem({
    Key? key,
    this.icon,
    this.selectIcon,
    this.onTap,
    this.loadingStatus,
    this.text,
    required this.selectStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap!(),
      borderRadius: StyleString.mdRadius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 4),
          selectStatus
              ? Icon(selectIcon!.icon!,
                  size: 21, color: Theme.of(context).primaryColor)
              : Icon(icon!.icon!,
                  size: 21, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 4),
          AnimatedOpacity(
            opacity: loadingStatus! ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: Text(
              text ?? '',
              style: TextStyle(
                  color: selectStatus
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.outline,
                  fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
