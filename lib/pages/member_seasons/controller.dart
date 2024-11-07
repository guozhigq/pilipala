import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/member/seasons.dart';

class MemberSeasonsController extends GetxController {
  final ScrollController scrollController = ScrollController();
  late int mid;
  int? seasonId;
  int? seriesId;
  late String category;
  int pn = 1;
  int ps = 30;
  int count = 0;
  RxList<MemberArchiveItem> seasonsList = <MemberArchiveItem>[].obs;
  late Map page;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    category = Get.parameters['category']!;
    if (category == '0') {
      seasonId = int.parse(Get.parameters['seasonId']!);
    }
    if (category == '1') {
      seriesId = int.tryParse(Get.parameters['seriesId']!);
      seasonId = int.tryParse(Get.parameters['seasonId']!);
    }
  }

  // 获取专栏详情 0: 专栏 1: 系列
  Future getSeasonDetail(type) async {
    if (type == 'onRefresh') {
      pn = 1;
    }
    var res = await MemberHttp.getSeasonDetail(
      mid: mid,
      seasonId: seasonId!,
      pn: pn,
      ps: ps,
      sortReverse: false,
    );
    if (res['status']) {
      seasonsList.addAll(res['data'].archives);
      page = res['data'].page;
      pn += 1;
    }
    return res;
  }

  // 获取系列详情 0: 专栏 1: 系列
  Future getSeriesDetail(type) async {
    if (type == 'onRefresh') {
      pn = 1;
    }
    var res = await MemberHttp.getSeriesDetail(
      mid: mid,
      seriesId: seriesId!,
      pn: pn,
      currentMid: 17340771,
    );
    if (res['status']) {
      seasonsList.addAll(res['data'].seriesList);
      page = res['data'].page;
      pn += 1;
    }
    return res;
  }

  // 上拉加载
  Future onLoad() async {
    if (category == '0') {
      getSeasonDetail('onLoad');
    }
    if (category == '1') {
      if (seasonId != null) {
        getSeasonDetail('onLoad');
      }
      if (seriesId != null) {
        getSeriesDetail('onLoad');
      }
    }
  }

  // 下拉刷新
  Future onRefresh() async {
    if (category == '0') {
      return getSeasonDetail('onRefresh');
    }
    if (category == '1') {
      if (seasonId != null) {
        return getSeasonDetail('onRefresh');
      }
      if (seriesId != null) {
        return getSeriesDetail('onRefresh');
      }
    }
  }
}
