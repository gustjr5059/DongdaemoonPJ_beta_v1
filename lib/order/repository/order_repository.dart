import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'dart:ui' as ui;

import '../../common/api_key.dart';
import '../../product/model/product_model.dart'; // API 키 로드 함수가 포함된 파일을 임포트

// ------ 주소검색 기능 관련 데이터 처리 로직 내용 부분 시작
// KA 헤더를 생성하는 비동기 함수
Future<String> getKAHeader() async {
  String sdkVersion = '3.22.3'; // SDK 버전은 수동으로 입력합니다.
  String osVersion; // 운영체제 버전을 저장할 변수
  String device; // 기기명을 저장할 변수
  String appName; // 앱 이름을 저장할 변수
  String appVersion; // 앱 버전을 저장할 변수
  String lang = ui.window.locale.toLanguageTag(); // 시스템 언어 설정
  String origin = 'com.example.couturier'; // origin 필드 추가

  // 운영체제와 기기명 얻기
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    osVersion = 'ios-${iosInfo.systemVersion}'; // iOS 운영체제 버전
    device = iosInfo.utsname.machine; // iOS 기기명
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    osVersion = 'android-${androidInfo.version.release}'; // 안드로이드 운영체제 버전
    device = androidInfo.model; // 안드로이드 기기명
  } else {
    osVersion = 'unknown'; // 알 수 없는 운영체제 버전
    device = 'unknown'; // 알 수 없는 기기명
  }

  // 앱 이름과 버전 얻기
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appName = packageInfo.appName; // 앱 이름
  appVersion = packageInfo.version; // 앱 버전

  // KA 헤더 문자열 생성 및 반환
  return 'sdk/$sdkVersion os/$osVersion lang/$lang device/$device appName/$appName appVersion/$appVersion origin/$origin';
}
// ------ 주소검색 기능 관련 데이터 처리 로직 내용 부분 끝

