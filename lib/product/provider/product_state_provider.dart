// Riverpod 라이브러리를 임포트합니다.
// 이 라이브러리는 상태 관리를 위한 강력하고 유연한 프레임워크로, 애플리케이션의 다양한 상태를 관리하는데 도움을 줍니다.
// Riverpod는 기존 Provider 라이브러리를 기반으로 하여 더욱 발전된 기능을 제공하며,
// 각종 상태 관리 요구 사항을 보다 세밀하고 효과적으로 다룰 수 있도록 설계되었습니다.
// 이를 통해 앱의 상태를 전역적으로 또는 로컬적으로 제어하고, 상태 변화에 따라 UI를 자동으로 업데이트하는 구조를 구현할 수 있습니다.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongdaemoon_beta_v1/product/provider/product_all_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';


// ------ 상세 화면마다의 각 id를 통해서 이미지 상태관리하는 provider를 케이스로 나눠서 개별적으로 사용하도록 한 로직 부분 시작
// _imagePageProviders라는 Map을 선언함. 키는 문자열이고 값은 StateProvider<int>임.
final Map<String, StateProvider<int>> _imagePageProviders = {};

// productId를 받아서 해당하는 StateProvider<int>를 반환하는 함수.
StateProvider<int> getImagePageProvider(String productId) {
  // _imagePageProviders에 productId가 존재하지 않으면 새 StateProvider<int>를 생성하여 추가하고, 존재하면 기존 값을 반환함.
  return _imagePageProviders.putIfAbsent(
      productId, () => StateProvider<int>((ref) => 0));
}
// ------ 상세 화면마다의 각 id를 통해서 이미지 상태관리하는 provider를 케이스로 나눠서 개별적으로 사용하도록 한 로직 부분 끝

// 상품 상세 화면에서 이미지 클릭 시, 상세 이미지 화면으로 이동하는 데 해당 화면 내 이미지 페이지 인덱스 상태관리 관련 StateProvider
final detailImagePageProvider = StateProvider<int>((ref) => 0);
// 색상 선택을 위한 상태 관리용 StateProvider
final colorSelectionUrlProvider = StateProvider<String?>((ref) => null);
final colorSelectionTextProvider = StateProvider<String?>((ref) => null);
final colorSelectionIndexProvider = StateProvider<int>((ref) => 0);
// 사이즈 선택을 위한 상태 관리용 StateProvider
final sizeSelectionIndexProvider = StateProvider<String?>((ref) => null);
// 상품 상세 화면에서 수량 부분의 숫자 인덱스 상태관리 관련 StateProvider
final detailQuantityIndexProvider = StateProvider<int>((ref) => 1);
// 상품 상세 화면에서 '상품 정보', '리뷰', '문의' 탭으로 각 탭이 선택될 때마다 각 내용이 나오도록 하는 ProductDetailScreenTabs 클래스
// 관련 탭 섹션 상수 부분
enum ProdDetailScreenTabSection { productInfo, reviews, inquiry }
// 상품 상세 화면에서 '상품 정보', '리뷰', '문의' 탭으로 각 탭이 선택될 때마다 각 내용이 나오도록 하는 ProductDetailScreenTabs 클래스
// 관련 탭 섹션 상태관리 관련 StateProvider
final prodDetailScreenTabSectionProvider = StateProvider<ProdDetailScreenTabSection>((ref) => ProdDetailScreenTabSection.productInfo);
// ------- 상품 상세 화면 관련 StateProvider 끝

// 상품 상세화면 내 상품정보 안에서 이미지의 전체 이미지로 보이도록하는 확장 유무 상태관리인 showFullImageProvider
final showFullImageProvider = StateProvider<bool>((ref) => false);

