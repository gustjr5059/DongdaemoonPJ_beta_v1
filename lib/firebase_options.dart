// Firebase 초기화 코드(Firebase와 Flutter 프로젝트가 통합되어 Firebase 서비스를 사용 가능)
// 이 파일은 FlutterFire CLI에 의해 생성되었습니다. FlutterFire CLI는 Flutter 애플리케이션과 Firebase 서비스를 연동하는데 사용되는 도구입니다.
// 이 코드는 Firebase 서비스를 애플리케이션에 통합하고 초기화하는 데 필요한 설정을 포함합니다.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
// 위 지시어는 Dart 분석기에게 특정 경고나 규칙을 무시하도록 지시합니다. 여기서는 80자를 초과하는 줄과
// 정적 멤버만을 포함하는 클래스에 대한 경고를 무시하도록 설정되어 있습니다.

// Firebase 핵심 기능을 위한 FirebaseOptions 클래스를 임포트합니다.
// FirebaseOptions 클래스는 Firebase 프로젝트의 구성 정보를 담고 있어, Firebase 서비스를 사용할 때 필요한 설정을 제공합니다.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

// Flutter의 기본 플랫폼 라이브러리에서 필요한 요소들을 임포트합니다.
// defaultTargetPlatform은 현재 애플리케이션이 실행되고 있는 플랫폼을 알려줍니다.
// kIsWeb은 애플리케이션이 웹 플랫폼에서 실행되고 있는지 여부를 확인하는 상수입니다.
// TargetPlatform은 각기 다른 플랫폼(예: iOS, Android)을 구분하는 데 사용되는 열거형(enum)입니다.
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAw65cPowqU4lMrzb6Rl1cz_GYiuiDzTZw', // GoogleService-Info.plist의 API_KEY
    appId: '1:749619968982:ios:4aedade48e4a0e75ca8277', // GoogleService-Info.plist의 GOOGLE_APP_ID
    messagingSenderId: '749619968982', // GoogleService-Info.plist의 GCM_SENDER_ID
    projectId: 'wearcanopj', // GoogleService-Info.plist의 PROJECT_ID
    storageBucket: 'wearcanopj.appspot.com', // GoogleService-Info.plist의 STORAGE_BUCKET
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDU82dmhQYtksb8nH5252NURtumoc3gU1g', // google-services.json의 current_key
    appId: '1:749619968982:android:fdcf1ef35523df5dca8277', // google-services.json의 mobilesdk_app_id
    messagingSenderId: '749619968982', // google-services.json의 project_number
    projectId: 'wearcanopj', // google-services.json의 project_id
    storageBucket: 'wearcanopj.appspot.com', // google-services.json의 storage_bucket
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAw65cPowqU4lMrzb6Rl1cz_GYiuiDzTZw', // GoogleService-Info.plist의 API_KEY
    appId: '1:749619968982:ios:4aedade48e4a0e75ca8277', // GoogleService-Info.plist의 GOOGLE_APP_ID
    messagingSenderId: '749619968982', // GoogleService-Info.plist의 GCM_SENDER_ID
    projectId: 'wearcanopj', // GoogleService-Info.plist의 PROJECT_ID
    storageBucket: 'wearcanopj.appspot.com', // GoogleService-Info.plist의 STORAGE_BUCKET
    iosBundleId: 'com.gshe.wearcano', // GoogleService-Info.plist의 BUNDLE_ID
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAw65cPowqU4lMrzb6Rl1cz_GYiuiDzTZw', // GoogleService-Info.plist의 API_KEY
    appId: '1:749619968982:ios:4aedade48e4a0e75ca8277', // GoogleService-Info.plist의 GOOGLE_APP_ID
    messagingSenderId: '749619968982', // GoogleService-Info.plist의 GCM_SENDER_ID
    projectId: 'wearcanopj', // GoogleService-Info.plist의 PROJECT_ID
    storageBucket: 'wearcanopj.appspot.com', // GoogleService-Info.plist의 STORAGE_BUCKET
    iosBundleId: 'com.gshe.wearcano', // GoogleService-Info.plist의 BUNDLE_ID
  );
}
