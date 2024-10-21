import 'dart:async';
import 'package:flutter/material.dart';

enum SeekDirection { forward, backward }

class SeekIndicator extends StatefulWidget {
  final SeekDirection direction;
  final void Function(Duration) onSubmitted;

  const SeekIndicator({
    Key? key,
    required this.direction,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<SeekIndicator> createState() => _SeekIndicatorState();
}

class _SeekIndicatorState extends State<SeekIndicator> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(const Duration(seconds: 10));
      timer = null;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.direction == SeekDirection.forward
              ? [
                  const Color(0x00767676),
                  const Color(0x88767676),
                ]
              : [
                  const Color(0x88767676),
                  const Color(0x00767676),
                ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.direction == SeekDirection.forward
                  ? Icons.fast_forward
                  : Icons.fast_rewind,
              size: 24.0,
              color: const Color(0xFFFFFFFF),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.direction == SeekDirection.forward ? '快进10秒' : '快退10秒',
              style: const TextStyle(
                fontSize: 12.0,
                color: Color(0xFFFFFFFF),
                shadows: [
                  Shadow(
                    color: Color(0xFF000000),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
