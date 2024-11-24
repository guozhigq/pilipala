import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HttpError extends StatelessWidget {
  const HttpError({
    required this.errMsg,
    this.fn,
    this.btnText,
    this.isShowBtn = true,
    this.isInSliver = true,
    super.key,
  });

  final String? errMsg;
  final Function()? fn;
  final String? btnText;
  final bool isShowBtn;
  final bool isInSliver;

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    final errorContent = SizedBox(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/error.svg", height: 200),
          const SizedBox(height: 30),
          Text(
            errMsg ?? '请求异常',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 20),
          if (isShowBtn)
            FilledButton.tonal(
              onPressed: () => fn?.call(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  return primary.withAlpha(20);
                }),
              ),
              child: Text(btnText ?? '点击重试', style: TextStyle(color: primary)),
            ),
        ],
      ),
    );
    if (isInSliver) {
      return SliverToBoxAdapter(child: errorContent);
    } else {
      return Align(alignment: Alignment.topCenter, child: errorContent);
    }
  }
}
