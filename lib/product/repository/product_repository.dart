// Firebase Firestore 라이브러리의 임포트
// Firestore는 Google Firebase 플랫폼의 일부로 제공되는 NoSQL 클라우드 데이터베이스입니다.
// 이 데이터베이스를 사용하면 데이터를 실시간으로 저장하고 동기화할 수 있어서, 멀티 사용자 앱에서 데이터의 일관성을 유지할 수 있습니다.
// Firestore는 문서와 컬렉션으로 데이터를 구성하며, 강력한 쿼리 기능과 실시간 업데이트 기능을 제공합니다.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 라이브러리의 임포트
// ProductContent 모델 정의 파일의 임포트
// 이 파일은 애플리케이션에서 사용될 제품 데이터의 구조를 정의하는 클래스를 포함하고 있습니다.
// 제품 모델은 제품의 이름, 가격, 설명, 이미지 URL 등과 같은 속성을 가질 수 있으며,
// Firestore 데이터베이스와의 상호작용을 통해 이러한 데이터를 쉽게 저장하고 검색할 수 있습니다.
import '../model/product_model.dart'; // ProductContent 모델 정의 파일의 임포트

// -------- 2차 카테고리(신상, 최고 ~~) 시작 부분
// Firestore 데이터베이스로부터 신상 상품 정보를 조회하는 기능을 제공하는 클래스
class NewProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'a1b1', 'a2b1', 'a3b1', 'a4b1', 'a5b1', 'a6b1',
    'a7b1', 'a8b1', 'a9b1', 'a10b1', 'a11b1', 'a12b1'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  NewProductRepository(this.firestore); // 생성자

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
      // `currentCollection` 문자열의 두 번째 문자부터 세 번째 문자까지 가져오도록 해서 'a'와 붙여서 조합한 문서 이름
      String mainCollection = 'a' + currentCollection.substring(1, 3); // 예: a10b1 -> a10
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
          .doc(mainCollection) // 'a10', 'a2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'a10b1', 'a2b1' 등)
          .doc('couture') // 'couture' 문서 접근
          .collection('couture_items') // 'couture_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
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
class BestProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'a1b2', 'a2b2', 'a3b2', 'a4b2', 'a5b2', 'a6b2',
    'a7b2', 'a8b2', 'a9b2', 'a10b2', 'a11b2', 'a12b2'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  BestProductRepository(this.firestore); // 생성자

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
      // `currentCollection` 문자열의 두 번째 문자부터 세 번째 문자까지 가져오도록 해서 'a'와 붙여서 조합한 문서 이름
      String mainCollection = 'a' + currentCollection.substring(1, 3); // 예: a10b1 -> a10
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
          .doc(mainCollection) // 'a10', 'a2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'a10b1', 'a2b1' 등)
          .doc('couture') // 'couture' 문서 접근
          .collection('couture_items') // 'couture_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
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
class SaleProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'a1b3', 'a2b3', 'a3b3', 'a4b3', 'a5b3', 'a6b3',
    'a7b3', 'a8b3', 'a9b3', 'a10b3', 'a11b3', 'a12b3'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  SaleProductRepository(this.firestore); // 생성자

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
      // `currentCollection` 문자열의 두 번째 문자부터 세 번째 문자까지 가져오도록 해서 'a'와 붙여서 조합한 문서 이름
      String mainCollection = 'a' + currentCollection.substring(1, 3); // 예: a10b1 -> a10
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
          .doc(mainCollection) // 'a10', 'a2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'a10b1', 'a2b1' 등)
          .doc('couture') // 'couture' 문서 접근
          .collection('couture_items') // 'couture_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
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
class SpringProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'a1b4', 'a2b4', 'a3b4', 'a4b4', 'a5b4', 'a6b4',
    'a7b4', 'a8b4', 'a9b4', 'a10b4', 'a11b4', 'a12b4'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  SpringProductRepository(this.firestore); // 생성자

  // 봄 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchSpringProductContents(
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
      // `currentCollection` 문자열의 두 번째 문자부터 세 번째 문자까지 가져오도록 해서 'a'와 붙여서 조합한 문서 이름
      String mainCollection = 'a' + currentCollection.substring(1, 3); // 예: a10b1 -> a10
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
          .doc(mainCollection) // 'a10', 'a2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'a10b1', 'a2b1' 등)
          .doc('couture') // 'couture' 문서 접근
          .collection('couture_items') // 'couture_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
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
class SummerProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'a1b5', 'a2b5', 'a3b5', 'a4b5', 'a5b5', 'a6b5',
    'a7b5', 'a8b5', 'a9b5', 'a10b5', 'a11b5', 'a12b5'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  SummerProductRepository(this.firestore); // 생성자

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
      // `currentCollection` 문자열의 두 번째 문자부터 세 번째 문자까지 가져오도록 해서 'a'와 붙여서 조합한 문서 이름
      String mainCollection = 'a' + currentCollection.substring(1, 3); // 예: a10b1 -> a10
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
          .doc(mainCollection) // 'a10', 'a2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'a10b1', 'a2b1' 등)
          .doc('couture') // 'couture' 문서 접근
          .collection('couture_items') // 'couture_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
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
class AutumnProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'a1b6', 'a2b6', 'a3b6', 'a4b6', 'a5b6', 'a6b6',
    'a7b6', 'a8b6', 'a9b6', 'a10b6', 'a11b6', 'a12b6'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  AutumnProductRepository(this.firestore); // 생성자

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
      // `currentCollection` 문자열의 두 번째 문자부터 세 번째 문자까지 가져오도록 해서 'a'와 붙여서 조합한 문서 이름
      String mainCollection = 'a' + currentCollection.substring(1, 3); // 예: a10b1 -> a10
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
          .doc(mainCollection) // 'a10', 'a2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'a10b1', 'a2b1' 등)
          .doc('couture') // 'couture' 문서 접근
          .collection('couture_items') // 'couture_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
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
class WinterProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'a1b7', 'a2b7', 'a3b7', 'a4b7', 'a5b7', 'a6b7',
    'a7b7', 'a8b7', 'a9b7', 'a10b7', 'a11b7', 'a12b7'
  ];
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  WinterProductRepository(this.firestore); // 생성자

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
      // `currentCollection` 문자열의 두 번째 문자부터 세 번째 문자까지 가져오도록 해서 'a'와 붙여서 조합한 문서 이름
      String mainCollection = 'a' + currentCollection.substring(1, 3); // 예: a10b1 -> a10
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
          .doc(mainCollection) // 'a10', 'a2' 등 메인 컬렉션에 해당하는 문서 접근
          .collection(currentCollection) // 세부 컬렉션 (예: 'a10b1', 'a2b1' 등)
          .doc('couture') // 'couture' 문서 접근
          .collection('couture_items') // 'couture_items' 하위 컬렉션 접근
          .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
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

