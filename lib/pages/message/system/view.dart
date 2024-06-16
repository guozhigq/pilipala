import 'package:flutter/material.dart';

class MessageSystemPage extends StatefulWidget {
  const MessageSystemPage({super.key});

  @override
  State<MessageSystemPage> createState() => _MessageSystemPageState();
}

class _MessageSystemPageState extends State<MessageSystemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('系统通知'),
      ),
    );
  }
}
