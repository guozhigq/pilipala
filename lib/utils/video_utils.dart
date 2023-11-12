import 'package:pilipala/models/video/play/url.dart';

class VideoUtils {
  static String getCdnUrl(dynamic item) {
    var backupUrl = "";
    var videoUrl = "";

    /// 先获取backupUrl 一般是upgcxcode地址 播放更稳定
    if (item is VideoItem) {
      backupUrl = item.backupUrl ?? "";
      videoUrl = backupUrl.contains("http") ? backupUrl : (item.baseUrl ?? "");
    } else if (item is AudioItem) {
      backupUrl = item.backupUrl ?? "";
      videoUrl = backupUrl.contains("http") ? backupUrl : (item.baseUrl ?? "");
    } else {
      return "";
    }

    /// issues #70
    if (videoUrl.contains(".mcdn.bilivideo") ||
        videoUrl.contains("/upgcxcode/")) {
      //CDN列表
      var cdnList = {
        'ali': 'upos-sz-mirrorali.bilivideo.com',
        'cos': 'upos-sz-mirrorcos.bilivideo.com',
        'hw': 'upos-sz-mirrorhw.bilivideo.com',
      };
      //取一个CDN
      var cdn = cdnList['ali'] ?? "";
      var reg = RegExp(r'(http|https)://(.*?)/upgcxcode/');
      videoUrl = videoUrl.replaceAll(reg, "https://$cdn/upgcxcode/");
    }

    return videoUrl;
  }
}
