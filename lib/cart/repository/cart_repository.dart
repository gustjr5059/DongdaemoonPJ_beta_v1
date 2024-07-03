import 'package:http/http.dart' as http; // http 패키지를 사용하기 위해 import
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore를 사용하기 위해 import
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage를 사용하기 위해 import
import '../../product/model/product_model.dart'; // 제품 모델을 사용하기 위해 import

// ------- 장바구니와 관련된 데이터를 Firebase에 저장하고 저장된 데이터를 불러오고 하는 관리 관련 데이터 처리 로직인 CartItemRepository 클래스 시작
// CartItemRepository 클래스는 Firestore와의 데이터 통신을 담당하는 역할
class CartItemRepository {
  final FirebaseFirestore firestore; // Firebase Firestore 인스턴스 변수 선언
  final FirebaseStorage storage; // Firebase Storage 인스턴스 변수 선언

  CartItemRepository(
      {required this.firestore, required this.storage}); // 생성자에서 firestore와 storage를 초기화

  // Firestore에서 장바구니 아이템 개수 가져오는 함수 - Firestore에서 'cart_item' 컬렉션의 문서 개수를 반환
  Future<int> getCartItemCount() async {
    final querySnapshot = await firestore.collection('cart_item').get(); // 'cart_item' 컬렉션의 모든 문서를 가져옴
    return querySnapshot.docs.length; // 문서의 개수를 반환
  }

  // 이미지 URL을 Firebase Storage에 업로드하는 함수 - 주어진 이미지 URL을 가져와 Firebase Storage에 저장하고, 다운로드 URL을 반환
  Future<String> uploadImage(String imageUrl, String storagePath) async {
    final response = await http.get(Uri.parse(imageUrl)); // 주어진 이미지 URL로부터 데이터를 가져옴
    final bytes = response.bodyBytes; // 이미지 데이터를 바이트로 변환
    final ref = storage.ref().child(storagePath); // Firebase Storage에 저장할 경로 생성
    await ref.putData(bytes, SettableMetadata(contentType: 'image/png')); // 이미지를 Firebase Storage에 저장
    final downloadUrl = await ref.getDownloadURL(); // 저장된 이미지의 다운로드 URL을 가져옴
    return downloadUrl; // 다운로드 URL을 반환
  }

  // 장바구니에 아이템 추가하는 함수 - 선택된 색상, 사이즈, 수량 정보를 포함하여 장바구니 아이템을 Firestore에 추가
  Future<void> addToCartItem(ProductContent product, String? selectedColorText,
      String? selectedColorUrl, String? selectedSize, int quantity) async {
    // Firestore에 저장할 문서명 생성
    final cartItemCount = await getCartItemCount(); // 현재 장바구니 아이템 개수를 가져옴
    final newDocName = 'cart_item_${cartItemCount + 1}'; // 새로운 문서명을 생성

    // Firestore에 저장할 데이터 준비
    final data = {
      'thumbnails': product.thumbnail, // 제품의 썸네일 이미지 URL
      'brief_introduction': product.briefIntroduction, // 제품의 간단한 소개
      'original_price': product.originalPrice, // 제품의 원래 가격
      'discount_price': product.discountPrice, // 제품의 할인 가격
      'discount_percent': product.discountPercent, // 제품의 할인율
      'selected_color_text': selectedColorText, // 선택한 색상의 텍스트 데이터 저장
      'selected_color_image': null, // 나중에 저장될 이미지 URL
      'selected_size': selectedSize, // 선택한 사이즈
      'selected_count': quantity, // 선택한 수량
    };

    // 파이어스토리지에 저장할 경로 생성
    final storagePath = 'cart_item_image/cart_$newDocName'; // 저장할 경로 생성

    // 썸네일 이미지 저장
    if (product.thumbnail != null) { // 썸네일 이미지가 있을 경우
      final thumbnailUrl = await uploadImage(product.thumbnail!,
          '$storagePath/thumbnails'); // 썸네일 이미지를 업로드하고 URL을 가져옴
      data['thumbnails'] = thumbnailUrl; // 데이터를 업데이트
    }

    // 선택한 색상 이미지 저장
    if (selectedColorUrl != null) { // 선택한 색상 이미지가 있을 경우
      final colorImageUrl = await uploadImage(selectedColorUrl,
          '$storagePath/selected_color'); // 색상 이미지를 업로드하고 URL을 가져옴
      data['selected_color_image'] = colorImageUrl; // 데이터를 업데이트
    }

    // Firestore에 데이터 저장
    await firestore.collection('cart_item').doc(newDocName).set(data); // Firestore에 데이터를 저장
  }

  // Firestore에서 장바구니 아이템 목록을 가져오는 함수 - Firestore에서 'cart_item' 컬렉션의 문서를 가져와 List로 반환
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final querySnapshot = await firestore.collection('cart_item').get(); // 'cart_item' 컬렉션에서 모든 문서를 가져옴
    return querySnapshot.docs.map((doc) { // 가져온 문서들을 순회하여 리스트로 반환
      final data = doc.data(); // 문서 데이터를 가져옴
      data['id'] = doc.id; // 문서 ID를 데이터에 추가함
      return data; // 데이터 반환
    }).toList();
  }

  // Firestore에서 가져온 수량 데이터를 업데이트하는 함수
  Future<void> updateCartItemQuantity(String docId, int newQuantity) async {
    await firestore.collection('cart_item').doc(docId).update({ // 주어진 문서 ID에 해당하는 문서의 'selected_count' 필드를 업데이트함
      'selected_count': newQuantity,
    });
  }

  // 장바구니 화면 내에서 상품 아이템을 '삭제' 버튼 클릭 시, Firestore에서 삭제되도록 하는 함수
  Future<void> removeCartItem(String docId) async {
    await firestore.collection('cart_item').doc(docId).delete(); // 주어진 문서 ID에 해당하는 문서를 Firestore에서 삭제
  }
}
// ------- 장바구니와 관련된 데이터를 Firebase에 저장하고 저장된 데이터를 불러오고 하는 관리 관련 데이터 처리 로직인 CartItemRepository 클래스 끝
