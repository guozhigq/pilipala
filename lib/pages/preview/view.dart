import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:pilipala/common/widgets/appbar.dart';
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
  late AnimationController animationController;
  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 250), vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    _doubleClickAnimationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        controller: animationController,
        visible: _previewController.visiable,
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          centerTitle: false,
          title: Obx(
            () => Text.rich(
              TextSpan(children: [
                TextSpan(text: _previewController.currentPage.toString()),
                const TextSpan(text: ' / '),
                TextSpan(text: _previewController.imgList.length.toString()),
              ]),
            ),
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              tooltip: 'action',
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 'share',
                  onTap: _previewController.onShareImg,
                  child: const Text('分享'),
                ),
                PopupMenuItem(
                  value: 'save',
                  onTap: _previewController.onSaveImg,
                  child: const Text('保存'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: GestureDetector(
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
                final Offset? pointerDownPosition = state.pointerDownPosition;
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
                  end = doubleTapScales[1];
                } else {
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
                          child: LinearProgressIndicator(value: progress),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _previewController.onSaveImg(),
        child: const Icon(Icons.save_alt_rounded),
      ),
    );
  }
}