// -------- MainCategoryProductsRepository, SectionCategoryProductsRepository를 분기해서 사용하도록 하는 추상 클래스 내용 시작
// repository를 사용할 때 구체적인 인터페이스 또는 추상 클래스를 정의하여 이를 기반으로
// 각 레퍼지토리에서 상속하도록 해서 BaseProductListNotifier에서 각 노티파이어에 맞는 레퍼지토리의 fetchProductContents 메서드를 인식하도록 함
abstract class CategoryProductsRepository {
  Future<List<ProductContent>> fetchProductContents({
    required String mainCollection,
    required String subCollection,
    required int limit,
    DocumentSnapshot? startAfter,
    bool boolExistence = true,
  });
}
// -------- MainCategoryProductsRepository, SectionCategoryProductsRepository를 분기해서 사용하도록 하는 추상 클래스 내용 끝

// -------- 1차 카테고리 관련 데이터를 불러오는 로직인 MainCategoryProductsRepository 시작 부분
class MainCategoryProductsRepository implements CategoryProductsRepository {
  final FirebaseFirestore firestore;
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷을 저장
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  MainCategoryProductsRepository(this.firestore);

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
        .doc(mainCollection) // 'a10', 'a2' 등의 메인 문서
        .collection(subCollection) // 'a10b1', 'a2b1' 등의 서브 컬렉션
        .doc('couture') // 하위 문서 'couture'
        .collection('couture_items') // 최하위 컬렉션 'couture_items'
        .where('boolExistence', isEqualTo: boolExistence) // boolExistence 필터 추가
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

// -------- 2차 카테고리 관련 데이터를 불러오는 로직인 SectionCategoryProductsRepository 시작 부분
class SectionCategoryProductsRepository implements CategoryProductsRepository {
  final FirebaseFirestore firestore;
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷을 저장
  final Map<String, bool> noMoreDataPerCollection = {}; // 각 컬렉션별 데이터 없음 상태 저장

