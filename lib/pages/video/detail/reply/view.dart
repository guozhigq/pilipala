import 'package:flutter/material.dart';

class VideoReplyPanel extends StatefulWidget {
  const VideoReplyPanel({super.key});

  @override
  State<VideoReplyPanel> createState() => _VideoReplyPanelState();
}

class _VideoReplyPanelState extends State<VideoReplyPanel> {
  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Text('评论'),
    );
  }
}
