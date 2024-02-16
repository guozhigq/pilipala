import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/loggeer.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  late File logsPath;
  late String fileContent;
  List logsContent = [];

  @override
  void initState() {
    getPath();
    super.initState();
  }

  void getPath() async {
    logsPath = await getLogsPath();
    fileContent = await logsPath.readAsString();
    logsContent = await parseLogs(fileContent);
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> parseLogs(String fileContent) async {
    const String splitToken =
        '======================================================================';
    List contentList = fileContent.split(splitToken).map((item) {
      return item
          .replaceAll(
              '============================== CATCHER 2 LOG ==============================',
              'Pilipala错误日志 \n ********************')
          .replaceAll('DEVICE INFO', '设备信息')
          .replaceAll('APP INFO', '应用信息')
          .replaceAll('ERROR', '错误信息')
          .replaceAll('STACK TRACE', '错误堆栈');
    }).toList();
    List<Map<String, dynamic>> result = [];
    for (String i in contentList) {
      dynamic date;
      String body = i
          .split("\n")
          .map((l) {
            if (l.startsWith("Crash occurred on")) {
              try {
                date = DateTime.parse(
                  l.split("Crash occurred on")[1].trim().split('.')[0],
                );
              } catch (e) {
                print(e.toString());
                date = l.toString();
              }
              return "";
            }
            return l;
          })
          .where((dynamic l) => l.replaceAll("\n", "").trim().isNotEmpty)
          .join("\n");
      if (date != null || body != '') {
        result.add({'date': date, 'body': body, 'expand': false});
      }
    }
    return result.reversed.toList();
  }

  void copyLogs() async {
    await Clipboard.setData(ClipboardData(text: fileContent));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('复制成功')),
      );
    }
  }

  void feedback() {
    launchUrl(
      Uri.parse('https://github.com/guozhigq/pilipala/issues'),
      // 系统自带浏览器打开
      mode: LaunchMode.externalApplication,
    );
  }

  void clearLogsHandle() async {
    if (await clearLogs()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已清空')),
        );
        logsContent = [];
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text('日志', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String type) {
              // 处理菜单项选择的逻辑
              switch (type) {
                case 'copy':
                  copyLogs();
                  break;
                case 'feedback':
                  feedback();
                  break;
                case 'clear':
                  clearLogsHandle();
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'copy',
                child: Text('复制日志'),
              ),
              const PopupMenuItem<String>(
                value: 'feedback',
                child: Text('错误反馈'),
              ),
              const PopupMenuItem<String>(
                value: 'clear',
                child: Text('清空日志'),
              ),
            ],
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: logsContent.isNotEmpty
          ? ListView.builder(
              itemCount: logsContent.length,
              itemBuilder: (context, index) {
                final log = logsContent[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            log['date'].toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: log['body']),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '已将 ${log['date'].toString()} 复制至剪贴板',
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.copy_outlined, size: 16),
                          label: const Text('复制'),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 1,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SelectableText(log['body']),
                        ),
                      ),
                    ),
                    const Divider(indent: 12, endIndent: 12),
                  ],
                );
              },
            )
          : const CustomScrollView(
              slivers: <Widget>[
                NoData(),
              ],
            ),
    );
  }
}
