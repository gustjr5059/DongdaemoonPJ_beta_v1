
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

  // 생성자에서 Firestore 인스턴스를 초기화
  NewProductRepository(this.firestore);

  // 주어진 문서 ID를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String docId) async {
    // Firestore에서 특정 문서 ID를 가진 'couturier' 컬렉션의 문서를 조회
    final snapshot = await firestore.collection('couturier').doc(docId).get();
    // 조회된 문서 데이터를 ProductContent 모델로 변환하여 반환
    return ProductContent.fromFirestore(snapshot);
  }

  // a1 ~ a12 문서 하위의 a1b1 ~ a12b1 컬렉션의 데이터를 가져오는 함수
  Future<List<ProductContent>> fetchNewProductContents() async {
    List<ProductContent> products = [];
    // print('Fetching new product contents...'); // 로그 추가

    // a1 ~ a12 문서의 하위 컬렉션인 a1b1 ~ a12b1의 문서들을 조회
    for (int i = 1; i <= 12; i++) {
      for (int j = 1; j <= 15; j++) {
        String documentPath = 'couturier/a$i/a${i}b1/a${i}b1_$j';
        try {
          final snapshot = await firestore.doc(documentPath).get();
          if (snapshot.exists) {
            products.add(ProductContent.fromFirestore(snapshot));
          } else {
            print('Document not found: $documentPath'); // 로그 추가
          }
        } catch (e) {
          print('Error fetching document: $documentPath, error: $e'); // 에러 로그 추가
        }
      }
    }

    // print('Fetched ${products.length} products.'); // 로그 추가
    return products;
  }
}

// Firestore 데이터베이스로부터 최고 상품 정보를 조회하는 기능을 제공하는 클래스
class BestProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  BestProductRepository(this.firestore);

  // 주어진 문서 ID를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String docId) async {
    // Firestore에서 특정 문서 ID를 가진 'couturier' 컬렉션의 문서를 조회
    final snapshot = await firestore.collection('couturier').doc(docId).get();
    // 조회된 문서 데이터를 ProductContent 모델로 변환하여 반환
    return ProductContent.fromFirestore(snapshot);
  }

  // a1 ~ a12 문서 하위의 a1b2 ~ a12b2 컬렉션의 데이터를 가져오는 함수
  Future<List<ProductContent>> fetchBestProductContents() async {
    List<ProductContent> products = [];
    // print('Fetching best product contents...'); // 로그 추가

    // a1 ~ a12 문서의 하위 컬렉션인 a1b2 ~ a12b2의 문서들을 조회
    for (int i = 1; i <= 12; i++) {
      for (int j = 1; j <= 15; j++) {
        String documentPath = 'couturier/a$i/a${i}b2/a${i}b2_$j';
        try {
          final snapshot = await firestore.doc(documentPath).get();
          if (snapshot.exists) {
            products.add(ProductContent.fromFirestore(snapshot));
          } else {
            print('Document not found: $documentPath'); // 로그 추가
          }
        } catch (e) {
          print('Error fetching document: $documentPath, error: $e'); // 에러 로그 추가
        }
      }
    }

    // print('Fetched ${products.length} products.'); // 로그 추가
    return products;
  }
}

// Firestore 데이터베이스로부터 할인 상품 정보를 조회하는 기능을 제공하는 클래스
class SaleProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  SaleProductRepository(this.firestore);

  // 주어진 문서 ID를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String docId) async {
    // Firestore에서 특정 문서 ID를 가진 'couturier' 컬렉션의 문서를 조회
    final snapshot = await firestore.collection('couturier').doc(docId).get();
    // 조회된 문서 데이터를 ProductContent 모델로 변환하여 반환
    return ProductContent.fromFirestore(snapshot);
  }

  // a1 ~ a12 문서 하위의 a1b3 ~ a12b3 컬렉션의 데이터를 가져오는 함수
  Future<List<ProductContent>> fetchSaleProductContents() async {
    List<ProductContent> products = [];
    // print('Fetching sale product contents...'); // 로그 추가

    // a1 ~ a12 문서의 하위 컬렉션인 a1b3 ~ a12b3의 문서들을 조회
    for (int i = 1; i <= 12; i++) {
      for (int j = 1; j <= 15; j++) {
        String documentPath = 'couturier/a$i/a${i}b3/a${i}b3_$j';
        try {
          final snapshot = await firestore.doc(documentPath).get();
          if (snapshot.exists) {
            products.add(ProductContent.fromFirestore(snapshot));
          } else {
            print('Document not found: $documentPath'); // 로그 추가
          }
        } catch (e) {
          print('Error fetching document: $documentPath, error: $e'); // 에러 로그 추가
        }
      }
    }

    // print('Fetched ${products.length} products.'); // 로그 추가
    return products;
  }
}

