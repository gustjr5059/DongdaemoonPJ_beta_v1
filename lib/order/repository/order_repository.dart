import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'dart:ui' as ui;

import '../../common/api_key.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../product/model/product_model.dart'; // API 키 로드 함수가 포함된 파일을 임포트
import 'package:crypto/crypto.dart'; // 해시 계산을 위한 crypto 패키지 사용
import 'dart:convert'; // utf8 변환을 위해 사용


// 발주 관련 화면의 레퍼지토리 클래스
class OrderRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스를 저장할 필드

  // 생성자에서 Firestore 인스턴스를 받아 초기화합니다.
  OrderRepository({required this.firestore});

  // 이메일을 이용해 사용자 정보를 가져오는 비동기 함수
  Future<Map<String, dynamic>?> getUserInfoByEmail(String email) async {
    try {
      print('이메일에 대한 사용자 정보 가져오는 중: $email');
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get(); // Firestore에서 이메일로 사용자 정보 검색

      if (querySnapshot.docs.isNotEmpty) {
        print('이메일에 대한 사용자 정보 확인됨: $email');
        return querySnapshot.docs.first.data() as Map<String,
            dynamic>?; // 사용자 정보 반환
      } else {
        print('이메일에 대한 사용자 정보 없음: $email');
        return null; // 사용자 정보가 없을 경우 null 반환
      }
    } catch (e) {
      print('사용자 데이터 가져오는 중 오류 발생: $e'); // 에러 발생 시 에러 메시지 출력
      return null; // 에러 발생 시 null 반환
    }
  }

  // ------ 발주자 정보, 수령자 정보, 결제 정보, 상품 정보, 발주 관련 번호 정보를 매개변수로 받는 함수 내용 시작
  // 발주를 처리하고, 발주 ID를 반환하는 함수
  Future<String> placeOrder({
    required Map<String, dynamic> ordererInfo, // 발주자 정보
    required Map<String, dynamic> recipientInfo, // 수령자 정보
    required Map<String, dynamic> amountInfo, // 결제 정보
    required List<ProductContent> productInfo, // 상품 정보 리스트
  }) async {
    print('발주 처리 중...');
    // 현재 로그인한 사용자의 이메일을 가져옴
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      print('사용자가 로그인하지 않았습니다');
      throw Exception('사용자가 로그인하지 않았습니다');
    }

    // 현재 시간을 기반으로 주문 번호를 생성
    final now = DateTime.now(); // 현재 시간을 가져옴
    // final orderNumber = DateFormat('yyyyMMdd').format(now) + (now.hour * 3600 + now.minute * 60 + now.second).toString(); // 주문 번호 생성
    final orderNumber = DateFormat('yyyyMMddHHmmss').format(now); // 주문 번호 생성
    print('생성된 주문 번호: $orderNumber');

    // 발주 문서를 생성할 위치를 Firestore에서 지정 (order_number를 문서 ID로 사용)
    final orderDoc = firestore.collection('wearcano_order_list')
        .doc(userEmail)
        .collection('orders')
        .doc(orderNumber); // orderId 대신 orderNumber 사용

    // 발주자 정보를 Firestore에 저장
    await orderDoc.collection('orderer_info').doc('info').set(ordererInfo);
    print('발주자 정보 저장됨.');

    // 수령자 정보를 Firestore에 저장
    await orderDoc.collection('recipient_info').doc('info').set(recipientInfo);
    print('수령자 정보 저장됨.');

    // 결제 정보를 Firestore에 저장
    await orderDoc.collection('amount_info').doc('info').set(amountInfo);
    print('결제 정보 저장됨.');

    // 발주 데이터를 Firestore에 저장할 때 버튼 상태 필드를 추가.
    await orderDoc.collection('button_info').doc('info').set({
      'boolRefundBtn': false, // 초기값은 false로 설정
      'boolReviewWriteBtn': false, // 초기값은 false로 설정
      'private_orderList_closed_button': false // 초기값은 false로 설정
    });
    print('버튼 정보 저장됨.');

    String marketCode = ''; // 상점 코드 변수 지정

    // 상품 정보를 반복문을 통해 Firestore에 저장
    for (var i = 0; i < productInfo.length; i++) {
      final item = productInfo[i]; // item 변수 정의
      final productDocId = '${orderNumber}_${i + 1}'; // 'order_number_1', 'order_number_2' 형식의 문서 ID 생성

      // 상품 번호의 앞 세 자리 텍스트를 추출하여 market_code 필드로 저장
      if (item.productNumber != null && item.productNumber!.length >= 3) {
        marketCode = item.productNumber!.substring(0, 3); // 상품 번호의 앞 세 자리 추출
      }

      await orderDoc.collection('product_info').doc(productDocId).set({
        'separator_key': productDocId, // separator_key 필드에 생성된 문서 ID 저장
        'product_id': item.docId, // 상품 상세 화면의 문서 id를 저장
        'category': item.category, // 상품의 카테고리 저장
        'brief_introduction': item.briefIntroduction, // 상품 간략 소개
        'product_number': item.productNumber, // 상품 번호
        'market_code': marketCode, // 상품 번호의 앞 세 자리 저장
        'thumbnails': item.thumbnail, // 썸네일 이미지 URL
        'original_price': item.originalPrice, // 원래 가격
        'discount_price': item.discountPrice, // 할인 가격
        'discount_percent': item.discountPercent, // 할인 퍼센트
        'selected_count': item.selectedCount, // 선택한 수량
        'selected_color_image': item.selectedColorImage, // 선택한 색상 이미지
        'selected_color_text': item.selectedColorText, // 선택한 색상 텍스트
        'selected_size': item.selectedSize, // 선택한 사이즈
        'boolReviewCompleteBtn': false, // 초기값은 false로 설정
        'boolRefundCompleteBtn': false, // 초기값은 false로 설정
      });
      print('상품 정보 저장됨 - 상품 ID: ${item.docId}, market_code: $marketCode');
    }

    // 발주 상태 정보를 Firestore에 저장
    final orderStatusInfo = {
      'order_status': '발주신청 완료', // 기본 값으로 '발주신청 완료'를 저장
    };
    await orderDoc.collection('order_status_info').doc('info').set(orderStatusInfo);
    print('발주 상태 정보 저장됨.');

    // number_info 컬렉션에 order_number와 order_date 추가
    await orderDoc.collection('number_info').doc('info').set({
      'order_number': orderNumber, // 주문 번호 저장
      'order_date': now, // 주문 날짜 저장
      'market_code': marketCode, // number_info 컬렉션에 market_code 추가
    });
    print('숫자 정보 저장됨.');

    // 이메일로 발주 데이터 전송할 때, Firestore에 주문 정보를 저장하는 로직
    await firestore.collection('wearcano_order_list')
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
        'market_code': marketCode, // number_info 컬렉션에 market_code 추가
      },
      'private_orderList_closed_button': false, // 발주내역 화면에서 발주내역을 삭제 시, UI에서 안 보이도록 하기 위한 로직
    });
    print('발주 데이터 Firestore에 저장됨.');

    return orderNumber; // orderId 대신 orderNumber 반환
  }

  // 파이어스토어에 저장된 발주 내역 데이터를 불러오는 로직 관련 함수
  // 발주 데이터를 가져오는 함수
  Future<Map<String, dynamic>> fetchOrderData(String userEmail, String orderNumber) async {
    print('발주 데이터 가져오는 중 - 이메일: $userEmail, 주문 번호: $orderNumber');
    // 발주 문서를 Firestore에서 가져옴
    final orderDoc = firestore.collection('wearcano_order_list')
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
      print('주문 데이터 없음 - 이메일: $userEmail, 주문 번호: $orderNumber');
      throw Exception('주문 데이터 없음');
    }

    // 상품 정보를 리스트로 변환
    final productInfo = productInfoQuery.docs.map((doc) => doc.data()).toList();

    // 각 정보를 맵으로 반환
    final orderData = {
      'ordererInfo': ordererInfoDoc.data(), // 발주자 정보
      'recipientInfo': recipientInfoDoc.data(), // 수령자 정보
      'amountInfo': amountInfoDoc.data(), // 결제 정보
      'numberInfo': numberInfoDoc.data(), // 주문 번호 및 날짜 정보
      'productInfo': productInfo, // 상품 정보 리스트
    };

    print('발주 데이터 성공적으로 가져옴.');
    return orderData;
  }

  // 입금계좌 정보를 불러오는 함수
  Future<String> fetchAccountNumber() async {
    print('입금계좌번호 정보 불러오는 중...');
    // 특정 계좌 문서를 Firestore에서 가져옴
    final accountDoc = await firestore.collection('accounts').doc('account_1').get();
    // 계좌 문서가 존재하지 않으면 예외를 발생시킴
    if (!accountDoc.exists) {
      print('계좌 문서를 찾을 수 없습니다.');
      throw Exception('계좌 문서를 찾을 수 없습니다.');
    }
    final accountNumber = accountDoc.data()?['account_number'] ?? '';
    print('불러온 입금계좌번호: $accountNumber');
    return accountNumber;
  }
}
// 발주 관련 화면의 레퍼지토리 내용 끝


// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 관련 데이터 불러오는 OrderlistRepository 클래스 내용 시작 부분
class OrderlistRepository {
  final FirebaseFirestore firestore;

  // OrderlistRepository 클래스의 생성자, FirebaseFirestore 인스턴스를 받아옴
  OrderlistRepository({required this.firestore});

  // 주어진 이메일 주소를 기반으로 발주 내역을 가져오는 함수.
  // 마지막 문서 스냅샷과 불러올 데이터의 개수도 매개변수로 받음.
  Future<List<Map<String, dynamic>>> fetchOrdersByEmail({
    required String userEmail,  // 사용자 이메일을 필수 매개변수로 받음.
    DocumentSnapshot? lastDocument,  // 마지막 문서 스냅샷을 받을 수 있는 선택적 매개변수.
    required int limit,  // 불러올 데이터 개수를 필수로 받음.
  }) async {
    try {
      print('Firestore에서 발주 데이터를 가져옵니다: 사용자 이메일 - $userEmail, 불러올 개수 - $limit');
      if (lastDocument != null) {
        print('마지막 문서 이후의 데이터를 가져옵니다.');
      }

      // 'order_list' 컬렉션에서 사용자 이메일에 해당하는 문서를 가져옴
      final userDocRef = firestore.collection('wearcano_order_list').doc(userEmail);

      // 'orders' 컬렉션에서 'private_orderList_closed_button' 값이 false인 문서들만 조회하며, 제한된 개수로 불러옴.
      // 'numberInfo.order_number' 필드 기준 내림차순으로 해서 최신 문서 순으로 정렬되도록 함.
      // 해당 조건값으로 하는 색인 추가함!!
      Query query = userDocRef.collection('orders')
          .where('private_orderList_closed_button', isEqualTo: false)
          .orderBy('numberInfo.order_number', descending: true)
          .limit(limit);

      // 마지막 문서가 존재하면, 그 문서 이후의 데이터만 불러옴.
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
        print("이전 데이터 이후로 데이터를 불러옵니다."); // 마지막 문서 이후 데이터를 불러온다는 메시지를 출력함
      }

      // 위에서 정의한 쿼리 실행 및 결과를 가져옴.
      final ordersQuerySnapshot = await query.get();

      print("가져온 문서 수: ${ordersQuerySnapshot.docs.length}"); // 가져온 문서의 수를 출력함

      // 결과가 없으면 빈 리스트를 반환.
      if (ordersQuerySnapshot.docs.isEmpty) {
        print('발주 내역이 없습니다.');
        return [];
      }

      print('총 ${ordersQuerySnapshot.docs.length}개의 발주를 Firestore에서 가져왔습니다.');

      // 모든 발주 데이터를 저장할 리스트 선언.
      final List<Map<String, dynamic>> allOrders = [];

      // 가져온 각 발주 문서에 대해 추가 정보를 조회하여 처리.
      for (var orderDoc in ordersQuerySnapshot.docs) {

        // 'number_info' 컬렉션에서 'info' 문서를 가져옴.
        final numberInfoDoc = await orderDoc.reference.collection('number_info').doc('info').get();
        // 'order_status_info' 컬렉션에서 'info' 문서를 가져옴.
        final orderStatusDoc = await orderDoc.reference.collection('order_status_info').doc('info').get();

          // 발주 데이터를 리스트에 추가
          allOrders.add({
            'numberInfo': numberInfoDoc.data() as Map<String, dynamic>? ?? {}, // 'number_info' 데이터.
            'orderStatus': orderStatusDoc.data()?['order_status'] ?? '', // 'order_status_info' 데이터.
            'snapshot': orderDoc,  // 마지막 문서 스냅샷.
          });
      }
      return allOrders;
    } catch (e) {
      print('Firestore에서 발주 데이터를 불러오는 도중 오류 발생: $e');
      return [];
    }
  }

  // 특정 발주 번호에 해당하는 발주를 삭제하는 함수.
  Future<void> fetchDeleteOrders({
    required String userEmail,
    required String orderNumber,
  }) async {
    try {
      print('Firestore에서 발주 삭제 요청: 사용자 이메일 - $userEmail, 발주 번호 - $orderNumber');

      // 사용자의 이메일을 기준으로 order_list 컬렉션의 문서 참조를 가져옴
      final userDocRef = firestore.collection('wearcano_order_list').doc(userEmail);

      // 'orders' 컬렉션에서 특정 발주 번호와 일치하는 문서를 조회.
      final ordersQuerySnapshot = await userDocRef.collection('orders')
          .where('numberInfo.order_number', isEqualTo: orderNumber)
          .get();

      // 조회된 문서가 있으면, 해당 문서를 삭제 처리.
      if (ordersQuerySnapshot.docs.isNotEmpty) {
        final orderDocRef = ordersQuerySnapshot.docs.first.reference;

        // 삭제 시간을 현재 시간으로 설정.
        final DateTime orderListDeleteTime = DateTime.now();

        // 'button_info' 컬렉션의 'info' 문서를 업데이트하여 삭제 버튼을 비활성화 및 삭제 시간 기록.
        final buttonInfoDocRef = orderDocRef.collection('button_info').doc('info');
        await buttonInfoDocRef.update({
          'private_orderList_closed_button': true,  // 삭제 버튼 비활성화.
          'orderList_delete_time': orderListDeleteTime,  // 삭제 시간 기록.
        });

        // 해당 발주 문서에서 'private_orderList_closed_button' 필드를 업데이트.
        await orderDocRef.update({
          'private_orderList_closed_button': true,  // 삭제 처리.
        });
      } else {
        // 문서가 존재하지 않는 경우 예외 처리
        print("orderNumber: $orderNumber에 해당하는 문서를 찾을 수 없음");
        throw Exception('orderNumber: $orderNumber에 해당하는 문서를 찾을 수 없음');
      }
    } catch (e) {
      // 발주내역 숨김 처리 실패 시 예외 처리
      print('orderNumber: $orderNumber 발주내역 숨김 처리 실패: $e');
      throw Exception('발주내역 숨김 처리 실패: $e');
    }
  }

