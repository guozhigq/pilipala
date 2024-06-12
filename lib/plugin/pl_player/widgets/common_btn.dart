import 'package:flutter/material.dart';

class ComBtn extends StatelessWidget {
  final Widget? icon;
  final Function? fuc;

  const ComBtn({
    this.icon,
    this.fuc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        onPressed: () {
          fuc!();
        },
        icon: icon!,
      ),
    );
  }
}