  SectionCategoryProductsRepository(this.firestore);

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
        .doc(mainCollection) // 'a10', 'a2' 등의 메인 문서
        .collection(subCollection) // 'a10b1', 'a2b1' 등의 서브 컬렉션
        .doc('couture') // 하위 문서 'couture'
        .collection('couture_items') // 최하위 컬렉션 'couture_items'
        .where('boolExistence', isEqualTo: boolExistence) // boolExistence 필터 추가
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


// 이젠 상품 상세 화면 관련 데이터를 불러오는 곳에서만 사용됨!!
// -------- 1차 카테고리(블라우스, 가디건 ~~), 상품 상세 화면 관련 데이터 등의 범용성 있게 파이어스토어 데이터를 일정 단위로 불러오도록 하는 클래스 시작 부분
// -------- 파이어스토어 내 데이터를 불러오는 범용성 리포지토리 (데이터 범위는 provider에서 정함) 시작
class GeneralProductRepository<T> {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  final List<String> collections; // 컬렉션 목록

  // 생성자에서 Firestore 인스턴스를 초기화하고 컬렉션 목록을 전달받음
  GeneralProductRepository(this.firestore, this.collections);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath); // 경로에 해당하는 문서 참조
    final snapshot = await docRef.get(); // 문서 스냅샷 가져오기
    if (snapshot.exists) {
      print('문서 조회 성공: $fullPath');
      return ProductContent.fromFirestore(
          snapshot); // 데이터가 존재하면 ProductContent로 변환하여 반환
    } else {
      print('문서 조회 실패: Firestore 데이터가 없습니다. 경로: $fullPath');
      throw Exception('Firestore 데이터가 없습니다.'); // 데이터가 없으면 예외 발생
    }
  }

  // 상품 데이터를 가져오는 함수
  Future<List<ProductContent>> fetchProductContents(
      {required int limit, DocumentSnapshot? startAfter}) async {
    List<ProductContent> products = []; // 상품 목록 초기화

    // 제한된 수의 상품을 가져올 때까지 반복
    while (products.length < limit &&
        currentCollectionIndex < collections.length) {
      String currentCollection = collections[currentCollectionIndex]; // 현재 컬렉션
      print('현재 조회 중인 컬렉션: $currentCollection');

      Query query = firestore
          .collectionGroup(currentCollection)
          .limit(limit - products.length); // 현재 컬렉션에서 제한된 수의 상품 가져오기

      // // `currentCollection` 문자열의 두 번째 문자부터 세 번째 문자까지 가져오도록 해서 'a'와 붙여서 조합한 문서 이름
      // String mainCollection = 'a' + currentCollection.substring(1, 3); // 예: a10b1 -> a10
      // print('현재 조회 중인 메인 컬렉션: $mainCollection, 서브 컬렉션: $currentCollection');
      //
      // // /products/mainCollection/currentCollection/couture/couture_items 경로에서 문서를 가져오는 쿼리
      // Query query = firestore
      //     .collection('products')
      //     .doc(mainCollection) // 'a10', 'a2' 등 메인 컬렉션에 해당하는 문서 접근
      //     .collection(currentCollection) // 세부 컬렉션 (예: 'a10b1', 'a2b1' 등)
      //     .doc('couture') // 'couture' 문서 접근
      //     .collection('couture_items') // 'couture_items' 하위 컬렉션 접근
      //     .where('boolExistence', isEqualTo: true) // 'boolExistence' 필터링 조건 추가
      //     .limit(limit - products.length); // 남은 limit 수 만큼만 가져오기

      // 상품 데이터를 가져올 때, 마지막 데이터 이후부터 새롭게 가져오도록 하는 로직 부분
      if (startAfter != null) {
        print('이전 문서 이후부터 조회 시작: ${startAfter.id}');
        query = query.startAfterDocument(startAfter); // 마지막 문서 이후부터 시작
      }

      final snapshots = await query.get(); // 쿼리 실행하여 스냅샷 가져오기
      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        print('가져온 문서 수: ${snapshots.docs.length}, 마지막 문서 ID: ${lastDocument!.id}');

        products.addAll(snapshots.docs
            .map((doc) => ProductContent.fromFirestore(doc))
            .toList()); // 상품 목록에 추가
      } else {
        print('컬렉션 $currentCollection 에서 더 이상 가져올 데이터가 없습니다.');
        lastDocument = null; // 문서가 없으면 마지막 문서 초기화
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    print('가져온 제품 총 수: ${products.length}');
    return products; // 가져온 상품 목록 반환
  }

  // 각 리포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    print('데이터 초기화: 마지막 문서 및 컬렉션 인덱스를 리셋합니다.');
    lastDocument = null; // 마지막 문서 초기화
    currentCollectionIndex = 0; // 컬렉션 인덱스 초기화
  }
}
// -------- 파이어스토어 내 데이터를 불러오는 범용성 리포지토리 (데이터 범위는 provider에서 정함) 끝
// -------- 1차 카테고리(블라우스, 가디건 ~~), 상품 상세 화면 관련 데이터 등의 범용성 있게 파이어스토어 데이터를 일정 단위로 불러오도록 하는 클래스 끝 부분

