import 'package:flutter/material.dart';
// import 'package:pilipala/models/common/theme_type.dart';

class SlideDialog<T extends num> extends StatefulWidget {
  final T value;
  final String title;
  final double min;
  final double max;
  final int? divisions;
  final String? suffix;

  const SlideDialog({
    super.key,
    required this.value,
    required this.title,
    required this.min,
    required this.max,
    this.divisions,
    this.suffix,
  });

  @override
  _SlideDialogState<T> createState() => _SlideDialogState<T>();
}

class _SlideDialogState<T extends num> extends State<SlideDialog<T>> {
  late double _tempValue;

  @override
  void initState() {
    super.initState();
    _tempValue = widget.value.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      contentPadding:
          const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 8),
      content: SizedBox(
        height: 40,
        child: Slider(
          value: _tempValue,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions ?? 10,
          label: '$_tempValue${widget.suffix ?? ''}',
          onChanged: (double value) {
            setState(() {
              _tempValue = value;
            });
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            '取消',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _tempValue as T),
          child: const Text('确定'),
        )
      ],
    );
  }
}
