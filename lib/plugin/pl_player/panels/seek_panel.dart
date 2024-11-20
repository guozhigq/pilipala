import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/seek_indicator.dart';

class SeekPanel extends StatelessWidget {
  const SeekPanel({
    required this.mountSeekBackwardButton,
    required this.mountSeekForwardButton,
    required this.hideSeekBackwardButton,
    required this.hideSeekForwardButton,
    required this.onSubmittedcb,
    Key? key,
  }) : super(key: key);

  final RxBool mountSeekBackwardButton;
  final RxBool mountSeekForwardButton;
  final RxBool hideSeekBackwardButton;
  final RxBool hideSeekForwardButton;
  final void Function(String, Duration) onSubmittedcb;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: mountSeekBackwardButton.value || mountSeekForwardButton.value,
        child: Positioned.fill(
          child: Row(
            children: [
              _buildSeekIndicator(
                mountSeekBackwardButton,
                hideSeekBackwardButton,
                'backward',
                SeekIndicator(
                  direction: SeekDirection.backward,
                  onSubmitted: (Duration value) {
                    onSubmittedcb.call('backward', value);
                  },
                ),
              ),
              Expanded(child: Container()),
              _buildSeekIndicator(
                mountSeekForwardButton,
                hideSeekForwardButton,
                'forward',
                SeekIndicator(
                  direction: SeekDirection.forward,
                  onSubmitted: (Duration value) {
                    onSubmittedcb.call('forward', value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeekIndicator(
    RxBool mountSeekButton,
    RxBool hideSeekButton,
    String direction,
    Widget seekIndicator,
  ) {
    return Expanded(
      child: mountSeekButton.value
          ? AnimatedOpacity(
              opacity: hideSeekButton.value ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: seekIndicator,
            )
          : const SizedBox.shrink(),
    );
  }
}
