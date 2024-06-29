import 'package:flutter/material.dart';

class MessageAtPage extends StatefulWidget {
  const MessageAtPage({super.key});

  @override
  State<MessageAtPage> createState() => _MessageAtPageState();
}

class _MessageAtPageState extends State<MessageAtPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('@我的'),
      ),
    );
  }
}