// Firestore 데이터베이스로부터 봄 상품 정보를 조회하는 기능을 제공하는 클래스
class SpringProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  SpringProductRepository(this.firestore);

  // 주어진 문서 ID를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String docId) async {
    // Firestore에서 특정 문서 ID를 가진 'couturier' 컬렉션의 문서를 조회
    final snapshot = await firestore.collection('couturier').doc(docId).get();
    // 조회된 문서 데이터를 ProductContent 모델로 변환하여 반환
    return ProductContent.fromFirestore(snapshot);
  }

  // a1 ~ a12 문서 하위의 a1b4 ~ a12b4 컬렉션의 데이터를 가져오는 함수
  Future<List<ProductContent>> fetchSpringProductContents() async {
    List<ProductContent> products = [];
    // print('Fetching spring product contents...'); // 로그 추가

    // a1 ~ a12 문서의 하위 컬렉션인 a1b4 ~ a12b4의 문서들을 조회
    for (int i = 1; i <= 12; i++) {
      for (int j = 1; j <= 15; j++) {
        String documentPath = 'couturier/a$i/a${i}b4/a${i}b4_$j';
        try {
          final snapshot = await firestore.doc(documentPath).get();
          if (snapshot.exists) {
            products.add(ProductContent.fromFirestore(snapshot));
          } else {
            print('Document not found: $documentPath'); // 로그 추가
          }
        } catch (e) {
          print('Error fetching document: $documentPath, error: $e'); // 에러 로그 추가
        }
      }
    }

    // print('Fetched ${products.length} products.'); // 로그 추가
    return products;
  }
}

// Firestore 데이터베이스로부터 여름 상품 정보를 조회하는 기능을 제공하는 클래스
class SummerProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  SummerProductRepository(this.firestore);

  // 주어진 문서 ID를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String docId) async {
    // Firestore에서 특정 문서 ID를 가진 'couturier' 컬렉션의 문서를 조회
    final snapshot = await firestore.collection('couturier').doc(docId).get();
    // 조회된 문서 데이터를 ProductContent 모델로 변환하여 반환
    return ProductContent.fromFirestore(snapshot);
  }

  // a1 ~ a12 문서 하위의 a1b5 ~ a12b5 컬렉션의 데이터를 가져오는 함수
  Future<List<ProductContent>> fetchSummerProductContents() async {
    List<ProductContent> products = [];
    // print('Fetching summer product contents...'); // 로그 추가

    // a1 ~ a12 문서의 하위 컬렉션인 a1b5 ~ a12b5의 문서들을 조회
    for (int i = 1; i <= 12; i++) {
      for (int j = 1; j <= 15; j++) {
        String documentPath = 'couturier/a$i/a${i}b5/a${i}b5_$j';
        try {
          final snapshot = await firestore.doc(documentPath).get();
          if (snapshot.exists) {
            products.add(ProductContent.fromFirestore(snapshot));
          } else {
            print('Document not found: $documentPath'); // 로그 추가
          }
        } catch (e) {
          print('Error fetching document: $documentPath, error: $e'); // 에러 로그 추가
        }
      }
    }

    // print('Fetched ${products.length} products.'); // 로그 추가
    return products;
  }
}

