
// 네트워크 이미지를 캐싱하는 기능을 제공하는 'cached_network_image' 패키지를 임포트합니다.
// 이 패키지는 이미지 로딩 속도를 개선하고 데이터 사용을 최적화합니다.
import 'package:flutter/cupertino.dart';

// Flutter의 기본 디자인과 인터페이스 요소들을 사용하기 위한 Material 디자인 패키지를 임포트합니다.
import 'package:flutter/material.dart'; // Flutter의 기본 디자인 위젯
// 외부 웹사이트나 애플리케이션 링크를 열기 위한 URL Launcher 패키지를 임포트합니다.
import 'package:url_launcher/url_launcher.dart';

// 여러 의류 카테고리 화면을 정의한 파일들을 임포트합니다.
import '../../../../common/model/banner_model.dart';
import '../../../../product/layout/product_body_parts_layout.dart';
import '../../../../product/model/product_model.dart';
// Riverpod는 상태 관리를 위한 외부 라이브러리입니다. 이를 통해 애플리케이션의 상태를 효율적으로 관리할 수 있습니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/provider/aaq_home_state_provider.dart';
import '../../product/provider/aaq_product_all_providers.dart';
import '../../product/provider/aaq_product_state_provider.dart';
import '../../product/view/sub_main_screen/aaq_autumn_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaq_best_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaq_new_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaq_sale_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaq_spring_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaq_summer_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aaq_winter_sub_main_screen.dart';


// ------ 대배너 클릭 시 URL 이동 로직 관련 함수 내용 시작
void aaqOnLargeBannerTap(BuildContext context, int index,
    List<AllLargeBannerImage> images, WidgetRef ref) async {
  // 선택된 인덱스의 배너 이미지 정보를 가져옴
  final bannerImage = images[index];

  // 인덱스가 4이고, subCategory가 있을 경우
  if (index == 4 && bannerImage.subCategory != null) {
    // subCategory에 따른 화면 전환을 위한 변수 선언
    Widget destinationScreen;
    // subCategory 값에 따라 각기 다른 화면으로 이동함
    switch (bannerImage.subCategory) {
      case '신상':
        destinationScreen = AaqNewSubMainScreen();
        break;
      case '스테디 셀러':
        destinationScreen = AaqBestSubMainScreen();
        break;
      case '특가 상품':
        destinationScreen = AaqSaleSubMainScreen();
        break;
      case '봄':
        destinationScreen = AaqSpringSubMainScreen();
        break;
      case '여름':
        destinationScreen = AaqSummerSubMainScreen();
        break;
      case '가을':
        destinationScreen = AaqAutumnSubMainScreen();
        break;
      case '겨울':
        destinationScreen = AaqWinterSubMainScreen();
        break;
      default:
        // 유효하지 않은 카테고리일 경우 경고 메시지 출력 후 함수 종료
        print('유효하지 않은 카테고리입니다.');
        return;
    }
    // 선택한 화면으로 이동함
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => destinationScreen));
  }
  // productId가 있을 경우 해당 제품 상세 화면으로 이동함
  else if (bannerImage.productId != null) {
    final product = ProductContent(
      docId: bannerImage.productId!, // 제품 문서 ID 설정
      category: bannerImage.category, // 제품 카테고리 설정
    );
    // 제품 상세 화면으로 이동하는 함수 호출
    ProductInfoDetailScreenNavigation(ref)
        .navigateToDetailScreen(context, product);
  }
  // url이 있을 경우 외부 URL로 이동함
  else if (bannerImage.url != null) {
    Uri uri = Uri.parse(bannerImage.url!); // URL 파싱
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // URL 실행
    } else {
      // URL이 없을 경우 경고 메시지 출력
      print('링크가 없는 배너입니다.');
    }
  }
  // 위 조건에 모두 해당되지 않을 경우 경고 메시지 출력
  else {
    print('링크가 없는 배너입니다.');
  }
}
// ------ 대배너 클릭 시 URL 이동 로직 관련 함수 내용 끝

