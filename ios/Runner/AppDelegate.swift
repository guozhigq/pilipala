import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // 设置音频会话类别，确保在静音模式下播放音频
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, options: [.duckOthers])
    } catch {
      print("Failed to set audio session category: \(error)")
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}