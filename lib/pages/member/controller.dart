import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/member/archive.dart';
import 'package:pilipala/models/member/info.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/wbi_sign.dart';

class MemberController extends GetxController {
  late int mid;
  Rx<MemberInfoModel> memberInfo = MemberInfoModel().obs;
  Map? userStat;
  String? face;
  String? heroTag;
  Box user = GStrorage.user;
  late int ownerMid;
  // 投稿列表
  RxList<VListItemModel>? archiveList = [VListItemModel()].obs;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    ownerMid = user.get(UserBoxKey.userMid) ?? -1;
    face = Get.arguments['face'] ?? '';
    heroTag = Get.arguments['heroTag'] ?? '';
  }

  // 获取用户信息
  Future<Map<String, dynamic>> getInfo() async {
    await getMemberStat();
    var res = await MemberHttp.memberInfo(mid: mid);
    if (res['status']) {
      memberInfo.value = res['data'];
    }
    return res;
  }

  // 获取用户状态
  Future<Map<String, dynamic>> getMemberStat() async {
    var res = await MemberHttp.memberStat(mid: mid);
    if (res['status']) {
      userStat = res['data'];
    }
    return res;
  }

  Future getMemberCardInfo() async {
    var res = await MemberHttp.memberCardInfo(mid: mid);
    if (res['status']) {
      print(userStat);
    }
    return res;
  }
}
