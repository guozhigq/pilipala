import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../http/reply.dart';
import '../../models/video/reply/emote.dart';

class EmotePanelController extends GetxController
    with GetTickerProviderStateMixin {
  late List<PackageItem> emotePackage;
  late TabController tabController;

  Future getEmote() async {
    var res = await ReplyHttp.getEmoteList(business: 'reply');
    if (res['status']) {
      emotePackage = res['data'].packages;
      tabController = TabController(length: emotePackage.length, vsync: this);
    }
    return res;
  }
}
