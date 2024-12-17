// Firebase Firestore 라이브러리의 임포트
// Firestore는 Google Firebase 플랫폼의 일부로 제공되는 NoSQL 클라우드 데이터베이스입니다.
// 이 데이터베이스를 사용하면 데이터를 실시간으로 저장하고 동기화할 수 있어서, 멀티 사용자 앱에서 데이터의 일관성을 유지할 수 있습니다.
// Firestore는 문서와 컬렉션으로 데이터를 구성하며, 강력한 쿼리 기능과 실시간 업데이트 기능을 제공합니다.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 라이브러리의 임포트
// ProductContent 모델 정의 파일의 임포트
// 이 파일은 애플리케이션에서 사용될 제품 데이터의 구조를 정의하는 클래스를 포함하고 있습니다.
// 제품 모델은 제품의 이름, 가격, 설명, 이미지 URL 등과 같은 속성을 가질 수 있으며,
// Firestore 데이터베이스와의 상호작용을 통해 이러한 데이터를 쉽게 저장하고 검색할 수 있습니다.
import '../../../../product/model/product_model.dart';
import '../../../../product/repository/product_repository.dart';

// -------- 2차 카테고리(신상, 최고 ~~) 시작 부분
// Firestore 데이터베이스로부터 신상 상품 정보를 조회하는 기능을 제공하는 클래스
class AaiNewProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aai1B1', 'Aai2B1', 'Aai3B1', 'Aai4B1', 'Aai5B1', 'Aai6B1',
    'Aai7B1', 'Aai8B1', 'Aai9B1', 'Aai10B1', 'Aai11B1', 'Aai12B1'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AaiNewProductRepository(this.firestore); // 생성자

  // 신상 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchNewProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 모든 컬렉션이 소진되었는지 확인하여 추가 호출을 방지
    if (allCollectionsExhausted()) {
      print('모든 컬렉션에서 더 이상 가져올 데이터가 없습니다.');
      return products; // 빈 리스트 반환
    }

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit &&
        currentCollectionIndex < collections.length) {
      String currentCollection =
      collections[currentCollectionIndex]; // 현재 컬렉션 이름
      // 한 자리 숫자는 substring(2, 4), 두 자리 숫자는 substring(2, 5) 사용
      String mainCollection = currentCollection.length == 7
          ? 'Aa' + currentCollection.substring(2, 5)
          : 'Aa' + currentCollection.substring(2, 4);
      final collectionKey = '$mainCollection/$currentCollection';

      // 해당 컬렉션이 데이터 없음 상태라면 다음 컬렉션으로 이동
      if (noMoreDataPerCollection[collectionKey] == true) {
        currentCollectionIndex++;
        continue;
      }

      print('현재 조회 중인 메인 컬렉션: $mainCollection, 서브 컬렉션: $currentCollection');

      // /products/mainCollection/currentCollection/couture/couture_items 경로에서 문서를 가져오는 쿼리
      Query query = firestore
          .collection('products')
          .doc('wearcano')
          .collection('product_9')
          .doc(mainCollection) // 'Aai10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aai10B1', 'Aai2B1' 등)
          .doc('wearcano') // 'wearcano' 문서 접근
          .collection('wearcano_items') // 'wearcano_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
          .orderBy('discount_price', descending: false) // discount_price 필드를 오름차순으로 정렬
          .limit(limit - products.length); // 남은 limit 수 만큼만 가져오기

      if (lastDocument != null) {
        print('이전 문서 이후부터 조회 시작: ${lastDocument!.id}');
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기

      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        print('가져온 문서 수: ${snapshots.docs.length}, 마지막 문서 ID: ${lastDocument!.id}');

        products.addAll(snapshots.docs
            .map((doc) => ProductContent.fromFirestore(doc))
            .toList()); // 제품 리스트에 추가
      } else {
        print('컬렉션 $currentCollection 에서 더 이상 가져올 데이터가 없습니다.');
        noMoreDataPerCollection[collectionKey] = true; // 현재 컬렉션 데이터 없음 표시
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    print('가져온 제품 총 수: ${products.length}');
    return products; // 제품 리스트 반환
  }

  // 모든 컬렉션의 데이터가 끝났는지 확인하는 메서드
  bool allCollectionsExhausted() {
    return noMoreDataPerCollection.values.length == collections.length &&
        noMoreDataPerCollection.values.every((isExhausted) => isExhausted);
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    print('데이터 초기화: 마지막 문서 및 컬렉션 인덱스를 리셋합니다.');
    lastDocument = null;
    currentCollectionIndex = 0;
    noMoreDataPerCollection.clear(); // 모든 컬렉션의 데이터 상태 초기화
  }
}

