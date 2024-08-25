import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
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
    // 현재 로그인한 사용자의 이메일을 가져옴
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      throw Exception('User not logged in');
    }

    // 현재 시간을 기반으로 주문 번호를 생성
    final now = DateTime.now(); // 현재 시간을 가져옴
    final orderNumber = DateFormat('yyyyMMdd').format(now) + (now.hour * 3600 + now.minute * 60 + now.second).toString(); // 주문 번호 생성

    // 발주 문서를 생성할 위치를 Firestore에서 지정 (order_number를 문서 ID로 사용)
    final orderDoc = firestore.collection('order_list')
        .doc(userEmail)
        .collection('orders')
        .doc(orderNumber); // orderId 대신 orderNumber 사용

    // 발주자 정보를 Firestore에 저장
    await orderDoc.collection('orderer_info').doc('info').set(ordererInfo);
    // 수령자 정보를 Firestore에 저장
    await orderDoc.collection('recipient_info').doc('info').set(recipientInfo);
    // 결제 정보를 Firestore에 저장
    await orderDoc.collection('amount_info').doc('info').set(amountInfo);
    // 발주 데이터를 Firestore에 저장할 때 버튼 상태 필드를 추가.
    await orderDoc.collection('button_info').doc('info').set({
      'boolRefundBtn': false, // 초기값은 false로 설정
      'boolReviewWriteBtn': false, // 초기값은 false로 설정
    });

