import UIKit
import Flutter
import KakaoSDKCommon
import KakaoSDKAuth
import NaverThirdPartyLogin // 네이버 로그인 설정


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

//        // 네이버 로그인 초기화 코드 (NaverThirdPartyLoginConnection)
//        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
//        instance?.isNaverAppOauthEnable = true  // 네이버 앱으로 인증 가능 여부
//        instance?.isInAppOauthEnable = true     // SafariViewController 인증 여부
//        instance?.delegate = self               // delegate 설정
//
//     // 환경 변수에서 API 키 로드
//     if let path = Bundle.main.path(forResource: "config", ofType: "json") {
//         do {
//             let data = try Data(contentsOf: URL(fileURLWithPath: path))
//             if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                let kakaoApiKey = json["kakao_api_key"] as? String {
//                 KakaoSDK.initSDK(appKey: kakaoApiKey)
//             }
//         } catch {
//             print("Failed to load Kakao API key from config.json")
//         }
//     } else {
//         print("config.json file not found")
//     }
//
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }

//   override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//     if (AuthApi.isKakaoTalkLoginUrl(url)) {
//       return AuthController.handleOpenUrl(url: url)
//     }
//     return super.application(app, open: url, options: options)
//   }

  // 네이버 로그인 설정 부분 시작
//     // iOS 9 이상부터 URL 스킴으로 돌아왔을 때 처리
//     override func application(
//       _ app: UIApplication,
//       open url: URL,
//       options: [UIApplication.OpenURLOptionsKey : Any] = [:]
//     ) -> Bool {
//
//       // 카카오톡
//       if (AuthApi.isKakaoTalkLoginUrl(url)) {
//         return AuthController.handleOpenUrl(url: url)
//       }
//       // 네이버
//       else if url.absoluteString.contains("thirdPartyLoginResult") {
//         NaverThirdPartyLoginConnection.getSharedInstance()?.receiveAccessToken(url)
//         return true
//       }
//
//       return super.application(app, open: url, options: options)
//     }
// }

    print("앱이 시작되었습니다. GeneratedPluginRegistrant.register 호출 전")

    // 네이버 로그인 초기화 코드
    let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    instance?.isNaverAppOauthEnable = true  // 네이버 앱으로 인증 가능 여부
    instance?.isInAppOauthEnable = false     // SafariViewController 인증 여부
    instance?.delegate = self               // delegate 설정

    // GeneratedPluginRegistrant 등록 호출
    GeneratedPluginRegistrant.register(with: self)

    print("GeneratedPluginRegistrant.register 호출 완료")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    print("application(_:open:options:) 호출됨, URL: \(url.absoluteString)")

    // 네이버 인증 후 돌아오는 URL 처리
    if url.absoluteString.contains("thirdPartyLoginResult") {
      print("네이버 로그인 URL 처리 중")
      NaverThirdPartyLoginConnection.getSharedInstance()?.receiveAccessToken(url)
      return true
    }

    return super.application(app, open: url, options: options)
  }
}

// 네이버 로그인 delegate
extension AppDelegate: NaverThirdPartyLoginConnectionDelegate {
    public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공: 액세스 토큰 발급")
    }

    public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 로그인 성공: 리프레시 토큰 발급")
    }

    public func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그아웃 성공")
    }

    public func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("네이버 로그인 오류 발생: \(error.localizedDescription)")
    }
}
  // 네이버 로그인 설정 부분 끝
