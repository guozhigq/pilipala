import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/drag_handle.dart';
import 'package:pilipala/models/video/ai.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/utils/global_data_cache.dart';
import 'package:pilipala/utils/utils.dart';

class AiDetail extends StatelessWidget {
  final ModelResult? modelResult;

  const AiDetail({
    Key? key,
    this.modelResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      height: GlobalDataCache.sheetHeight,
      child: Column(
        children: [
          const DragHandle(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    if (modelResult!.summary != '') ...[
                      _buildSummaryText(modelResult!.summary!),
                      const SizedBox(height: 20),
                    ],
                    _buildOutlineList(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryText(String summary) {
    return SelectableText(
      summary,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.6,
      ),
    );
  }

  Widget _buildOutlineList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modelResult!.outline!.length,
      itemBuilder: (context, index) {
        final outline = modelResult!.outline![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOutlineTitle(outline.title!),
            const SizedBox(height: 20),
            _buildPartOutlineList(context, outline.partOutline!),
          ],
        );
      },
    );
  }

  Widget _buildOutlineTitle(String title) {
    return SelectableText(
      title,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
    );
  }

  Widget _buildPartOutlineList(
      BuildContext context, List<PartOutline> partOutline) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: partOutline.length,
      itemBuilder: (context, i) {
        final part = partOutline[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPartText(context, part),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  void _onPartTap(BuildContext context, int timestamp) {
    try {
      final controller = Get.find<VideoDetailController>(
        tag: Get.arguments['heroTag'],
      );
      controller.plPlayerController.seekTo(
        Duration(seconds: timestamp),
      );
    } catch (_) {}
  }

  Widget _buildPartText(BuildContext context, PartOutline part) {
    return SelectableText.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 15,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        children: [
          TextSpan(
            text: Utils.tampToSeektime(part.timestamp!),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _onPartTap(context, part.timestamp!),
          ),
          const TextSpan(text: ' '),
          TextSpan(text: part.content!),
        ],
      ),
    );
  }
}