// 발주 관련 화면의 레퍼지토리 클래스
class OrderRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스를 저장할 필드

  // 생성자에서 Firestore 인스턴스를 받아 초기화합니다.
  OrderRepository({required this.firestore});

  // 이메일을 이용해 사용자 정보를 가져오는 비동기 함수
  Future<Map<String, dynamic>?> getUserInfoByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get(); // Firestore에서 이메일로 사용자 정보 검색

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data() as Map<String,
            dynamic>?; // 사용자 정보 반환
      } else {
        return null; // 사용자 정보가 없을 경우 null 반환
      }
    } catch (e) {
      print('Error fetching user data: $e'); // 에러 발생 시 에러 메시지 출력
      return null; // 에러 발생 시 null 반환
    }
  }

  // ------ 주소검색 기능 관련 데이터 처리 로직 내용 부분 시작
  // 주소를 검색하는 비동기 함수
  Future<List<dynamic>> searchAddress(String query) async {
    try {
      if (query.isEmpty) {
        throw Exception('Query parameter is required.'); // 쿼리가 비어있을 경우 예외 발생
      }
      final apiKey = await loadApiKey(); // 환경 변수에서 API 키 로드
      final kaHeader = await getKAHeader(); // KA 헤더 얻기
      final encodedQuery = Uri.encodeComponent(query); // 쿼리 인코딩
      final url = Uri.parse(
          'https://dapi.kakao.com/v2/local/search/address.json?query=$encodedQuery'); // API 호출 URL 생성

      print('API 호출 URL: $url'); // 디버깅을 위해 URL 출력
      print('KA Header: $kaHeader'); // 디버깅을 위해 KA 헤더 출력

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'KakaoAK $apiKey', // API 키를 헤더에 추가
          'KA': kaHeader, // KA 헤더 추가
        },
      );

      print('HTTP 상태 코드: ${response.statusCode}'); // 디버깅을 위해 상태 코드 출력
      print('HTTP 응답 본문: ${response.body}'); // 디버깅을 위해 응답 본문 출력

      if (response.statusCode == 200) {
        final data = json.decode(response.body); // 응답 본문을 JSON으로 디코딩
        return data['documents']; // 주소 데이터 반환
      } else {
        throw Exception(
            'Failed to load addresses: ${response.statusCode}'); // 실패 시 예외 발생
      }
    } catch (e) {
      throw Exception('Failed to load addresses: $e'); // 예외 발생 시 예외 메시지 출력
    }
  }

  // ------ 주소검색 기능 관련 데이터 처리 로직 내용 부분 끝

  // ------ 발주자 정보, 수령자 정보, 결제 정보, 상품 정보, 발주 관련 번호 정보를 매개변수로 받는 함수 내용 시작
  // 발주를 처리하고, 발주 ID를 반환하는 함수
  Future<String> placeOrder({
    required Map<String, dynamic> ordererInfo, // 발주자 정보
    required Map<String, dynamic> recipientInfo, // 수령자 정보
    required Map<String, dynamic> amountInfo, // 결제 정보
    required List<ProductContent> productInfo, // 상품 정보 리스트
  }) async {
    // 현재 로그인한 사용자의 UID를 가져옴
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // 발주 문서를 생성할 위치를 Firestore에서 지정
    final orderDoc = firestore.collection('order_list').doc(userId).collection('orders').doc();
    // 발주 ID를 생성
    final orderId = orderDoc.id;

    // 발주자 정보를 Firestore에 저장
    await orderDoc.collection('orderer_info').doc('info').set(ordererInfo);
    // 수령자 정보를 Firestore에 저장
    await orderDoc.collection('recipient_info').doc('info').set(recipientInfo);
    // 결제 정보를 Firestore에 저장
    await orderDoc.collection('amount_info').doc('info').set(amountInfo);

    // 상품 정보를 반복문을 통해 Firestore에 저장
    for (var item in productInfo) {
      await orderDoc.collection('product_info').add({
        'briefIntroduction': item.briefIntroduction, // 상품 간략 소개
        'productNumber': item.productNumber, // 상품 번호
        'thumbnail': item.thumbnail, // 썸네일 이미지 URL
        'originalPrice': item.originalPrice, // 원래 가격
        'discountPrice': item.discountPrice, // 할인 가격
        'discountPercent': item.discountPercent, // 할인 퍼센트
        'selectedCount': item.selectedCount, // 선택한 수량
        'selectedColorImage': item.selectedColorImage, // 선택한 색상 이미지
        'selectedColorText': item.selectedColorText, // 선택한 색상 텍스트
        'selectedSize': item.selectedSize, // 선택한 사이즈
      });
    }

    // number_info 컬렉션에 order_number와 order_date 추가
    final now = DateTime.now(); // 현재 시간을 가져옴
    final orderNumber = DateFormat('yyyyMMdd').format(now) + (now.hour * 3600 + now.minute * 60 + now.second).toString(); // 주문 번호 생성
    await orderDoc.collection('number_info').doc('info').set({
      'order_number': orderNumber, // 주문 번호 저장
      'order_date': now, // 주문 날짜 저장
    });

    return orderId; // 발주 ID를 반환
  }

  // 파이어스토어에 저장된 발주 내역 데이터를 불러오는 로직 관련 함수
  // 발주 데이터를 가져오는 함수
  Future<Map<String, dynamic>> fetchOrderData(String userId, String orderId) async {
    // 발주 문서를 Firestore에서 가져옴
    final orderDoc = firestore.collection('order_list').doc(userId).collection('orders').doc(orderId);

    // 각 정보 문서를 Firestore에서 가져옴
    final ordererInfoDoc = await orderDoc.collection('orderer_info').doc('info').get();
    final recipientInfoDoc = await orderDoc.collection('recipient_info').doc('info').get();
    final amountInfoDoc = await orderDoc.collection('amount_info').doc('info').get();
    final numberInfoDoc = await orderDoc.collection('number_info').doc('info').get();
    final productInfoQuery = await orderDoc.collection('product_info').get();

    // 정보 문서가 존재하지 않으면 예외를 발생시킴
    if (!ordererInfoDoc.exists || !recipientInfoDoc.exists || !amountInfoDoc.exists || !numberInfoDoc.exists) {
      throw Exception('Order not found');
    }

    // 상품 정보를 리스트로 변환
    final productInfo = productInfoQuery.docs.map((doc) => doc.data()).toList();

    // 각 정보를 맵으로 반환
    return {
      'ordererInfo': ordererInfoDoc.data(), // 발주자 정보
      'recipientInfo': recipientInfoDoc.data(), // 수령자 정보
      'amountInfo': amountInfoDoc.data(), // 결제 정보
      'numberInfo': numberInfoDoc.data(), // 주문 번호 및 날짜 정보
      'productInfo': productInfo, // 상품 정보 리스트
    };
  }
  // ------ 발주자 정보, 수령자 정보, 결제 정보, 상품 정보, 발주 관련 정보를 매개변수로 받는 함수 내용 끝

  // 입금계좌 정보를 불러오는 함수
  Future<String> fetchAccountNumber() async {
    // 특정 계좌 문서를 Firestore에서 가져옴
    final accountDoc = await firestore.collection('accounts').doc('account_1').get();
    // 계좌 문서가 존재하지 않으면 예외를 발생시킴
    if (!accountDoc.exists) {
      throw Exception('Account not found');
    }
    // 계좌 번호를 반환, 존재하지 않으면 'No account number' 반환
    return accountDoc.data()?['account_number'] ?? 'No account number';
  }
}
// 발주 관련 화면의 레퍼지토리 내용 끝
