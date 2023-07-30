import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pilipala/common/constants.dart';

class NetworkImgLayer extends StatelessWidget {
  final String? src;
  final double? width;
  final double? height;
  final double? cacheW;
  final double? cacheH;
  final String? type;
  final Duration? fadeOutDuration;
  final Duration? fadeInDuration;

  const NetworkImgLayer({
    Key? key,
    this.src,
    required this.width,
    required this.height,
    this.cacheW,
    this.cacheH,
    this.type,
    this.fadeOutDuration,
    this.fadeInDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double pr = MediaQuery.of(context).devicePixelRatio;
    // double pr = 2;
    return src != ''
        ? ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(type == 'avatar'
                ? 50
                : type == 'emote'
                    ? 0
                    : StyleString.imgRadius.x),
            child: CachedNetworkImage(
              imageUrl: src!.startsWith('//') ? 'https:${src!}' : src!,
              width: width ?? double.infinity,
              height: height ?? double.infinity,
              alignment: Alignment.center,
              maxWidthDiskCache: ((cacheW ?? width!) * pr).toInt(),
              // maxHeightDiskCache: (cacheH ?? height!).toInt(),
              memCacheWidth: ((cacheW ?? width!) * pr).toInt(),
              // memCacheHeight: (cacheH ?? height!).toInt(),
              fit: BoxFit.cover,
              fadeOutDuration:
                  fadeOutDuration ?? const Duration(milliseconds: 200),
              fadeInDuration:
                  fadeInDuration ?? const Duration(milliseconds: 200),
              // filterQuality: FilterQuality.high,
              errorWidget: (context, url, error) => placeholder(context),
              placeholder: (context, url) => placeholder(context),
            ),
          )
        : placeholder(context);
  }

  Widget placeholder(context) {
    return Container(
      color: Theme.of(context).colorScheme.onInverseSurface.withOpacity(0.6),
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: Center(
          child: Image.asset(
        type == 'avatar'
            ? 'assets/images/noface.jpeg'
            : 'assets/images/loading.png',
        width: 300,
        height: 300,
      )),
    );
  }
}
