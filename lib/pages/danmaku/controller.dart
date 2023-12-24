import 'package:pilipala/http/danmaku.dart';
import 'package:pilipala/models/danmaku/dm.pb.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

class PlDanmakuController {
  PlDanmakuController(this.cid);
  final int cid;
  Map<int,List<DanmakuElem>> dmSegMap = {};
  // 已请求的段落标记
  List<bool> requestedSeg = [];

  bool get initiated => requestedSeg.isNotEmpty;

  static int SEGMENT_LENGTH = 60 * 6 * 1000;

  void initiate(int videoDuration, int progress) {
    if (requestedSeg.isEmpty) {
      int segCount = (videoDuration / SEGMENT_LENGTH).ceil();
      requestedSeg = List<bool>.generate(segCount, (index) => false);
    }
    queryDanmaku(
        calcSegment(progress)
    );
  }

  void dispose() {
    dmSegMap.clear();
    requestedSeg.clear();
  }

  int calcSegment(int progress) {
    return progress ~/ SEGMENT_LENGTH;
  }

  void queryDanmaku(int segmentIndex) async {
    assert(requestedSeg[segmentIndex] == false);
    requestedSeg[segmentIndex] = true;
    DmSegMobileReply result =
        await DanmakaHttp.queryDanmaku(cid: cid, segmentIndex: segmentIndex + 1);
    if (result.elems.isNotEmpty) {
      for (var element in result.elems) {
        int pos = element.progress ~/ 100;//每0.1秒存储一次
        if (dmSegMap[pos] == null) {
          dmSegMap[pos] = [];
        }
        dmSegMap[pos]!.add(element);
      }
    }
  }

  List<DanmakuElem>? getCurrentDanmaku(int progress) {
    int segmentIndex = calcSegment(progress);
    if (!requestedSeg[segmentIndex]) {
      queryDanmaku(segmentIndex);
    }
    return dmSegMap[progress ~/ 100];
  }
}