// Firestore 데이터베이스로부터 가을 상품 정보를 조회하는 기능을 제공하는 클래스
class AutumnProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  AutumnProductRepository(this.firestore);

  // 주어진 문서 ID를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String docId) async {
    // Firestore에서 특정 문서 ID를 가진 'couturier' 컬렉션의 문서를 조회
    final snapshot = await firestore.collection('couturier').doc(docId).get();
    // 조회된 문서 데이터를 ProductContent 모델로 변환하여 반환
    return ProductContent.fromFirestore(snapshot);
  }

  // a1 ~ a12 문서 하위의 a1b6 ~ a12b6 컬렉션의 데이터를 가져오는 함수
  Future<List<ProductContent>> fetchAutumnProductContents() async {
    List<ProductContent> products = [];
    // print('Fetching autumn product contents...'); // 로그 추가

    // a1 ~ a12 문서의 하위 컬렉션인 a1b6 ~ a12b6의 문서들을 조회
    for (int i = 1; i <= 12; i++) {
      for (int j = 1; j <= 15; j++) {
        String documentPath = 'couturier/a$i/a${i}b6/a${i}b6_$j';
        try {
          final snapshot = await firestore.doc(documentPath).get();
          if (snapshot.exists) {
            products.add(ProductContent.fromFirestore(snapshot));
          } else {
            print('Document not found: $documentPath'); // 로그 추가
          }
        } catch (e) {
          print('Error fetching document: $documentPath, error: $e'); // 에러 로그 추가
        }
      }
    }

    // print('Fetched ${products.length} products.'); // 로그 추가
    return products;
  }
}

// Firestore 데이터베이스로부터 겨울 상품 정보를 조회하는 기능을 제공하는 클래스
class WinterProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  WinterProductRepository(this.firestore);

  // 주어진 문서 ID를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String docId) async {
    // Firestore에서 특정 문서 ID를 가진 'couturier' 컬렉션의 문서를 조회
    final snapshot = await firestore.collection('couturier').doc(docId).get();
    // 조회된 문서 데이터를 ProductContent 모델로 변환하여 반환
    return ProductContent.fromFirestore(snapshot);
  }

  // a1 ~ a12 문서 하위의 a1b7 ~ a12b7 컬렉션의 데이터를 가져오는 함수
  Future<List<ProductContent>> fetchWinterProductContents() async {
    List<ProductContent> products = [];
    // print('Fetching winter product contents...'); // 로그 추가

    // a1 ~ a12 문서의 하위 컬렉션인 a1b7 ~ a12b7의 문서들을 조회
    for (int i = 1; i <= 12; i++) {
      for (int j = 1; j <= 15; j++) {
        String documentPath = 'couturier/a$i/a${i}b7/a${i}b7_$j';
        try {
          final snapshot = await firestore.doc(documentPath).get();
          if (snapshot.exists) {
            products.add(ProductContent.fromFirestore(snapshot));
          } else {
            print('Document not found: $documentPath'); // 로그 추가
          }
        } catch (e) {
          print('Error fetching document: $documentPath, error: $e'); // 에러 로그 추가
        }
      }
    }

    // print('Fetched ${products.length} products.'); // 로그 추가
    return products;
  }
}

// -------- 2차 카테고리(신상, 최고 ~~) 끝 부분

// -------- 1차 카테고리(블라우스, 가디건 ~~) 시작 부분

// Firestore 데이터베이스로부터 블라우스 상품 정보를 조회하는 기능을 제공하는 클래스
class BlouseProductRepository {
  final FirebaseFirestore firestore; // Firestore 인스턴스

  // 생성자에서 Firestore 인스턴스를 초기화
  BlouseProductRepository(this.firestore);

  // 주어진 전체 경로(fullPath)를 사용하여 Firestore에서 상품 데이터를 조회하고 ProductContent 객체로 변환하는 함수
  Future<ProductContent> getProduct(String fullPath) async {
    // fullPath는 전체 Firestore 경로를 포함합니다.
    final docRef = firestore.doc(fullPath);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      // 조회된 문서 데이터를 ProductContent 모델로 변환하여 반환
      return ProductContent.fromFirestore(snapshot);
    } else {
      // 데이터가 없을 경우 예외를 발생시킴
      throw Exception('Firestore 데이터가 없습니다.');
    }
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
