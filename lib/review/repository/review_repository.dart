import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../../product/layout/product_body_parts_layout.dart';

// ------ 리뷰 관리 화면 내 데이터 처리 로직인 ReviewRepository 내용 시작 부분
// Firestore와 상호작용하여 리뷰 관련 데이터를 처리하는 ReviewRepository 클래스 정의
class ReviewRepository {
  final FirebaseFirestore firestore;

  ReviewRepository({required this.firestore});

  // 특정 사용자의 발주 데이터를 실시간으로 가져오는 함수
  Stream<List<Map<String, dynamic>>> streamOrdersByEmail(String userEmail) {
    try {
      print('Streaming orders for email: $userEmail');
      final userDocRef = firestore.collection('order_list').doc(userEmail);

      // orders 컬렉션을 실시간으로 스트리밍
      return userDocRef.collection('orders').snapshots().asyncMap((
          ordersQuerySnapshot) async {
        print('Fetched orders: ${ordersQuerySnapshot.docs
            .length} for email: $userEmail');

        if (ordersQuerySnapshot.docs.isEmpty) {
          print('No orders found for email $userEmail');
          return [];
        }

        final List<Map<String, dynamic>> allOrders = [];

        for (var orderDoc in ordersQuerySnapshot.docs) {
          print('Processing order: ${orderDoc.id}');

          final numberInfoDoc = await orderDoc.reference.collection(
              'number_info').doc('info').get();
          print('Fetched numberInfo for order: ${orderDoc.id}');

          final ordererInfoDoc = await orderDoc.reference.collection(
              'orderer_info').doc('info').get();
          print('Fetched ordererInfo for order: ${orderDoc.id}');

          final amountInfoDoc = await orderDoc.reference.collection(
              'amount_info').doc('info').get();
          print('Fetched amountInfo for order: ${orderDoc.id}');

          final productInfoQuery = await orderDoc.reference.collection(
              'product_info')
              .where('boolReviewCompleteBtn', isEqualTo: false)
              .get();
          print('Fetched productInfo for order: ${orderDoc.id}');

          final productInfo = productInfoQuery.docs.map((doc) {
            print('Processing product: ${doc.id}');
            return doc.data() as Map<String, dynamic>;
          }).toList();

          allOrders.add({
            'numberInfo': numberInfoDoc.data() as Map<String, dynamic>? ?? {},
            'ordererInfo': ordererInfoDoc.data() as Map<String, dynamic>? ?? {},
            'amountInfo': amountInfoDoc.data() as Map<String, dynamic>? ?? {},
            'productInfo': productInfo,
          });
        }

        allOrders.sort((a, b) {
          final dateA = a['numberInfo']['order_date'] as Timestamp?;
          final dateB = b['numberInfo']['order_date'] as Timestamp?;
          if (dateA != null && dateB != null) {
            return dateB.compareTo(dateA);
          }
          return 0;
        });

        print('Finished streaming and sorting orders for email: $userEmail');
        return allOrders;
      });
    } catch (e) {
      print('Failed to stream orders for email $userEmail: $e');
      return Stream.value([]); // 오류 발생 시 빈 리스트 스트림 반환
    }
  }

  // 사용자 이메일을 통해 이름 가져오는 함수
  Future<String> fetchUserNameByEmail(String email) async {
    // 사용자 이메일을 통해 이름을 가져오는 비동기 함수 선언
    try { // 오류 발생 가능성이 있는 코드 블록을 시도함
      print('Fetching user name for email: $email');
      DocumentSnapshot userDoc = await firestore.collection('users')
          .doc(email)
          .get(); // Firestore에서 'users' 컬렉션의 문서를 이메일로 가져옴
      if (userDoc.exists) { // 해당 문서가 존재하는지 확인
        String userName = userDoc['name']; // 문서에서 'name' 필드의 값을 가져옴
        print('User name found: $userName');
        return userName; // 사용자 이름을 반환
      } else { // 문서가 존재하지 않는 경우
        print('No user name found for email: $email');
        return '알 수 없음'; // '알 수 없음'이라는 문자열을 반환
      }
    } catch (e) { // 오류가 발생한 경우 처리
      print('Error fetching user name for email $email: $e'); // 오류 메시지를 콘솔에 출력
      return '알 수 없음'; // 오류 발생 시 '알 수 없음'이라는 문자열을 반환
    }
  }

