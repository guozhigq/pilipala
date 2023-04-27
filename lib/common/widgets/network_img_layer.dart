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
            borderRadius: BorderRadius.circular(
                type == 'avatar' ? 50 : StyleString.imgRadius.x),
            child: CachedNetworkImage(
              imageUrl: src!,
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
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: Center(
          child: Image.asset(
        'assets/images/loading.png',
        width: 300,
        height: 300,
      )),
    );
  }
}
