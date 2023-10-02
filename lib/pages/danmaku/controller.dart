import 'package:pilipala/http/danmaku.dart';
import 'package:pilipala/models/danmaku/dm.pb.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

class PlDanmakuController {
  PlDanmakuController(this.cid, this.playerController);
  final int cid;
  final PlPlayerController playerController;
  late Duration videoDuration;
  // 按 6min 分段
  int segCount = 0;
  List<DmSegMobileReply> dmSegList = [];
  int currentSegIndex = 1;
  int currentDmIndex = 0;

  void calcSegment() {
    dmSegList.clear();
    // 视频分段数
    segCount = (videoDuration.inSeconds / (60 * 6)).ceil();
    dmSegList = List<DmSegMobileReply>.generate(
        segCount < 1 ? 1 : segCount, (index) => DmSegMobileReply());
    // 当前分段
    try {
      currentSegIndex =
          (playerController.position.value.inSeconds / (60 * 6)).ceil();
      currentSegIndex = currentSegIndex < 1 ? 1 : currentSegIndex;
    } catch (_) {}
  }

  Future<List<DmSegMobileReply>> queryDanmaku() async {
    // dmSegList.clear();
    DmSegMobileReply result =
        await DanmakaHttp.queryDanmaku(cid: cid, segmentIndex: currentSegIndex);
    if (result.elems.isNotEmpty) {
      result.elems.sort((a, b) => (a.progress).compareTo(b.progress));
      // dmSegList.add(result);
      currentSegIndex = currentSegIndex < 1 ? 1 : currentSegIndex;
      dmSegList[currentSegIndex - 1] = result;
    }
    if (dmSegList.isNotEmpty) {
      findClosestPositionIndex(playerController.position.value.inMilliseconds);
    }
    return dmSegList;
  }

  /// 查询当前最接近的弹幕
  void findClosestPositionIndex(int position) {
    int segIndex = (position / (6 * 60 * 1000)).ceil() - 1;
    if (segIndex < 0) segIndex = 0;
    List elems = dmSegList[segIndex].elems;

    if (segIndex < dmSegList.length) {
      int left = 0;
      int right = elems.length;

      while (left < right) {
        int mid = (right + left) ~/ 2;
        var midPosition = elems[mid].progress;

        if (midPosition >= position) {
          right = mid;
        } else {
          left = mid + 1;
        }
      }

      currentSegIndex = segIndex;
      currentDmIndex = right;
    } else {
      currentSegIndex = segIndex;
      currentDmIndex = 0;
    }
  }
}