// Firestore 데이터베이스로부터 최고 상품 정보를 조회하는 기능을 제공하는 클래스
class AaiBestProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aai1B2', 'Aai2B2', 'Aai3B2', 'Aai4B2', 'Aai5B2', 'Aai6B2',
    'Aai7B2', 'Aai8B2', 'Aai9B2', 'Aai10B2', 'Aai11B2', 'Aai12B2'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AaiBestProductRepository(this.firestore); // 생성자

  // 최고 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchBestProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 모든 컬렉션이 소진되었는지 확인하여 추가 호출을 방지
    if (allCollectionsExhausted()) {
      print('모든 컬렉션에서 더 이상 가져올 데이터가 없습니다.');
      return products; // 빈 리스트 반환
    }

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit &&
        currentCollectionIndex < collections.length) {
      String currentCollection =
      collections[currentCollectionIndex]; // 현재 컬렉션 이름
      // 한 자리 숫자는 substring(2, 4), 두 자리 숫자는 substring(2, 5) 사용
      String mainCollection = currentCollection.length == 7
          ? 'Aa' + currentCollection.substring(2, 5)
          : 'Aa' + currentCollection.substring(2, 4);
      final collectionKey = '$mainCollection/$currentCollection';

      // 해당 컬렉션이 데이터 없음 상태라면 다음 컬렉션으로 이동
      if (noMoreDataPerCollection[collectionKey] == true) {
        currentCollectionIndex++;
        continue;
      }

      print('현재 조회 중인 메인 컬렉션: $mainCollection, 서브 컬렉션: $currentCollection');

      // /products/mainCollection/currentCollection/couture/couture_items 경로에서 문서를 가져오는 쿼리
      Query query = firestore
          .collection('products')
          .doc('wearcano')
          .collection('product_9')
          .doc(mainCollection) // 'Aai10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aai10B1', 'Aai2B1' 등)
          .doc('wearcano') // 'wearcano' 문서 접근
          .collection('wearcano_items') // 'wearcano_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
          .orderBy('discount_price', descending: false) // discount_price 필드를 오름차순으로 정렬
          .limit(limit - products.length); // 남은 limit 수 만큼만 가져오기

      if (lastDocument != null) {
        print('이전 문서 이후부터 조회 시작: ${lastDocument!.id}');
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기

      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        print('가져온 문서 수: ${snapshots.docs.length}, 마지막 문서 ID: ${lastDocument!.id}');

        products.addAll(snapshots.docs
            .map((doc) => ProductContent.fromFirestore(doc))
            .toList()); // 제품 리스트에 추가
      } else {
        print('컬렉션 $currentCollection 에서 더 이상 가져올 데이터가 없습니다.');
        noMoreDataPerCollection[collectionKey] = true; // 현재 컬렉션 데이터 없음 표시
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    print('가져온 제품 총 수: ${products.length}');
    return products; // 제품 리스트 반환
  }

  // 모든 컬렉션의 데이터가 끝났는지 확인하는 메서드
  bool allCollectionsExhausted() {
    return noMoreDataPerCollection.values.length == collections.length &&
        noMoreDataPerCollection.values.every((isExhausted) => isExhausted);
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    print('데이터 초기화: 마지막 문서 및 컬렉션 인덱스를 리셋합니다.');
    lastDocument = null;
    currentCollectionIndex = 0;
    noMoreDataPerCollection.clear(); // 모든 컬렉션의 데이터 상태 초기화
  }
}