// ------ 소배너 클릭 시 URL 이동 로직 관련 함수 내용 시작
void aaqOnSmallBannerTap(BuildContext context, int index,
    List<AllSmallBannerImage> images, WidgetRef ref) async {
  // 선택된 인덱스의 배너 이미지 정보를 가져옴
  final bannerImage = images[index];

  // productId가 있을 경우 해당 제품 상세 화면으로 이동함
  if (bannerImage.productId != null) {
    final product = ProductContent(
      docId: bannerImage.productId!, // 제품 문서 ID 설정
      category: bannerImage.category, // 제품 카테고리 설정
    );
    // 제품 상세 화면으로 이동하는 함수 호출
    ProductInfoDetailScreenNavigation(ref)
        .navigateToDetailScreen(context, product);
  }
  // url이 있을 경우 외부 URL로 이동함
  else if (bannerImage.url != null) {
    Uri uri = Uri.parse(bannerImage.url!); // URL 파싱
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // URL 실행
    } else {
      // URL이 없을 경우 경고 메시지 출력
      print('링크가 없는 배너입니다.');
    }
  }
  // 위 조건에 모두 해당되지 않을 경우 경고 메시지 출력
  else {
    print('링크가 없는 배너입니다.');
  }
}
// ------ 소배너 클릭 시 URL 이동 로직 관련 함수 내용 끝

// ------ 상점 내 각 화면별 초기화 로직 내용 시작
class AaqStoreInitializer {
  final WidgetRef ref;

  AaqStoreInitializer(this.ref);

