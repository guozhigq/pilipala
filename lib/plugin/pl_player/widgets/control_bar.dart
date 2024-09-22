import 'package:flutter/material.dart';

class ControlBar extends StatelessWidget {
  final bool visible;
  final IconData icon;
  final double value;

  const ControlBar({
    Key? key,
    required this.visible,
    required this.icon,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xFFFFFFFF);
    return Align(
      child: AnimatedOpacity(
        curve: Curves.easeInOut,
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 150),
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
            decoration: BoxDecoration(
              color: const Color(0x88000000),
              borderRadius: BorderRadius.circular(64.0),
            ),
            height: 34.0,
            child: Row(
              children: <Widget>[
                Icon(icon, color: color, size: 18.0),
                const SizedBox(width: 4.0),
                Container(
                  constraints: const BoxConstraints(minWidth: 30.0),
                  child: Text(
                    '${(value * 100.0).round()}%',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13.0, color: color),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