// Firestore 데이터베이스로부터 할인 상품 정보를 조회하는 기능을 제공하는 클래스
class AaiSaleProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aai1B3', 'Aai2B3', 'Aai3B3', 'Aai4B3', 'Aai5B3', 'Aai6B3',
    'Aai7B3', 'Aai8B3', 'Aai9B3', 'Aai10B3', 'Aai11B3', 'Aai12B3'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AaiSaleProductRepository(this.firestore); // 생성자

  // 할인 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchSaleProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 모든 컬렉션이 소진되었는지 확인하여 추가 호출을 방지
    if (allCollectionsExhausted()) {
      print('모든 컬렉션에서 더 이상 가져올 데이터가 없습니다.');
      return products; // 빈 리스트 반환
    }

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit &&
        currentCollectionIndex < collections.length) {
      String currentCollection =
      collections[currentCollectionIndex]; // 현재 컬렉션 이름
      // 한 자리 숫자는 substring(2, 4), 두 자리 숫자는 substring(2, 5) 사용
      String mainCollection = currentCollection.length == 7
          ? 'Aa' + currentCollection.substring(2, 5)
          : 'Aa' + currentCollection.substring(2, 4);
      final collectionKey = '$mainCollection/$currentCollection';

      // 해당 컬렉션이 데이터 없음 상태라면 다음 컬렉션으로 이동
      if (noMoreDataPerCollection[collectionKey] == true) {
        currentCollectionIndex++;
        continue;
      }

      print('현재 조회 중인 메인 컬렉션: $mainCollection, 서브 컬렉션: $currentCollection');

      // /products/mainCollection/currentCollection/couture/couture_items 경로에서 문서를 가져오는 쿼리
      Query query = firestore
          .collection('products')
          .doc('wearcano')
          .collection('product_9')
          .doc(mainCollection) // 'Aai10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aai10B1', 'Aai2B1' 등)
          .doc('wearcano') // 'wearcano' 문서 접근
          .collection('wearcano_items') // 'wearcano_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
          .orderBy('discount_price', descending: false) // discount_price 필드를 오름차순으로 정렬
          .limit(limit - products.length); // 남은 limit 수 만큼만 가져오기

      if (lastDocument != null) {
        print('이전 문서 이후부터 조회 시작: ${lastDocument!.id}');
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기

      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        print('가져온 문서 수: ${snapshots.docs.length}, 마지막 문서 ID: ${lastDocument!.id}');

        products.addAll(snapshots.docs
            .map((doc) => ProductContent.fromFirestore(doc))
            .toList()); // 제품 리스트에 추가
      } else {
        print('컬렉션 $currentCollection 에서 더 이상 가져올 데이터가 없습니다.');
        noMoreDataPerCollection[collectionKey] = true; // 현재 컬렉션 데이터 없음 표시
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    print('가져온 제품 총 수: ${products.length}');
    return products; // 제품 리스트 반환
  }

  // 모든 컬렉션의 데이터가 끝났는지 확인하는 메서드
  bool allCollectionsExhausted() {
    return noMoreDataPerCollection.values.length == collections.length &&
        noMoreDataPerCollection.values.every((isExhausted) => isExhausted);
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    print('데이터 초기화: 마지막 문서 및 컬렉션 인덱스를 리셋합니다.');
    lastDocument = null;
    currentCollectionIndex = 0;
    noMoreDataPerCollection.clear(); // 모든 컬렉션의 데이터 상태 초기화
  }
}

