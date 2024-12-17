import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 패키지를 사용하기 위해 import
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore를 사용하기 위해 import
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage를 사용하기 위해 import
import '../../common/layout/common_body_parts_layout.dart';
import '../../product/model/product_model.dart'; // 제품 모델을 사용하기 위해 import

import 'package:crypto/crypto.dart'; // 해시 계산을 위한 crypto 패키지 사용
import 'dart:convert'; // utf8 변환을 위해 사용


// ------- 장바구니와 관련된 데이터를 Firebase에 저장하고 저장된 데이터를 불러오고 하는 관리 관련 데이터 처리 로직인 CartItemRepository 클래스 시작
// CartItemRepository 클래스는 Firestore와의 데이터 통신을 담당하는 역할
class CartItemRepository {
  final FirebaseFirestore firestore; // Firebase Firestore 인스턴스 변수 선언
  final FirebaseStorage storage; // Firebase Storage 인스턴스 변수 선언

  CartItemRepository(
      {required this.firestore, required this.storage}); // 생성자에서 firestore와 storage를 초기화

  // 이미지 URL을 Firebase Storage에 업로드하는 함수 - 주어진 이미지 URL을 가져와 Firebase Storage에 저장하고, 다운로드 URL을 반환
  Future<String> uploadImage(String imageUrl, String storagePath) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보 가져옴
    if (user == null) { // 사용자가 로그인되어 있지 않은 경우 예외 발생
      print('사용자가 로그인되어 있지 않습니다.');
      throw Exception('사용자가 로그인되어 있지 않습니다.'); // 예외 발생
    }
    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email; // 이메일 주소를 가져옴
    if (userEmail == null) {
      print('사용자 이메일을 가져올 수 없습니다.');
      throw Exception('사용자 이메일을 가져올 수 없습니다.');
    }
    print('이미지를 업로드합니다. URL: $imageUrl, 경로: $storagePath, 사용자: $userEmail');
    final response = await http.get(Uri.parse(imageUrl)); // 주어진 이미지 URL로부터 데이터를 가져옴
    final bytes = response.bodyBytes; // 이미지 데이터를 바이트로 변환
    final ref = storage.ref().child('$userEmail/$storagePath'); // Firebase Storage에 저장할 경로 생성
    await ref.putData(bytes, SettableMetadata(contentType: 'image/png')); // 이미지를 Firebase Storage에 저장
    final downloadUrl = await ref.getDownloadURL(); // 저장된 이미지의 다운로드 URL을 가져옴
    print('이미지 업로드 완료, 접근 가능 URL: $downloadUrl');
    return downloadUrl; // 다운로드 URL을 반환
  }

  // 장바구니에 아이템 추가하는 함수 - 선택된 색상, 사이즈, 수량 정보를 포함하여 장바구니 아이템을 Firestore에 추가
  Future<bool> addToCartItem(BuildContext context, ProductContent product, String? selectedColorText,
      String? selectedColorUrl, String? selectedSize, int selectedCount) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보 가져옴
    if (user == null) { // 사용자가 로그인되어 있지 않은 경우 예외 발생
      print('사용자가 로그인되어 있지 않습니다.');
      throw Exception('사용자가 로그인되어 있지 않습니다.'); // 예외 발생
    }
    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email; // 이메일 주소를 가져옴
    if (userEmail == null) {
      print('사용자 이메일을 가져올 수 없습니다.');
      throw Exception('사용자 이메일을 가져올 수 없습니다.');
    }

    // 중복 체크를 위한 해시 생성
    // 동일한 상품이 신상 및 겨울 등으로 여러 카테고리에 중복해서 있을 경우에도 동일한 상품으로 인식하도록 변경
    // 기존의 해시 생성 로직에서 ${product.docId}를 제외해서 문서는 달라도 다른 데이터가 동일하면 동일한 해시가 생성 -> 동일한 데이터로 인식해서 장바구니에 안 담기도록 함
    // 기존의 ${selectedCount}를 제외해서 선택된 수량만 다른 경우엔 새롭게 데이터를 저장하지 않고 기존 문서 내 'selected_count' 필드값만 변경해서 반영이 되도록 함!!
    final String combinedData = "${product.category}|${product.productNumber}|"
        "${product.thumbnail}|${product.briefIntroduction}|${product.originalPrice}|"
        "${product.discountPrice}|${product.discountPercent}|${selectedColorText}|${selectedColorUrl}|${selectedSize}";

    // 해시 생성 (SHA-256 사용)
    final String productHash = sha256.convert(utf8.encode(combinedData)).toString();

    // Firestore에 저장할 데이터 준비
    final data = {
      'product_id': product.docId, // 상품 상세 화면의 문서 id를 저장
      'category': product.category, // 상품의 카테고리 저장
      'product_number': product.productNumber, // 상품 번호
      'thumbnails': product.thumbnail, // 제품의 썸네일 이미지 URL
      'brief_introduction': product.briefIntroduction, // 제품의 간단한 소개
      'original_price': product.originalPrice, // 제품의 원래 가격
      'discount_price': product.discountPrice, // 제품의 할인 가격
      'discount_percent': product.discountPercent, // 제품의 할인율
      'selected_color_text': selectedColorText, // 선택한 색상의 텍스트 데이터 저장
      'selected_color_image': null, // 나중에 저장될 이미지 URL
      'selected_size': selectedSize, // 선택한 사이즈
      'selected_count': selectedCount, // 선택한 수량
      'product_hash': productHash, // 생성된 해시값을 함께 저장
      'timestamp': FieldValue.serverTimestamp(), // 현재 서버 타임스탬프를 저장
      'bool_checked': false, // 기본값으로 체크되지 않은 상태로 저장
    };

    // Firestore 내 동일한 해시값이 있는지 확인
    final querySnapshot = await firestore
        .collection('wearcano_cart_item')
        .doc(userEmail)
        .collection('items')
        .where('product_hash', isEqualTo: productHash) // 해시로 중복 여부 확인
        .get();

    // 동일한 문서가 있을 경우 처리
    // 꾸띠르 앱 프로젝트는 수량이 없으므로 동일한 문서가 있으면 장바구니에 담기지 않도록 하는게 맞지만 그와 달리 웨어카노 앱 프로젝트에선
    // 수량을 제외한 모든 데이터가 동일한 조건인 'product_hash', isEqualTo: productHash인 경우에
    // 선택한 수량이 기존 장바구니 데이터 문서의 수량 관련 필드값에 반영되어 변경되도록 해야함
    // 이래야 새롭게 담기진 않지만 기존 동일한 상품이 장바구니엔 담기지만 수량만 증가하는 식으로 보여야 함!!
    if (querySnapshot.docs.isNotEmpty) {
      // 기존 문서가 있는 경우, 수량을 더하여 업데이트
      final existingDoc = querySnapshot.docs.first;
      final int existingCount = existingDoc['selected_count'] ?? 1;
      await existingDoc.reference.update({'selected_count': existingCount + selectedCount});
      print('기존 장바구니 아이템의 수량이 업데이트되었습니다: ${existingCount + selectedCount}');
      showCustomSnackBar(context, '장바구니 내 동일한 상품의 수량에 선택한 수량이 반영되었습니다.');
      return false;
    }

    print('상품을 장바구니에 추가합니다. 상품 ID: ${product.docId}, 선택 색상: $selectedColorText, 선택 사이즈: $selectedSize, 선택한 수량: $selectedCount');

    // 파이어스토리지에 저장할 경로 생성
    final storagePath = 'wearcano_cart_item_image/cart_${DateTime.now().millisecondsSinceEpoch}'; // 저장할 경로 생성

    // 썸네일 이미지 저장
    if (product.thumbnail != null) { // 썸네일 이미지가 있을 경우
      final thumbnailUrl = await uploadImage(product.thumbnail!,
          '$storagePath/thumbnails'); // 썸네일 이미지를 업로드하고 URL을 가져옴
      data['thumbnails'] = thumbnailUrl; // 데이터를 업데이트
      print('썸네일 이미지 업로드 완료: $thumbnailUrl');
    }

    // 선택한 색상 이미지 저장
    if (selectedColorUrl != null) { // 선택한 색상 이미지가 있을 경우
      final colorImageUrl = await uploadImage(selectedColorUrl,
          '$storagePath/selected_color'); // 색상 이미지를 업로드하고 URL을 가져옴
      data['selected_color_image'] = colorImageUrl; // 데이터를 업데이트
      print('선택된 색상 이미지 업로드 완료: $colorImageUrl');
    }

    // Firestore에 데이터 저장 - 문서 ID를 타임스탬프 기반으로 설정하여 최신순으로 정렬되도록 함
    await firestore.collection('wearcano_cart_item').doc(userEmail).collection('items').doc('${DateTime.now().millisecondsSinceEpoch}').set(data);
    print('상품이 장바구니에 추가되었습니다. 사용자: $userEmail');

    return true; // 성공적으로 저장되면 true 반환
  }