  void reset() {
    // ------ Aaq 상점 초기화 부분 시작
    // 홈 화면 관련 초기화 부분 시작
    // 스크롤 위치 및 현재 탭 인덱스 초기화
    ref.read(aaqHomeScrollPositionProvider.notifier).state =
    0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqHomeCurrentTabProvider.notifier).state =
    0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
    ref.read(aaqHomeSmall1BannerPageProvider.notifier).state =
    0; // 홈 소배너1 페이지뷰 초기화
    ref.read(aaqHomeSmall2BannerPageProvider.notifier).state =
    0; // 홈 소배너2 페이지뷰 초기화
    ref.read(aaqHomeSmall3BannerPageProvider.notifier).state =
    0; // 홈 소배너3 페이지뷰 초기화
    ref.read(aaqHomeSectionScrollPositionsProvider.notifier).state =
    {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
    // 홈 화면 관련 초기화 부분 끝

    // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
    ref.invalidate(aaqMainProductRepositoryProvider);
    ref.invalidate(aaqSectionProductRepositoryProvider);
    // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

    // ------ 2차 메인 화면 관련 부분 시작
    // 블라우스 메인 화면 관련 초기화 부분 시작
    ref.read(aaqBlouseMainScrollPositionProvider.notifier).state =
    0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqBlouseCurrentTabProvider.notifier).state =
    0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqBlouseMainLargeBannerPageProvider.notifier).state =
    0; // 블라우스 대배너 페이지뷰 초기화
    ref.read(aaqBlouseMainSmall1BannerPageProvider.notifier).state =
    0; // 블라우스 소배너 페이지뷰 초기화
    ref
        .read(aaqBlouseMainProductListProvider.notifier)
        .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqBlouseMainSortButtonProvider.notifier).state =
    ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 블라우스 메인 화면 관련 초기화 부분 끝

    // 가디건 메인 화면 관련 초기화 부분 시작
    ref.read(aaqCardiganMainScrollPositionProvider.notifier).state =
    0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqCardiganCurrentTabProvider.notifier).state =
    0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqCardiganMainLargeBannerPageProvider.notifier).state =
    0; // 가디건 대배너 페이지뷰 초기화
    ref.read(aaqCardiganMainSmall1BannerPageProvider.notifier).state =
    0; // 가디건 소배너 페이지뷰 초기화
    ref
        .read(aaqCardiganMainProductListProvider.notifier)
        .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqCardiganMainSortButtonProvider.notifier).state =
    ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 가디건 메인 화면 관련 초기화 부분 끝

    // 코트 메인 화면 관련 초기화 부분 시작
    ref.read(aaqCoatMainScrollPositionProvider.notifier).state =
    0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqCoatCurrentTabProvider.notifier).state =
    0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqCoatMainLargeBannerPageProvider.notifier).state =
    0; // 코트 대배너 페이지뷰 초기화
    ref.read(aaqCoatMainSmall1BannerPageProvider.notifier).state =
    0; // 코트 소배너 페이지뷰 초기화
    ref
        .read(aaqCoatMainProductListProvider.notifier)
        .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqCoatMainSortButtonProvider.notifier).state =
    ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 코트 메인 화면 관련 초기화 부분 끝

    // 청바지 메인 화면 관련 초기화 부분 시작
    ref.read(aaqJeanMainScrollPositionProvider.notifier).state =
    0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqJeanCurrentTabProvider.notifier).state =
    0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqJeanMainLargeBannerPageProvider.notifier).state =
    0; // 청바지 대배너 페이지뷰 초기화
    ref.read(aaqJeanMainSmall1BannerPageProvider.notifier).state =
    0; // 청바지 소배너 페이지뷰 초기화
    ref
        .read(aaqJeanMainProductListProvider.notifier)
        .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqJeanMainSortButtonProvider.notifier).state =
    ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 청바지 메인 화면 관련 초기화 부분 끝

    // 맨투맨 메인 화면 관련 초기화 부분 시작
    ref.read(aaqMtmMainScrollPositionProvider.notifier).state =
    0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqMtmCurrentTabProvider.notifier).state =
    0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqMtmMainLargeBannerPageProvider.notifier).state =
    0; // 맨투맨 대배너 페이지뷰 초기화
    ref.read(aaqMtmMainSmall1BannerPageProvider.notifier).state =
    0; // 맨투맨 소배너 페이지뷰 초기화
    ref
        .read(aaqMtmMainProductListProvider.notifier)
        .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqMtmMainSortButtonProvider.notifier).state =
    ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 맨투맨 메인 화면 관련 초기화 부분 끝

    // 니트 메인 화면 관련 초기화 부분 시작
    ref.read(aaqNeatMainScrollPositionProvider.notifier).state =
    0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqNeatCurrentTabProvider.notifier).state =
    0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqNeatMainLargeBannerPageProvider.notifier).state =
    0; // 니트 대배너 페이지뷰 초기화
    ref.read(aaqNeatMainSmall1BannerPageProvider.notifier).state =
    0; // 니트 소배너 페이지뷰 초기화
    ref
        .read(aaqNeatMainProductListProvider.notifier)
        .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqNeatMainSortButtonProvider.notifier).state =
    ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 니트 메인 화면 관련 초기화 부분 끝

    // 원피스 메인 화면 관련 초기화 부분 시작
    ref.read(aaqOnepieceMainScrollPositionProvider.notifier).state =
    0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqOnepieceCurrentTabProvider.notifier).state =
    0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqOnepieceMainLargeBannerPageProvider.notifier).state =
    0; // 원피스 대배너 페이지뷰 초기화
    ref.read(aaqOnepieceMainSmall1BannerPageProvider.notifier).state =
    0; // 원피스 소배너 페이지뷰 초기화
    ref
        .read(aaqOnepieceMainProductListProvider.notifier)
        .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqOnepieceMainSortButtonProvider.notifier).state =
    ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 원피스 메인 화면 관련 초기화 부분 끝

    // 패딩 메인 화면 관련 초기화 부분 시작
    ref.read(aaqPaedingMainScrollPositionProvider.notifier).state =
    0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqPaedingCurrentTabProvider.notifier).state =
    0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqPaedingMainLargeBannerPageProvider.notifier).state =
    0; // 패딩 대배너 페이지뷰 초기화
    ref.read(aaqPaedingMainSmall1BannerPageProvider.notifier).state =
    0; // 패딩 소배너 페이지뷰 초기화
    ref
        .read(aaqPaedingMainProductListProvider.notifier)
        .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqPaedingMainSortButtonProvider.notifier).state =
    ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 패딩 메인 화면 관련 초기화 부분 끝

    // 팬츠 메인 화면 관련 초기화 부분 시작
    ref.read(aaqPantsMainScrollPositionProvider.notifier).state =
    0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqPantsCurrentTabProvider.notifier).state =
    0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqPantsMainLargeBannerPageProvider.notifier).state =
    0; // 팬츠 대배너 페이지뷰 초기화
    ref.read(aaqPantsMainSmall1BannerPageProvider.notifier).state =
    0; // 팬츠 소배너 페이지뷰 초기화
    ref
        .read(aaqPantsMainProductListProvider.notifier)
        .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqPantsMainSortButtonProvider.notifier).state =
    ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 팬츠 메인 화면 관련 초기화 부분 끝

    // 폴라티 메인 화면 관련 초기화 부분 시작
    ref.read(aaqPolaMainScrollPositionProvider.notifier).state =
    0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqPolaCurrentTabProvider.notifier).state =
    0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqPolaMainLargeBannerPageProvider.notifier).state =
    0; // 폴라티 대배너 페이지뷰 초기화
    ref.read(aaqPolaMainSmall1BannerPageProvider.notifier).state =
    0; // 폴라티 소배너 페이지뷰 초기화
    ref
        .read(aaqPolaMainProductListProvider.notifier)
        .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqPolaMainSortButtonProvider.notifier).state =
    ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 폴라티 메인 화면 관련 초기화 부분 끝

    // 티셔츠 메인 화면 관련 초기화 부분 시작
    ref.read(aaqShirtMainScrollPositionProvider.notifier).state =
    0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqShirtCurrentTabProvider.notifier).state =
    0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqShirtMainLargeBannerPageProvider.notifier).state =
    0; // 티셔츠 대배너 페이지뷰 초기화
    ref.read(aaqShirtMainSmall1BannerPageProvider.notifier).state =
    0; // 티셔츠 소배너 페이지뷰 초기화
    ref
        .read(aaqShirtMainProductListProvider.notifier)
        .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqShirtMainSortButtonProvider.notifier).state =
    ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 티셔츠 메인 화면 관련 초기화 부분 끝

    // 스커트 메인 화면 관련 초기화 부분 시작
    ref.read(aaqSkirtMainScrollPositionProvider.notifier).state =
    0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aaqSkirtCurrentTabProvider.notifier).state =
    0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aaqSkirtMainLargeBannerPageProvider.notifier).state =
    0; // 스커트 대배너 페이지뷰 초기화
    ref.read(aaqSkirtMainSmall1BannerPageProvider.notifier).state =
    0; // 스커트 소배너 페이지뷰 초기화
    ref
        .read(aaqSkirtMainProductListProvider.notifier)
        .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aaqSkirtMainSortButtonProvider.notifier).state =
    ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 스커트 메인 화면 관련 초기화 부분 끝
    // ------ 2차 메인 화면 관련 부분 끝

    // ------ 섹션 더보기 화면 관련 부분 시작
    // 신상 더보기 화면 관련 초기화 부분 시작
    ref.read(aaqNewSubMainScrollPositionProvider.notifier).state =
    0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaqNewSubMainProductListProvider.notifier)
        .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaqNewSubMainSortButtonProvider.notifier).state =
    ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaqNewSubMainLargeBannerPageProvider.notifier).state =
    0; // 신상 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaqNewSubMainSmall1BannerPageProvider.notifier).state =
    0; // 신상 더보기 화면 소배너 페이지뷰 초기화
    // 신상 더보기 화면 관련 초기화 부분 끝

    // 최고 더보기 화면 관련 초기화 부분 시작
    ref.read(aaqBestSubMainScrollPositionProvider.notifier).state =
    0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaqBestSubMainProductListProvider.notifier)
        .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaqBestSubMainSortButtonProvider.notifier).state =
    ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaqBestSubMainLargeBannerPageProvider.notifier).state =
    0; // 최고 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaqBestSubMainSmall1BannerPageProvider.notifier).state =
    0; // 최고 더보기 화면 소배너 페이지뷰 초기화
    // 최고 더보기 화면 관련 초기화 부분 끝

    // 할인 더보기 화면 관련 초기화 부분 시작
    ref.read(aaqSaleSubMainScrollPositionProvider.notifier).state =
    0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaqSaleSubMainProductListProvider.notifier)
        .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaqSaleSubMainSortButtonProvider.notifier).state =
    ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaqSaleSubMainLargeBannerPageProvider.notifier).state =
    0; // 할인 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaqSaleSubMainSmall1BannerPageProvider.notifier).state =
    0; // 할인 더보기 화면 소배너 페이지뷰 초기화
    // 할인 더보기 화면 관련 초기화 부분 끝

    // 봄 더보기 화면 관련 초기화 부분 시작
    ref.read(aaqSpringSubMainScrollPositionProvider.notifier).state =
    0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaqSpringSubMainProductListProvider.notifier)
        .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaqSpringSubMainSortButtonProvider.notifier).state =
    ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaqSpringSubMainLargeBannerPageProvider.notifier).state =
    0; // 봄 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaqSpringSubMainSmall1BannerPageProvider.notifier).state =
    0; // 봄 더보기 화면 소배너 페이지뷰 초기화
    // 봄 더보기 화면 관련 초기화 부분 끝

    // 여름 더보기 화면 관련 초기화 부분 시작
    ref.read(aaqSummerSubMainScrollPositionProvider.notifier).state =
    0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaqSummerSubMainProductListProvider.notifier)
        .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaqSummerSubMainSortButtonProvider.notifier).state =
    ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaqSummerSubMainLargeBannerPageProvider.notifier).state =
    0; // 여름 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaqSummerSubMainSmall1BannerPageProvider.notifier).state =
    0; // 여름 더보기 화면 소배너 페이지뷰 초기화
    // 여름 더보기 화면 관련 초기화 부분 끝

    // 가을 더보기 화면 관련 초기화 부분 시작
    ref.read(aaqAutumnSubMainScrollPositionProvider.notifier).state =
    0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaqAutumnSubMainProductListProvider.notifier)
        .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaqAutumnSubMainSortButtonProvider.notifier).state =
    ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaqAutumnSubMainLargeBannerPageProvider.notifier).state =
    0; // 가을 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaqAutumnSubMainSmall1BannerPageProvider.notifier).state =
    0; // 가을 더보기 화면 소배너 페이지뷰 초기화
    // 가을 더보기 화면 관련 초기화 부분 끝

    // 겨울 더보기 화면 관련 초기화 부분 시작
    ref.read(aaqWinterSubMainScrollPositionProvider.notifier).state =
    0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aaqWinterSubMainProductListProvider.notifier)
        .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
    ref.read(aaqWinterSubMainSortButtonProvider.notifier).state =
    ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aaqWinterSubMainLargeBannerPageProvider.notifier).state =
    0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aaqWinterSubMainSmall1BannerPageProvider.notifier).state =
    0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
    // 겨울 더보기 화면 관련 초기화 부분 끝
    // ------ 섹션 더보기 화면 관련 부분 끝

    // ------ Aaq 상점 초기화 부분 끝
  }
}
// ------ 상점 내 각 화면별 초기화 로직 내용 끝