// Firestore 데이터베이스로부터 봄 상품 정보를 조회하는 기능을 제공하는 클래스
class AaiSpringProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aai1B4', 'Aai2B4', 'Aai3B4', 'Aai4B4', 'Aai5B4', 'Aai6B4',
    'Aai7B4', 'Aai8B4', 'Aai9B4', 'Aai10B4', 'Aai11B4', 'Aai12B4'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AaiSpringProductRepository(this.firestore); // 생성자

  // 봄 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchSpringProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 모든 컬렉션이 소진되었는지 확인하여 추가 호출을 방지
    if (allCollectionsExhausted()) {
      print('모든 컬렉션에서 더 이상 가져올 데이터가 없습니다.');
      return products; // 빈 리스트 반환
    }

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit &&
        currentCollectionIndex < collections.length) {
      String currentCollection =
      collections[currentCollectionIndex]; // 현재 컬렉션 이름
      // 한 자리 숫자는 substring(2, 4), 두 자리 숫자는 substring(2, 5) 사용
      String mainCollection = currentCollection.length == 7
          ? 'Aa' + currentCollection.substring(2, 5)
          : 'Aa' + currentCollection.substring(2, 4);
      final collectionKey = '$mainCollection/$currentCollection';

      // 해당 컬렉션이 데이터 없음 상태라면 다음 컬렉션으로 이동
      if (noMoreDataPerCollection[collectionKey] == true) {
        currentCollectionIndex++;
        continue;
      }

      print('현재 조회 중인 메인 컬렉션: $mainCollection, 서브 컬렉션: $currentCollection');

      // /products/mainCollection/currentCollection/couture/couture_items 경로에서 문서를 가져오는 쿼리
      Query query = firestore
          .collection('products')
          .doc('wearcano')
          .collection('product_9')
          .doc(mainCollection) // 'Aai10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aai10B1', 'Aai2B1' 등)
          .doc('wearcano') // 'wearcano' 문서 접근
          .collection('wearcano_items') // 'wearcano_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
          .orderBy('discount_price', descending: false) // discount_price 필드를 오름차순으로 정렬
          .limit(limit - products.length); // 남은 limit 수 만큼만 가져오기

      if (lastDocument != null) {
        print('이전 문서 이후부터 조회 시작: ${lastDocument!.id}');
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기

      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        print('가져온 문서 수: ${snapshots.docs.length}, 마지막 문서 ID: ${lastDocument!.id}');

        products.addAll(snapshots.docs
            .map((doc) => ProductContent.fromFirestore(doc))
            .toList()); // 제품 리스트에 추가
      } else {
        print('컬렉션 $currentCollection 에서 더 이상 가져올 데이터가 없습니다.');
        noMoreDataPerCollection[collectionKey] = true; // 현재 컬렉션 데이터 없음 표시
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    print('가져온 제품 총 수: ${products.length}');
    return products; // 제품 리스트 반환
  }

  // 모든 컬렉션의 데이터가 끝났는지 확인하는 메서드
  bool allCollectionsExhausted() {
    return noMoreDataPerCollection.values.length == collections.length &&
        noMoreDataPerCollection.values.every((isExhausted) => isExhausted);
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    print('데이터 초기화: 마지막 문서 및 컬렉션 인덱스를 리셋합니다.');
    lastDocument = null;
    currentCollectionIndex = 0;
    noMoreDataPerCollection.clear(); // 모든 컬렉션의 데이터 상태 초기화
  }
}