// 특정 발주 번호에 해당하는 데이터를 가져오는 함수임
  Future<Map<String, dynamic>> fetchOrderlistItemByOrderNumber(String userEmail, String orderNumber) async {
    // 발주 상세 데이터를 요청한다는 메시지를 출력함
    print("발주 상세 데이터 요청 시작: orderNumber=$orderNumber, userEmail=$userEmail");

    try {
      // Firestore의 'couture_order_list' 컬렉션에서 사용자의 이메일을 기준으로 문서 참조를 가져옴
      final userDocRef = firestore.collection('wearcano_order_list').doc(userEmail);

      // 'orders' 서브 컬렉션에서 'numberInfo.order_number' 필드와 일치하는 주문 번호를 가진 문서를 조회함
      final ordersQuerySnapshot = await userDocRef.collection('orders')
          .where('numberInfo.order_number', isEqualTo: orderNumber)
          .get();

      // 조회된 문서 개수를 출력함
      print('발주 문서 조회 결과: ${ordersQuerySnapshot.docs.length}건의 데이터가 조회됨');

      // 조회된 문서가 없을 경우, 빈 Map을 반환함
      if (ordersQuerySnapshot.docs.isEmpty) {
        print('해당 발주 번호에 해당하는 발주 데이터가 없음: orderNumber=$orderNumber');
        return {}; // 빈 Map 반환
      }

      // 첫 번째로 조회된 문서의 참조를 가져옴
      final orderDocRef = ordersQuerySnapshot.docs.first.reference;
      print('처리 중인 발주 문서: ${orderDocRef.id}');

      // 'number_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final numberInfoDoc = await orderDocRef.collection('number_info').doc(
          'info').get();
      print('발주 번호 정보 조회: ${numberInfoDoc.exists ? '존재함' : '존재하지 않음'}');

      // 'orderer_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final ordererInfoDoc = await orderDocRef.collection('orderer_info').doc(
          'info').get();
      print('주문자 정보 조회: ${ordererInfoDoc.exists ? '존재함' : '존재하지 않음'}');

      // 'amount_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final amountInfoDoc = await orderDocRef.collection('amount_info').doc(
          'info').get();
      print('수량 정보 조회: ${amountInfoDoc.exists ? '존재함' : '존재하지 않음'}');

      // 'recipient_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final recipientInfoDoc = await orderDocRef.collection('recipient_info')
          .doc('info')
          .get();
      print('수령자 정보 조회: ${recipientInfoDoc.exists ? '존재함' : '존재하지 않음'}');

      // 'product_info' 서브 컬렉션의 모든 문서를 조회하여 제품 정보를 가져옴
      final productInfoQuery = await orderDocRef.collection('product_info')
          .get();
      print('제품 정보 조회 결과: ${productInfoQuery.docs.length}개의 제품 데이터가 조회됨');

      // 'order_status_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final orderStatusDoc = await orderDocRef.collection('order_status_info')
          .doc('info')
          .get();
      print('발주 상태 정보 조회: ${orderStatusDoc.exists ? '존재함' : '존재하지 않음'}');

      // 조회된 제품 정보 문서들을 순회하며 Map 형식으로 변환함
      final productInfo = productInfoQuery.docs.map((doc) {
        // 처리 중인 제품의 ID를 출력함
        print('처리 중인 제품: ${doc.id}');
        // 문서 데이터를 Map으로 변환함
        return doc.data() as Map<String, dynamic>;
      }).toList();

      // 각 정보들을 하나의 Map으로 합쳐 반환, 없을 경우 빈 맵을 반환
      final orderData = {
        'numberInfo': numberInfoDoc.data() as Map<String, dynamic>? ?? {},
        // 주문 번호 정보
        'ordererInfo': ordererInfoDoc.data() as Map<String, dynamic>? ?? {},
        // 주문자 정보
        'amountInfo': amountInfoDoc.data() as Map<String, dynamic>? ?? {},
        // 금액 정보
        'recipientInfo': recipientInfoDoc.data() as Map<String, dynamic>? ?? {},
        // 수령인 정보
        'productInfo': productInfo,
        // 제품 정보 리스트
        'orderStatus': orderStatusDoc.data()?['order_status'] ?? '',
        // 주문 상태 정보
      };

      // 발주 상세 데이터 요청이 완료되었다는 메시지를 출력함
      print('발주 상세 데이터 요청 완료: orderNumber=$orderNumber');

      // 발주 데이터를 반환함
      return orderData;
    } catch (error) {
      // 오류 발생 시 에러 메시지를 출력함
      print('발주 상세 데이터 요청 실패: $error');
      // 발생한 오류를 상위로 던져 처리하도록 함
      throw error;
    }
  }
}
// ------ 발주내역 관리 화면 내 드롭다운 메뉴 버튼 관련 데이터 불러오는 OrderlistRepository 클래스 내용 끝 부분