  // 파이어스토리지에 이미지를 업로드하고 URL을 반환하는 함수
  Future<String?> uploadImage(File image, String storagePath) async {
    try {
      print('Uploading image to: $storagePath');
      // 파이어스토리지 참조 경로 설정
      final ref = FirebaseStorage.instance.ref().child(storagePath);
      // 이미지를 파이어스토리지에 업로드함
      await ref.putFile(image);
      // 업로드된 이미지의 다운로드 URL을 반환함
      final downloadUrl = await ref.getDownloadURL();
      print('Image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      // 업로드 중 발생한 오류를 출력함
      print('Image upload error for $storagePath: $e');
      // 오류 발생 시 null을 반환함
      return null;
    }
  }

  // 리뷰 데이터를 파이어스토어에 저장하는 함수
  Future<void> submitReview({
    required String userEmail, // 필수: 유저 이메일
    required String orderNumber, // 필수: 주문 번호
    required String reviewTitle, // 필수: 리뷰 제목
    required String reviewContents, // 필수: 리뷰 내용
    required List<File> images, // 필수: 리뷰 이미지 리스트
    required Map<String, dynamic> productInfo, // 필수: 제품 정보
    required Map<String, dynamic> numberInfo, // 필수: 숫자 관련 정보
    required String userName, // 필수: 유저 이름
    DateTime? paymentCompleteDate, // 선택적: 결제 완료일
    DateTime? deliveryStartDate, // 선택적: 배송 시작일
  }) async {
    try {
      // 파이어스토리지에 저장할 경로 설정
      final String storagePath = 'review_images/$userEmail/${DateTime
          .now()
          .millisecondsSinceEpoch}';

      // 리뷰 이미지 업로드 및 URL 리스트 생성
      List<String?> uploadedImageUrls = [];
      for (int i = 0; i < images.length; i++) {
        // 각 이미지를 업로드하고 URL을 가져옴
        final imageUrl = await uploadImage(
            images[i], '$storagePath/review_image$i');
        // URL이 null이 아닌 경우 리스트에 추가함
        if (imageUrl != null) {
          uploadedImageUrls.add(imageUrl);
        }
      }

      // separator_key 필드를 productInfo에서 가져옴
      final String separatorKey = productInfo['separator_key'] ?? '';

      // 디버그 메시지 추가
      print("Submitting review with separatorKey: $separatorKey");

      // 현재 시간을 가져옴
      final DateTime reviewWriteTime = DateTime.now();

      // 리뷰 데이터 생성
      final data = {
        'order_number': orderNumber,
        // 주문 번호를 포함함
        'separator_key': separatorKey,
        // separator_key를 포함함
        'product_number': productInfo['product_number'] ?? null,
        // 제품 번호를 포함함
        'brief_introduction': productInfo['brief_introduction'] ?? null,
        // 제품 간단 소개를 포함함
        'product_id': productInfo['product_id'] ?? null,
        // 제품 ID를 포함함
        'category': productInfo['category'] ?? null,
        // 제품 카테고리를 포함함
        'thumbnails': productInfo['thumbnails'] ?? null,
        // 제품 썸네일을 포함함
        'original_price': productInfo['original_price'] ?? null,
        // 원가를 포함함
        'discount_price': productInfo['discount_price'] ?? null,
        // 할인가를 포함함
        'discount_percent': productInfo['discount_percent'] ?? null,
        // 할인율을 포함함
        'selected_color_image': productInfo['selected_color_image'] ?? null,
        // 선택된 색상 이미지를 포함함
        'selected_color_text': productInfo['selected_color_text'] ?? null,
        // 선택된 색상 텍스트를 포함함
        'selected_size': productInfo['selected_size'] ?? null,
        // 선택된 사이즈를 포함함
        'selected_count': productInfo['selected_count'] ?? null,
        // 선택된 수량을 포함함
        'order_date': numberInfo['order_date'] ?? null,
        // 주문 날짜를 포함함
        'payment_complete_date': paymentCompleteDate ?? null,
        // 결제 완료일을 포함함
        'delivery_start_date': deliveryStartDate ?? null,
        // 배송 시작일을 포함함
        'review_title': reviewTitle.isNotEmpty ? reviewTitle : null,
        // 리뷰 제목을 포함함 (없으면 null)
        'review_contents': reviewContents.isNotEmpty ? reviewContents : null,
        // 리뷰 내용을 포함함 (없으면 null)
        'review_image1': uploadedImageUrls.isNotEmpty
            ? uploadedImageUrls[0]
            : null,
        // 첫 번째 리뷰 이미지를 포함함 (없으면 null)
        'review_image2': uploadedImageUrls.length > 1
            ? uploadedImageUrls[1]
            : null,
        // 두 번째 리뷰 이미지를 포함함 (없으면 null)
        'review_image3': uploadedImageUrls.length > 2
            ? uploadedImageUrls[2]
            : null,
        // 세 번째 리뷰 이미지를 포함함 (없으면 null)
        'user_name': userName.isNotEmpty ? userName : null,
        // 유저 이름을 포함함 (없으면 null)
        'review_write_time': reviewWriteTime,
        // 리뷰 작성 시간을 포함함
        'private_review_closed_button': false,
        // 리뷰 삭제 버튼 활성화 관련 데이터 포함함
      };

      // 파이어스토어에 리뷰 데이터를 저장함
      await firestore.collection('review_list')
          .doc(userEmail) // 유저 이메일로 문서 경로 설정
          .collection('reviews') // 'reviews' 컬렉션에 저장
          .doc(separatorKey) // separator_key로 문서 ID 설정
          .set(data); // 데이터 저장

      // 리뷰 작성 완료 후, 해당 발주에 대한 'boolReviewCompleteBtn' 필드를 true로 업데이트함
      await firestore.collection('order_list')
          .doc(userEmail)
          .collection('orders')
          .doc(orderNumber)
          .collection('product_info')
          .doc(separatorKey)
          .update({
        'boolReviewCompleteBtn': true, // 리뷰 작성 완료 버튼 필드를 true로 설정
      });

      print("Review submitted successfully with separatorKey: $separatorKey");
    } catch (e) {
      // 리뷰 제출 중 발생한 오류를 출력함
      print('Failed to submit review: $e');
      // 오류 발생 시 예외를 던져 상위에서 처리할 수 있도록 함
      throw e;
    }
  }

