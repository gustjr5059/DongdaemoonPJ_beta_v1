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


// 발주 관련 화면의 레퍼지토리 클래스
class OrderRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스를 저장할 필드

  // 생성자에서 Firestore 인스턴스를 받아 초기화합니다.
  OrderRepository({required this.firestore});

  // 이메일을 이용해 사용자 정보를 가져오는 비동기 함수
  Future<Map<String, dynamic>?> getUserInfoByEmail(String email) async {
    try {
      print('Fetching user info for email: $email');
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get(); // Firestore에서 이메일로 사용자 정보 검색

      if (querySnapshot.docs.isNotEmpty) {
        print('User info found for email: $email');
        return querySnapshot.docs.first.data() as Map<String,
            dynamic>?; // 사용자 정보 반환
      } else {
        print('No user info found for email: $email');
        return null; // 사용자 정보가 없을 경우 null 반환
      }
    } catch (e) {
      print('Error fetching user data: $e'); // 에러 발생 시 에러 메시지 출력
      return null; // 에러 발생 시 null 반환
    }
  }

  // ------ 발주자 정보, 수령자 정보, 결제 정보, 상품 정보, 발주 관련 번호 정보를 매개변수로 받는 함수 내용 시작
  // 발주를 처리하고, 발주 ID를 반환하는 함수
  Future<String> placeOrder({
    required Map<String, dynamic> ordererInfo, // 발주자 정보
    required List<ProductContent> productInfo, // 상품 정보 리스트
  }) async {
    print('Placing order...');
    // 현재 로그인한 사용자의 이메일을 가져옴
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      print('User not logged in');
      throw Exception('User not logged in');
    }

    // 현재 시간을 기반으로 주문 번호를 생성
    final now = DateTime.now(); // 현재 시간을 가져옴
    final orderNumber = DateFormat('yyyyMMdd').format(now) + (now.hour * 3600 + now.minute * 60 + now.second).toString(); // 주문 번호 생성
    print('Generated order number: $orderNumber');

    // 발주 문서를 생성할 위치를 Firestore에서 지정 (order_number를 문서 ID로 사용)
    final orderDoc = firestore.collection('couture_order_list')
        .doc(userEmail)
        .collection('orders')
        .doc(orderNumber); // orderId 대신 orderNumber 사용

    // 발주자 정보를 Firestore에 저장
    await orderDoc.collection('orderer_info').doc('info').set(ordererInfo);
    print('Orderer info saved.');

    // 발주 데이터를 Firestore에 저장할 때 버튼 상태 필드를 추가.
    await orderDoc.collection('button_info').doc('info').set({
      'private_orderList_closed_button': false // 초기값은 false로 설정
    });
    print('Button info saved.');

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
        'selected_color_image': item.selectedColorImage, // 선택한 색상 이미지
        'selected_color_text': item.selectedColorText, // 선택한 색상 텍스트
        'selected_size': item.selectedSize, // 선택한 사이즈
      });
      print('Product info saved for product ID: ${item.docId}');
    }

    // number_info 컬렉션에 order_number와 order_date 추가
    await orderDoc.collection('number_info').doc('info').set({
      'order_number': orderNumber, // 주문 번호 저장
      'order_date': now, // 주문 날짜 저장
    });
    print('Number info saved.');

    // 이메일로 발주 데이터 전송할 때, Firestore에 주문 정보를 저장하는 로직
    await firestore.collection('couture_order_list')
        .doc(userEmail)
        .collection('orders')
        .doc(orderNumber) // orderId 대신 orderNumber 사용
        .set({
      'ordererInfo': ordererInfo, // 발주자 정보
      'productInfo': productInfo.map((item) => item.toMap()).toList(), // 상품 정보 리스트
      'numberInfo': {
        'order_number': orderNumber, // 주문 번호
        'order_date': now, // 주문 날짜
      },
      'private_orderList_closed_button': false,
    });
    print('Order data saved to Firestore.');

    return orderNumber; // orderId 대신 orderNumber 반환
  }

  // 파이어스토어에 저장된 발주 내역 데이터를 불러오는 로직 관련 함수
  // 발주 데이터를 가져오는 함수
  Future<Map<String, dynamic>> fetchOrderData(String userEmail, String orderNumber) async {
    print('Fetching order data for email: $userEmail and order number: $orderNumber');
    // 발주 문서를 Firestore에서 가져옴
    final orderDoc = firestore.collection('couture_order_list')
        .doc(userEmail)
        .collection('orders')
        .doc(orderNumber); // orderId 대신 orderNumber 사용

    // 각 정보 문서를 Firestore에서 가져옴
    final ordererInfoDoc = await orderDoc.collection('orderer_info').doc('info').get();
    final numberInfoDoc = await orderDoc.collection('number_info').doc('info').get();
    final productInfoQuery = await orderDoc.collection('product_info').get();

    // 정보 문서가 존재하지 않으면 예외를 발생시킴
    if (!ordererInfoDoc.exists || !numberInfoDoc.exists) {
      print('Order not found for email: $userEmail and order number: $orderNumber');
      throw Exception('Order not found');
    }

    // 상품 정보를 리스트로 변환
    final productInfo = productInfoQuery.docs.map((doc) => doc.data()).toList();

    // 각 정보를 맵으로 반환
    final orderData = {
      'ordererInfo': ordererInfoDoc.data(), // 발주자 정보
      'numberInfo': numberInfoDoc.data(), // 주문 번호 및 날짜 정보
      'productInfo': productInfo, // 상품 정보 리스트
    };

    print('Successfully fetched order data.');
    return orderData;
  }
}
// 발주 관련 화면의 레퍼지토리 내용 끝


