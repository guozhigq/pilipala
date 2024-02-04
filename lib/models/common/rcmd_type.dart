// 首页推荐类型
enum RcmdType { web, app, notLogin }

extension RcmdTypeExtension on RcmdType {
  String get values => ['web', 'app', 'notLogin'][index];
  String get labels => ['web端', 'app端', '游客模式'][index];
}
