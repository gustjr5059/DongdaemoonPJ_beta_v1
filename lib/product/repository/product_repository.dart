
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
    // 컬렉션 이름 리스트
    'a1b1', 'a2b1', 'a3b1', 'a4b1', 'a5b1', 'a6b1',
    'a7b1', 'a8b1', 'a9b1', 'a10b1', 'a11b1', 'a12b1'
  ];

  NewProductRepository(this.firestore); // 생성자

  // 신상 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchNewProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit && currentCollectionIndex < collections.length) {
      String currentCollection = collections[currentCollectionIndex]; // 현재 컬렉션 이름
      Query query = firestore.collectionGroup(currentCollection).limit(limit - products.length); // 쿼리 설정
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기
      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        products.addAll(snapshots.docs.map((doc) => ProductContent.fromFirestore(doc)).toList()); // 제품 리스트에 추가
      } else {
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    return products; // 제품 리스트 반환
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    lastDocument = null;
    currentCollectionIndex = 0;
  }
}

// Firestore 데이터베이스로부터 최고 상품 정보를 조회하는 기능을 제공하는 클래스
class BestProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    // 컬렉션 이름 리스트
    'a1b2', 'a2b2', 'a3b2', 'a4b2', 'a5b2', 'a6b2',
    'a7b2', 'a8b2', 'a9b2', 'a10b2', 'a11b2', 'a12b2'
  ];

  BestProductRepository(this.firestore); // 생성자

  // 최고 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchBestProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit && currentCollectionIndex < collections.length) {
      String currentCollection = collections[currentCollectionIndex]; // 현재 컬렉션 이름
      Query query = firestore.collectionGroup(currentCollection).limit(limit - products.length); // 쿼리 설정
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기
      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        products.addAll(snapshots.docs.map((doc) => ProductContent.fromFirestore(doc)).toList()); // 제품 리스트에 추가
      } else {
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    return products; // 제품 리스트 반환
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    lastDocument = null;
    currentCollectionIndex = 0;
  }
}

// Firestore 데이터베이스로부터 할인 상품 정보를 조회하는 기능을 제공하는 클래스
class SaleProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    // 컬렉션 이름 리스트
    'a1b3', 'a2b3', 'a3b3', 'a4b3', 'a5b3', 'a6b3',
    'a7b3', 'a8b3', 'a9b3', 'a10b3', 'a11b3', 'a12b3'
  ];

  SaleProductRepository(this.firestore); // 생성자

  // 할인 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchSaleProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit && currentCollectionIndex < collections.length) {
      String currentCollection = collections[currentCollectionIndex]; // 현재 컬렉션 이름
      Query query = firestore.collectionGroup(currentCollection).limit(limit - products.length); // 쿼리 설정
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기
      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        products.addAll(snapshots.docs.map((doc) => ProductContent.fromFirestore(doc)).toList()); // 제품 리스트에 추가
      } else {
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    return products; // 제품 리스트 반환
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    lastDocument = null;
    currentCollectionIndex = 0;
  }
}

// Firestore 데이터베이스로부터 봄 상품 정보를 조회하는 기능을 제공하는 클래스
class SpringProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    // 컬렉션 이름 리스트
    'a1b4', 'a2b4', 'a3b4', 'a4b4', 'a5b4', 'a6b4',
    'a7b4', 'a8b4', 'a9b4', 'a10b4', 'a11b4', 'a12b4'
  ];

  SpringProductRepository(this.firestore); // 생성자

  // 봄 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchSpringProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit && currentCollectionIndex < collections.length) {
      String currentCollection = collections[currentCollectionIndex]; // 현재 컬렉션 이름
      Query query = firestore.collectionGroup(currentCollection).limit(limit - products.length); // 쿼리 설정
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기
      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        products.addAll(snapshots.docs.map((doc) => ProductContent.fromFirestore(doc)).toList()); // 제품 리스트에 추가
      } else {
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    return products; // 제품 리스트 반환
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    lastDocument = null;
    currentCollectionIndex = 0;
  }
}