// Firestore에서 장바구니 아이템을 페이징 처리하여 불러오는 함수
  Future<List<Map<String, dynamic>>> getPagedCartItems({DocumentSnapshot? lastDocument, required int limit}) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보를 가져옴
    final userEmail = user?.email; // 사용자의 이메일 주소를 가져옴
    if (userEmail == null) throw Exception('사용자가 로그인되어 있지 않습니다.'); // 사용자가 로그인하지 않은 경우 예외를 발생시킴

    print("Firestore에서 ${limit}개씩 데이터를 불러옵니다. 마지막 문서: $lastDocument"); // Firestore에서 지정한 갯수만큼 데이터를 불러온다는 메시지를 출력함

    Query query = firestore.collection('wearcano_cart_item').doc(userEmail).collection('items').orderBy('timestamp', descending: true).limit(limit);
    // Firestore에서 사용자의 장바구니 아이템을 'timestamp'로 내림차순 정렬하고 지정한 개수만큼 데이터를 가져오도록 쿼리를 작성함
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument); // 마지막 문서 이후부터 데이터를 불러옴
      print("이전 데이터 이후로 데이터를 불러옵니다."); // 마지막 문서 이후 데이터를 불러온다는 메시지를 출력함
    }

    final querySnapshot = await query.get(); // Firestore 쿼리를 실행하여 결과를 가져옴

    print("가져온 문서 수: ${querySnapshot.docs.length}"); // 가져온 문서의 수를 출력함

    // querySnapshot.docs.map()에서 반환되는 데이터를 정확히 Map<String, dynamic>으로 변환함
    return querySnapshot.docs.map((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // 명시적으로 데이터를 Map<String, dynamic>으로 캐스팅함
      data['id'] = doc.id;  // 문서의 ID를 명시적으로 추가함
      data['snapshot'] = doc; // 마지막 문서를 기록함
      print("불러온 데이터: ${data['product_id']}"); // 불러온 데이터의 product_id를 출력함
      return data;
    }).toList(); // 데이터를 리스트로 변환하여 반환함
  }

