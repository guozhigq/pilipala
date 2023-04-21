class Api {
  // 推荐视频
  static const String recommendList = '/x/web-interface/index/top/feed/rcmd';
  // 热门视频
  static const String hotList = '/x/web-interface/popular';
  // 视频详情
  // 竖屏 https://api.bilibili.com/x/web-interface/view?aid=527403921
  static const String videoIntro = '/x/web-interface/view';

  // 视频详情页 相关视频
  static const String relatedList = '/x/web-interface/archive/related';

  // 用户(被)关注数、投稿数
  // https://api.bilibili.com/x/relation/stat?vmid=697166795
  static const String userStat = '/x/relation/stat';

  // 评论列表
  static const String replyList = '/x/v2/reply';
}