// Firestore 데이터베이스로부터 여름 상품 정보를 조회하는 기능을 제공하는 클래스
class SummerProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    // 컬렉션 이름 리스트
    'a1b5', 'a2b5', 'a3b5', 'a4b5', 'a5b5', 'a6b5',
    'a7b5', 'a8b5', 'a9b5', 'a10b5', 'a11b5', 'a12b5'
  ];

  SummerProductRepository(this.firestore); // 생성자

  // 여름 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchSummerProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit && currentCollectionIndex < collections.length) {
      String currentCollection = collections[currentCollectionIndex]; // 현재 컬렉션 이름
      Query query = firestore.collectionGroup(currentCollection).limit(limit - products.length); // 쿼리 설정
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기
      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        products.addAll(snapshots.docs.map((doc) => ProductContent.fromFirestore(doc)).toList()); // 제품 리스트에 추가
      } else {
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    return products; // 제품 리스트 반환
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    lastDocument = null;
    currentCollectionIndex = 0;
  }
}

// Firestore 데이터베이스로부터 가을 상품 정보를 조회하는 기능을 제공하는 클래스
class AutumnProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    // 컬렉션 이름 리스트
    'a1b6', 'a2b6', 'a3b6', 'a4b6', 'a5b6', 'a6b6',
    'a7b6', 'a8b6', 'a9b6', 'a10b6', 'a11b6', 'a12b6'
  ];

  AutumnProductRepository(this.firestore); // 생성자

  // 가을 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchAutumnProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit && currentCollectionIndex < collections.length) {
      String currentCollection = collections[currentCollectionIndex]; // 현재 컬렉션 이름
      Query query = firestore.collectionGroup(currentCollection).limit(limit - products.length); // 쿼리 설정
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기
      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        products.addAll(snapshots.docs.map((doc) => ProductContent.fromFirestore(doc)).toList()); // 제품 리스트에 추가
      } else {
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    return products; // 제품 리스트 반환
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    lastDocument = null;
    currentCollectionIndex = 0;
  }
}

// Firestore 데이터베이스로부터 겨울 상품 정보를 조회하는 기능을 제공하는 클래스
class WinterProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    // 컬렉션 이름 리스트
    'a1b7', 'a2b7', 'a3b7', 'a4b7', 'a5b7', 'a6b7',
    'a7b7', 'a8b7', 'a9b7', 'a10b7', 'a11b7', 'a12b7'
  ];

  WinterProductRepository(this.firestore); // 생성자

  // 겨울 상품 데이터를 가져오는 함수 (제품 가져오는 단위가 4개라는 의미 : limit =4)
  Future<List<ProductContent>> fetchWinterProductContents({int limit = 4}) async {
    List<ProductContent> products = []; // 제품 리스트 초기화

    // 필요한 만큼 제품을 가져올 때까지 루프 실행
    while (products.length < limit && currentCollectionIndex < collections.length) {
      String currentCollection = collections[currentCollectionIndex]; // 현재 컬렉션 이름
      Query query = firestore.collectionGroup(currentCollection).limit(limit - products.length); // 쿼리 설정
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후의 데이터 가져오기
      }

      final snapshots = await query.get(); // 쿼리 실행 및 스냅샷 가져오기
      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        products.addAll(snapshots.docs.map((doc) => ProductContent.fromFirestore(doc)).toList()); // 제품 리스트에 추가
      } else {
        lastDocument = null;
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    return products; // 제품 리스트 반환
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    lastDocument = null;
    currentCollectionIndex = 0;
  }
}

// -------- 2차 카테고리(신상, 최고 ~~) 끝 부분

// -------- 1차 카테고리(블라우스, 가디건 ~~) 시작 부분

