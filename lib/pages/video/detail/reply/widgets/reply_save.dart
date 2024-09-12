import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/video/detail/reply/widgets/reply_item.dart';
import 'package:saver_gallery/saver_gallery.dart';

class ReplySave extends StatefulWidget {
  final ReplyItemModel? replyItem;
  const ReplySave({required this.replyItem, super.key});

  @override
  State<ReplySave> createState() => _ReplySaveState();
}

class _ReplySaveState extends State<ReplySave> {
  final _boundaryKey = GlobalKey();

  void _generatePicWidget() async {
    SmartDialog.showLoading(msg: '保存中');
    try {
      RenderRepaintBoundary boundary = _boundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      String picName =
          "plpl_reply_${DateTime.now().toString().replaceAll(RegExp(r'[- :]'), '').split('.').first}";
      final result = await SaverGallery.saveImage(
        Uint8List.fromList(pngBytes),
        name: '$picName.png',
        androidRelativePath: "Pictures/PiliPala",
        androidExistNotSave: false,
      );
      if (result.isSuccess) {
        SmartDialog.showToast('保存成功');
      }
    } catch (err) {
      print(err);
    } finally {
      SmartDialog.dismiss();
    }
  }

  List<Widget> _createWidgets(int count, Widget Function() builder) {
    return List<Widget>.generate(count, (_) => Expanded(child: builder()));
  }

  List<Widget> _createColumnWidgets() {
    return _createWidgets(3, () => Row(children: _createRowWidgets()));
  }

  List<Widget> _createRowWidgets() {
    return _createWidgets(
      4,
      () => Center(
        child: Transform.rotate(
          angle: pi / 10,
          child: const Text(
            'PiliPala',
            style: TextStyle(
              color: Color(0x08000000),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: EdgeInsets.fromLTRB(
            0,
            MediaQuery.of(context).padding.top + 4,
            0,
            MediaQuery.of(context).padding.bottom + 4,
          ),
          color: Colors.black54,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: RepaintBoundary(
                        key: _boundaryKey,
                        child: IntrinsicHeight(
                          child: Stack(
                            children: [
                              ReplyItem(
                                replyItem: widget.replyItem,
                                showReplyRow: false,
                                replySave: true,
                              ),
                              Positioned.fill(
                                child: Column(
                                  children: _createColumnWidgets(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => Get.back(),
                    child: const Text('取消'),
                  ),
                  const SizedBox(width: 40),
                  FilledButton(
                    onPressed: _generatePicWidget,
                    child: const Text('保存'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