// ------ 이미지 리스트의 상태를 관리하며, 이미지를 페이징 처리하여 불러오는 로직인 ImageNotifier 클래스 시작 부분
class ImageNotifier extends StateNotifier<List<String>> {
  final ProductDtTabRepository repository; // 상품 데이터를 불러오는 레포지토리
  final Ref ref; // Provider에서 사용할 참조 객체
  final String fullPath; // Firestore 경로를 저장
  int currentIndex = 0;  // 현재까지 불러온 마지막 이미지 인덱스를 저장
  bool isLoadingMore = false; // 이미지 로드 중 여부를 저장
  bool hasMore = true; // 추가 이미지를 로드할 수 있는지 여부를 저장
  bool showCollapseButton = false; // '접기' 버튼을 표시할지 여부

  // 생성자에서 초기 값을 설정함.
  ImageNotifier({
    required this.repository,
    required this.ref,
    required this.fullPath,
  }) : super([]) {
    // 첫 번째 이미지를 로드함.
    print("ImageNotifier: 첫 번째 이미지 로드 시작.");
    loadMoreImages(); // 생성 시 처음에 1개의 이미지를 로드함.
  }

  // 이미지 리스트를 유지하면서 상태만 초기화하는 함수
  void resetButtonState() {
    showCollapseButton = false;  // '접기' 버튼을 초기화
  }

  // 추가 이미지를 로드하는 함수
  Future<void> loadMoreImages() async {
    // 이미 로드 중이거나 더 이상 로드할 이미지가 없을 경우, 로드를 중단함.
    if (isLoadingMore || !hasMore) {
      print("ImageNotifier: 이미 로드 중이거나 더 이상 로드할 이미지가 없습니다.");
      return;
    }

    print("ImageNotifier: 이미지 로드 시작 (currentIndex: $currentIndex)");
    isLoadingMore = true; // 로드 중 상태로 설정함.

    try {
      // 현재 인덱스를 기반으로 Firestore에서 이미지를 불러옴.
      final images = await repository.fetchProductDetailImages(
        fullPath: fullPath,  // Firestore 경로를 전달함.
        startIndex: currentIndex,  // 현재 인덱스를 전달함.
      );

      if (images.isNotEmpty) {
        currentIndex++;  // 이미지가 로드되면 인덱스를 증가시킴.
        state = [...state, ...images]; // 새로 불러온 이미지를 기존 상태에 추가함.

        // 두 번째 페이지일 때 바로 '접기' 버튼을 표시하도록 설정
        if (currentIndex == 2) {
          showCollapseButton = true;
        }
        print("ImageNotifier: 이미지 로드 성공, 현재 이미지 수: ${state.length}, 현재 인덱스: $currentIndex");
      } else {
        hasMore = false; // 불러올 이미지가 없으면 더 이상 로드하지 않도록 설정함.
        print("ImageNotifier: 더 이상 불러올 이미지가 없습니다.");
      }
    } catch (e) {
      print("ImageNotifier: 이미지 로드 중 에러 발생 - $e"); // 에러 발생 시 출력함.
    } finally {
      isLoadingMore = false;  // 이미지 로드가 완료되면 로드 중 상태를 해제함.
      // 상태가 변경되었음을 알리기 위해 상태 변화를 알림.
      ref.notifyListeners();
      print("ImageNotifier: 이미지 로드 완료.");
    }
  }

  // 이미지 리스트를 초기화하고 첫 번째 이미지를 다시 로드하는 함수
  void reset() {
    print("ImageNotifier: 이미지 리스트 초기화 및 첫 번째 이미지 로드 시작.");
    state = []; // 이미지 리스트를 초기화함.
    currentIndex = 0; // 인덱스를 초기화함.
    hasMore = true; // 추가 로드를 가능하게 설정함.
    loadMoreImages(); // 첫 번째 이미지를 다시 로드함.
  }
}

// imagesProvider는 ImageNotifier를 제공하며, fullPath를 매개변수로 받음.
// Provider를 통해 ImageNotifier를 상태로 관리함.
final imagesProvider = StateNotifierProvider.family<ImageNotifier, List<String>, String>((ref, fullPath) {
  final repository = ref.read(productDtTabRepositoryProvider); // 레포지토리를 읽어옴.
  return ImageNotifier(repository: repository, ref: ref, fullPath: fullPath); // ImageNotifier를 생성하여 반환함.
});