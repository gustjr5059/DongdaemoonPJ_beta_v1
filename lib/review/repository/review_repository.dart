import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import '../../product/layout/product_body_parts_layout.dart';

// ------ 리뷰 관리 화면 내 데이터 처리 로직인 PrivateReviewRepository 내용 시작 부분
// Firestore와 상호작용하여 리뷰 관련 데이터를 처리하는 PrivateReviewRepository 클래스 정의
class PrivateReviewRepository {
  // Firestore 인스턴스를 참조하기 위한 변수임.
  final FirebaseFirestore firestore;

  // PrivateReviewRepository 생성자 정의
  PrivateReviewRepository({required this.firestore});

  // 사용자 이메일을 통해 이름 가져오는 함수
  Future<String> fetchUserNameByEmail(String email) async {
    // 사용자 이메일을 통해 이름을 가져오는 비동기 함수 선언
    try { // 오류 발생 가능성이 있는 코드 블록을 시도함
      print('Fetching user name for email: $email');

      // ---------- (1) 'users' 컬렉션에서 userEmail에 대응하는 문서를 찾음 ----------
      // 기존에는 바로 wearcano_order_list.doc(userEmail)를 참조했으나,
      // 이제는 userEmail로 users 컬렉션에서 registration_id를 추출한 뒤, 그 값을 doc ID로 사용.
      final userQuerySnapshot = await firestore
          .collection('users')
          .where('registration_id', isEqualTo: email)
          .limit(1)
          .get();

      // 만약 문서를 찾지 못하면 빈 리스트 반환
      if (userQuerySnapshot.docs.isEmpty) {
        print('해당 이메일과 일치하는 users 문서를 찾지 못했음: $email');
        // 함수의 반환 타입이 Future<String>이면 '문자열로 기입;'
        return '에러 발생';
      }

      // 찾은 문서에서 registration_id 필드를 가져옴
      final userDocData = userQuerySnapshot.docs.first.data();
      final registrationId = userDocData['registration_id']?.toString() ?? '';

      // 만약 registration_id 필드가 없으면 빈 리스트 반환
      if (registrationId.isEmpty) {
        print('해당 users 문서에 registration_id가 없음: $email');
        // 함수의 반환 타입이 Future<String>이면 '문자열로 기입;'
        return '에러 발생';
      }

      // ---------- (2) wearcano_order_list 컬렉션에서 doc(registrationId)로 참조 ----------
      DocumentSnapshot userDoc = await firestore.collection('users')
          .doc(registrationId)
          .get(); // Firestore에서 'users' 컬렉션의 문서를 이메일로 가져옴
      if (userDoc.exists) { // 해당 문서가 존재하는지 확인
        String userName = userDoc['name']; // 문서에서 'name' 필드의 값을 가져옴
        print('User name found: $userName');
        return userName; // 사용자 이름을 반환
      } else { // 문서가 존재하지 않는 경우
        print('No user name found for email: $email');
        return '에러 발생'; // '에러 발생' 이라는 문자열을 반환
      }
    } catch (e) { // 오류가 발생한 경우 처리
      print('Error fetching user name for email $email: $e'); // 오류 메시지를 콘솔에 출력
      return '에러 발생'; // 오류 발생 시 '에러 발생' 이라는 문자열을 반환
    }
  }

  // ---------------------
  // 2) (참고) 리뷰 이미지 하나를 업로드하는 Private 함수 (별도 분리)
  // ---------------------
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

  // ---------------------
  // 3) [변경] 리뷰 데이터를 "먼저 null 이미지로 생성" 후, "백그라운드에서 이미지 업로드 & 문서 업데이트"
  // ---------------------
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

      // 기존에는 바로 wearcano_order_list.doc(userEmail)를 참조했으나,
      // 이제는 userEmail로 users 컬렉션에서 registration_id를 추출한 뒤, 그 값을 doc ID로 사용.
      // (a) userEmail -> registrationId 찾기
      final userQuerySnapshot = await firestore
          .collection('users')
          .where('registration_id', isEqualTo: userEmail)
          .limit(1)
          .get();

      // 만약 문서를 찾지 못하면 빈 리스트 반환
      // 함수의 반환 타입이 Future<void>이면 그냥 'return;'
      if (userQuerySnapshot.docs.isEmpty) {
        print('해당 이메일과 일치하는 users 문서를 찾지 못했음: $userEmail');
        return;
      }

      // 찾은 문서에서 registration_id 필드를 가져옴
      final userDocData = userQuerySnapshot.docs.first.data();
      final registrationId = userDocData['registration_id']?.toString() ?? '';