// Firestore 데이터베이스로부터 여름 상품 정보를 조회하는 기능을 제공하는 클래스
class AaiSummerProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aai1B5', 'Aai2B5', 'Aai3B5', 'Aai4B5', 'Aai5B5', 'Aai6B5',
    'Aai7B5', 'Aai8B5', 'Aai9B5', 'Aai10B5', 'Aai11B5', 'Aai12B5'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AaiSummerProductRepository(this.firestore); // 생성자

  // 여름 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchSummerProductContents(
      {int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 모든 컬렉션이 소진되었는지 확인하여 추가 호출을 방지
    if (allCollectionsExhausted()) {
      print('모든 컬렉션에서 더 이상 가져올 데이터가 없습니다.');
      return products; // 빈 리스트 반환
    }

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit &&
        currentCollectionIndex < collections.length) {
      String currentCollection =
      collections[currentCollectionIndex]; // 현재 컬렉션 이름
      // 한 자리 숫자는 substring(2, 4), 두 자리 숫자는 substring(2, 5) 사용
      String mainCollection = currentCollection.length == 7
          ? 'Aa' + currentCollection.substring(2, 5)
          : 'Aa' + currentCollection.substring(2, 4);
      final collectionKey = '$mainCollection/$currentCollection';

      // 해당 컬렉션이 데이터 없음 상태라면 다음 컬렉션으로 이동
      if (noMoreDataPerCollection[collectionKey] == true) {
        currentCollectionIndex++;
        continue;
      }

      print('현재 조회 중인 메인 컬렉션: $mainCollection, 서브 컬렉션: $currentCollection');

      // /products/mainCollection/currentCollection/couture/couture_items 경로에서 문서를 가져오는 쿼리
      Query query = firestore
          .collection('products')
          .doc('wearcano')
          .collection('product_9')
          .doc(mainCollection) // 'Aai10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aai10B1', 'Aai2B1' 등)
          .doc('wearcano') // 'wearcano' 문서 접근
          .collection('wearcano_items') // 'wearcano_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
          .orderBy('discount_price', descending: false) // discount_price 필드를 오름차순으로 정렬
          .limit(limit - products.length); // 남은 limit 수 만큼만 가져오기

      if (lastDocument != null) {
        print('이전 문서 이후부터 조회 시작: ${lastDocument!.id}');
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기

      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        print('가져온 문서 수: ${snapshots.docs.length}, 마지막 문서 ID: ${lastDocument!.id}');

        products.addAll(snapshots.docs
            .map((doc) => ProductContent.fromFirestore(doc))
            .toList()); // 제품 리스트에 추가
      } else {
        print('컬렉션 $currentCollection 에서 더 이상 가져올 데이터가 없습니다.');
        noMoreDataPerCollection[collectionKey] = true; // 현재 컬렉션 데이터 없음 표시
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    print('가져온 제품 총 수: ${products.length}');
    return products; // 제품 리스트 반환
  }

  // 모든 컬렉션의 데이터가 끝났는지 확인하는 메서드
  bool allCollectionsExhausted() {
    return noMoreDataPerCollection.values.length == collections.length &&
        noMoreDataPerCollection.values.every((isExhausted) => isExhausted);
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    print('데이터 초기화: 마지막 문서 및 컬렉션 인덱스를 리셋합니다.');
    lastDocument = null;
    currentCollectionIndex = 0;
    noMoreDataPerCollection.clear(); // 모든 컬렉션의 데이터 상태 초기화
  }
}