// Firestore 데이터베이스로부터 블라우스 상품 정보를 조회하는 기능을 제공하는 클래스
class BlouseProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스
  DocumentSnapshot? lastDocument; // 마지막으로 가져온 문서 스냅샷
  int currentCollectionIndex = 0; // 현재 컬렉션 인덱스
  List<String> collections = [
    'a2b1', 'a2b2', 'a2b3', 'a2b4', 'a2b5', 'a2b6', 'a2b7'
  ]; // 컬렉션 목록

  // 생성자에서 Firestore 인스턴스를 초기화
  BlouseProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    // fullPath는 전체 Firestore 경로를 포함합니다.
    final docRef = firestore.doc(fullPath); // 경로에 해당하는 문서 참조
    final snapshot = await docRef.get(); // 문서 스냅샷 가져오기
    if (snapshot.exists) {
      // 조회된 문서 데이터를 ProductContent 모델로 변환하여 반환
      return ProductContent.fromFirestore(snapshot); // 데이터가 존재하면 ProductContent로 변환하여 반환
    } else {
      // 데이터가 없을 경우 예외를 발생시킴
      throw Exception('Firestore 데이터가 없습니다.'); // 데이터가 없으면 예외 발생
    }
  }

  // 2차 메인 화면 내 블라우스 상품 데이터를 가져오는 함수
  Future<List<ProductContent>> fetchBlouseProductContents({required int limit, DocumentSnapshot? startAfter}) async {
    List<ProductContent> products = []; // 상품 목록 초기화

    // 필요한 수의 상품을 가져올 때까지 반복
    while (products.length < limit && currentCollectionIndex < collections.length) {
      String currentCollection = collections[currentCollectionIndex]; // 현재 컬렉션
      Query query = firestore.collectionGroup(currentCollection).limit(limit - products.length); // 현재 컬렉션에서 제한된 수의 상품 가져오기
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!); // 마지막 문서 이후부터 시작
      }

      final snapshots = await query.get(); // 쿼리 실행하여 스냅샷 가져오기
      if (snapshots.docs.isNotEmpty) {
        lastDocument = snapshots.docs.last; // 마지막 문서 업데이트
        products.addAll(snapshots.docs.map((doc) => ProductContent.fromFirestore(doc)).toList()); // 상품 목록에 추가
      } else {
        lastDocument = null; // 문서가 없으면 마지막 문서 초기화
        currentCollectionIndex++; // 다음 컬렉션으로 이동
      }
    }

    return products; // 가져온 상품 목록 반환
  }

  // 각 레포지토리에 데이터를 초기화하는 reset 메서드
  void reset() {
    lastDocument = null; // 마지막 문서 초기화
    currentCollectionIndex = 0; // 컬렉션 인덱스 초기화
  }
}

// Firestore 데이터베이스로부터 가디건 상품 정보를 조회하는 기능을 제공하는 클래스
class CardiganProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  CardiganProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// Firestore 데이터베이스로부터 코트 상품 정보를 조회하는 기능을 제공하는 클래스
class CoatProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  CoatProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// Firestore 데이터베이스로부터 청바지 상품 정보를 조회하는 기능을 제공하는 클래스
class JeanProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  JeanProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// Firestore 데이터베이스로부터 맨투맨 상품 정보를 조회하는 기능을 제공하는 클래스
class MtmProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  MtmProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// Firestore 데이터베이스로부터 니트 상품 정보를 조회하는 기능을 제공하는 클래스
class NeatProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  NeatProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// Firestore 데이터베이스로부터 원피스 상품 정보를 조회하는 기능을 제공하는 클래스
class OnepieceProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  OnepieceProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// Firestore 데이터베이스로부터 패딩 상품 정보를 조회하는 기능을 제공하는 클래스
class PaedingProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  PaedingProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// Firestore 데이터베이스로부터 팬츠 상품 정보를 조회하는 기능을 제공하는 클래스
class PantsProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  PantsProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// Firestore 데이터베이스로부터 폴라티 상품 정보를 조회하는 기능을 제공하는 클래스
class PolaProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  PolaProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// Firestore 데이터베이스로부터 셔츠 상품 정보를 조회하는 기능을 제공하는 클래스
class ShirtProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  ShirtProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// Firestore 데이터베이스로부터 스커트 상품 정보를 조회하는 기능을 제공하는 클래스
class SkirtProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  SkirtProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      return ProductContent.fromFirestore(snapshot);
    } else {
      throw Exception('Firestore 데이터가 없습니다.');
    }
  }
}

// -------- 1차 카테고리(블라우스, 가디건 ~~) 끝 부분