// 상품 정보를 반복문을 통해 Firestore에 저장
    for (var i = 0; i < productInfo.length; i++) {
      final item = productInfo[i]; // item 변수 정의
      final productDocId = '${orderNumber}_${i + 1}'; // 'order_number_1', 'order_number_2' 형식의 문서 ID 생성
      await orderDoc.collection('product_info').doc(productDocId).set({
        'separator_key': productDocId, // separator_key 필드에 생성된 문서 ID 저장
        'product_id': item.docId, // 상품 상세 화면의 문서 id를 저장
        'category': item.category, // 상품의 카테고리 저장
        'brief_introduction': item.briefIntroduction, // 상품 간략 소개
        'product_number': item.productNumber, // 상품 번호
        'thumbnails': item.thumbnail, // 썸네일 이미지 URL
        'original_price': item.originalPrice, // 원래 가격
        'discount_price': item.discountPrice, // 할인 가격
        'discount_percent': item.discountPercent, // 할인 퍼센트
        'selected_count': item.selectedCount, // 선택한 수량
        'selected_color_image': item.selectedColorImage, // 선택한 색상 이미지
        'selected_color_text': item.selectedColorText, // 선택한 색상 텍스트
        'selected_size': item.selectedSize, // 선택한 사이즈
        'boolReviewCompleteBtn': false, // 초기값은 false로 설정
      });
    }

    // 발주 상태 정보를 Firestore에 저장
    final orderStatusInfo = {
      'order_status': '발주신청 완료', // 기본 값으로 '발주신청 완료'를 저장
    };
    await orderDoc.collection('order_status_info').doc('info').set(orderStatusInfo);

    // number_info 컬렉션에 order_number와 order_date 추가
    await orderDoc.collection('number_info').doc('info').set({
      'order_number': orderNumber, // 주문 번호 저장
      'order_date': now, // 주문 날짜 저장
    });

    // // 이메일로 발주 데이터 전송 (클라이언트 관점에서의 이메일 보내기 기능 관련 코드)
    // await sendOrderEmail(ordererInfo, recipientInfo, amountInfo, productInfo, orderNumber);

    // 이메일로 발주 데이터 전송할 때, Firestore에 주문 정보를 저장하는 로직
    // 해당 로직에 의해 데이터가 중복으로 저장되지만 해당 로직이 없으면 이메일 전송 기능이 구현이 안됨
    // 해당 로직이 이메일 전송 기능인 sendOrderEmailV2의 functions 함수의 트리거 역할!!
    // 해당 로직과 index.js 로직이 백엔드인 파이어베이스에서 관련 데이터로 이메일 보내는 기능 구현 로직
    await firestore.collection('order_list')
        .doc(userEmail)
        .collection('orders')
        .doc(orderNumber) // orderId 대신 orderNumber 사용
        .set({
      'ordererInfo': ordererInfo, // 발주자 정보
      'recipientInfo': recipientInfo, // 수령자 정보
      'amountInfo': amountInfo, // 결제 정보
      'productInfo': productInfo.map((item) => item.toMap()).toList(), // 상품 정보 리스트
      'numberInfo': {
        'order_number': orderNumber, // 주문 번호
        'order_date': now, // 주문 날짜
      }
    });

    return orderNumber; // orderId 대신 orderNumber 반환
  }


  // ------ flutter_email_sender 패키지를 활용한 ios 기본 메일 앱과 연동하여 이메일 보내는 기능
  // 클라이언트 관점에서 이메일 전송하는 기능 (사용자가 직접 메일 앱에서 나온 UI를 보고 보내기 버튼을 클릭해야 이메일을 보낼 수 있는 단점이 있음 - 그래서 사용 x)
  // // ------ '결제하기' 버튼 클릭 시, 관련 발주 데이터를 특정 이메일 계정으로 발송하는 기능 관련 함수 내용 시작 부분
  // Future<void> sendOrderEmail(
  //     Map<String, dynamic> ordererInfo,
  //     Map<String, dynamic> recipientInfo,
  //     Map<String, dynamic> amountInfo,
  //     List<ProductContent> productInfo,
  //     String orderNumber,
  //     ) async {
  //   final email = Email(
  //     body: _generateOrderEmailBody(ordererInfo, recipientInfo, amountInfo, productInfo),
  //     subject: '신규 발주 내역: [$orderNumber] ${ordererInfo['email']}',
  //     recipients: ['stonehead0627@gmail.com'],
  //     isHTML: true,
  //   );
  //
  //   try {
  //     print('이메일 전송 준비 완료');
  //     print('이메일 내용: ${email.body}');
  //     await FlutterEmailSender.send(email);
  //     print('이메일 전송 성공');
  //   } catch (error) {
  //     print('이메일 전송 실패: $error');
  //   }
  // }
  // // ------ '결제하기' 버튼 클릭 시, 관련 발주 데이터를 특정 이메일 계정으로 발송하는 기능 관련 함수 내용 끝 부분
  //
  // // ------ 발송하는 이메일 본문 내용 구성 UI 관련 함수 내용 시작 부분
  // String _generateOrderEmailBody(
  //     Map<String, dynamic> ordererInfo,
  //     Map<String, dynamic> recipientInfo,
  //     Map<String, dynamic> amountInfo,
  //     List<ProductContent> productInfo,
  //     ) {
  //   final buffer = StringBuffer();
  //   final numberFormat = NumberFormat('###,###');
  //
  //   buffer.writeln('<html><body>');
  //   buffer.writeln('<h2>발주자 정보</h2>');
  //   buffer.writeln('<table border="1" cellpadding="5" cellspacing="0">');
  //   buffer.writeln('<tr><td><b>이름</b></td><td>${ordererInfo['name']}</td></tr>');
  //   buffer.writeln('<tr><td><b>이메일</b></td><td>${ordererInfo['email']}</td></tr>');
  //   buffer.writeln('<tr><td><b>휴대폰 번호</b></td><td>${ordererInfo['phone_number']}</td></tr>');
  //   buffer.writeln('</table><br>');
  //
  //   buffer.writeln('<h2>수령자 정보</h2>');
  //   buffer.writeln('<table border="1" cellpadding="5" cellspacing="0">');
  //   buffer.writeln('<tr><td><b>이름</b></td><td>${recipientInfo['name']}</td></tr>');
  //   buffer.writeln('<tr><td><b>휴대폰 번호</b></td><td>${recipientInfo['phone_number']}</td></tr>');
  //   buffer.writeln('<tr><td><b>우편번호</b></td><td>${recipientInfo['postal_code']}</td></tr>');
  //   buffer.writeln('<tr><td><b>주소</b></td><td>${recipientInfo['address']}</td></tr>');
  //   buffer.writeln('<tr><td><b>상세 주소</b></td><td>${recipientInfo['detail_address']}</td></tr>');
  //   buffer.writeln('<tr><td><b>메모</b></td><td>${recipientInfo['memo']}</td></tr>');
  //   buffer.writeln('<tr><td><b>추가 메모</b></td><td>${recipientInfo['extra_memo']}</td></tr>');
  //   buffer.writeln('</table><br>');
  //
  //   buffer.writeln('<h2>금액 정보</h2>');
  //   buffer.writeln('<table border="1" cellpadding="5" cellspacing="0">');
  //   buffer.writeln('<tr><td><b>총 상품금액</b></td><td>${numberFormat.format(amountInfo['total_product_price'])}원</td></tr>');
  //   buffer.writeln('<tr><td><b>상품 할인금액</b></td><td>${numberFormat.format(amountInfo['product_discount_price'])}원</td></tr>');
  //   buffer.writeln('<tr><td><b>총 결제금액</b></td><td>${numberFormat.format(amountInfo['total_payment_price'])}원</td></tr>');
  //   buffer.writeln('</table><br>');
  //
  //   buffer.writeln('<h2>상품 정보</h2>');
  //   for (var item in productInfo) {
  //     buffer.writeln('<table border="1" cellpadding="5" cellspacing="0">');
  //     buffer.writeln('<tr><td><b>상품</b></td><td>${item.briefIntroduction}</td></tr>');
  //     buffer.writeln('<tr><td><b>상품 번호</b></td><td>${item.productNumber}</td></tr>');
  //     buffer.writeln('<tr><td><b>원래 가격</b></td><td>${numberFormat.format(item.originalPrice)}원</td></tr>');
  //     buffer.writeln('<tr><td><b>할인 가격</b></td><td>${numberFormat.format(item.discountPrice)}원</td></tr>');
  //     buffer.writeln('<tr><td><b>할인 퍼센트</b></td><td>${item.discountPercent}%</td></tr>');
  //     buffer.writeln('<tr><td><b>선택한 수량</b></td><td>${item.selectedCount}개</td></tr>');
  //     buffer.writeln('<tr><td><b>선택한 색상</b></td><td>${item.selectedColorText}</td></tr>');
  //     buffer.writeln('<tr><td><b>선택한 사이즈</b></td><td>${item.selectedSize}</td></tr>');
  //     buffer.writeln('</table><br>');
  //   }
  //
  //   buffer.writeln('</body></html>');
  //   return buffer.toString();
  // }
  // // ------ 발송하는 이메일 본문 내용 구성 UI 관련 함수 내용 끝 부분

  // 파이어스토어에 저장된 발주 내역 데이터를 불러오는 로직 관련 함수
  // 발주 데이터를 가져오는 함수
  Future<Map<String, dynamic>> fetchOrderData(String userEmail, String orderNumber) async {
    // 발주 문서를 Firestore에서 가져옴
    final orderDoc = firestore.collection('order_list')
        .doc(userEmail)
        .collection('orders')
        .doc(orderNumber); // orderId 대신 orderNumber 사용

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


// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 관련 데이터 불러오는 OrderlistRepository 클래스 내용 시작 부분
class OrderlistRepository {
  final FirebaseFirestore firestore;

  // OrderlistRepository 클래스의 생성자, FirebaseFirestore 인스턴스를 받아옴
  OrderlistRepository({required this.firestore});

  // 특정 사용자의 발주 데이터를 가져오는 함수
  Future<List<Map<String, dynamic>>> fetchOrdersByEmail(String userEmail) async {
    try {
      print('Fetching orders for email: $userEmail');
      // 'order_list' 컬렉션에서 사용자 이메일에 해당하는 문서를 가져옴
      final userDocRef = firestore.collection('order_list').doc(userEmail);

      // 해당 문서의 'orders' 하위 컬렉션의 모든 문서를 가져옴
      final ordersQuerySnapshot = await userDocRef.collection('orders').get();
      print('Fetched orders: ${ordersQuerySnapshot.docs.length} for email: $userEmail');

      if (ordersQuerySnapshot.docs.isEmpty) {
        print('No orders found for email $userEmail');
        return []; // 빈 리스트 반환
        // // 발주 내역이 없는 경우 예외를 던짐
        // throw Exception('No orders found for email $userEmail');
      }

      final List<Map<String, dynamic>> allOrders = [];

      for (var orderDoc in ordersQuerySnapshot.docs) {
        print('Processing order: ${orderDoc.id}');

        // 각 발주 문서의 하위 컬렉션에서 필요한 정보를 가져옴
        final numberInfoDoc = await orderDoc.reference.collection('number_info').doc('info').get();
        final ordererInfoDoc = await orderDoc.reference.collection('orderer_info').doc('info').get();
        final amountInfoDoc = await orderDoc.reference.collection('amount_info').doc('info').get();
        final productInfoQuery = await orderDoc.reference.collection('product_info').get();
        final orderStatusDoc = await orderDoc.reference.collection('order_status_info').doc('info').get();

        // 'product_info' 하위 컬렉션의 모든 문서를 리스트로 변환
        final productInfo = productInfoQuery.docs.map((doc) {
          print('Processing product: ${doc.id}');
          return doc.data() as Map<String, dynamic>;
        }).toList();

        // 발주 데이터를 리스트에 추가
        allOrders.add({
          'numberInfo': numberInfoDoc.data() as Map<String, dynamic>? ?? {},
          'ordererInfo': ordererInfoDoc.data() as Map<String, dynamic>? ?? {},
          'amountInfo': amountInfoDoc.data() as Map<String, dynamic>? ?? {},
          'productInfo': productInfo,
          'orderStatus': orderStatusDoc.data()?['order_status'] ?? '없음', // order_status 필드 추가
        });
      }

      print('Finished fetching orders for email: $userEmail');
      return allOrders;
    } catch (e) {
      print('Failed to fetch orders for email $userEmail: $e');
      return []; // 에러 발생 시 빈 리스트 반환
      // // 에러 발생 시 예외를 던짐
      // throw Exception('Failed to fetch orders for email $userEmail: $e');
    }
  }

  // 특정 발주 번호에 해당하는 데이터를 가져오는 메서드
  Future<Map<String, dynamic>?> fetchOrderByOrderNumber(String userEmail, String orderNumber) async {
    try {
      // Firestore의 'order_list' 컬렉션에서 사용자의 이메일을 기준으로 문서 참조를 가져옴
      final userDocRef = firestore.collection('order_list').doc(userEmail);

      // 'orders' 서브 컬렉션에서 'numberInfo.order_number' 필드와 일치하는 주문 번호를 가진 문서를 조회
      final ordersQuerySnapshot = await userDocRef.collection('orders')
          .where('numberInfo.order_number', isEqualTo: orderNumber)
          .get();

      // 조회된 문서가 없을 경우, null을 반환하여 주문이 없음을 알림
      if (ordersQuerySnapshot.docs.isEmpty) {
        return null; // 일치하는 문서가 없을 경우 null 반환
      }

      // 첫 번째로 조회된 문서의 참조를 가져옴
      final orderDocRef = ordersQuerySnapshot.docs.first.reference;

      // 'number_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final numberInfoDoc = await orderDocRef.collection('number_info').doc('info').get();

      // 'orderer_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final ordererInfoDoc = await orderDocRef.collection('orderer_info').doc('info').get();

      // 'amount_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final amountInfoDoc = await orderDocRef.collection('amount_info').doc('info').get();

      // 'recipient_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final recipientInfoDoc = await orderDocRef.collection('recipient_info').doc('info').get();

      // 'product_info' 서브 컬렉션의 모든 문서를 조회하여 제품 정보를 가져옴
      final productInfoQuery = await orderDocRef.collection('product_info').get();

      // 'order_status_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final orderStatusDoc = await orderDocRef.collection('order_status_info').doc('info').get();

      // 조회된 제품 정보 문서들을 순회하며 Map 형식으로 변환
      final productInfo = productInfoQuery.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      // 각 정보들을 하나의 Map으로 합쳐 반환, 없을 경우 빈 맵을 반환
      return {
        'numberInfo': numberInfoDoc.data() as Map<String, dynamic>? ?? {}, // 주문 번호 정보
        'ordererInfo': ordererInfoDoc.data() as Map<String, dynamic>? ?? {}, // 주문자 정보
        'amountInfo': amountInfoDoc.data() as Map<String, dynamic>? ?? {}, // 금액 정보
        'recipientInfo': recipientInfoDoc.data() as Map<String, dynamic>? ?? {}, // 수령인 정보
        'productInfo': productInfo, // 제품 정보 리스트
        'orderStatus': orderStatusDoc.data()?['order_status'] ?? '에러 발생', // 주문 상태 정보
      };
    } catch (e) {
      // 오류 발생 시 로그를 출력하고 null을 반환
      print('Failed to fetch order details for order number $orderNumber: $e');
      return null;
    }
  }
}
// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 관련 데이터 불러오는 OrderlistRepository 클래스 내용 끝 부분

