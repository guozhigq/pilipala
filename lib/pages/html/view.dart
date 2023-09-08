import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/html_render.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';

import 'controller.dart';

class HtmlRenderPage extends StatefulWidget {
  const HtmlRenderPage({super.key});

  @override
  State<HtmlRenderPage> createState() => _HtmlRenderPageState();
}

class _HtmlRenderPageState extends State<HtmlRenderPage> {
  HtmlRenderController htmlRenderCtr = Get.put(HtmlRenderController());
  late String title;
  late String id;

  @override
  void initState() {
    super.initState();
    title = Get.parameters['title']!;
    id = Get.parameters['id']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: htmlRenderCtr.reqHtml(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var data = snapshot.data;
                  if (data['status']) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                          child: Row(
                            children: [
                              NetworkImgLayer(
                                width: 40,
                                height: 40,
                                type: 'avatar',
                                src: htmlRenderCtr.response['avatar']!,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(htmlRenderCtr.response['uname'],
                                      style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .fontSize,
                                      )),
                                  Text(
                                    htmlRenderCtr.response['updateTime'],
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .fontSize,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                          child: HtmlRender(
                            htmlContent: htmlRenderCtr.response['content'],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 8,
                                color: Theme.of(context)
                                    .dividerColor
                                    .withOpacity(0.05),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text('error');
                  }
                } else {
                  // 骨架屏
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