// 장바구니의 특정 아이템에 대한 실시간 구독 스트림을 제공하는 함수
  Stream<Map<String, dynamic>> cartItemStream(String itemId) {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보를 가져옴
    final userEmail = user?.email; // 사용자의 이메일 주소를 가져옴
    if (userEmail == null) throw Exception('사용자가 로그인되어 있지 않습니다.'); // 사용자가 로그인하지 않은 경우 예외를 발생시킴

    return firestore.collection('wearcano_cart_item')
        .doc(userEmail)
        .collection('items')
        .doc(itemId)
        .snapshots() // 지정한 아이템에 대한 실시간 스트림을 구독함
        .handleError((error) { // 구독 중 오류가 발생하면 처리함
      print('cartItemStream에서 오류 발생: $error'); // 오류 메시지를 출력함
    }).map((docSnapshot) {
      if (docSnapshot.exists) { // 문서가 존재하는 경우
        final data = docSnapshot.data() as Map<String, dynamic>; // 문서 데이터를 Map<String, dynamic>으로 변환함
        data['id'] = docSnapshot.id; // 문서의 ID를 명시적으로 추가함
        return data;
      } else {
        // 문서가 존재하지 않는 경우 구독을 해제함
        print('itemId에 대한 문서가 존재하지 않습니다: $itemId'); // 문서가 존재하지 않음을 출력함
        return null; // 예외를 던지지 않고 null을 반환함
      }
    }).where((data) => data != null).cast<Map<String, dynamic>>(); // null 값을 필터링하여 스트림에서 제외함
  }

  // Firestore에서 가져온 수량 데이터를 업데이트하는 함수
  Future<void> updateCartItemQuantity(String docId, int newQuantity) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보 가져옴
    if (user == null) { // 사용자가 로그인되어 있지 않은 경우 예외 발생
      print('사용자가 로그인되어 있지 않습니다.');
      throw Exception('사용자가 로그인되어 있지 않습니다.'); // 예외 발생
    }
    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email; // 이메일 주소를 가져옴
    if (userEmail == null) {
      print('사용자 이메일을 가져올 수 없습니다.');
      throw Exception('사용자 이메일을 가져올 수 없습니다.');
    }
    print('사용자 $userEmail의 장바구니 아이템 문서 ID: $docId의 수량을 $newQuantity로 업데이트합니다.');
    await firestore.collection('wearcano_cart_item').doc(userEmail).collection('items').doc(docId).update({ // 주어진 문서 ID에 해당하는 문서의 'selected_count' 필드를 업데이트함
      'selected_count': newQuantity, // 새로운 수량으로 업데이트
    });
    print('문서 ID: $docId의 장바구니 아이템 수량이 업데이트되었습니다.');
  }