      // 만약 registration_id 필드가 없으면 빈 리스트 반환
      // 함수의 반환 타입이 Future<void>이면 그냥 'return;'
      if (registrationId.isEmpty) {
        print('해당 users 문서에 registration_id가 없음: $userEmail');
        return;
      }

      // (b) 리뷰 문서 ID (separatorKey) 준비
      // separator_key 필드를 productInfo에서 가져옴
      final String separatorKey = productInfo['separator_key'] ?? '';
      // 디버그 메시지 추가
      print("separatorKey와 함께 review 제출 중: $separatorKey");

      // (c) 리뷰 작성 시간 (현재 작성 시간)
      final DateTime reviewWriteTime = DateTime.now();

      // ----------------------------------------
      // 1) 먼저 Firestore 문서 생성 (이미지= null) → 즉시 "작성 완료" 처리
      // ----------------------------------------
      // 리뷰 필드 중 이미지 관련 필드는 null로 두어 생성
      final initialReviewData = {
        'order_number': orderNumber,
        'separator_key': separatorKey,
        'product_number': productInfo['product_number'] ?? null,
        'brief_introduction': productInfo['brief_introduction'] ?? null,
        'product_id': productInfo['product_id'] ?? null,
        'category': productInfo['category'] ?? null,
        'thumbnails': productInfo['thumbnails'] ?? null,
        'original_price': productInfo['original_price'] ?? null,
        'discount_price': productInfo['discount_price'] ?? null,
        'discount_percent': productInfo['discount_percent'] ?? null,
        'selected_color_image': productInfo['selected_color_image'] ?? null,
        'selected_color_text': productInfo['selected_color_text'] ?? null,
        'selected_size': productInfo['selected_size'] ?? null,
        'selected_count': productInfo['selected_count'] ?? null,
        'order_date': numberInfo['order_date'] ?? null,
        'payment_complete_date': paymentCompleteDate ?? null,
        'delivery_start_date': deliveryStartDate ?? null,
        'review_title': reviewTitle.isNotEmpty ? reviewTitle : null,
        'review_contents': reviewContents.isNotEmpty ? reviewContents : null,
        'review_image1': null, // 처음에는 null
        'review_image2': null, // 처음에는 null
        'review_image3': null, // 처음에는 null
        'user_name': userName.isNotEmpty ? userName : null,
        'review_write_time': reviewWriteTime,
        'private_review_closed_button': false,
      };

      // 문서 참조
      final reviewDocRef = firestore
          .collection('wearcano_review_list')
          .doc(registrationId)
          .collection('reviews')
          .doc(separatorKey);

      // 문서 생성
      await reviewDocRef.set(initialReviewData);

      // 리뷰 작성 완료 후, 해당 발주에 대한 'boolReviewCompleteBtn' 필드를 true로 업데이트함
      await firestore.collection('wearcano_order_list')
          .doc(registrationId)
          .collection('orders')
          .doc(orderNumber)
          .collection('product_info')
          .doc(separatorKey)
          .update({
        'boolReviewCompleteBtn': true, // 리뷰 작성 완료 버튼 필드를 true로 설정
      });

      // 여기까지 되면 화면단에서는 "리뷰 작성 완료" 처리를 할 수 있음
      print("Review doc created with null images. Immediate success for the user.");

      // ----------------------------------------
      // 2) 백그라운드에서 이미지 업로드 → Firestore 문서 이미지 필드 업데이트
      // ----------------------------------------
      // 파이어스토리지 경로 예: wearcano_review_images/{userEmail}/{timestamp}/...
      final String storagePath = 'wearcano_review_images/$userEmail/${DateTime.now().millisecondsSinceEpoch}';

      // 백그라운드 동작 (UI에선 이미 "리뷰 작성" 완료라고 안내 가능)
      Future.delayed(Duration.zero, () async {
        try {
          // 실제 업로드된 이미지 URL을 임시 저장할 map
          // (문서 업데이트 시, "review_image1", "review_image2" 등만 변경)
          final Map<String, String?> updatedImages = {};

          // 여러 장의 이미지를 순회하며 업로드
          for (int i = 0; i < images.length; i++) {
            final uploadedImageUrl = await uploadImage(
              images[i],
              '$storagePath/review_image$i',
            );
            if (uploadedImageUrl != null) {
              // 예: i=0 -> 'review_image1' 키에 저장
              updatedImages['review_image${i + 1}'] = uploadedImageUrl;
            }
          }

          // 업로드 완료 후, 문서 업데이트
          if (updatedImages.isNotEmpty) {
            await reviewDocRef.update(updatedImages);
            print("Review images updated in Firestore: $updatedImages");
          }
        } catch (e) {
          print('Error in background image upload: $e');
          // 여기서 굳이 throw하거나 UI에 알릴 필요가 없다면 무시해도 됨
        }
      });

