// ignore_for_file: depend_on_referenced_packages

import 'dart:math';
import 'dart:ui' as ui show Image;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

double get maxDragOffset => 100;
double hideHeight = maxDragOffset / 2.3;
double refreshHeight = maxDragOffset / 1.5;

class PullToRefreshHeader extends StatelessWidget {
  const PullToRefreshHeader(
    this.info,
    this.lastRefreshTime, {
    this.color,
    Key? key,
  }) : super(key: key);

  final PullToRefreshScrollNotificationInfo? info;
  final DateTime? lastRefreshTime;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final PullToRefreshScrollNotificationInfo? infos = info;
    if (infos == null) {
      return Container();
    }
    String text = '';
    if (infos.mode == PullToRefreshIndicatorMode.armed) {
      text = 'Release to refresh';
    } else if (infos.mode == PullToRefreshIndicatorMode.refresh ||
        infos.mode == PullToRefreshIndicatorMode.snap) {
      text = 'Loading...';
    } else if (infos.mode == PullToRefreshIndicatorMode.done) {
      text = 'Refresh completed.';
    } else if (infos.mode == PullToRefreshIndicatorMode.drag) {
      text = 'Pull to refresh';
    } else if (infos.mode == PullToRefreshIndicatorMode.canceled) {
      text = 'Cancel refresh';
    }

    final TextStyle ts = const TextStyle(
      color: Colors.grey,
    ).copyWith(fontSize: 14);

    final double dragOffset = info?.dragOffset ?? 0.0;

    final DateTime time = lastRefreshTime ?? DateTime.now();
    final double top = -hideHeight + dragOffset;
    return Container(
      height: dragOffset,
      color: color ?? Colors.transparent,
      // padding: EdgeInsets.only(top: dragOffset / 3),
      // padding: EdgeInsets.only(bottom: 5.0),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            right: 0.0,
            top: top,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 12.0),
                    child: RefreshImage(top, null),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(text, style: ts),
                    Text(
                      'Last updated:${DateFormat('yyyy-MM-dd hh:mm').format(time)}',
                      style: ts.copyWith(fontSize: 14),
                    )
                  ],
                ),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RefreshImage extends StatelessWidget {
  const RefreshImage(this.top, Key? key) : super(key: key);

  final double top;

  @override
  Widget build(BuildContext context) {
    const double imageSize = 30;
    return ExtendedImage.asset(
      'assets/flutterCandies_grey.png',
      width: imageSize,
      height: imageSize,
      afterPaintImage: (Canvas canvas, Rect rect, ui.Image image, Paint paint) {
        final double imageHeight = image.height.toDouble();
        final double imageWidth = image.width.toDouble();
        final Size size = rect.size;
        final double y =
            (1 - min(top / (refreshHeight - hideHeight), 1)) * imageHeight;

        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0.0, y, imageWidth, imageHeight - y),
          Rect.fromLTWH(rect.left, rect.top + y / imageHeight * size.height,
              size.width, (imageHeight - y) / imageHeight * size.height),
          Paint()
            ..colorFilter =
                const ColorFilter.mode(Color(0xFFea5504), BlendMode.srcIn)
            ..isAntiAlias = false
            ..filterQuality = FilterQuality.low,
        );

        //canvas.restore();
      },
    );
  }
}
