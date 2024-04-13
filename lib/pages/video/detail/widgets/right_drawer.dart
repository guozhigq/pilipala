import 'package:flutter/material.dart';

class RightDrawer extends StatefulWidget {
  const RightDrawer({super.key});

  @override
  State<RightDrawer> createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        shadowColor: Colors.transparent,
        elevation: 0,
        backgroundColor:
            Theme.of(context).colorScheme.surface.withOpacity(0.8));
  }
}
