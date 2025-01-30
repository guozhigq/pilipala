import 'package:flutter/material.dart';

class SubordinateScrollController extends ScrollController {
  SubordinateScrollController({
    required ScrollController parent,
    String? debugLabel,
  })  : _parent = parent,
        super(
          initialScrollOffset: parent.initialScrollOffset,
          keepScrollOffset: parent.keepScrollOffset,
          debugLabel: switch ((parent.debugLabel, debugLabel)) {
            (null, null) => null,
            (null, String label) => label,
            (String label, null) => '$label/sub',
            (String parentLabel, String label) => '$parentLabel/$label',
          },
        );

  final ScrollController _parent;
  bool _isActive = false;

  ScrollController get parent => _parent;

  bool get isActive => _isActive;
  set isActive(bool value) {
    if (_isActive != value) {
      _isActive = value;
      if (_isActive) {
        _attachToParent();
      } else {
        _detachFromParent();
      }
    }
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _parent.createScrollPosition(
      physics,
      context,
      oldPosition,
    );
  }

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    if (_isActive) {
      _parent.attach(position);
    }
  }

  @override
  void detach(ScrollPosition position) {
    if (_isActive) {
      _parent.detach(position);
    }
    super.detach(position);
  }

  void _detachFromParent() {
    for (final position in positions) {
      _parent.detach(position);
    }
  }

  void _attachToParent() {
    for (final position in positions) {
      _parent.attach(position);
    }
  }

  @override
  void dispose() {
    if (isActive) {
      isActive = false;
    }
    super.dispose();
  }
}

class SubordinateScrollControllerScope extends StatefulWidget {
  final Widget child;
  final bool isActive;

  const SubordinateScrollControllerScope({
    super.key,
    required this.isActive,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() =>
      _SubordinateScrollControllerProviderState();
}

class _SubordinateScrollControllerProviderState
    extends State<SubordinateScrollControllerScope> {
  SubordinateScrollController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final parentController = PrimaryScrollController.of(context);

    if (parentController != _controller?.parent) {
      _controller?.dispose();
      _controller = SubordinateScrollController(parent: parentController);
      _controller!.isActive = widget.isActive;
    }
  }

  @override
  void didUpdateWidget(covariant SubordinateScrollControllerScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller!.isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _controller!,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
