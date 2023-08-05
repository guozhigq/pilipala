// ignore_for_file: library_private_types_in_public_api

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'controller.dart';

typedef DoubleClickAnimationListener = void Function();

class ImagePreview extends StatefulWidget {
  const ImagePreview({Key? key}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview>
    with TickerProviderStateMixin {
  final PreviewController _previewController = Get.put(PreviewController());
  // late AnimationController animationController;
  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];
  bool _dismissDisabled = false;

  @override
  void initState() {
    super.initState();
    // animationController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 400));
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
  }

  @override
  void dispose() {
    // animationController.dispose();
    _doubleClickAnimationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        primary: false,
        toolbarHeight: 0,
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          DismissiblePage(
            backgroundColor: Colors.transparent,
            onDismissed: () {
              Navigator.of(context).pop();
            },
            // Note that scrollable widget inside DismissiblePage might limit the functionality
            // If scroll direction matches DismissiblePage direction
            direction: DismissiblePageDismissDirection.down,
            disabled: _dismissDisabled,
            isFullScreen: true,
            child: Hero(
              tag: _previewController
                  .imgList[_previewController.initialPage.value],
              child: GestureDetector(
                onTap: () {
                  _previewController.visiable = !_previewController.visiable;
                  setState(() {});
                },
                child: ExtendedImageGesturePageView.builder(
                  controller: ExtendedPageController(
                    initialPage: _previewController.initialPage.value,
                    pageSpacing: 0,
                  ),
                  onPageChanged: (int index) {
                    _previewController.initialPage.value = index;
                    _previewController.currentPage.value = index + 1;
                  },
                  canScrollPage: (GestureDetails? gestureDetails) =>
                      gestureDetails!.totalScale! <= 1.0,
                  preloadPagesCount: 2,
                  itemCount: _previewController.imgList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExtendedImage.network(
                      _previewController.imgList[index],
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      onDoubleTap: (ExtendedImageGestureState state) {
                        final Offset? pointerDownPosition =
                            state.pointerDownPosition;
                        final double? begin = state.gestureDetails!.totalScale;
                        double end;

                        //remove old
                        _doubleClickAnimation
                            ?.removeListener(_doubleClickAnimationListener);

                        //stop pre
                        _doubleClickAnimationController.stop();

                        //reset to use
                        _doubleClickAnimationController.reset();

                        if (begin == doubleTapScales[0]) {
                          setState(() {
                            _dismissDisabled = true;
                          });
                          end = doubleTapScales[1];
                        } else {
                          setState(() {
                            _dismissDisabled = false;
                          });
                          end = doubleTapScales[0];
                        }

                        _doubleClickAnimationListener = () {
                          state.handleDoubleTap(
                              scale: _doubleClickAnimation!.value,
                              doubleTapPosition: pointerDownPosition);
                        };
                        _doubleClickAnimation = _doubleClickAnimationController
                            .drive(Tween<double>(begin: begin, end: end));

                        _doubleClickAnimation!
                            .addListener(_doubleClickAnimationListener);

                        _doubleClickAnimationController.forward();
                      },
                      loadStateChanged: (ExtendedImageState state) {
                        if (state.extendedImageLoadState == LoadState.loading) {
                          final ImageChunkEvent? loadingProgress =
                              state.loadingProgress;
                          final double? progress =
                              loadingProgress?.expectedTotalBytes != null
                                  ? loadingProgress!.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null;
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 150.0,
                                  child:
                                      LinearProgressIndicator(value: progress),
                                ),
                                const SizedBox(height: 10.0),
                                Text('${((progress ?? 0.0) * 100).toInt()}%'),
                              ],
                            ),
                          );
                        }
                      },
                      initGestureConfigHandler: (ExtendedImageState state) {
                        return GestureConfig(
                          inPageView: true,
                          initialScale: 1.0,
                          maxScale: 5.0,
                          animationMaxScale: 6.0,
                          initialAlignment: InitialAlignment.center,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // height: 45,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom, top: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black87,
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Text.rich(
                        TextSpan(
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                            children: [
                              TextSpan(
                                  text: _previewController.currentPage
                                      .toString()),
                              const TextSpan(text: ' / '),
                              TextSpan(
                                  text: _previewController.imgList.length
                                      .toString()),
                            ]),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () => _previewController.onShareImg(),
                        child: const Text('分享')),
                    const SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () => _previewController.onSaveImg(),
                        child: const Text('保存'))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