// ------- 수령자 정보 즐겨찾기 선택 화면과 관련된 데이터를 Firebase에 저장하고 저장된 데이터를 불러오는 관리 관련 데이터 처리 로직인 RecipientInfoItemRepository 클래스 시작
// RecipientInfoItemRepository 클래스는 Firestore와의 데이터 통신을 담당하는 역할
class RecipientInfoItemRepository {
  final FirebaseFirestore firestore; // Firebase Firestore 인스턴스 변수 선언

  RecipientInfoItemRepository(
      {required this.firestore}); // 생성자에서 firestore를 초기화함

  // 수령자 정보를 Firestore에 저장하는 함수
  Future<bool> saveRecipientInfo(BuildContext context, Map<String, dynamic> recipientInfo) async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail == null) throw Exception('사용자가 로그인 되어있지 않습니다.'); // 로그인되지 않은 경우 예외를 발생시킴

      // 필수 항목 검증
      // 수령자 정보의 필수 항목들이 모두 기입되었는지 확인함
      if (recipientInfo['name'].isEmpty ||
          recipientInfo['phone_number'].isEmpty ||
          recipientInfo['address'].isEmpty ||
          recipientInfo['postal_code'].isEmpty ||
          recipientInfo['detail_address'].isEmpty ||
          recipientInfo['memo'].isEmpty ||
          recipientInfo['memo'] == '기사님께 보여지는 메모입니다.') {
        // 입력이 누락된 경우 스낵바를 통해 경고 메시지를 표시함
        showCustomSnackBar(context, '수령자 정보 내 모든 항목에 정보를 기입한 후 등록해주세요.');
        return false; // 필수 항목이 비어있으면 false 반환
      }

      // 중복 체크를 위한 해시 생성
      // 수령자 정보 데이터를 결합하여 중복 확인용 해시를 생성함
      final combinedData = "${recipientInfo['name']}|${recipientInfo['phone_number']}|"
          "${recipientInfo['postal_code']}|${recipientInfo['address']}|"
          "${recipientInfo['detail_address']}|${recipientInfo['memo']}";
      final String hashKey = sha256.convert(utf8.encode(combinedData)).toString(); // 해시 생성 (SHA-256 사용)

      // Firestore 내 동일한 해시값이 있는지 확인
      // 중복된 수령자 정보가 있는지 Firestore에서 확인함
      final querySnapshot = await firestore
          .collection('wearcano_recipient_info_list')
          .doc(userEmail)
          .collection('recipient_info')
          .where('hashKey', isEqualTo: hashKey) // 해시로 중복 여부 확인
          .get();

      // 동일한 문서가 있을 경우 처리
      // 중복된 정보가 있는 경우 처리함
      if (querySnapshot.docs.isNotEmpty) {
        print('해당 수령자 정보는 이미 즐겨찾기 목록에 담겨 있습니다.');
        showCustomSnackBar(context, '해당 수령자 정보는 이미 즐겨찾기 목록에 담겨 있습니다.');
        return false; // 중복이 있으면 false 반환
      }

      // 저장된 시간 데이터 생성
      // 현재 서버 타임스탬프를 저장함
      final timestamp = FieldValue.serverTimestamp();

      // Firestore에 수령자 정보 저장
      // Firestore에 수령자 정보를 저장하는 과정임
      await firestore
          .collection('wearcano_recipient_info_list')
          .doc(userEmail)
          .collection('recipient_info')
          .doc('${DateTime.now().millisecondsSinceEpoch}')
          .set({
        ...recipientInfo,
        'hashKey': hashKey, // 해시키 추가
        'timestamp': timestamp, // 저장된 시간 데이터 추가
      });

      print('수신자 정보가 Firestore에 저장되었습니다. 해시 키: $hashKey.');
      return true; // 성공적으로 저장된 경우 true 반환
    } catch (e) {
      // 에러 발생 시 처리
      // 저장 중 오류 발생 시 에러 메시지 출력함
      print('수신자 정보 저장 중 오류 발생: $e');
      showCustomSnackBar(context, '저장 중 오류가 발생했습니다.');
      return false; // 에러 발생 시 false 반환
    }
  }

  // Firestore에서 수령자 정보 즐겨찾기 목록 내 아이템을 페이징 처리하여 불러오는 함수
  // Firestore로부터 수령자 정보를 페이징하여 불러오는 함수
  Future<List<Map<String, dynamic>>> getPagedRecipientInfoItems({DocumentSnapshot? lastDocument, required int limit}) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보를 가져옴
    final userEmail = user?.email; // 사용자의 이메일 주소를 가져옴
    if (userEmail == null) throw Exception('사용자가 로그인되어 있지 않습니다.'); // 사용자가 로그인하지 않은 경우 예외를 발생시킴

    print("Firestore에서 ${limit}개씩 데이터를 불러옵니다. 마지막 문서: $lastDocument"); // 지정된 갯수만큼 데이터를 불러온다는 메시지를 출력함

    // Firestore에서 지정한 개수만큼 데이터를 가져오도록 쿼리를 작성함
    Query query = firestore.collection('wearcano_recipient_info_list')
        .doc(userEmail)
        .collection('recipient_info')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    // 마지막 문서 이후 데이터를 불러옴
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument); // 마지막 문서 이후 데이터를 불러오는 설정
      print("이전 데이터 이후로 데이터를 불러옵니다."); // 마지막 문서 이후 데이터를 불러옴을 알림
    }

    // 쿼리를 실행하여 결과를 가져옴
    final querySnapshot = await query.get();

    print("가져온 문서 수: ${querySnapshot.docs.length}"); // 가져온 문서의 수를 출력함

    // 가져온 데이터를 Map 형태로 변환하여 반환함
    return querySnapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // 명시적으로 Map<String, dynamic>으로 변환함
      data['id'] = doc.id;  // 문서의 ID를 추가함
      data['snapshot'] = doc; // 마지막 문서를 기록함
      print("불러온 데이터: ${data['product_id']}"); // 불러온 데이터의 product_id를 출력함
      return data;
    }).toList(); // 데이터를 리스트로 변환하여 반환함
  }

  // 수령자 정보 즐겨찾기 목록의 특정 아이템에 대한 실시간 구독 스트림을 제공하는 함수
  // 특정 수령자 정보를 실시간으로 구독하는 스트림을 제공함
  Stream<Map<String, dynamic>> recipientInfoItemStream(String itemId) {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보를 가져옴
    final userEmail = user?.email; // 사용자의 이메일 주소를 가져옴
    if (userEmail == null) throw Exception('사용자가 로그인되어 있지 않습니다.'); // 로그인하지 않은 경우 예외 발생

    // 지정한 아이템에 대한 실시간 스트림을 구독함
    return firestore.collection('wearcano_recipient_info_list')
        .doc(userEmail)
        .collection('recipient_info')
        .doc(itemId)
        .snapshots() // 실시간 스트림을 구독함
        .handleError((error) {
      print('recipientInfoItemStream에서 오류 발생: $error'); // 구독 중 오류가 발생하면 처리함
    }).map((docSnapshot) {
      if (docSnapshot.exists) { // 문서가 존재하는 경우
        final data = docSnapshot.data() as Map<String, dynamic>; // 데이터를 Map으로 변환함
        data['id'] = docSnapshot.id; // 문서 ID를 추가함
        return data;
      } else {
        print('itemId: $itemId에 대한 문서가 존재하지 않습니다.'); // 문서가 존재하지 않음을 알림
        return null;
      }
    }).where((data) => data != null).cast<Map<String, dynamic>>(); // null 값을 필터링하여 스트림에서 제외함
  }

  // 수령자 정보 즐겨찾기 선택 화면 내에서 아이템을 '삭제' 버튼 클릭 시, Firestore에서 삭제되도록 하는 함수
  // Firestore에서 수령자 정보를 삭제하는 함수
  Future<void> removeRecipientInfoItem(String docId) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보를 가져옴
    if (user == null) {
      print('사용자가 로그인되어 있지 않습니다.'); // 사용자가 로그인되지 않은 경우 예외 발생
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }
    final userEmail = user.email; // 사용자의 이메일 주소를 가져옴
    if (userEmail == null) {
      print('사용자 이메일을 불러올 수 없습니다.'); // 이메일이 없는 경우 예외 발생
      throw Exception('사용자 이메일을 불러올 수 없습니다.');
    }
    print('사용자: $userEmail의 docId: $docId에 대한 RecipientInfo 항목을 삭제합니다.'); // 삭제할 문서 ID와 사용자를 출력함
    await firestore.collection('wearcano_recipient_info_list').doc(userEmail)
        .collection('recipient_info')
        .doc(docId)
        .delete(); // Firestore에서 문서를 삭제함
    print('docId: $docId에 대한 RecipientInfo 항목이 삭제되었습니다.'); // 문서 삭제 완료 메시지 출력
  }
}
// ------- 수령자 정보 즐겨찾기 선택 화면과 관련된 데이터를 Firebase에 저장하고 저장된 데이터를 불러오는 관리 관련 데이터 처리 로직인 RecipientInfoItemRepository 클래스 끝