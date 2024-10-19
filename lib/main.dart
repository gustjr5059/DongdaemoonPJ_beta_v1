// Firebase 코어 관련 기능을 사용하기 위해 필요한 Firebase Core 패키지를 임포트합니다.
// 이 패키지는 Firebase 서비스를 Flutter 애플리케이션에 연동하고 초기화하는데 사용됩니다.
// Firebase 서비스에는 인증, 데이터베이스, 분석 등 다양한 기능이 포함되어 있으며,
// 이를 사용하기 위해서는 초기화 과정이 필수적입니다.
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase 코어 관련 패키지
import 'package:firebase_messaging/firebase_messaging.dart';
// iOS 스타일의 인터페이스 요소를 사용하기 위해 Cupertino 디자인 패키지를 임포트합니다.
// 이 패키지는 iOS 사용자에게 친숙한 디자인 요소와 애니메이션을 제공하여 iOS 사용자 경험을 향상시킵니다.
import 'package:flutter/cupertino.dart'; // iOS 스타일 위젯 관련 패키지
// Flutter의 UI 구성 요소를 제공하는 Material 디자인 패키지를 임포트합니다.
// 이 패키지는 다양한 머티리얼 디자인 위젯을 포함하여 사용자 인터페이스를 효과적으로 구성할 수 있도록 도와줍니다.
import 'package:flutter/material.dart'; // Material 디자인 위젯 관련 패키지
import 'package:flutter_app_badger/flutter_app_badger.dart';
// 상태 관리를 위한 현대적인 라이브러리인 Riverpod를 임포트합니다.
// Riverpod는 애플리케이션의 상태를 효과적으로 관리하고, 상태 변화에 따라 UI를 자동으로 업데이트합니다.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 상태 관리 라이브러리 Riverpod 관련 패키지
// 애플리케이션의 초기 스크린을 정의하는 스플래시 스크린 뷰 파일을 임포트합니다.
// 이 스크린은 앱이 로딩되는 동안 사용자에게 보여지며, 첫 인상을 형성하는 중요한 역할을 합니다.
import 'common/view/splash1_error_screen.dart';
import 'common/view/splash1_screen.dart';

// Firebase 초기 설정 파일을 임포트합니다.
// 이 파일은 FlutterFire CLI 도구를 사용하여 생성되며, Firebase 프로젝트의 구성 정보를 포함하고 있습니다.
// Firebase 서비스를 사용하기 위한 필수적인 API 키, 프로젝트 ID 등의 정보가 이 파일에 정의되어 있습니다.
import 'firebase_options.dart';
import 'message/view/message_screen.dart'; // Firebase 초기 설정 관련 패키지 (firebase_cli를 통해 생성된 파일)

// Firebase 초기화 코드
// (Firebase와 Flutter 프로젝트를 연동하여 Firebase 서비스를 사용할 수 있게 함)
// Firebase와 Flutter 프로젝트가 통합되어 Firebase 서비스를 사용가능)
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Flutter 엔진이 초기화되기 전에 실행되어야 하는 코드를 위한 메서드
  // Firebase 초기화
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // 현재 플랫폼에 맞는 Firebase 초기 설정 적용
  );
  runApp(
    ProviderScope(
      // 앱 전체에 걸쳐 Riverpod 상태 관리를 가능하게 하는 최상위 위젯
      child: MyApp(),
    ),
  );
}

