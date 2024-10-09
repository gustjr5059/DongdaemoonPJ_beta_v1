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
      print('User not logged in');
      throw Exception('User not logged in'); // 예외 발생
    }
    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email; // 이메일 주소를 가져옴
    if (userEmail == null) {
      print('User email not available');
      throw Exception('User email not available');
    }
    print('Uploading image from URL: $imageUrl to path: $storagePath for user: $userEmail');
    final response = await http.get(Uri.parse(imageUrl)); // 주어진 이미지 URL로부터 데이터를 가져옴
    final bytes = response.bodyBytes; // 이미지 데이터를 바이트로 변환
    final ref = storage.ref().child('$userEmail/$storagePath'); // Firebase Storage에 저장할 경로 생성
    await ref.putData(bytes, SettableMetadata(contentType: 'image/png')); // 이미지를 Firebase Storage에 저장
    final downloadUrl = await ref.getDownloadURL(); // 저장된 이미지의 다운로드 URL을 가져옴
    print('Image uploaded and accessible at: $downloadUrl');
    return downloadUrl; // 다운로드 URL을 반환
  }

  // 장바구니에 아이템 추가하는 함수 - 선택된 색상, 사이즈, 수량 정보를 포함하여 장바구니 아이템을 Firestore에 추가
  Future<bool> addToCartItem(BuildContext context, ProductContent product, String? selectedColorText,
      String? selectedColorUrl, String? selectedSize, int selectedCount) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보 가져옴
    if (user == null) { // 사용자가 로그인되어 있지 않은 경우 예외 발생
      print('User not logged in');
      throw Exception('User not logged in'); // 예외 발생
    }
    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email; // 이메일 주소를 가져옴
    if (userEmail == null) {
      print('User email not available');
      throw Exception('User email not available');
    }

    // 중복 체크를 위한 해시 생성
    final String combinedData = "${product.docId}|${product.category}|${product.productNumber}|"
        "${product.thumbnail}|${product.briefIntroduction}|${product.originalPrice}|"
        "${product.discountPrice}|${product.discountPercent}|${selectedColorText}|${selectedColorUrl}|${selectedSize}|${selectedCount}";

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
        .collection('cart_item')
        .doc(userEmail)
        .collection('items')
        .where('product_hash', isEqualTo: productHash) // 해시로 중복 여부 확인
        .get();

    // 동일한 문서가 있을 경우 처리
    if (querySnapshot.docs.isNotEmpty) {
      print('해당 상품은 이미 장바구니에 담겨 있습니다.');
      showCustomSnackBar(context, '해당 상품은 이미 장바구니에 담겨 있습니다.');
      return false; // 중복이 있으면 false 반환하여 성공 메시지 표시하지 않음
    }

    print('Adding product to cart: ${product.docId}, selected color: $selectedColorText, size: $selectedSize, count: $selectedCount');

    // 파이어스토리지에 저장할 경로 생성
    final storagePath = 'cart_item_image/cart_${DateTime.now().millisecondsSinceEpoch}'; // 저장할 경로 생성

    // 썸네일 이미지 저장
    if (product.thumbnail != null) { // 썸네일 이미지가 있을 경우
      final thumbnailUrl = await uploadImage(product.thumbnail!,
          '$storagePath/thumbnails'); // 썸네일 이미지를 업로드하고 URL을 가져옴
      data['thumbnails'] = thumbnailUrl; // 데이터를 업데이트
      print('Thumbnail image uploaded and added to data: $thumbnailUrl');
    }

    // 선택한 색상 이미지 저장
    if (selectedColorUrl != null) { // 선택한 색상 이미지가 있을 경우
      final colorImageUrl = await uploadImage(selectedColorUrl,
          '$storagePath/selected_color'); // 색상 이미지를 업로드하고 URL을 가져옴
      data['selected_color_image'] = colorImageUrl; // 데이터를 업데이트
      print('Selected color image uploaded and added to data: $colorImageUrl');
    }

    // Firestore에 데이터 저장 - 문서 ID를 타임스탬프 기반으로 설정하여 최신순으로 정렬되도록 함
    await firestore.collection('cart_item').doc(userEmail).collection('items').doc('${DateTime.now().millisecondsSinceEpoch}').set(data);
    print('Product added to cart for user: $userEmail');

    return true; // 성공적으로 저장되면 true 반환
  }

