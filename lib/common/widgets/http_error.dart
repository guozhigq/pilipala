import 'package:flutter/material.dart';

class HttpError extends StatelessWidget {
  const HttpError({required this.errMsg, required this.fn, super.key});

  final String? errMsg;
  final Function()? fn;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errMsg ?? '请求异常',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  fn!();
                },
                child: const Text('点击重试'))
          ],
        ),
      ),
    );
  }
}