// ------ 앱 실행할 때 필요한 메인 실행 역할인 MyApp 클래스 내용 시작
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirebaseConnected = true; // Firebase 연결 상태 변수
  StreamSubscription? _networkSubscription; // 네트워크 상태 구독자
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Firebase Messaging 인스턴스 생성


  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection(); // Firebase 연결 상태 확인
    _monitorNetworkStatus(); // 네트워크 상태 실시간 감지
    _initializeFCM(); // Firebase Messaging(Firebase Cloud Messaging) 초기화
  }

  @override
  void dispose() {
    _networkSubscription?.cancel(); // 네트워크 상태 구독 해제
    super.dispose();
  }

  // Firebase 연결 상태를 확인하는 함수
  Future<void> _checkFirebaseConnection() async {
    try {
      // Firebase 연결 확인 (Firebase 기본 서비스 확인)
      await Firebase.initializeApp(); // Firebase 초기화
      setState(() {
        _isFirebaseConnected = true; // 연결 성공 시 상태 업데이트
      });
    } catch (e) {
      setState(() {
        _isFirebaseConnected = false; // 연결 실패 시 상태 업데이트
      });
    }
  }

  // 네트워크 상태를 실시간으로 모니터링하는 함수
  void _monitorNetworkStatus() {
    _networkSubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      for (var result in results) {
        if (result == ConnectivityResult.none) {
          setState(() {
            _isFirebaseConnected = false; // 네트워크 연결이 끊기면 상태 업데이트
          });
        } else {
          _checkFirebaseConnection(); // 네트워크가 다시 연결되면 Firebase 연결 상태 확인
        }
      }
    });
  }

  // // Firebase Messaging 초기화 및 푸시 알림 설정
  // void _initializeFCM() {
  //   _firebaseMessaging.requestPermission(); // 푸시 알림 권한 요청
  //   _firebaseMessaging.getToken().then((token) {
  //     print('FCM Token: $token'); // Firebase Cloud Messaging 토큰 출력
  //     saveFcmToken(token); // FCM 토큰을 Firestore 등에 저장하는 로직
  //   });
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('FCM 메시지 수신: ${message.notification?.title}'); // 알림 메시지 수신 시 처리
  //     showAlertDialog(context, message.notification?.title, message.notification?.body); // 알림 수신 시 다이얼로그 표시
  //   });
  //
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('알림 클릭 후 앱 실행: ${message.data}');
  //     Navigator.pushNamed(context, '/PrivateMessageMainScreen'); // 알림 클릭 시 쪽지 화면으로 이동
  //   });
  // }

  // Android 배지 숫자 설정 함수
  Future<void> _setAndroidBadgeCount(int badgeCount) async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.updateBadgeCount(badgeCount);
    }
  }

  // Android 배지 숫자 초기화 함수
  Future<void> _resetAndroidBadgeCount() async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.removeBadge();
    }
  }


  // Firebase Messaging 초기화 및 푸시 알림 설정
  void _initializeFCM() async {
    // 푸시 알림 권한 요청
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true, // 경고(alert)를 허용
      announcement: false, // 공지(announcement)는 허용하지 않음
      badge: true, // 배지를 허용
      carPlay: false, // CarPlay에서는 푸시 알림을 받지 않음
      criticalAlert: false, // 중요 알림(critical alert)은 허용하지 않음
      provisional: false, // 비공식 권한(provisional)을 허용하지 않음
      sound: true, // 소리(sound)를 허용
    );

    // FCM 자동 초기화 활성화
    FirebaseMessaging.instance.setAutoInitEnabled(true);

    // 사용자가 권한을 승인했을 때만 푸시 알림 설정 진행
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // APNS 토큰 요청
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        print('APNS Token: $apnsToken'); // APNS 토큰 출력
      } else {
        print('APNS Token is null. Please check APNS configuration.');
      }

      // FCM 토큰 요청
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print('FCM Token: $token'); // FCM 토큰 출력
        saveFcmToken(token); // FCM 토큰을 Firestore에 저장하는 함수 호출
      } else {
        print('Failed to get FCM Token');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print('User declined or has not accepted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    }

    // 안드로이드 관련 배지 업데이트 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("FCM 메시지 수신: ${message.notification?.title}");
      // 읽지 않은 메시지 갯수 동기화 (Android)
      int unreadCount = await _getUnreadMessagesCount();
      _setAndroidBadgeCount(unreadCount); // Android 배지 업데이트
    });

    // 알림 클릭 시 처리
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final messageId = message.data['messageId'];
      final recipientId = message.data['recipientId'];

      // 메시지를 읽음 상태로 업데이트
      markMessageAsRead(messageId, recipientId);

      // 배지 숫자 초기화 (Android)
      _resetAndroidBadgeCount();

      // 쪽지 화면으로 이동
      Navigator.pushNamed(context, '/PrivateMessageMainScreen', arguments: {
        'messageId': messageId,
        'recipientId': recipientId,
      });
    });
  }

  // 안드로이드 읽지 않은 메세지 처리 로직
  Future<int> _getUnreadMessagesCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final unreadMessages = await FirebaseFirestore.instance
        .collection('message_list')
        .doc(user.email)
        .collection('message')
        .where('read', isEqualTo: false)
        .get();

    return unreadMessages.size;
  }

  // Firestore에 FCM 토큰 저장하는 함수 (구현 필요)
  void saveFcmToken(String? token) async {
    if (token == null) return;

    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.email);

    // 기존에 저장된 FCM 토큰 배열을 가져옴
    final docSnapshot = await userDoc.get();
    List<String> tokens = (docSnapshot.data()?['fcmTokens'] as List<dynamic>?)?.cast<String>() ?? [];

    // 중복된 토큰이 아니면 배열에 추가
    if (!tokens.contains(token)) {
      tokens.add(token);
      await userDoc.update({
        'fcmTokens': tokens, // 토큰 업데이트
      }).catchError((error) {
        print('Firestore 업데이트 중 오류 발생: $error');
      });
    }
  }

  // Firebase Firestore에서 메시지를 읽음 상태로 업데이트하는 함수
  Future<void> markMessageAsRead(String messageId, String recipientId) async {
    final messageRef = FirebaseFirestore.instance
        .collection('message_list')
        .doc(recipientId)
        .collection('message')
        .doc(messageId);

    await messageRef.update({
      'read': true,
    });
  }

  // 알림 메시지 수신 시 다이얼로그를 표시하는 함수
  void showAlertDialog(BuildContext context, String? title, String? body) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? '알림'),
        content: Text(body ?? '새로운 메시지가 도착했습니다.'),
        actions: [
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // 화면에 debug 리본형식이 나오는 것 비활성화하는 설정
//       // Firebase가 연결되어 있으면 SplashScreen1()을 홈 화면으로 설정
//       // Firebase가 연결되지 않았거나 네트워크가 끊긴 경우 SplashErrorScreen1()을 홈 화면으로 설정
//       home: _isFirebaseConnected ? SplashScreen1() : SplashErrorScreen1(),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨김
      initialRoute: '/', // 앱의 초기 경로 설정
      routes: {
        '/': (context) => _isFirebaseConnected ? SplashScreen1() : SplashErrorScreen1(), // Firebase 연결 상태에 따라 화면 전환
        '/PrivateMessageMainScreen': (context) => PrivateMessageMainScreen(), // 푸시 알림 클릭 시 쪽지 화면으로 이동
      },
    );
  }
}

// ------ 앱 실행할 때 필요한 메인 실행 역할인 MyApp 클래스 내용 끝
