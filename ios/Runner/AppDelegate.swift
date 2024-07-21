import UIKit
import Flutter
import KakaoSDKCommon
import KakaoSDKAuth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 환경 변수에서 API 키 로드
    if let path = Bundle.main.path(forResource: "config", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let kakaoApiKey = json["kakao_api_key"] as? String {
                KakaoSDK.initSDK(appKey: kakaoApiKey)
            }
        } catch {
            print("Failed to load Kakao API key from config.json")
        }
    } else {
        print("config.json file not found")
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if (AuthApi.isKakaoTalkLoginUrl(url)) {
      return AuthController.handleOpenUrl(url: url)
    }
    return super.application(app, open: url, options: options)
  }
}