// ------- 상품 상세 화면 내 상품정보 탭 화면에서 이미지 데이터를 불러오는 데이터 처리 로직인 ProductDtTabRepository 클래스 시작 부분
class ProductDtTabRepository {
  final FirebaseFirestore firestore;

  // firestore 인스턴스를 생성자에서 전달받아 사용함.
  ProductDtTabRepository(this.firestore);

  // 상품 상세 이미지 리스트를 페이징 처리하여 가져오는 함수
  // fullPath와 startIndex를 인자로 받아 이미지 데이터를 불러옴.
  Future<List<String>> fetchProductDetailImages({
    required String fullPath,  // Firestore 경로를 전달받음.
    required int startIndex,   // 이미지 필드의 시작 인덱스를 전달받음.
  }) async {
    print("ProductRepository: 상품 상세 이미지 로드 시작 (fullPath: $fullPath, startIndex: $startIndex)");

    // Firestore에서 해당 경로의 문서를 가져옴.
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();  // 문서의 스냅샷을 가져옴.

    // 문서가 존재하는지 확인함.
    if (snapshot.exists) {
      print("ProductRepository: 상품 데이터를 성공적으로 가져옴.");
      final data = snapshot.data() as Map<String, dynamic>;  // 문서 데이터를 맵으로 변환함.

      // 이미지 필드 이름을 배열로 관리하여 순차적으로 접근할 수 있게 처리함.
      List<String> fieldNames = [
        'detail_intro_image1',  // 첫 번째 이미지 필드
        'detail_intro_image2',  // 두 번째 이미지 필드
        'detail_intro_image3',  // 세 번째 이미지 필드
        'detail_intro_image4'   // 네 번째 이미지 필드
      ];

      // 인덱스가 유효한 범위인지 확인함.
      if (startIndex < 0 || startIndex >= fieldNames.length) {
        print("ProductRepository: 더 이상 불러올 이미지가 없습니다.");
        return [];  // 불러올 이미지가 없는 경우 빈 리스트를 반환함.
      }

      // // 해당 인덱스의 이미지를 가져옴.
      // List<String> images = [];
      // String? imageUrl = data[fieldNames[startIndex]] as String?;  // 필드에서 이미지 URL을 가져옴.
      // if (imageUrl != null) {
      //   images.add(imageUrl);  // 유효한 URL이면 리스트에 추가함.
      // }

      // // 인덱스에 따른 이미지 로드 처리
      // List<String> images = [];
      // if (startIndex == 0) {
      //   // 첫 번째 페이지: detail_intro_image1만 불러옴
      //   images.add(data[fieldNames[0]] as String);
      // } else if (startIndex == 1) {
      //   // 두 번째 페이지: detail_intro_image2만 불러옴
      //   images.add(data[fieldNames[1]] as String);
      // } else if (startIndex == 2) {
      //   // 세 번째 페이지: detail_intro_image3 불러옴
      //   images.add(data[fieldNames[2]] as String);
      // } else if (startIndex == 3) {
      //   // 네 번째 페이지: detail_intro_image4 불러옴
      //   images.add(data[fieldNames[3]] as String);
      // }

      // 인덱스에 따른 이미지 로드 처리
      List<String> images = [];
      if (startIndex == 0) {
        // 첫 번째 페이지: detail_intro_image1, detail_intro_image2 불러옴
        images.add(data[fieldNames[0]] as String);
        images.add(data[fieldNames[1]] as String);
      } else if (startIndex == 1) {
        // 두 번째 페이지: detail_intro_image3, detail_intro_image4 불러옴
        images.add(data[fieldNames[2]] as String);
        images.add(data[fieldNames[3]] as String);
      }

      print("ProductRepository: ${images.length}개의 이미지 로드 완료 (로드된 이미지: $images)");

      return images;  // 불러온 이미지를 반환함.
    } else {
      print("ProductRepository: 상품 데이터를 찾을 수 없습니다.");
      throw Exception('상품 데이터를 찾을 수 없습니다.');  // 문서가 없을 경우 예외를 던짐.
    }
  }
}
// ------- 상품 상세 화면 내 상품정보 탭 화면에서 이미지 데이터를 불러오는 데이터 처리 로직인 ProductRepository 클래스 끝 부분