// Firestore에서 장바구니 아이템을 페이징 처리하여 불러오는 함수
  Future<List<Map<String, dynamic>>> getPagedCartItems({DocumentSnapshot? lastDocument, required int limit}) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보를 가져옴
    final userEmail = user?.email; // 사용자의 이메일 주소를 가져옴
    if (userEmail == null) throw Exception('User not logged in'); // 사용자가 로그인하지 않은 경우 예외를 발생시킴

    print("Firestore에서 ${limit}개씩 데이터를 불러옵니다. 마지막 문서: $lastDocument"); // Firestore에서 지정한 갯수만큼 데이터를 불러온다는 메시지를 출력함

    Query query = firestore.collection('cart_item').doc(userEmail).collection('items').orderBy('timestamp', descending: true).limit(limit);
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
    if (userEmail == null) throw Exception('User not logged in'); // 사용자가 로그인하지 않은 경우 예외를 발생시킴

    return firestore.collection('cart_item')
        .doc(userEmail)
        .collection('items')
        .doc(itemId)
        .snapshots() // 지정한 아이템에 대한 실시간 스트림을 구독함
        .handleError((error) { // 구독 중 오류가 발생하면 처리함
      print('Error in cartItemStream: $error'); // 오류 메시지를 출력함
    }).map((docSnapshot) {
      if (docSnapshot.exists) { // 문서가 존재하는 경우
        final data = docSnapshot.data() as Map<String, dynamic>; // 문서 데이터를 Map<String, dynamic>으로 변환함
        data['id'] = docSnapshot.id; // 문서의 ID를 명시적으로 추가함
        return data;
      } else {
        // 문서가 존재하지 않는 경우 구독을 해제함
        print('Document does not exist for itemId: $itemId'); // 문서가 존재하지 않음을 출력함
        return null; // 예외를 던지지 않고 null을 반환함
      }
    }).where((data) => data != null).cast<Map<String, dynamic>>(); // null 값을 필터링하여 스트림에서 제외함
  }

  // Firestore에서 가져온 수량 데이터를 업데이트하는 함수
  Future<void> updateCartItemQuantity(String docId, int newQuantity) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보 가져옴
    if (user == null) { // 사용자가 로그인되어 있지 않은 경우 예외 발생
      print('User not logged in');
      throw Exception('User not logged in'); // 예외 발생
    }
    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email; // 이메일 주소를 가져옴
    if (userEmail == null) {
      print('User email not available');
      throw Exception('User email not available');
    }
    print('Updating cart item quantity for docId: $docId to $newQuantity for user: $userEmail');
    await firestore.collection('cart_item').doc(userEmail).collection('items').doc(docId).update({ // 주어진 문서 ID에 해당하는 문서의 'selected_count' 필드를 업데이트함
      'selected_count': newQuantity, // 새로운 수량으로 업데이트
    });
    print('Cart item quantity updated for docId: $docId');
  }

// 장바구니 화면 내에서 상품 아이템을 '삭제' 버튼 클릭 시, Firestore에서 삭제되도록 하는 함수
  Future<void> removeCartItem(String docId) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보를 가져옴
    if (user == null) { // 사용자가 로그인되어 있지 않은 경우 예외를 발생시킴
      print('User not logged in');
      throw Exception('User not logged in'); // 예외를 발생시킴
    }
    final userEmail = user.email; // 현재 로그인한 사용자의 이메일 주소를 가져옴
    if (userEmail == null) {
      print('User email not available'); // 사용자의 이메일이 없는 경우 예외를 발생시킴
      throw Exception('User email not available');
    }
    print('Removing cart item for docId: $docId for user: $userEmail'); // 삭제할 문서 ID와 사용자를 출력함
    await firestore.collection('cart_item').doc(userEmail).collection('items').doc(docId).delete(); // 주어진 문서 ID에 해당하는 문서를 Firestore에서 삭제함
    print('Cart item removed for docId: $docId'); // 문서 삭제 완료 메시지를 출력함
  }

  // Firestore에서 특정 아이템의 체크 상태를 업데이트하는 함수인 updateCartItemChecked
  Future<void> updateCartItemChecked(String id, bool checked) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인한 사용자 정보 가져옴
    if (user == null) { // 사용자가 로그인되어 있지 않은 경우 예외 발생
      print('User not logged in');
      throw Exception('User not logged in'); // 예외 발생
    }
    // 현재 로그인한 사용자 이메일 가져옴
    final userEmail = user.email; // 이메일 주소를 가져옴
    if (userEmail == null) {
      print('User email not available');
      throw Exception('User email not available');
    }
    print('Updating cart item checked status for id: $id to $checked for user: $userEmail');
    await firestore.collection('cart_item').doc(userEmail).collection('items').doc(id).update({'bool_checked': checked}); // 주어진 ID에 해당하는 문서의 체크 상태를 업데이트
    print('Cart item checked status updated for id: $id');
  }
}
// ------- 장바구니와 관련된 데이터를 Firebase에 저장하고 저장된 데이터를 불러오고 하는 관리 관련 데이터 처리 로직인 CartItemRepository 클래스 끝
