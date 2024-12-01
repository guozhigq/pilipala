import 'package:flutter/material.dart';

class CommenWidget extends StatelessWidget {
  final String msg;

  const CommenWidget({required this.msg, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Center(
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }
}
