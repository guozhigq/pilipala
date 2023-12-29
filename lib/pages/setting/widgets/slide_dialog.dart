import 'package:flutter/material.dart';
// import 'package:pilipala/models/common/theme_type.dart';

class SlideDialog<T extends num> extends StatefulWidget {
  final T value;
  final String title;
  final double min;
  final double max;
  final int divisions;
  final String? suffix;
  const SlideDialog({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.title,
    this.suffix,
  });

  @override
  _SlideDialogState<T> createState() => _SlideDialogState<T>();
}

class _SlideDialogState<T extends num> extends State<SlideDialog<T>> {
  late T _tempValue;

  @override
  void initState() {
    super.initState();
    _tempValue = widget.value;
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
          value: widget.value.toDouble(),
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          label: '${widget.value}${widget.suffix}',
          onChanged: (double value) {
            print(value);
            setState(() {
              _tempValue = value as T;
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
            )),
        TextButton(
            onPressed: () => Navigator.pop(context, _tempValue),
            child: const Text('确定'))
      ],
    );
  }
}