// ------ 발주내역 화면 내 데이터 불러오는 OrderlistRepository 클래스 내용 시작 부분
class OrderlistRepository {
  // Firestore 인스턴스를 저장하는 필드 선언.
  final FirebaseFirestore firestore;

  // Firestore 인스턴스를 필수 매개변수로 받는 생성자.
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

      // 'couture_order_list' 컬렉션에서 사용자 이메일에 해당하는 문서를 참조.
      final userDocRef = firestore.collection('couture_order_list').doc(userEmail);

      // 'orders' 컬렉션에서 'private_orderList_closed_button' 값이 false인 문서들만 조회하며, 제한된 개수로 불러옴.
      Query query = userDocRef.collection('orders')
          .where('private_orderList_closed_button', isEqualTo: false)
          .limit(limit);

      // 마지막 문서가 존재하면, 그 문서 이후의 데이터만 불러옴.
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      // 위에서 정의한 쿼리 실행 및 결과를 가져옴.
      final ordersQuerySnapshot = await query.get();

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

        // 'orderer_info' 컬렉션에서 'info' 문서를 가져옴.
        final ordererInfoDoc = await orderDoc.reference.collection('orderer_info').doc('info').get();

        // 'product_info' 컬렉션에서 모든 문서를 가져옴.
        final productInfoQuery = await orderDoc.reference.collection('product_info').get();

        // 가져온 'product_info' 문서들을 리스트로 변환.
        final productInfo = productInfoQuery.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        // 조회한 정보를 리스트에 추가, 마지막 문서 스냅샷도 저장.
        allOrders.add({
          'numberInfo': numberInfoDoc.data() as Map<String, dynamic>? ?? {},  // 'number_info' 데이터.
          'ordererInfo': ordererInfoDoc.data() as Map<String, dynamic>? ?? {},  // 'orderer_info' 데이터.
          'productInfo': productInfo,  // 'product_info' 리스트.
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
  Future<void> fetchDeleteOrders(String userEmail, String orderNumber) async {
    try {
      print('Firestore에서 발주 삭제 요청: 사용자 이메일 - $userEmail, 발주 번호 - $orderNumber');

      // 'couture_order_list' 컬렉션에서 사용자 이메일에 해당하는 문서를 참조.
      final userDocRef = firestore.collection('couture_order_list').doc(userEmail);

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
      }
    } catch (e) {
      print('Firestore에서 발주 삭제 도중 오류 발생: $e');
    }
  }

  // 특정 발주 번호에 해당하는 데이터를 가져오는 메서드
  Future<Map<String, dynamic>?> fetchOrderByOrderNumber(String userEmail,
      String orderNumber) async {
    try {
      print(
          'Fetching order details for order number: $orderNumber for email: $userEmail');

      // Firestore의 'order_list' 컬렉션에서 사용자의 이메일을 기준으로 문서 참조를 가져옴
      final userDocRef = firestore.collection('couture_order_list').doc(userEmail);

      // 'orders' 서브 컬렉션에서 'numberInfo.order_number' 필드와 일치하는 주문 번호를 가진 문서를 조회
      final ordersQuerySnapshot = await userDocRef.collection('orders')
          .where('numberInfo.order_number', isEqualTo: orderNumber)
          .get();
      print('Fetched orders: ${ordersQuerySnapshot.docs
          .length} for order number: $orderNumber');

      // 조회된 문서가 없을 경우, null을 반환하여 주문이 없음을 알림
      if (ordersQuerySnapshot.docs.isEmpty) {
        print('No order found for order number: $orderNumber');
        return null; // 일치하는 문서가 없을 경우 null 반환
      }

      // 첫 번째로 조회된 문서의 참조를 가져옴
      final orderDocRef = ordersQuerySnapshot.docs.first.reference;
      print('Processing order document: ${orderDocRef.id}');

      // 'number_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final numberInfoDoc = await orderDocRef.collection('number_info').doc(
          'info').get();
      print('Fetched numberInfo: ${numberInfoDoc.exists
          ? 'exists'
          : 'does not exist'}');

      // 'orderer_info' 서브 컬렉션에서 'info' 문서를 가져옴
      final ordererInfoDoc = await orderDocRef.collection('orderer_info').doc(
          'info').get();
      print('Fetched ordererInfo: ${ordererInfoDoc.exists
          ? 'exists'
          : 'does not exist'}');

      // 'product_info' 서브 컬렉션의 모든 문서를 조회하여 제품 정보를 가져옴
      final productInfoQuery = await orderDocRef.collection('product_info')
          .get();
      print('Fetched productInfo: ${productInfoQuery.docs
          .length} products found');

      // 조회된 제품 정보 문서들을 순회하며 Map 형식으로 변환
      final productInfo = productInfoQuery.docs.map((doc) {
        print('Processing product: ${doc.id}');
        return doc.data() as Map<String, dynamic>;
      }).toList();

      // 각 정보들을 하나의 Map으로 합쳐 반환, 없을 경우 빈 맵을 반환
      final orderData = {
        'numberInfo': numberInfoDoc.data() as Map<String, dynamic>? ?? {},
        // 주문 번호 정보
        'ordererInfo': ordererInfoDoc.data() as Map<String, dynamic>? ?? {},
        // 주문자 정보
        'productInfo': productInfo,
        // 제품 정보 리스트
      };

      print('Finished fetching order details for order number: $orderNumber');
      return orderData;
    } catch (e) {
      // 오류 발생 시 로그를 출력하고 null을 반환
      print('Failed to fetch order details for order number $orderNumber: $e');
      return null;
    }
  }
}
// ------ 발주내역 화면 내 데이터 불러오는 OrderlistRepository 클래스 내용 끝 부분