// Firestore 데이터베이스로부터 가을 상품 정보를 조회하는 기능을 제공하는 클래스
class AaiAutumnProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aai1B6', 'Aai2B6', 'Aai3B6', 'Aai4B6', 'Aai5B6', 'Aai6B6',
    'Aai7B6', 'Aai8B6', 'Aai9B6', 'Aai10B6', 'Aai11B6', 'Aai12B6'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AaiAutumnProductRepository(this.firestore); // 생성자

  // 가을 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchAutumnProductContents(
      {int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 모든 컬렉션이 소진되었는지 확인하여 추가 호출을 방지
    if (allCollectionsExhausted()) {
      print('모든 컬렉션에서 더 이상 가져올 데이터가 없습니다.');
      return products; // 빈 리스트 반환
    }

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit &&
        currentCollectionIndex < collections.length) {
      String currentCollection =
      collections[currentCollectionIndex]; // 현재 컬렉션 이름
      // 한 자리 숫자는 substring(2, 4), 두 자리 숫자는 substring(2, 5) 사용
      String mainCollection = currentCollection.length == 7
          ? 'Aa' + currentCollection.substring(2, 5)
          : 'Aa' + currentCollection.substring(2, 4);
      final collectionKey = '$mainCollection/$currentCollection';

      // 해당 컬렉션이 데이터 없음 상태라면 다음 컬렉션으로 이동
      if (noMoreDataPerCollection[collectionKey] == true) {
        currentCollectionIndex++;
        continue;
      }

      print('현재 조회 중인 메인 컬렉션: $mainCollection, 서브 컬렉션: $currentCollection');

      // /products/mainCollection/currentCollection/couture/couture_items 경로에서 문서를 가져오는 쿼리
      Query query = firestore
          .collection('products')
          .doc('wearcano')
          .collection('product_9')
          .doc(mainCollection) // 'Aai10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aai10B1', 'Aai2B1' 등)
          .doc('wearcano') // 'wearcano' 문서 접근
          .collection('wearcano_items') // 'wearcano_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
          .orderBy('discount_price', descending: false) // discount_price 필드를 오름차순으로 정렬
          .limit(limit - products.length); // 남은 limit 수 만큼만 가져오기

      if (lastDocument != null) {
        print('이전 문서 이후부터 조회 시작: ${lastDocument!.id}');
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기

      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        print('가져온 문서 수: ${snapshots.docs.length}, 마지막 문서 ID: ${lastDocument!.id}');

        products.addAll(snapshots.docs
            .map((doc) => ProductContent.fromFirestore(doc))
            .toList()); // 제품 리스트에 추가
      } else {
        print('컬렉션 $currentCollection 에서 더 이상 가져올 데이터가 없습니다.');
        noMoreDataPerCollection[collectionKey] = true; // 현재 컬렉션 데이터 없음 표시
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    print('가져온 제품 총 수: ${products.length}');
    return products; // 제품 리스트 반환
  }

  // 모든 컬렉션의 데이터가 끝났는지 확인하는 메서드
  bool allCollectionsExhausted() {
    return noMoreDataPerCollection.values.length == collections.length &&
        noMoreDataPerCollection.values.every((isExhausted) => isExhausted);
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    print('데이터 초기화: 마지막 문서 및 컬렉션 인덱스를 리셋합니다.');
    lastDocument = null;
    currentCollectionIndex = 0;
    noMoreDataPerCollection.clear(); // 모든 컬렉션의 데이터 상태 초기화
  }
}

// Firestore 데이터베이스로부터 겨울 상품 정보를 조회하는 기능을 제공하는 클래스
class AaiWinterProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aai1B7', 'Aai2B7', 'Aai3B7', 'Aai4B7', 'Aai5B7', 'Aai6B7',
    'Aai7B7', 'Aai8B7', 'Aai9B7', 'Aai10B7', 'Aai11B7', 'Aai12B7'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AaiWinterProductRepository(this.firestore); // 생성자

  // 겨울 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchWinterProductContents(
      {int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 모든 컬렉션이 소진되었는지 확인하여 추가 호출을 방지
    if (allCollectionsExhausted()) {
      print('모든 컬렉션에서 더 이상 가져올 데이터가 없습니다.');
      return products; // 빈 리스트 반환
    }

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit &&
        currentCollectionIndex < collections.length) {
      String currentCollection =
      collections[currentCollectionIndex]; // 현재 컬렉션 이름
      // 한 자리 숫자는 substring(2, 4), 두 자리 숫자는 substring(2, 5) 사용
      String mainCollection = currentCollection.length == 7
          ? 'Aa' + currentCollection.substring(2, 5)
          : 'Aa' + currentCollection.substring(2, 4);
      final collectionKey = '$mainCollection/$currentCollection';

      // 해당 컬렉션이 데이터 없음 상태라면 다음 컬렉션으로 이동
      if (noMoreDataPerCollection[collectionKey] == true) {
        currentCollectionIndex++;
        continue;
      }

      print('현재 조회 중인 메인 컬렉션: $mainCollection, 서브 컬렉션: $currentCollection');

      // /products/mainCollection/currentCollection/couture/couture_items 경로에서 문서를 가져오는 쿼리
      Query query = firestore
          .collection('products')
          .doc('wearcano')
          .collection('product_9')
          .doc(mainCollection) // 'Aai10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aai10B1', 'Aai2B1' 등)
          .doc('wearcano') // 'wearcano' 문서 접근
          .collection('wearcano_items') // 'wearcano_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
          .orderBy('discount_price', descending: false) // discount_price 필드를 오름차순으로 정렬
          .limit(limit - products.length); // 남은 limit 수 만큼만 가져오기

      if (lastDocument != null) {
        print('이전 문서 이후부터 조회 시작: ${lastDocument!.id}');
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기

      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        print('가져온 문서 수: ${snapshots.docs.length}, 마지막 문서 ID: ${lastDocument!.id}');

        products.addAll(snapshots.docs
            .map((doc) => ProductContent.fromFirestore(doc))
            .toList()); // 제품 리스트에 추가
      } else {
        print('컬렉션 $currentCollection 에서 더 이상 가져올 데이터가 없습니다.');
        noMoreDataPerCollection[collectionKey] = true; // 현재 컬렉션 데이터 없음 표시
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    print('가져온 제품 총 수: ${products.length}');
    return products; // 제품 리스트 반환
  }

  // 모든 컬렉션의 데이터가 끝났는지 확인하는 메서드
  bool allCollectionsExhausted() {
    return noMoreDataPerCollection.values.length == collections.length &&
        noMoreDataPerCollection.values.every((isExhausted) => isExhausted);
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    print('데이터 초기화: 마지막 문서 및 컬렉션 인덱스를 리셋합니다.');
    lastDocument = null;
    currentCollectionIndex = 0;
    noMoreDataPerCollection.clear(); // 모든 컬렉션의 데이터 상태 초기화
  }
}
// -------- 2차 카테고리(신상, 최고 ~~) 끝 부분