// 장바구니 화면 내에서 상품 아이템을 '삭제' 버튼 클릭 시, Firestore에서 삭제되도록 하는 함수
  Future<void> removeCartItem(String docId) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보를 가져옴
    if (user == null) { // 사용자가 로그인되어 있지 않은 경우 예외를 발생시킴
      print('사용자가 로그인되어 있지 않습니다.');
      throw Exception('사용자가 로그인되어 있지 않습니다.'); // 예외를 발생시킴
    }
    final userEmail = user.email; // 현재 로그인한 사용자의 이메일 주소를 가져옴
    if (userEmail == null) {
      print('사용자 이메일을 가져올 수 없습니다.'); // 사용자의 이메일이 없는 경우 예외를 발생시킴
      throw Exception('사용자 이메일을 가져올 수 없습니다.');
    }
    print('장바구니 아이템을 삭제합니다. 문서 ID: $docId, 사용자: $userEmail'); // 삭제할 문서 ID와 사용자를 출력함
    await firestore.collection('wearcano_cart_item').doc(userEmail).collection('items').doc(docId).delete(); // 주어진 문서 ID에 해당하는 문서를 Firestore에서 삭제함
    print('장바구니 아이템 삭제 완료: 문서 ID: $docId'); // 문서 삭제 완료 메시지를 출력함
  }

  // Firestore에서 특정 아이템의 체크 상태를 업데이트하는 함수인 updateCartItemChecked
  Future<void> updateCartItemChecked(String id, bool checked) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보 가져옴
    if (user == null) { // 사용자가 로그인되어 있지 않은 경우 예외 발생
      print('사용자가 로그인되어 있지 않습니다.');
      throw Exception('사용자가 로그인되어 있지 않습니다.'); // 예외 발생
    }
    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email; // 이메일 주소를 가져옴
    if (userEmail == null) {
      print('사용자 이메일을 가져올 수 없습니다.');
      throw Exception('사용자 이메일을 가져올 수 없습니다.');
    }
    print('장바구니 아이템 체크 상태를 업데이트합니다. ID: $id, 상태: $checked, 사용자: $userEmail');
    await firestore.collection('wearcano_cart_item').doc(userEmail).collection('items').doc(id).update({'bool_checked': checked}); // 주어진 ID에 해당하는 문서의 체크 상태를 업데이트
    print('장바구니 아이템 체크 상태 업데이트 완료: ID: $id');
  }

  // 새로 추가되는 함수: 현재 로그인한 사용자의 모든 장바구니 아이템의 bool_checked 필드를 false로 업데이트
  Future<void> resetAllCartItemsChecked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('사용자가 로그인되어 있지 않습니다.');
      // throw Exception('사용자가 로그인되어 있지 않습니다.');
      return; // 예외를 던지지 않고 함수 종료
    }
    final userEmail = user.email;
    if (userEmail == null) {
      print('사용자 이메일을 가져올 수 없습니다.');
      // throw Exception('사용자 이메일을 가져올 수 없습니다.');
      return; // 예외를 던지지 않고 함수 종료
    }

    print('사용자 $userEmail의 모든 장바구니 아이템의 bool_checked 필드를 false로 업데이트합니다.');

    final collectionRef = firestore.collection('wearcano_cart_item')
        .doc(userEmail)
        .collection('items');

    // Firestore의 batch 기능을 사용해 모든 문서에 대해서 bool_checked를 false로 변경
    final querySnapshot = await collectionRef.get();
    if (querySnapshot.docs.isNotEmpty) {
      WriteBatch batch = firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'bool_checked': false});
      }
      await batch.commit();
      print('모든 장바구니 아이템 bool_checked 필드 값이 false로 초기화되었습니다.');
    } else {
      print('장바구니 아이템이 없습니다. 초기화할 것이 없습니다.');
    }
  }

}
// ------- 장바구니와 관련된 데이터를 Firebase에 저장하고 저장된 데이터를 불러오고 하는 관리 관련 데이터 처리 로직인 CartItemRepository 클래스 끝

// ------- 장바구니 아이콘과 관련된 데이터를 Firebase에 저장하고 저장된 데이터를 불러오고 하는 관리 관련 데이터 차리 로직인 CartIconRepository 클래스 시작
class CartIconRepository {
  final FirebaseFirestore firestore;

  CartIconRepository({required this.firestore});

  // 장바구니 문서 갯수를 구독하는 함수
  Stream<int> watchCartItemCount() {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;

    if (userEmail == null) {
      // 사용자 인증 정보가 없으면 빈 스트림 반환
      return Stream.value(0);
    }

    // Firestore 경로에서 문서 개수를 실시간으로 반환
    return firestore
        .collection('wearcano_cart_item')
        .doc(userEmail)
        .collection('items')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
// ------- 장바구니 아이콘과 관련된 데이터를 Firebase에 저장하고 저장된 데이터를 불러오고 하는 관리 관련 데이터 차리 로직인 CartIconRepository 클래스 끝