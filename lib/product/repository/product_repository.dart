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

  void reset(); // 상태 초기화를 위한 메서드 추가
}
// -------- MainCategoryProductsRepository, SectionCategoryProductsRepository를 분기해서 사용하도록 하는 추상 클래스 내용 끝

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