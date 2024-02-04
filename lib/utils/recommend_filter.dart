import 'dart:math';

import 'storage.dart';

class RecommendFilter {
  // static late int filterUnfollowedRatio;
  static late int minDurationForRcmd;
  static late int minLikeRatioForRecommend;
  static late bool exemptFilterForFollowed;
  static late bool applyFilterToRelatedVideos;
  RecommendFilter() {
    update();
  }

  static void update() {
    var setting = GStrorage.setting;
    // filterUnfollowedRatio =
    //     setting.get(SettingBoxKey.filterUnfollowedRatio, defaultValue: 0);
    minDurationForRcmd =
        setting.get(SettingBoxKey.minDurationForRcmd, defaultValue: 0);
    minLikeRatioForRecommend =
        setting.get(SettingBoxKey.minLikeRatioForRecommend, defaultValue: 0);
    exemptFilterForFollowed =
        setting.get(SettingBoxKey.exemptFilterForFollowed, defaultValue: true);
    applyFilterToRelatedVideos = setting
        .get(SettingBoxKey.applyFilterToRelatedVideos, defaultValue: true);
  }

  static bool filter(dynamic videoItem, {bool relatedVideos = false}) {
    if (relatedVideos && !applyFilterToRelatedVideos) {
      return false;
    }
    //由于相关视频中没有已关注标签，只能视为非关注视频
    if (!relatedVideos &&
        videoItem.isFollowed == 1 &&
        exemptFilterForFollowed) {
      return false;
    }
    if (videoItem.duration > 0 && videoItem.duration < minDurationForRcmd) {
      return true;
    }
    if (videoItem.stat.view is int &&
        videoItem.stat.view > -1 &&
        videoItem.stat.like is int &&
        videoItem.stat.like > -1 &&
        videoItem.stat.like * 100 <
            minLikeRatioForRecommend * videoItem.stat.view) {
      return true;
    }
    return false;
  }
}