// -------- 1차 카테고리 관련 데이터를 불러오는 로직인 AaiMainCategoryProductsRepository 시작 부분
class AaiMainCategoryProductsRepository implements CategoryProductsRepository {
  final FirebaseFirestore firestore;
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷을 저장
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AaiMainCategoryProductsRepository(this.firestore);

  // boolExistence 조건을 적용하여 Firestore에서 데이터를 가져오는 메서드
  Future<List<ProductContent>> fetchProductContents({
    required String mainCollection, // 최상위 컬렉션 문서 ID
    required String subCollection, // 서브 컬렉션 이름
    required int limit,
    DocumentSnapshot? startAfter,
    bool boolExistence = true, // boolExistence 필터
  }) async {
    // 해당 서브 컬렉션에 대해 데이터 없음 상태인지 확인
    final collectionKey = '$mainCollection/$subCollection';
    if (noMoreDataPerCollection[collectionKey] == true) {
      print('추가로 불러올 데이터가 없습니다. (컬렉션: $collectionKey)');
      return []; // 데이터 없음 상태인 경우 빈 리스트 반환
    }

    print('데이터 조회 시작: 메인 컬렉션 - $mainCollection, 서브 컬렉션 - $subCollection');
    List<ProductContent> products = []; // 제품 리스트 초기화

    // Firestore에서 데이터 쿼리 설정
    Query query = firestore
        .collection('products')
        .doc('wearcano')
        .collection('product_9')
        .doc(mainCollection) // 'Aai10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
        .collection(subCollection) // 세부 컬렉션 (예: 'Aai10B1', 'Aai2B1' 등)
        .doc('wearcano') // 하위 문서 'wearcano'
        .collection('wearcano_items') // 최하위 컬렉션 'wearcano_items'
        .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
        .limit(limit);

    // 페이지네이션을 위해 이전 문서 이후로 시작 설정
    if (startAfter != null) {
      print('이전 문서 이후부터 조회 시작: ${startAfter.id}');
      query = query.startAfterDocument(startAfter);
    }

    // 쿼리 실행 및 결과 가져오기
    final snapshots = await query.get();

    if (snapshots.docs.isNotEmpty) {
      lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
      print('가져온 문서 수: ${snapshots.docs.length}, 마지막 문서 ID: ${lastDocument!.id}');
      products = snapshots.docs
          .map((doc) => ProductContent.fromFirestore(doc))
          .toList(); // ProductContent 객체로 변환하여 반환
    } else {
      print('컬렉션에서 더 이상 가져올 데이터가 없습니다. (컬렉션: $collectionKey)');
      noMoreDataPerCollection[collectionKey] = true; // 현재 컬렉션 데이터 없음 표시
      lastDocument = null;
    }

    print('총 가져온 제품 수: ${products.length}');
    return products;
  }

