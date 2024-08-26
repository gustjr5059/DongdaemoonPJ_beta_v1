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
        final productInfoQuery = await orderDoc.reference.collection('product_info')
            .where('boolReviewCompleteBtn', isEqualTo: false) // boolReviewCompleteBtn 필드값이 'false'인 데이터만 가져오도록 조건절
            .get();

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

      // separator_key 필드를 productInfo에서 가져옴
      final String separatorKey = productInfo['separator_key'] ?? '';

      // 현재 시간을 가져옴
      final DateTime reviewWriteTime = DateTime.now();

      // 리뷰 데이터 생성
      final data = {
        'order_number': orderNumber,  // 주문 번호를 포함함
        'separator_key': separatorKey,  // separator_key를 포함함
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
        'review_write_time': reviewWriteTime,  // 리뷰 작성 시간을 포함함
      };

      // 파이어스토어에 리뷰 데이터를 저장함
      await firestore.collection('review_list')
          .doc(userEmail)  // 유저 이메일로 문서 경로 설정
          .collection('reviews')  // 'reviews' 컬렉션에 저장
          .doc(separatorKey)  // separator_key로 문서 ID 설정
          .set(data);  // 데이터 저장

      // 리뷰 작성 완료 후, 해당 발주에 대한 'boolReviewCompleteBtn' 필드를 true로 업데이트함
      await firestore.collection('order_list')
          .doc(userEmail)
          .collection('orders')
          .doc(orderNumber)
          .collection('product_info')
          .doc(separatorKey)
          .update({
        'boolReviewCompleteBtn': true,  // 리뷰 작성 완료 버튼 필드를 true로 설정
      });
    } catch (e) {
      // 리뷰 제출 중 발생한 오류를 출력함
      print('Failed to submit review: $e');
      // 오류 발생 시 예외를 던져 상위에서 처리할 수 있도록 함
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> fetchReviewList(String userEmail) async {
    // 사용자의 이메일을 인자로 받아 해당 사용자의 리뷰 목록을 가져오는 비동기 함수임.

    try {
      // Firestore에서 리뷰 데이터를 가져오는 과정에서 발생할 수 있는 예외를 처리하기 위해 try-catch 블록을 사용함.

      // 리뷰 컬렉션에 대한 참조를 가져오고,
      // 'review_write_time' 필드를 기준으로 내림차순으로 정렬하도록 쿼리를 작성함.
      final userReviewsRef = firestore
          .collection('review_list')
          .doc(userEmail)
          .collection('reviews')
          .orderBy('review_write_time', descending: true);
      // 'review_list' 컬렉션 안에 특정 사용자의 이메일에 해당하는
      // 문서를 참조한 후, 'reviews' 하위 컬렉션을 가져옴.
      // 리뷰는 'review_write_time' 필드를 기준으로 최신순으로 정렬됨.

      // 작성된 쿼리를 실행하여 쿼리 결과를 가져옴.
      final querySnapshot = await userReviewsRef.get();
      // get() 메서드를 호출하여 Firestore에서 해당 사용자의 리뷰 데이터를 가져옴.
      // 이 데이터는 QuerySnapshot 형태로 반환됨.

      // 쿼리 결과가 비어 있는지 확인하고,
      // 리뷰가 없는 경우 빈 리스트를 반환함.
      if (querySnapshot.docs.isEmpty) {
        print('No reviews found for user: $userEmail');
        return [];
        // 쿼리 결과가 비어 있는 경우, 로그 메시지를 출력하고
        // 빈 리스트를 반환하여 리뷰가 없음을 나타냄.
      }

      // 쿼리 결과를 Map<String, dynamic> 형식으로 변환하여 리스트로 반환함.
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      // 쿼리에서 가져온 각 문서를 Map 형식으로 변환하고, 이를 리스트로 만듦.
      // 이 리스트는 리뷰 데이터를 포함한 맵들의 리스트임.

    } catch (e) {
      // 리뷰 데이터를 가져오는 중 예외가 발생했을 때 처리하는 부분임.
      print('Failed to fetch reviews for user $userEmail: $e');
      // 예외 발생 시, 로그에 오류 메시지를 출력하여 문제를 기록함.

      throw Exception('Failed to fetch reviews: $e');
      // 예외를 다시 던져서 호출한 쪽에서 이 오류를 처리할 수 있도록 함.
    }
  }
}
// ------ 리뷰 관리 화면 내 데이터 처리 로직인 ReviewRepository 내용 끝 부분