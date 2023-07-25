// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class ExpandedSection extends StatefulWidget {
  final Widget? child;
  final bool expand;
  final double begin;
  final double end;

  const ExpandedSection({
    super.key,
    this.expand = false,
    this.child,
    this.begin = 0.0,
    this.end = 1.0,
  });

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  // void prepareAnimations() {
  //   expandController = AnimationController(
  //       vsync: this, duration: const Duration(milliseconds: 500));
  //   animation = CurvedAnimation(
  //     parent: expandController,
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }

  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    Animation<double> curve = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: widget.begin, end: widget.end).animate(curve);
    //   animation = CurvedAnimation(
    //     parent: expandController,
    //     curve: Curves.fastOutSlowIn,
    //   );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: -1.0,
      sizeFactor: animation,
      child: widget.child,
    );
  }
}
