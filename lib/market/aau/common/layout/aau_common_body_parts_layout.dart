
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

import '../../home/provider/aau_home_state_provider.dart';
import '../../product/provider/aau_product_all_providers.dart';
import '../../product/provider/aau_product_state_provider.dart';
import '../../product/view/sub_main_screen/aau_autumn_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_best_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_new_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_sale_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_spring_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_summer_sub_main_screen.dart';
import '../../product/view/sub_main_screen/aau_winter_sub_main_screen.dart';


// ------ 대배너 클릭 시 URL 이동 로직 관련 함수 내용 시작
void aauOnLargeBannerTap(BuildContext context, int index,
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
        destinationScreen = AauNewSubMainScreen();
        break;
      case '스테디 셀러':
        destinationScreen = AauBestSubMainScreen();
        break;
      case '특가 상품':
        destinationScreen = AauSaleSubMainScreen();
        break;
      case '봄':
        destinationScreen = AauSpringSubMainScreen();
        break;
      case '여름':
        destinationScreen = AauSummerSubMainScreen();
        break;
      case '가을':
        destinationScreen = AauAutumnSubMainScreen();
        break;
      case '겨울':
        destinationScreen = AauWinterSubMainScreen();
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
void aauOnSmallBannerTap(BuildContext context, int index,
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
class AauStoreInitializer {
  final WidgetRef ref;

  AauStoreInitializer(this.ref);

  void reset() {
    // ------ Aau 상점 초기화 부분 시작
    // 홈 화면 관련 초기화 부분 시작
    // 스크롤 위치 및 현재 탭 인덱스 초기화
    ref.read(aauHomeScrollPositionProvider.notifier).state =
    0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauHomeCurrentTabProvider.notifier).state =
    0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
    ref.read(aauHomeSmall1BannerPageProvider.notifier).state =
    0; // 홈 소배너1 페이지뷰 초기화
    ref.read(aauHomeSmall2BannerPageProvider.notifier).state =
    0; // 홈 소배너2 페이지뷰 초기화
    ref.read(aauHomeSmall3BannerPageProvider.notifier).state =
    0; // 홈 소배너3 페이지뷰 초기화
    ref.read(aauHomeSectionScrollPositionsProvider.notifier).state =
    {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
    // 홈 화면 관련 초기화 부분 끝

    // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
    ref.invalidate(aauMainProductRepositoryProvider);
    ref.invalidate(aauSectionProductRepositoryProvider);
    // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

    // ------ 2차 메인 화면 관련 부분 시작
    // 블라우스 메인 화면 관련 초기화 부분 시작
    ref.read(aauBlouseMainScrollPositionProvider.notifier).state =
    0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauBlouseCurrentTabProvider.notifier).state =
    0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauBlouseMainLargeBannerPageProvider.notifier).state =
    0; // 블라우스 대배너 페이지뷰 초기화
    ref.read(aauBlouseMainSmall1BannerPageProvider.notifier).state =
    0; // 블라우스 소배너 페이지뷰 초기화
    ref
        .read(aauBlouseMainProductListProvider.notifier)
        .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauBlouseMainSortButtonProvider.notifier).state =
    ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 블라우스 메인 화면 관련 초기화 부분 끝

    // 가디건 메인 화면 관련 초기화 부분 시작
    ref.read(aauCardiganMainScrollPositionProvider.notifier).state =
    0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauCardiganCurrentTabProvider.notifier).state =
    0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauCardiganMainLargeBannerPageProvider.notifier).state =
    0; // 가디건 대배너 페이지뷰 초기화
    ref.read(aauCardiganMainSmall1BannerPageProvider.notifier).state =
    0; // 가디건 소배너 페이지뷰 초기화
    ref
        .read(aauCardiganMainProductListProvider.notifier)
        .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauCardiganMainSortButtonProvider.notifier).state =
    ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 가디건 메인 화면 관련 초기화 부분 끝

    // 코트 메인 화면 관련 초기화 부분 시작
    ref.read(aauCoatMainScrollPositionProvider.notifier).state =
    0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauCoatCurrentTabProvider.notifier).state =
    0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauCoatMainLargeBannerPageProvider.notifier).state =
    0; // 코트 대배너 페이지뷰 초기화
    ref.read(aauCoatMainSmall1BannerPageProvider.notifier).state =
    0; // 코트 소배너 페이지뷰 초기화
    ref
        .read(aauCoatMainProductListProvider.notifier)
        .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauCoatMainSortButtonProvider.notifier).state =
    ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 코트 메인 화면 관련 초기화 부분 끝

    // 청바지 메인 화면 관련 초기화 부분 시작
    ref.read(aauJeanMainScrollPositionProvider.notifier).state =
    0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauJeanCurrentTabProvider.notifier).state =
    0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauJeanMainLargeBannerPageProvider.notifier).state =
    0; // 청바지 대배너 페이지뷰 초기화
    ref.read(aauJeanMainSmall1BannerPageProvider.notifier).state =
    0; // 청바지 소배너 페이지뷰 초기화
    ref
        .read(aauJeanMainProductListProvider.notifier)
        .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauJeanMainSortButtonProvider.notifier).state =
    ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 청바지 메인 화면 관련 초기화 부분 끝

    // 맨투맨 메인 화면 관련 초기화 부분 시작
    ref.read(aauMtmMainScrollPositionProvider.notifier).state =
    0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauMtmCurrentTabProvider.notifier).state =
    0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauMtmMainLargeBannerPageProvider.notifier).state =
    0; // 맨투맨 대배너 페이지뷰 초기화
    ref.read(aauMtmMainSmall1BannerPageProvider.notifier).state =
    0; // 맨투맨 소배너 페이지뷰 초기화
    ref
        .read(aauMtmMainProductListProvider.notifier)
        .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauMtmMainSortButtonProvider.notifier).state =
    ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 맨투맨 메인 화면 관련 초기화 부분 끝

    // 니트 메인 화면 관련 초기화 부분 시작
    ref.read(aauNeatMainScrollPositionProvider.notifier).state =
    0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauNeatCurrentTabProvider.notifier).state =
    0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauNeatMainLargeBannerPageProvider.notifier).state =
    0; // 니트 대배너 페이지뷰 초기화
    ref.read(aauNeatMainSmall1BannerPageProvider.notifier).state =
    0; // 니트 소배너 페이지뷰 초기화
    ref
        .read(aauNeatMainProductListProvider.notifier)
        .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauNeatMainSortButtonProvider.notifier).state =
    ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 니트 메인 화면 관련 초기화 부분 끝

    // 원피스 메인 화면 관련 초기화 부분 시작
    ref.read(aauOnepieceMainScrollPositionProvider.notifier).state =
    0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauOnepieceCurrentTabProvider.notifier).state =
    0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauOnepieceMainLargeBannerPageProvider.notifier).state =
    0; // 원피스 대배너 페이지뷰 초기화
    ref.read(aauOnepieceMainSmall1BannerPageProvider.notifier).state =
    0; // 원피스 소배너 페이지뷰 초기화
    ref
        .read(aauOnepieceMainProductListProvider.notifier)
        .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauOnepieceMainSortButtonProvider.notifier).state =
    ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 원피스 메인 화면 관련 초기화 부분 끝

    // 패딩 메인 화면 관련 초기화 부분 시작
    ref.read(aauPaedingMainScrollPositionProvider.notifier).state =
    0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauPaedingCurrentTabProvider.notifier).state =
    0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauPaedingMainLargeBannerPageProvider.notifier).state =
    0; // 패딩 대배너 페이지뷰 초기화
    ref.read(aauPaedingMainSmall1BannerPageProvider.notifier).state =
    0; // 패딩 소배너 페이지뷰 초기화
    ref
        .read(aauPaedingMainProductListProvider.notifier)
        .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauPaedingMainSortButtonProvider.notifier).state =
    ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 패딩 메인 화면 관련 초기화 부분 끝

    // 팬츠 메인 화면 관련 초기화 부분 시작
    ref.read(aauPantsMainScrollPositionProvider.notifier).state =
    0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauPantsCurrentTabProvider.notifier).state =
    0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauPantsMainLargeBannerPageProvider.notifier).state =
    0; // 팬츠 대배너 페이지뷰 초기화
    ref.read(aauPantsMainSmall1BannerPageProvider.notifier).state =
    0; // 팬츠 소배너 페이지뷰 초기화
    ref
        .read(aauPantsMainProductListProvider.notifier)
        .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauPantsMainSortButtonProvider.notifier).state =
    ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 팬츠 메인 화면 관련 초기화 부분 끝

    // 폴라티 메인 화면 관련 초기화 부분 시작
    ref.read(aauPolaMainScrollPositionProvider.notifier).state =
    0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauPolaCurrentTabProvider.notifier).state =
    0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauPolaMainLargeBannerPageProvider.notifier).state =
    0; // 폴라티 대배너 페이지뷰 초기화
    ref.read(aauPolaMainSmall1BannerPageProvider.notifier).state =
    0; // 폴라티 소배너 페이지뷰 초기화
    ref
        .read(aauPolaMainProductListProvider.notifier)
        .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauPolaMainSortButtonProvider.notifier).state =
    ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 폴라티 메인 화면 관련 초기화 부분 끝

    // 티셔츠 메인 화면 관련 초기화 부분 시작
    ref.read(aauShirtMainScrollPositionProvider.notifier).state =
    0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauShirtCurrentTabProvider.notifier).state =
    0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauShirtMainLargeBannerPageProvider.notifier).state =
    0; // 티셔츠 대배너 페이지뷰 초기화
    ref.read(aauShirtMainSmall1BannerPageProvider.notifier).state =
    0; // 티셔츠 소배너 페이지뷰 초기화
    ref
        .read(aauShirtMainProductListProvider.notifier)
        .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauShirtMainSortButtonProvider.notifier).state =
    ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 티셔츠 메인 화면 관련 초기화 부분 끝

    // 스커트 메인 화면 관련 초기화 부분 시작
    ref.read(aauSkirtMainScrollPositionProvider.notifier).state =
    0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
    ref.read(aauSkirtCurrentTabProvider.notifier).state =
    0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
    ref.read(aauSkirtMainLargeBannerPageProvider.notifier).state =
    0; // 스커트 대배너 페이지뷰 초기화
    ref.read(aauSkirtMainSmall1BannerPageProvider.notifier).state =
    0; // 스커트 소배너 페이지뷰 초기화
    ref
        .read(aauSkirtMainProductListProvider.notifier)
        .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
    ref.read(aauSkirtMainSortButtonProvider.notifier).state =
    ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    // 스커트 메인 화면 관련 초기화 부분 끝
    // ------ 2차 메인 화면 관련 부분 끝

    // ------ 섹션 더보기 화면 관련 부분 시작
    // 신상 더보기 화면 관련 초기화 부분 시작
    ref.read(aauNewSubMainScrollPositionProvider.notifier).state =
    0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aauNewSubMainProductListProvider.notifier)
        .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
    ref.read(aauNewSubMainSortButtonProvider.notifier).state =
    ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aauNewSubMainLargeBannerPageProvider.notifier).state =
    0; // 신상 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aauNewSubMainSmall1BannerPageProvider.notifier).state =
    0; // 신상 더보기 화면 소배너 페이지뷰 초기화
    // 신상 더보기 화면 관련 초기화 부분 끝

    // 최고 더보기 화면 관련 초기화 부분 시작
    ref.read(aauBestSubMainScrollPositionProvider.notifier).state =
    0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aauBestSubMainProductListProvider.notifier)
        .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
    ref.read(aauBestSubMainSortButtonProvider.notifier).state =
    ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aauBestSubMainLargeBannerPageProvider.notifier).state =
    0; // 최고 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aauBestSubMainSmall1BannerPageProvider.notifier).state =
    0; // 최고 더보기 화면 소배너 페이지뷰 초기화
    // 최고 더보기 화면 관련 초기화 부분 끝

    // 할인 더보기 화면 관련 초기화 부분 시작
    ref.read(aauSaleSubMainScrollPositionProvider.notifier).state =
    0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aauSaleSubMainProductListProvider.notifier)
        .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
    ref.read(aauSaleSubMainSortButtonProvider.notifier).state =
    ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aauSaleSubMainLargeBannerPageProvider.notifier).state =
    0; // 할인 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aauSaleSubMainSmall1BannerPageProvider.notifier).state =
    0; // 할인 더보기 화면 소배너 페이지뷰 초기화
    // 할인 더보기 화면 관련 초기화 부분 끝

    // 봄 더보기 화면 관련 초기화 부분 시작
    ref.read(aauSpringSubMainScrollPositionProvider.notifier).state =
    0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aauSpringSubMainProductListProvider.notifier)
        .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
    ref.read(aauSpringSubMainSortButtonProvider.notifier).state =
    ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aauSpringSubMainLargeBannerPageProvider.notifier).state =
    0; // 봄 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aauSpringSubMainSmall1BannerPageProvider.notifier).state =
    0; // 봄 더보기 화면 소배너 페이지뷰 초기화
    // 봄 더보기 화면 관련 초기화 부분 끝

    // 여름 더보기 화면 관련 초기화 부분 시작
    ref.read(aauSummerSubMainScrollPositionProvider.notifier).state =
    0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aauSummerSubMainProductListProvider.notifier)
        .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
    ref.read(aauSummerSubMainSortButtonProvider.notifier).state =
    ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aauSummerSubMainLargeBannerPageProvider.notifier).state =
    0; // 여름 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aauSummerSubMainSmall1BannerPageProvider.notifier).state =
    0; // 여름 더보기 화면 소배너 페이지뷰 초기화
    // 여름 더보기 화면 관련 초기화 부분 끝

    // 가을 더보기 화면 관련 초기화 부분 시작
    ref.read(aauAutumnSubMainScrollPositionProvider.notifier).state =
    0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aauAutumnSubMainProductListProvider.notifier)
        .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
    ref.read(aauAutumnSubMainSortButtonProvider.notifier).state =
    ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aauAutumnSubMainLargeBannerPageProvider.notifier).state =
    0; // 가을 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aauAutumnSubMainSmall1BannerPageProvider.notifier).state =
    0; // 가을 더보기 화면 소배너 페이지뷰 초기화
    // 가을 더보기 화면 관련 초기화 부분 끝

    // 겨울 더보기 화면 관련 초기화 부분 시작
    ref.read(aauWinterSubMainScrollPositionProvider.notifier).state =
    0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
    ref
        .read(aauWinterSubMainProductListProvider.notifier)
        .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
    ref.read(aauWinterSubMainSortButtonProvider.notifier).state =
    ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
    ref.read(aauWinterSubMainLargeBannerPageProvider.notifier).state =
    0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
    ref.read(aauWinterSubMainSmall1BannerPageProvider.notifier).state =
    0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
    // 겨울 더보기 화면 관련 초기화 부분 끝
    // ------ 섹션 더보기 화면 관련 부분 끝

    // ------ Aau 상점 초기화 부분 끝
  }
}
// ------ 상점 내 각 화면별 초기화 로직 내용 끝
