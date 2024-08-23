import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ------ 리뷰 관리 화면 내 데이터 처리 로직인 ReviewRepository 내용 시작 부분
// Firestore와 상호작용하여 리뷰 관련 데이터를 처리하는 ReviewRepository 클래스 정의
class ReviewRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스를 저장하는 변수

  // ReviewRepository 생성자, firestore 매개변수를 필수로 받음
  ReviewRepository({required this.firestore});

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
      }

      final List<Map<String, dynamic>> allOrders = []; // 발주 데이터를 저장할 리스트

      for (var orderDoc in ordersQuerySnapshot.docs) {
        print('Processing order: ${orderDoc.id}');

        // 각 발주 문서의 하위 컬렉션에서 필요한 정보를 가져옴
        final numberInfoDoc = await orderDoc.reference.collection('number_info').doc('info').get();
        final ordererInfoDoc = await orderDoc.reference.collection('orderer_info').doc('info').get();
        final amountInfoDoc = await orderDoc.reference.collection('amount_info').doc('info').get();
        final productInfoQuery = await orderDoc.reference.collection('product_info').get();

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
        });
      }

      // 발주일자 기준으로 내림차순 정렬
      allOrders.sort((a, b) {
        final dateA = a['numberInfo']['order_date'] as Timestamp?;
        final dateB = b['numberInfo']['order_date'] as Timestamp?;
        if (dateA != null && dateB != null) {
          return dateB.compareTo(dateA); // 내림차순 정렬
        }
        return 0;
      });

      print('Finished fetching and sorting orders for email: $userEmail');
      return allOrders; // 정렬된 발주 데이터를 반환
    } catch (e) {
      print('Failed to fetch orders for email $userEmail: $e');
      return []; // 오류 발생 시 빈 리스트 반환
    }
  }

  // 사용자 이메일을 통해 이름 가져오는 함수
  Future<String> fetchUserNameByEmail(String email) async { // 사용자 이메일을 통해 이름을 가져오는 비동기 함수 선언
    try { // 오류 발생 가능성이 있는 코드 블록을 시도함
      DocumentSnapshot userDoc = await firestore.collection('users').doc(email).get(); // Firestore에서 'users' 컬렉션의 문서를 이메일로 가져옴
      if (userDoc.exists) { // 해당 문서가 존재하는지 확인
        String userName = userDoc['name']; // 문서에서 'name' 필드의 값을 가져옴
        return userName; // 사용자 이름을 반환
      } else { // 문서가 존재하지 않는 경우
        return '알 수 없음'; // '알 수 없음'이라는 문자열을 반환
      }
    } catch (e) { // 오류가 발생한 경우 처리
      print('Error fetching user name: $e'); // 오류 메시지를 콘솔에 출력
      return '알 수 없음'; // 오류 발생 시 '알 수 없음'이라는 문자열을 반환
    }
  }

  // 파이어스토리지에 이미지를 업로드하고 URL을 반환하는 함수
  Future<String?> uploadImage(File image, String storagePath) async {
    try {
      // 파이어스토리지 참조 경로 설정
      final ref = FirebaseStorage.instance.ref().child(storagePath);
      // 이미지를 파이어스토리지에 업로드함
      await ref.putFile(image);
      // 업로드된 이미지의 다운로드 URL을 반환함
      return await ref.getDownloadURL();
    } catch (e) {
      // 업로드 중 발생한 오류를 출력함
      print('Image upload error: $e');
      // 오류 발생 시 null을 반환함
      return null;
    }
  }

  // 리뷰 데이터를 파이어스토어에 저장하는 함수
  Future<void> submitReview({
    required String userEmail,  // 필수: 유저 이메일
    required String orderNumber,  // 필수: 주문 번호
    required String reviewTitle,  // 필수: 리뷰 제목
    required String reviewContents,  // 필수: 리뷰 내용
    required List<File> images,  // 필수: 리뷰 이미지 리스트
    required Map<String, dynamic> productInfo,  // 필수: 제품 정보
    required Map<String, dynamic> numberInfo,  // 필수: 숫자 관련 정보
    required String userName,  // 필수: 유저 이름
    DateTime? paymentCompleteDate,  // 선택적: 결제 완료일
    DateTime? deliveryStartDate,  // 선택적: 배송 시작일
  }) async {
    try {
      // 파이어스토리지에 저장할 경로 설정
      final String storagePath = 'review_images/$userEmail/${DateTime.now().millisecondsSinceEpoch}';

      // 리뷰 이미지 업로드 및 URL 리스트 생성
      List<String?> uploadedImageUrls = [];
      for (int i = 0; i < images.length; i++) {
        // 각 이미지를 업로드하고 URL을 가져옴
        final imageUrl = await uploadImage(images[i], '$storagePath/review_image$i');
        // URL이 null이 아닌 경우 리스트에 추가함
        if (imageUrl != null) {
          uploadedImageUrls.add(imageUrl);
        }
      }

      // 리뷰 데이터 생성
      final String reviewId = '${DateTime.now().millisecondsSinceEpoch}';
      final data = {
        'order_number': orderNumber,  // 주문 번호를 포함함
        'product_number': productInfo['product_number'] ?? null,  // 제품 번호를 포함함
        'brief_introduction': productInfo['brief_introduction'] ?? null,  // 제품 간단 소개를 포함함
        'product_id': productInfo['product_id'] ?? null,  // 제품 ID를 포함함
        'category': productInfo['category'] ?? null,  // 제품 카테고리를 포함함
        'thumbnails': productInfo['thumbnails'] ?? null,  // 제품 썸네일을 포함함
        'original_price': productInfo['original_price'] ?? null,  // 원가를 포함함
        'discount_price': productInfo['discount_price'] ?? null,  // 할인가를 포함함
        'discount_percent': productInfo['discount_percent'] ?? null,  // 할인율을 포함함
        'selected_color_image': productInfo['selected_color_image'] ?? null,  // 선택된 색상 이미지를 포함함
        'selected_color_text': productInfo['selected_color_text'] ?? null,  // 선택된 색상 텍스트를 포함함
        'selected_size': productInfo['selected_size'] ?? null,  // 선택된 사이즈를 포함함
        'selected_count': productInfo['selected_count'] ?? null,  // 선택된 수량을 포함함
        'order_date': numberInfo['order_date'] ?? null,  // 주문 날짜를 포함함
        'payment_complete_date': paymentCompleteDate ?? null,  // 결제 완료일을 포함함
        'delivery_start_date': deliveryStartDate ?? null,  // 배송 시작일을 포함함
        'review_title': reviewTitle.isNotEmpty ? reviewTitle : null,  // 리뷰 제목을 포함함 (없으면 null)
        'review_contents': reviewContents.isNotEmpty ? reviewContents : null,  // 리뷰 내용을 포함함 (없으면 null)
        'review_image1': uploadedImageUrls.isNotEmpty ? uploadedImageUrls[0] : null,  // 첫 번째 리뷰 이미지를 포함함 (없으면 null)
        'review_image2': uploadedImageUrls.length > 1 ? uploadedImageUrls[1] : null,  // 두 번째 리뷰 이미지를 포함함 (없으면 null)
        'review_image3': uploadedImageUrls.length > 2 ? uploadedImageUrls[2] : null,  // 세 번째 리뷰 이미지를 포함함 (없으면 null)
        'user_name': userName.isNotEmpty ? userName : null,  // 유저 이름을 포함함 (없으면 null)
      };

      // 파이어스토어에 리뷰 데이터를 저장함
      await firestore.collection('review_list')
          .doc(userEmail)  // 유저 이메일로 문서 경로 설정
          .collection('reviews')  // 'reviews' 컬렉션에 저장
          .doc(reviewId)  // 리뷰 ID로 문서 설정
          .set(data);  // 데이터 저장
    } catch (e) {
      // 리뷰 제출 중 발생한 오류를 출력함
      print('Failed to submit review: $e');
      // 오류 발생 시 예외를 던져 상위에서 처리할 수 있도록 함
      throw e;
    }
  }
}
// ------ 리뷰 관리 화면 내 데이터 처리 로직인 ReviewRepository 내용 끝 부분