import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/utils/feed_back.dart';

class ActionItem extends StatelessWidget {
  final Icon? icon;
  final Icon? selectIcon;
  final Function? onTap;
  final bool? loadingStatus;
  final String? text;
  final bool selectStatus;

  const ActionItem({
    Key? key,
    this.icon,
    this.selectIcon,
    this.onTap,
    this.loadingStatus,
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
      borderRadius: StyleString.mdRadius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 4),
          selectStatus
              ? Icon(selectIcon!.icon!,
                  size: 18, color: Theme.of(context).colorScheme.primary)
              : Icon(icon!.icon!,
                  size: 18, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 6),
          AnimatedOpacity(
            opacity: loadingStatus! ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                text ?? '',
                key: ValueKey<String>(text ?? ''),
                style: TextStyle(
                    color: selectStatus
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    fontSize: Theme.of(context).textTheme.labelSmall!.fontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