      // **주의**: 여기서는 이미 set()까지 완료하여, UI에 "성공" 안내가 가능하도록 함
      // 이미지 업로드는 별도 Future.delayed로 처리하므로, 아래에서 바로 return
      return;
    } catch (e) {
      print('Failed to submit review: $e');
      throw e; // 상위에서 에러 처리를 위해 rethrow
    }
  }

// ——— 페이징 처리하여 리뷰 목록을 가져오는 함수
  Future<List<Map<String, dynamic>>> getPagedReviewItemsList({
    required String userEmail, // 사용자 이메일
    DocumentSnapshot? lastDocument, // 이전 페이지의 마지막 문서 (페이징용)
    required int limit, // 가져올 리뷰 수의 제한
  }) async {
    try {
      // 리뷰 페이징 데이터를 가져오는 로직
      print("사용자 $userEmail에 대한 리뷰 $limit개 가져오는 중");

      // ---------- (1) 'users' 컬렉션에서 userEmail에 대응하는 문서를 찾음 ----------
      // 기존에는 바로 wearcano_order_list.doc(userEmail)를 참조했으나,
      // 이제는 userEmail로 users 컬렉션에서 registration_id를 추출한 뒤, 그 값을 doc ID로 사용.
      final userQuerySnapshot = await firestore
          .collection('users')
          .where('registration_id', isEqualTo: userEmail)
          .limit(1)
          .get();

      // 만약 문서를 찾지 못하면 빈 리스트 반환
      if (userQuerySnapshot.docs.isEmpty) {
        print('해당 이메일과 일치하는 users 문서를 찾지 못했음: $userEmail');
        // 함수의 반환 타입이 Future<Map>이면 '[];'
        return [];
      }

      // 찾은 문서에서 registration_id 필드를 가져옴
      final userDocData = userQuerySnapshot.docs.first.data();
      final registrationId = userDocData['registration_id']?.toString() ?? '';

      // 만약 registration_id 필드가 없으면 빈 리스트 반환
      if (registrationId.isEmpty) {
        print('해당 users 문서에 registration_id가 없음: $userEmail');
        // 함수의 반환 타입이 Future<Map>이면 '[];'
        return [];
      }

      // ---------- (2) wearcano_order_list 컬렉션에서 doc(registrationId)로 참조 ----------
      // Firestore 컬렉션 쿼리 작성
      // (해당 쿼리 관련 파이어스토어 내 색인-index가 존재)
      // (상품 상세 화면 내 리뷰 탭 관련 색인과는 다르게 생성)
      Query query = firestore
          .collection('wearcano_review_list') // 리뷰 리스트 컬렉션
          .doc(registrationId) // 사용자별 문서 지정
          .collection('reviews') // 리뷰 하위 컬렉션
          .where('private_review_closed_button', isEqualTo: false) // 공개 상태 조건
          .orderBy('review_write_time', descending: true) // 리뷰 작성 시간 내림차순 정렬
          .limit(limit); // 가져올 데이터 수 제한

      // 이전 페이지의 마지막 문서가 있을 경우 이어서 가져옴
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument); // 페이징 시작점 설정
      }

      // 쿼리 실행 및 데이터 가져오기
      final querySnapshot = await query.get();

      print("사용자 $userEmail의 리뷰 ${querySnapshot.docs.length}개를 성공적으로 가져옴");

      // 가져온 데이터를 리스트로 변환
      return querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // 문서 데이터를 Map 형태로 변환
        data['id'] = doc.id; // 문서 ID 추가
        data['separator_key'] = doc.id; // 분리 키로 문서 ID 설정
        data['snapshot'] = doc; // 원본 문서 Snapshot 저장
        return data; // 변환된 데이터 반환
      }).toList();
    } catch (e) {
      // 데이터 가져오기 실패 시 예외 처리
      print('사용자 $userEmail의 리뷰 데이터를 가져오는 데 실패: $e');
      throw Exception('리뷰 데이터를 가져오는 데 실패: $e');
    }
  }

