import 'package:flutter/material.dart';

/// A callback for the [InteractiveViewerBoundary] that is called when the scale
/// changed.
typedef ScaleChanged = void Function(double scale);

/// Builds an [InteractiveViewer] and provides callbacks that are called when a
/// horizontal boundary has been hit.
///
/// The callbacks are called when an interaction ends by listening to the
/// [InteractiveViewer.onInteractionEnd] callback.
class InteractiveViewerBoundary extends StatefulWidget {
  const InteractiveViewerBoundary({
    required this.child,
    required this.boundaryWidth,
    this.controller,
    this.onScaleChanged,
    this.onLeftBoundaryHit,
    this.onRightBoundaryHit,
    this.onNoBoundaryHit,
    this.maxScale,
    this.minScale,
    Key? key,
  }) : super(key: key);

  final Widget child;

  /// The max width this widget can have.
  ///
  /// If the [InteractiveViewer] can take up the entire screen width, this
  /// should be set to `MediaQuery.of(context).size.width`.
  final double boundaryWidth;

  /// The [TransformationController] for the [InteractiveViewer].
  final TransformationController? controller;

  /// Called when the scale changed after an interaction ended.
  final ScaleChanged? onScaleChanged;

  /// Called when the left boundary has been hit after an interaction ended.
  final VoidCallback? onLeftBoundaryHit;

  /// Called when the right boundary has been hit after an interaction ended.
  final VoidCallback? onRightBoundaryHit;

  /// Called when no boundary has been hit after an interaction ended.
  final VoidCallback? onNoBoundaryHit;

  final double? maxScale;

  final double? minScale;

  @override
  InteractiveViewerBoundaryState createState() =>
      InteractiveViewerBoundaryState();
}

class InteractiveViewerBoundaryState extends State<InteractiveViewerBoundary> {
  TransformationController? _controller;

  double? _scale;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TransformationController();
  }

  @override
  void dispose() {
    _controller!.dispose();

    super.dispose();
  }

  void _updateBoundaryDetection() {
    final double scale = _controller!.value.row0[0];

    if (_scale != scale) {
      // the scale changed
      _scale = scale;
      widget.onScaleChanged?.call(scale);
    }

    if (scale <= 1.01) {
      // cant hit any boundaries when the child is not scaled
      return;
    }

    final double xOffset = _controller!.value.row0[3];
    final double boundaryWidth = widget.boundaryWidth;
    final double boundaryEnd = boundaryWidth * scale;
    final double xPos = boundaryEnd + xOffset;

    if (boundaryEnd.round() == xPos.round()) {
      // left boundary hit
      widget.onLeftBoundaryHit?.call();
    } else if (boundaryWidth.round() == xPos.round()) {
      // right boundary hit
      widget.onRightBoundaryHit?.call();
    } else {
      widget.onNoBoundaryHit?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: widget.maxScale!,
      minScale: widget.minScale!,
      transformationController: _controller,
      onInteractionEnd: (_) => _updateBoundaryDetection(),
      child: widget.child,
    );
  }
}