  // 특정 사용자의 리뷰 목록을 실시간으로 가져오는 함수
  Stream<List<Map<String, dynamic>>> streamReviewList(String userEmail) {
    try {
      print('Streaming review list for user: $userEmail');
      final userReviewsRef = firestore
          .collection('review_list')
          .doc(userEmail)
          .collection('reviews')
          .where('private_review_closed_button', isEqualTo: false) // 추가된 조건
          .orderBy('product_id', descending: false)
          .orderBy('review_write_time', descending: true);

      return userReviewsRef.snapshots().map((snapshot) {
        print('Fetched ${snapshot.docs.length} reviews for user: $userEmail');
        return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Failed to fetch reviews for user $userEmail: $e');
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  // 리뷰를 삭제 처리하는 함수 (실제로는 삭제하지 않음)
  Future<void> privatDeleteReview({
    required String userEmail,
    required String separatorKey,
  }) async {
    try {
      print(
          "Hiding review with separatorKey: $separatorKey for user: $userEmail");

      // Firestore 경로 확인
      final reviewDoc = firestore
          .collection('review_list')
          .doc(userEmail)
          .collection('reviews')
          .doc(separatorKey);

      // 문서 존재 여부 확인
      final docSnapshot = await reviewDoc.get();

      if (docSnapshot.exists) {
        // 삭제 시간 기록을 위한 현재 시간 저장
        final DateTime reviewDeleteTime = DateTime.now();

        // 리뷰 관련 데이터가 있는 문서 내 해당 필드값 수정
        await reviewDoc.update({
          'private_review_closed_button': true,
          'review_delete_time': reviewDeleteTime,
        });

        print("Review hidden successfully for separatorKey: $separatorKey");
      } else {
        print("Document not found for separatorKey: $separatorKey");
        throw Exception('Document not found for separatorKey: $separatorKey');
      }
    } catch (e) {
      print('Failed to hide review for separatorKey: $separatorKey: $e');
      throw Exception('Failed to hide review: $e');
    }
  }

  // 특정 상품에 대한 리뷰 목록을 가져오는 비동기 함수
  Future<List<ProductReviewContents>> fetchProductReviews(String productId) async {
    // 디버깅 목적으로, 특정 상품 ID에 대한 리뷰를 가져오는 작업이 시작되었음을 출력함
    print("Fetching reviews for product ID: $productId");

    try {
      // Firestore에서 모든 사용자의 이메일을 가져오는 쿼리를 실행함
      final usersSnapshot = await firestore.collection('users').get();

      // 모든 리뷰를 저장할 리스트를 초기화함
      List<ProductReviewContents> allReviews = [];

      // 각 사용자 문서에 대해 반복문을 실행함
      for (var userDoc in usersSnapshot.docs) {
        // 각 사용자 문서에서 이메일을 추출함
        String? userEmail = userDoc['email'];

        if (userEmail != null) {
          // 해당 사용자의 리뷰 컬렉션에서 특정 조건에 맞는 리뷰들을 조회함
          final snapshot = await firestore
              .collection('review_list')
              .doc(userEmail)
              .collection('reviews')
              .where('private_review_closed_button', isEqualTo: false) // 리뷰 비공개 상태 확인
              .where('product_id', isEqualTo: productId) // 특정 상품 ID와 일치하는 리뷰 조회
              .orderBy('review_write_time', descending: true) // 최신 리뷰부터 정렬함
              .get();

          // 디버깅 목적으로, 특정 사용자에 대해 몇 개의 리뷰가 조회되었는지 출력함
          print("Fetched ${snapshot.docs.length} reviews for product ID: $productId from user $userEmail");

          // 각 리뷰 문서를 ProductReviewContents 객체로 변환함
          final userReviews = snapshot.docs.map((doc) {
            // 문서의 데이터를 가져옴
            final data = doc.data();

            // 리뷰 이미지 필드에서 값이 있는 이미지들만 리스트에 추가함
            List<String> reviewImages = [];
            if (data['review_image1'] != null && data['review_image1'].isNotEmpty) {
              reviewImages.add(data['review_image1']);
            }
            if (data['review_image2'] != null && data['review_image2'].isNotEmpty) {
              reviewImages.add(data['review_image2']);
            }
            if (data['review_image3'] != null && data['review_image3'].isNotEmpty) {
              reviewImages.add(data['review_image3']);
            }

            // 디버깅 목적으로, 각 리뷰 데이터의 내용을 출력함
            print("Review data: $data");

            // ProductReviewContents 객체를 생성하여 반환함
            return ProductReviewContents(
              reviewerName: data['user_name'] ?? '', // 리뷰어 이름을 추출함
              reviewDate: data['review_write_time'] != null
                  ? DateFormat('yyyy-MM-dd').format((data['review_write_time'] as Timestamp).toDate()) // 리뷰 작성 날짜를 포맷팅함
                  : '',
              reviewContent: data['review_contents'] ?? '', // 리뷰 내용을 추출함
              reviewTitle: data['review_title'] ?? '', // 리뷰 제목을 추출함
              reviewImages: reviewImages, // 리뷰 이미지 리스트를 설정함
              reviewSelectedColor: data['selected_color_text'] ?? '', // 선택된 색상을 추가함
              reviewSelectedSize: data['selected_size'] ?? '', // 선택된 사이즈를 추가함
            );
          }).toList();

          // 해당 사용자의 리뷰 리스트를 전체 리뷰 리스트에 추가함
          allReviews.addAll(userReviews);
        }
      }

      // 모든 리뷰 리스트를 반환함
      return allReviews;
    } catch (e) {
      // 에러 발생 시, 에러 내용을 출력함
      print('Error fetching reviews for product ID $productId: $e');
      // 예외를 다시 던져서 호출자가 처리할 수 있도록 함
      throw e;
    }
  }
}
// ------ 리뷰 관리 화면 내 데이터 처리 로직인 ReviewRepository 내용 끝 부분
