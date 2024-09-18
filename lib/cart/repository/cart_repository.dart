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
      String? selectedColorUrl, String? selectedSize) async {
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
      'product_hash': productHash, // 생성된 해시값을 함께 저장
      'timestamp': FieldValue.serverTimestamp(), // 현재 서버 타임스탬프를 저장
      'bool_checked': false, // 기본값으로 체크되지 않은 상태로 저장
    };

    // Firestore 내 동일한 해시값이 있는지 확인
    final querySnapshot = await firestore
        .collection('couture_request_item')
        .doc(userEmail)
        .collection('items')
        .where('product_hash', isEqualTo: productHash) // 해시로 중복 여부 확인
        .get();

    // 동일한 문서가 있을 경우 처리
    if (querySnapshot.docs.isNotEmpty) {
      print('해당 상품은 이미 요청품목에 담겨 있습니다.');
      showCustomSnackBar(context, '해당 상품은 이미 요청품목에 담겨 있습니다.');
      return false; // 중복이 있으면 false 반환하여 성공 메시지 표시하지 않음
    }

    print('Adding product to cart: ${product.docId}, selected color: $selectedColorText, size: $selectedSize');

    // 파이어스토리지에 저장할 경로 생성
    final storagePath = 'couture_request_item_image/couture_request_${DateTime.now().millisecondsSinceEpoch}'; // 저장할 경로 생성

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
    await firestore.collection('couture_request_item').doc(userEmail).collection('items').doc('${DateTime.now().millisecondsSinceEpoch}').set(data);
    print('Product added to cart for user: $userEmail');

    return true; // 성공적으로 저장되면 true 반환
  }

  // Firestore에서 장바구니 아이템 목록을 가져오는 함수 - Firestore에서 'cart_item' 컬렉션의 문서를 가져와 List로 반환
  Future<List<Map<String, dynamic>>> getCartItems() async {
    // 'cart_item' 컬렉션에서 모든 문서를 'timestamp' 필드 기준으로 내림차순 정렬하여 가져옴
    // - 장바구니 화면 내 timestamp인 필드 데이터를 가지고 내림차순으로 상품 데이터를 정렬하여 최신 데이터가 제일 상단에 위치하도록 함
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
    print('Fetching cart items for user: $userEmail');
    final querySnapshot = await firestore.collection('couture_request_item').doc(userEmail).collection('items').orderBy('timestamp', descending: true).get(); // 'cart_item' 컬렉션에서 모든 문서를 'timestamp' 필드 기준으로 내림차순 정렬하여 가져옴
    print('Cart items fetched: ${querySnapshot.docs.length}');
    return querySnapshot.docs.map((doc) { // 가져온 문서들을 순회하여 리스트로 반환
      final data = doc.data(); // 문서 데이터를 가져옴
      data['id'] = doc.id; // 문서 ID를 데이터에 추가함
      print('Cart item processed: ${data['product_id']}');
      return data; // 데이터 반환
    }).toList();
  }

  // 장바구니 화면 내에서 상품 아이템을 '삭제' 버튼 클릭 시, Firestore에서 삭제되도록 하는 함수
  Future<void> removeCartItem(String docId) async {
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
    print('Removing cart item for docId: $docId for user: $userEmail');
    await firestore.collection('couture_request_item').doc(userEmail).collection('items').doc(docId).delete(); // 주어진 문서 ID에 해당하는 문서를 Firestore에서 삭제
    print('Cart item removed for docId: $docId');
  }

  // Firestore에서 장바구니 아이템 스트림을 가져오는 함수
  Stream<List<Map<String, dynamic>>> cartItemsStream() {
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
    print('Subscribing to cart items stream for user: $userEmail');
    // Firestore의 'cart_item' 컬렉션을 timestamp 내림차순으로 정렬하여 가져옴.
    return firestore.collection('couture_request_item').doc(userEmail).collection('items').orderBy('timestamp', descending: true).snapshots().map((querySnapshot) {
      print('Cart items snapshot received with ${querySnapshot.docs.length} items');
      // 쿼리 결과를 문서 목록으로 변환.
      return querySnapshot.docs.map((doc) {
        // 각 문서의 데이터를 가져옴.
        final data = doc.data();
        // 문서의 ID를 데이터에 추가.
        data['id'] = doc.id;
        print('Cart item snapshot processed: ${data['product_id']}');
        // 데이터를 반환.
        return data;
        // 변환된 데이터를 리스트로 변환하여 반환.
      }).toList();
    });
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
    await firestore.collection('couture_request_item').doc(userEmail).collection('items').doc(id).update({'bool_checked': checked}); // 주어진 ID에 해당하는 문서의 체크 상태를 업데이트
    print('Cart item checked status updated for id: $id');
  }
}
// ------- 장바구니와 관련된 데이터를 Firebase에 저장하고 저장된 데이터를 불러오고 하는 관리 관련 데이터 처리 로직인 CartItemRepository 클래스 끝
