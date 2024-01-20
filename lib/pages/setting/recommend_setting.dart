import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/common/rcmd_type.dart';
import 'package:pilipala/pages/setting/widgets/select_dialog.dart';
import 'package:pilipala/utils/recommend_filter.dart';
import 'package:pilipala/utils/storage.dart';

import 'widgets/switch_item.dart';

class RecommendSetting extends StatefulWidget {
  const RecommendSetting({super.key});

  @override
  State<RecommendSetting> createState() => _RecommendSettingState();
}

class _RecommendSettingState extends State<RecommendSetting> {
  Box setting = GStrorage.setting;
  static Box localCache = GStrorage.localCache;
  late dynamic defaultRcmdType;
  Box userInfoCache = GStrorage.userInfo;
  late dynamic userInfo;
  bool userLogin = false;
  late dynamic accessKeyInfo;
  // late int filterUnfollowedRatio;
  late int minDurationForRcmd;
  late int minLikeRatioForRecommend;

  @override
  void initState() {
    super.initState();
    // 首页默认推荐类型
    defaultRcmdType =
        setting.get(SettingBoxKey.defaultRcmdType, defaultValue: 'web');
    userInfo = userInfoCache.get('userInfoCache');
    userLogin = userInfo != null;
    accessKeyInfo = localCache.get(LocalCacheKey.accessKey, defaultValue: null);
    // filterUnfollowedRatio = setting
    //     .get(SettingBoxKey.filterUnfollowedRatio, defaultValue: 0);
    minDurationForRcmd =
        setting.get(SettingBoxKey.minDurationForRcmd, defaultValue: 0);
    minLikeRatioForRecommend =
        setting.get(SettingBoxKey.minLikeRatioForRecommend, defaultValue: 0);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.titleMedium!;
    TextStyle subTitleStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          '推荐设置',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            dense: false,
            title: Text('首页推荐类型', style: titleStyle),
            subtitle: Text(
              '当前使用「$defaultRcmdType端」推荐¹',
              style: subTitleStyle,
            ),
            onTap: () async {
              String? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<String>(
                    title: '推荐类型',
                    value: defaultRcmdType,
                    values: RcmdType.values.map((e) {
                      return {'title': e.labels, 'value': e.values};
                    }).toList(),
                  );
                },
              );
              if (result != null) {
                if (result == 'app') {
                  // app端推荐需要access_key
                  if (accessKeyInfo == null) {
                    if (!userLogin) {
                      SmartDialog.showToast('请先登录');
                      return;
                    }
                    // 显示一个确认框，告知用户可能会导致账号被风控
                    SmartDialog.show(
                        animationType: SmartAnimationType.centerFade_otherSlide,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('提示'),
                            content: const Text(
                                '使用app端推荐需获取access_key，有小概率触发风控导致账号退出（在官方版本app重新登录即可解除），是否继续？'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  result = null;
                                  SmartDialog.dismiss();
                                },
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SmartDialog.dismiss();
                                  await MemberHttp.cookieToKey();
                                },
                                child: const Text('确定'),
                              ),
                            ],
                          );
                        });
                  }
                }
                if (result != null) {
                  defaultRcmdType = result;
                  setting.put(SettingBoxKey.defaultRcmdType, result);
                  SmartDialog.showToast('下次启动时生效');
                  setState(() {});
                }
              }
            },
          ),
          const SetSwitchItem(
            title: '推荐动态',
            subTitle: '是否在推荐内容中展示动态(仅app端)',
            setKey: SettingBoxKey.enableRcmdDynamic,
            defaultVal: true,
          ),
          const SetSwitchItem(
            title: '首页推荐刷新',
            subTitle: '下拉刷新时保留上次内容',
            setKey: SettingBoxKey.enableSaveLastData,
            defaultVal: false,
          ),
          // 分割线
          const Divider(height: 1),
          ListTile(
            dense: false,
            title: Text('点赞率过滤', style: titleStyle),
            subtitle: Text(
              '过滤掉点赞数/播放量「小于$minLikeRatioForRecommend%」的推荐视频(仅web端)',
              style: subTitleStyle,
            ),
            onTap: () async {
              int? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<int>(
                      title: '选择点赞率（0即不过滤）',
                      value: minLikeRatioForRecommend,
                      values: [0, 1, 2, 3, 4].map((e) {
                        return {'title': '$e %', 'value': e};
                      }).toList());
                },
              );
              if (result != null) {
                minLikeRatioForRecommend = result;
                setting.put(SettingBoxKey.minLikeRatioForRecommend, result);
                RecommendFilter.update();
                setState(() {});
              }
            },
          ),
          ListTile(
            dense: false,
            title: Text('视频时长过滤', style: titleStyle),
            subtitle: Text(
              '过滤掉时长「小于$minDurationForRcmd秒」的推荐视频',
              style: subTitleStyle,
            ),
            onTap: () async {
              int? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<int>(
                      title: '选择时长（0即不过滤）',
                      value: minDurationForRcmd,
                      values: [0, 30, 60, 90, 120].map((e) {
                        return {'title': '$e 秒', 'value': e};
                      }).toList());
                },
              );
              if (result != null) {
                minDurationForRcmd = result;
                setting.put(SettingBoxKey.minDurationForRcmd, result);
                RecommendFilter.update();
                setState(() {});
              }
            },
          ),
          SetSwitchItem(
            title: '已关注Up豁免推荐过滤',
            subTitle: '推荐中已关注用户发布的内容不会被过滤',
            setKey: SettingBoxKey.exemptFilterForFollowed,
            defaultVal: true,
            callFn: (_) => {RecommendFilter.update},
          ),
          // ListTile(
          //   dense: false,
          //   title: Text('按比例过滤未关注Up', style: titleStyle),
          //   subtitle: Text(
          //     '滤除推荐中占比「$filterUnfollowedRatio%」的未关注用户发布的内容',
          //     style: subTitleStyle,
          //   ),
          //   onTap: () async {
          //     int? result = await showDialog(
          //       context: context,
          //       builder: (context) {
          //         return SelectDialog<int>(
          //             title: '选择滤除比例（0即不过滤）',
          //             value: filterUnfollowedRatio,
          //             values: [0, 16, 32, 48, 64].map((e) {
          //               return {'title': '$e %', 'value': e};
          //             }).toList());
          //       },
          //     );
          //     if (result != null) {
          //       filterUnfollowedRatio = result;
          //       setting.put(
          //           SettingBoxKey.filterUnfollowedRatio, result);
          //       RecommendFilter.update();
          //       setState(() {});
          //     }
          //   },
          // ),
          SetSwitchItem(
            title: '过滤器也应用于相关视频',
            subTitle: '视频详情页的相关视频也进行过滤²',
            setKey: SettingBoxKey.applyFilterToRelatedVideos,
            defaultVal: true,
            callFn: (_) => {RecommendFilter.update},
          ),
          ListTile(
            dense: true,
            subtitle: Text(
              '¹ 若默认web端推荐不太符合预期，可尝试切换至app端。\n'
              '¹ 选择“模拟未登录(notLogin)”，将以空的key请求推荐接口，但播放页仍会携带用户信息，保证账号能正常记录进度、点赞投币等。\n\n'
              '² 由于接口未提供关注信息，无法豁免相关视频中的已关注Up。\n\n'
              '* 其它（如热门视频、手动搜索、链接跳转等）均不受过滤器影响。\n'
              '* 设定较严苛的条件可导致推荐项数锐减或多次请求，请酌情选择。\n'
              '* 后续可能会增加更多过滤条件，敬请期待。',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme.of(context).colorScheme.outline.withOpacity(0.7)),
            ),
          )
        ],
      ),
    );
  }
}
