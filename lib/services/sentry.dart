import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  static sentryInit(AppRunner appRunner) async {
    return await SentryFlutter.init(
      (options) => options
        ..dsn =
            'https://cb0ce70fcda1c903072a6c73cc2d89e2@o4506669621182464.ingest.sentry.io/4506669624459264'
        ..debug = true // 调试模式下启用
        ..attachThreads = true // 附带线程信息
        ..sendDefaultPii = true
        ..reportPackages = false // 禁用报告包信息
        ..tracesSampleRate = 0.1 // 要发送的事件百分比
        ..attachScreenshot = false // 屏幕截图
        ..attachViewHierarchy = true // 包含视图结构
        ..reportSilentFlutterErrors = true // 报告静默的 Flutter 错误
        ..enableAutoPerformanceTracing = true // 自动性能跟踪
        ..considerInAppFramesByDefault = false // 不考虑应用内帧
        ..enableWindowMetricBreadcrumbs = true // 启用窗口度量面包屑
        ..screenshotQuality = SentryScreenshotQuality.low // 屏幕截图质量
        ..maxRequestBodySize = MaxRequestBodySize.small // 请求体大小
        ..maxResponseBodySize = MaxResponseBodySize.small, // 响应体大小
      appRunner: appRunner,
    );
  }
}