// ——— 리뷰를 삭제 처리하는 함수 (실제로는 삭제하지 않음)
  Future<void> deleteReview({
    required String userEmail, // 사용자 이메일
    required String separatorKey, // 삭제할 리뷰의 식별 키
  }) async {
    try {
      // 리뷰 숨김 처리 로직
      print("사용자 $userEmail의 separatorKey: $separatorKey 리뷰 숨김 처리 중");

      // ---------- (1) 'users' 컬렉션에서 userEmail에 대응하는 문서를 찾음 ----------
      // 기존에는 바로 wearcano_order_list.doc(userEmail)를 참조했으나,
      // 이제는 userEmail로 users 컬렉션에서 registration_id를 추출한 뒤, 그 값을 doc ID로 사용.
      final userQuerySnapshot = await firestore
          .collection('users')
          .where('registration_id', isEqualTo: userEmail)
          .limit(1)
          .get();

      // 만약 문서를 찾지 못하면 빈 리스트 반환
      if (userQuerySnapshot.docs.isEmpty) {
        print('해당 이메일과 일치하는 users 문서를 찾지 못했음: $userEmail');
        // 함수의 반환 타입이 Future<void>이면 그냥 'return;'
        return;
      }

      // 찾은 문서에서 registration_id 필드를 가져옴
      final userDocData = userQuerySnapshot.docs.first.data();
      final registrationId = userDocData['registration_id']?.toString() ?? '';

      // 만약 registration_id 필드가 없으면 빈 리스트 반환
      if (registrationId.isEmpty) {
        print('해당 users 문서에 registration_id가 없음: $userEmail');
        // 함수의 반환 타입이 Future<void>이면 그냥 'return;'
        return;
      }

      // ---------- (2) wearcano_order_list 컬렉션에서 doc(registrationId)로 참조 ----------
      // Firestore 문서 경로 생성
      final reviewDoc = firestore
          .collection('wearcano_review_list') // 리뷰 리스트 컬렉션
          .doc(registrationId) // 사용자별 문서 지정
          .collection('reviews') // 리뷰 하위 컬렉션
          .doc(separatorKey); // 리뷰 식별 키로 문서 지정

      // 문서 존재 여부 확인
      final docSnapshot = await reviewDoc.get();

      if (docSnapshot.exists) {
        // 문서가 존재하는 경우
        final DateTime reviewDeleteTime = DateTime.now(); // 현재 시간 저장

        // 문서 데이터 업데이트
        await reviewDoc.update({
          'private_review_closed_button': true, // 리뷰 숨김 처리
          'review_delete_time': reviewDeleteTime, // 삭제 처리 시간 기록
        });

        print("사용자 $userEmail의 separatorKey: $separatorKey 리뷰를 성공적으로 숨김 처리 완료");
      } else {
        // 문서가 존재하지 않는 경우 예외 처리
        print("separatorKey: $separatorKey에 해당하는 문서를 찾을 수 없음");
        throw Exception('separatorKey: $separatorKey에 해당하는 문서를 찾을 수 없음');
      }
    } catch (e) {
      // 리뷰 숨김 처리 실패 시 예외 처리
      print('separatorKey: $separatorKey 리뷰 숨김 처리 실패: $e');
      throw Exception('리뷰 숨김 처리 실패: $e');
    }
  }

  // 특정 상품에 대한 리뷰 데이터를 페이징 처리하여 가져오는 함수
  Future<List<Map<String, dynamic>>> getPagedProductReviews({
    required String productId,
    DocumentSnapshot? lastDocument,
    required int limit,
  }) async {
    try {
      print('리뷰 페이징 요청 시작: productId=$productId, lastDocument=${lastDocument?.id}, limit=$limit');

      // productId가 일치하고, 공개 상태(private_review_closed_button=false)인 리뷰를
      // 최근 작성 순(review_write_time 내림차순)으로 limit 개수만큼 가져오는 쿼리
      Query query = firestore
          .collectionGroup('reviews')
          .where('private_review_closed_button', isEqualTo: false)
          .where('product_id', isEqualTo: productId)
          .orderBy('review_write_time', descending: true)
          .limit(limit);

      // lastDocument가 있다면 해당 문서 이후의 데이터를 불러오도록 설정
      if (lastDocument != null) {
        print('lastDocument 이후 데이터부터 시작합니다: ${lastDocument.id}');
        query = query.startAfterDocument(lastDocument);
      }

      // 쿼리 실행
      final querySnapshot = await query.get();
      print('쿼리 결과 문서 수: ${querySnapshot.docs.length}개');

      // 문서 데이터를 Map 형태로 변환, 마지막 문서 스냅샷도 데이터에 포함
      final result = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['snapshot'] = doc;
        print('리뷰 데이터 변환 완료: id=${doc.id}');
        return data;
      }).toList();

      print('리뷰 데이터 페이징 완료: 총 ${result.length}개 반환');
      return result;
    } catch (e) {
      print('리뷰 페이징 데이터 불러오기 실패: $e');
      throw Exception('리뷰 데이터를 가져오는 중 오류 발생: $e');
    }
  }
}
// ------ 리뷰 관리 화면 내 데이터 처리 로직인 ReviewRepository 내용 끝 부분
