// 首页推荐类型
enum RcmdType { web, app }

extension RcmdTypeExtension on RcmdType {
  String get values => ['web', 'app'][index];
  String get labels => ['web端', 'app端'][index];
}