  // 모든 컬렉션의 데이터가 끝났는지 확인하는 메서드
  bool allCollectionsExhausted() {
    return noMoreDataPerCollection.values.every((isExhausted) => isExhausted);
  }

  // 데이터를 초기화하는 reset 메서드
  void reset() {
    print('데이터 초기화: 마지막 문서를 리셋합니다.');
    lastDocument = null;
    noMoreDataPerCollection.clear(); // 모든 컬렉션의 데이터 상태 초기화
  }
}
// -------- 1차 카테고리 관련 데이터를 불러오는 로직인 MainCategoryProductsRepository 끝 부분

// -------- 2차 카테고리 관련 데이터를 불러오는 로직인 AaiSectionCategoryProductsRepository 시작 부분
class AaiSectionCategoryProductsRepository implements CategoryProductsRepository {
  final FirebaseFirestore firestore;
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷을 저장
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AaiSectionCategoryProductsRepository(this.firestore);

  // boolExistence 조건을 적용하여 Firestore에서 데이터를 가져오는 메서드
  Future<List<ProductContent>> fetchProductContents({
    required String mainCollection, // 최상위 컬렉션 문서 ID
    required String subCollection, // 서브 컬렉션 이름
    required int limit,
    DocumentSnapshot? startAfter,
    bool boolExistence = true, // boolExistence 필터
  }) async {
    // 해당 서브 컬렉션에 대해 데이터 없음 상태인지 확인
    final collectionKey = '$mainCollection/$subCollection';
    if (noMoreDataPerCollection[collectionKey] == true) {
      print('추가로 불러올 데이터가 없습니다. (컬렉션: $collectionKey)');
      return []; // 데이터 없음 상태인 경우 빈 리스트 반환
    }

    print('데이터 조회 시작: 메인 컬렉션 - $mainCollection, 서브 컬렉션 - $subCollection');
    List<ProductContent> products = []; // 제품 리스트 초기화

    // Firestore에서 데이터 쿼리 설정
    Query query = firestore
        .collection('products')
        .doc('wearcano')
        .collection('product_9')
        .doc(mainCollection) // 'Aai10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
        .collection(subCollection) // 세부 컬렉션 (예: 'Aai10B1', 'Aai2B1' 등)
        .doc('wearcano') // 하위 문서 'wearcano'
        .collection('wearcano_items') // 최하위 컬렉션 'wearcano_items'
        .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
        .limit(limit);

    // 페이지네이션을 위해 이전 문서 이후로 시작 설정
    if (startAfter != null) {
      print('이전 문서 이후부터 조회 시작: ${startAfter.id}');
      query = query.startAfterDocument(startAfter);
    }

    // 쿼리 실행 및 결과 가져오기
    final snapshots = await query.get();

    if (snapshots.docs.isNotEmpty) {
      lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
      print('가져온 문서 수: ${snapshots.docs.length}, 마지막 문서 ID: ${lastDocument!.id}');
      products = snapshots.docs
          .map((doc) => ProductContent.fromFirestore(doc))
          .toList(); // ProductContent 객체로 변환하여 반환
    } else {
      print('컬렉션에서 더 이상 가져올 데이터가 없습니다. (컬렉션: $collectionKey)');
      noMoreDataPerCollection[collectionKey] = true; // 현재 컬렉션 데이터 없음 표시
      lastDocument = null;
    }

    print('총 가져온 제품 수: ${products.length}');
    return products;
  }

  // 모든 컬렉션의 데이터가 끝났는지 확인하는 메서드
  bool allCollectionsExhausted() {
    return noMoreDataPerCollection.values.every((isExhausted) => isExhausted);
  }

  // 데이터를 초기화하는 reset 메서드
  void reset() {
    print('데이터 초기화: 마지막 문서를 리셋합니다.');
    lastDocument = null;
    noMoreDataPerCollection.clear(); // 모든 컬렉션의 데이터 상태 초기화
  }
}
// -------- 2차 카테고리 관련 데이터를 불러오는 로직인 SectionCategoryProductsRepository 끝 부분