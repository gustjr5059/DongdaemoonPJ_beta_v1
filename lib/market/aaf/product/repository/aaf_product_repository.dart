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
class AafNewProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aaf1B1', 'Aaf2B1', 'Aaf3B1', 'Aaf4B1', 'Aaf5B1', 'Aaf6B1',
    'Aaf7B1', 'Aaf8B1', 'Aaf9B1', 'Aaf10B1', 'Aaf11B1', 'Aaf12B1'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AafNewProductRepository(this.firestore); // 생성자

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
          .collection('product_6')
          .doc(mainCollection) // 'Aaf10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aaf10B1', 'Aaf2B1' 등)
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
class AafBestProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aaf1B2', 'Aaf2B2', 'Aaf3B2', 'Aaf4B2', 'Aaf5B2', 'Aaf6B2',
    'Aaf7B2', 'Aaf8B2', 'Aaf9B2', 'Aaf10B2', 'Aaf11B2', 'Aaf12B2'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AafBestProductRepository(this.firestore); // 생성자

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
          .collection('product_6')
          .doc(mainCollection) // 'Aaf10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aaf10B1', 'Aaf2B1' 등)
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
class AafSaleProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aaf1B3', 'Aaf2B3', 'Aaf3B3', 'Aaf4B3', 'Aaf5B3', 'Aaf6B3',
    'Aaf7B3', 'Aaf8B3', 'Aaf9B3', 'Aaf10B3', 'Aaf11B3', 'Aaf12B3'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AafSaleProductRepository(this.firestore); // 생성자

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
          .collection('product_6')
          .doc(mainCollection) // 'Aaf10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aaf10B1', 'Aaf2B1' 등)
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
class AafSpringProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aaf1B4', 'Aaf2B4', 'Aaf3B4', 'Aaf4B4', 'Aaf5B4', 'Aaf6B4',
    'Aaf7B4', 'Aaf8B4', 'Aaf9B4', 'Aaf10B4', 'Aaf11B4', 'Aaf12B4'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AafSpringProductRepository(this.firestore); // 생성자

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
          .collection('product_6')
          .doc(mainCollection) // 'Aaf10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aaf10B1', 'Aaf2B1' 등)
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
class AafSummerProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aaf1B5', 'Aaf2B5', 'Aaf3B5', 'Aaf4B5', 'Aaf5B5', 'Aaf6B5',
    'Aaf7B5', 'Aaf8B5', 'Aaf9B5', 'Aaf10B5', 'Aaf11B5', 'Aaf12B5'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AafSummerProductRepository(this.firestore); // 생성자

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
          .collection('product_6')
          .doc(mainCollection) // 'Aaf10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aaf10B1', 'Aaf2B1' 등)
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
class AafAutumnProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aaf1B6', 'Aaf2B6', 'Aaf3B6', 'Aaf4B6', 'Aaf5B6', 'Aaf6B6',
    'Aaf7B6', 'Aaf8B6', 'Aaf9B6', 'Aaf10B6', 'Aaf11B6', 'Aaf12B6'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AafAutumnProductRepository(this.firestore); // 생성자

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
          .collection('product_6')
          .doc(mainCollection) // 'Aaf10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aaf10B1', 'Aaf2B1' 등)
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
class AafWinterProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'Aaf1B7', 'Aaf2B7', 'Aaf3B7', 'Aaf4B7', 'Aaf5B7', 'Aaf6B7',
    'Aaf7B7', 'Aaf8B7', 'Aaf9B7', 'Aaf10B7', 'Aaf11B7', 'Aaf12B7'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AafWinterProductRepository(this.firestore); // 생성자

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
          .collection('product_6')
          .doc(mainCollection) // 'Aaf10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'Aaf10B1', 'Aaf2B1' 등)
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

// -------- 1차 카테고리 관련 데이터를 불러오는 로직인 AafMainCategoryProductsRepository 시작 부분
class AafMainCategoryProductsRepository implements CategoryProductsRepository {
  final FirebaseFirestore firestore;
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷을 저장
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AafMainCategoryProductsRepository(this.firestore);

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
        .collection('product_6')
        .doc(mainCollection) // 'Aaf10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
        .collection(subCollection) // 세부 컬렉션 (예: 'Aaf10B1', 'Aaf2B1' 등)
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

// -------- 2차 카테고리 관련 데이터를 불러오는 로직인 AafSectionCategoryProductsRepository 시작 부분
class AafSectionCategoryProductsRepository implements CategoryProductsRepository {
  final FirebaseFirestore firestore;
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷을 저장
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AafSectionCategoryProductsRepository(this.firestore);

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
        .collection('product_6')
        .doc(mainCollection) // 'Aaf10', 'Aa2' 등 메인 컬렉션에 해당하는 문서 접근
        .collection(subCollection) // 세부 컬렉션 (예: 'Aaf10B1', 'Aaf2B1' 등)
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