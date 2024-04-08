import 'dart:async';

import 'package:dlna_dart/dlna.dart';
import 'package:flutter/material.dart';

class LiveDlnaPage extends StatefulWidget {
  final String datasource;

  const LiveDlnaPage({Key? key, required this.datasource}) : super(key: key);

  @override
  State<LiveDlnaPage> createState() => _LiveDlnaPageState();
}

class _LiveDlnaPageState extends State<LiveDlnaPage> {
  final Map<String, DLNADevice> _deviceList = {};
  final DLNAManager searcher = DLNAManager();
  late final Timer stopSearchTimer;
  String selectDeviceKey = '';
  bool isSearching = true;

  DLNADevice? get device => _deviceList[selectDeviceKey];

  @override
  void initState() {
    stopSearchTimer = Timer(const Duration(seconds: 20), () {
      setState(() => isSearching = false);
      searcher.stop();
    });
    searcher.stop();
    startSearch();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searcher.stop();
    stopSearchTimer.cancel();
  }

  void startSearch() async {
    // clear old devices
    isSearching = true;
    selectDeviceKey = '';
    _deviceList.clear();
    setState(() {});
    // start search server
    final m = await searcher.start();
    m.devices.stream.listen((deviceList) {
      deviceList.forEach((key, value) {
        _deviceList[key] = value;
      });
      setState(() {});
    });
    // close the server, the closed server can be start by call searcher.start()
  }

  void selectDevice(String key) {
    if (selectDeviceKey.isNotEmpty) device?.pause();

    selectDeviceKey = key;
    device?.setUrl(widget.datasource);
    device?.play();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget cur;
    if (isSearching && _deviceList.isEmpty) {
      cur = const Center(child: CircularProgressIndicator());
    } else if (_deviceList.isEmpty) {
      cur = Center(
        child: Text(
          '没有找到设备',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    } else {
      cur = ListView(
        children: _deviceList.keys
            .map<Widget>((key) => ListTile(
                  contentPadding: const EdgeInsets.all(2),
                  title: Text(_deviceList[key]!.info.friendlyName),
                  subtitle: Text(key),
                  onTap: () => selectDevice(key),
                ))
            .toList(),
      );
    }

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('查找设备'),
          IconButton(
            onPressed: startSearch,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      content: SizedBox(
        height: 200,
        width: 200,
        child: cur,
      ),
    );
  }
}
