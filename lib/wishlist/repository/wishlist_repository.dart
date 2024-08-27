import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http; // http 패키지를 사용하기 위해 import
import 'package:cloud_firestore/cloud_firestore.dart'; // Cloud Firestore 패키지 import
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage 패키지 import
import '../../product/model/product_model.dart'; // Product 모델 클래스 import

// ------- 찜 목록 항목을 관리하는 Repository 클래스인 WishlistItemRepository 내용 구현 시작
class WishlistItemRepository {
  final FirebaseFirestore firestore; // Firebase Firestore 인스턴스 변수 선언
  final FirebaseStorage storage; // Firebase Storage 인스턴스 변수 선언

  WishlistItemRepository(
      {required this.firestore, required this.storage}); // 생성자에서 firestore와 storage를 초기화

  // 이미지 URL을 Firebase Storage에 업로드하는 함수 - 주어진 이미지 URL을 가져와 Firebase Storage에 저장하고, 다운로드 URL을 반환
  Future<String> uploadImage(String imageUrl, String storagePath) async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser!.email!; // 현재 로그인한 사용자 Email 가져옴
      print('Uploading image for user: $userEmail to path: $storagePath'); // 디버깅 메시지 추가
      final response = await http.get(Uri.parse(imageUrl)); // 주어진 이미지 URL로부터 데이터를 가져옴
      final bytes = response.bodyBytes; // 이미지 데이터를 바이트로 변환
      final ref = storage.ref().child('$userEmail/$storagePath'); // Firebase Storage에 저장할 경로 생성
      await ref.putData(bytes, SettableMetadata(contentType: 'image/png')); // 이미지를 Firebase Storage에 저장
      final downloadUrl = await ref.getDownloadURL(); // 저장된 이미지의 다운로드 URL을 가져옴
      print('Image uploaded successfully. Download URL: $downloadUrl'); // 업로드 완료 메시지 출력
      return downloadUrl; // 다운로드 URL을 반환
    } catch (e) {
      print('Error uploading image: $e'); // 오류 메시지 출력
      rethrow; // 오류 발생 시 다시 던짐
    }
  }

  // 찜 목록에 항목을 추가하는 함수
  Future<void> addToWishlistItem(String userId, ProductContent product) async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser!.email!; // 현재 로그인한 사용자 이메일을 가져옴
      print('Adding product to wishlist for user: $userEmail'); // 디버깅 메시지 추가
      // Firestore에 저장할 데이터 생성
      final data = {
        'product_id': product.docId, // 상품 ID
        'thumbnails': product.thumbnail, // 상품 썸네일
        'brief_introduction': product.briefIntroduction, // 간단한 소개
        'original_price': product.originalPrice, // 원래 가격
        'discount_price': product.discountPrice, // 할인 가격
        'discount_percent': product.discountPercent, // 할인율
        'timestamp': FieldValue.serverTimestamp(), // 서버 타임스탬프
      };

      // 파이어스토리지에 저장할 경로 생성
      final storagePath = 'wishlist_item_image/$userEmail/wishlist_${DateTime.now().millisecondsSinceEpoch}';
      // 저장할 경로 생성

      // 썸네일 이미지 저장
      if (product.thumbnail != null) { // 썸네일 이미지가 있을 경우
        print('Uploading thumbnail image for product: ${product.docId}'); // 디버깅 메시지 추가
        final thumbnailUrl = await uploadImage(product.thumbnail!,
            '$storagePath/thumbnails'); // 썸네일 이미지를 업로드하고 URL을 가져옴
        data['thumbnails'] = thumbnailUrl; // 데이터를 업데이트
      }

      // Firestore에 데이터 저장
      final docId = '${DateTime.now().millisecondsSinceEpoch}';
      print('Saving wishlist item with ID: $docId to Firestore'); // 디버깅 메시지 추가
      await firestore.collection('wishlist_item').doc(userEmail).collection('items').doc(docId).set(data);
      print('Wishlist item added successfully for product: ${product.docId}'); // 성공 메시지 출력
    } catch (e) {
      print('Error adding to wishlist: $e'); // 오류 메시지 출력
      rethrow; // 오류 발생 시 다시 던짐
    }
  }

  // 찜 목록에서 항목을 제거하는 함수
  Future<void> removeFromWishlistItem(String userId, String productId) async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser!.email!; // 현재 로그인한 사용자 이메일 가져옴
      print('Removing product from wishlist for user: $userEmail'); // 디버깅 메시지 추가
      // Firestore에서 해당 상품 ID를 가진 문서를 검색
      final snapshot = await firestore.collection('wishlist_item').doc(userEmail).collection('items').where('product_id', isEqualTo: productId).get();
      for (var doc in snapshot.docs) {
        print('Deleting wishlist item with ID: ${doc.id}'); // 삭제할 항목의 ID 출력
        // 해당 문서를 Firestore에서 삭제
        await firestore.collection('wishlist_item').doc(userEmail).collection('items').doc(doc.id).delete();
        try {
          // Firebase Storage에서 해당 이미지를 삭제
          await storage.ref('wishlist_item_image/$userEmail/${doc.id}').delete();
          print('Deleted image from storage with path: wishlist_item_image/$userEmail/${doc.id}'); // 삭제 완료 메시지 출력
        } catch (e) {
          if (e is FirebaseException && e.code == 'object-not-found') {
            print('Image not found in storage for path: wishlist_item_image/$userEmail/${doc.id}'); // 이미지가 없는 경우 메시지 출력
          } else {
            print('Error deleting image from storage: $e'); // 다른 오류 발생 시 메시지 출력
            rethrow; // 오류 발생 시 다시 던짐
          }
        }
      }
      print('Product removed from wishlist successfully for product ID: $productId'); // 성공 메시지 출력
    } catch (e) {
      print('Error removing from wishlist: $e'); // 오류 메시지 출력
      rethrow; // 오류 발생 시 다시 던짐
    }
  }
}
// ------- 찜 목록 항목을 관리하는 Repository 클래스인 WishlistItemRepository 내용 구현 끝