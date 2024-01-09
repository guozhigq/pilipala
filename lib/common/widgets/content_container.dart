import 'package:flutter/material.dart';

class ContentContainer extends StatelessWidget {
  final Widget? contentWidget;
  final Widget? bottomWidget;
  final bool isScrollable;
  final Clip? childClipBehavior;

  const ContentContainer(
      {Key? key,
      this.contentWidget,
      this.bottomWidget,
      this.isScrollable = true,
      this.childClipBehavior})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          clipBehavior: childClipBehavior ?? Clip.hardEdge,
          physics: isScrollable ? null : const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: constraints.copyWith(
              minHeight: constraints.maxHeight,
              maxHeight: double.infinity,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  if (contentWidget != null)
                    Expanded(
                      child: contentWidget!,
                    )
                  else
                    Spacer(),
                  if (bottomWidget != null) bottomWidget!,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
