import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../announcement/provider/announce_state_provider.dart';
import '../../cart/provider/cart_state_provider.dart';
import '../../common/provider/common_state_provider.dart';
import '../../home/provider/home_state_provider.dart';
import '../../inquiry/provider/inquiry_state_provider.dart';
import '../../manager/message/provider/message_all_provider.dart';
import '../../manager/message/provider/message_state_provider.dart';
import '../../manager/orderlist/provider/orderlist_all_provider.dart';
import '../../manager/orderlist/provider/orderlist_state_provider.dart';
import '../../manager/review/provider/review_all_provider.dart';
import '../../manager/review/provider/review_state_provider.dart';
import '../../market/aaa/home/provider/aaa_home_state_provider.dart';
import '../../market/aaa/product/provider/aaa_product_all_providers.dart';
import '../../market/aaa/product/provider/aaa_product_state_provider.dart';
import '../../message/provider/message_all_provider.dart';
import '../../message/provider/message_state_provider.dart';
import '../../order/provider/complete_payment_provider.dart';
import '../../order/provider/order_all_providers.dart';
import '../../order/provider/order_state_provider.dart';
import '../../product/provider/product_state_provider.dart';
import '../../review/provider/review_state_provider.dart';
import '../../wishlist/provider/wishlist_all_providers.dart';
import '../../wishlist/provider/wishlist_state_provider.dart';
import '../provider/profile_state_provider.dart';


// 로그아웃 및 자동로그인 체크 상태에서 앱 종료 후 재실행 시,
// 홈 내 섹션의 데이터 초기화 / 홈 화면 내 섹션의 스크롤 위치 초기화
// ------ 홈,장바구니,발주내역,마이페이지,2차 메인 화면 등 모든 화면화면 자체의 스크롤 위치 초기화 관련 함수 시작 부분
Future<void> logoutAndLoginAfterProviderReset(WidgetRef ref) async {
  // 로그아웃 기능 수행
  await FirebaseAuth.instance.signOut(); // Firebase 인증 로그아웃
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 자동 로그인 정보 삭제 및 비활성화
  prefs.setBool('autoLogin', false); // 자동 로그인 체크박스 비활성화
  // prefs.remove('autoLogin'); // 자동 로그인 정보 삭제
  prefs.remove('username'); // 저장된 사용자명 삭제
  prefs.remove('password'); // 저장된 비밀번호 삭제

  // 로그아웃했다가 재로그인 시, 초가화하려면 여기에 적용시켜야 반영이 됨
  // 모든 화면에서 로그아웃 버튼을 클릭했을 때 모든 화면의 상태를 초기화하는 로직-앱 종료 후 재실행할 때인 경우에도 여기 포함됨
  // 각 화면마다의 FirebaseAuth.instance.authStateChanges().listen((user) 여기에도 provider 구현하고, 여기에도 구현하는 두 곳 다 구현해야함.
  // 홈 화면 관련 초기화 부분 시작
  // 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(homeScrollPositionProvider.notifier).state =
      0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(homeCurrentTabProvider.notifier).state =
      0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(homeSectionScrollPositionsProvider.notifier).state =
      {}; // 홈 화면 내 섹션의 스크롤 위치 초기화
  ref.read(midCategoryViewBoolExpandedProvider.notifier).state =
      false; // 홈 화면 내 카테고리 버튼 뷰 확장 상태 관련 provider를 초기화
  ref.read(homeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(homeSmall1BannerPageProvider.notifier).state = 0; // 홈 소배너1 페이지뷰 초기화
  ref.invalidate(marketBtnProvider); // 홈 마켓 버튼 페이지뷰 초기화
  // 홈 화면 관련 초기화 부분 끝

  // 장바구니 화면 관련 초기화 부분 시작
  // 장바구니 화면에서 단순 화면 스크롤 초기화
  ref.read(cartScrollPositionProvider.notifier).state = 0.0;
  ref.invalidate(cartItemsProvider); // 장바구니 데이터 초기화
  // resetAndReloadCartItems를 호출하기 위해 cartItemsProvider.notifier를 읽어서 호출
  ref.read(cartItemsProvider.notifier).resetAndReloadCartItems();
  ref.invalidate(cartItemCountProvider); // 장바구니 아이템 갯수 데이터 초기화
  // 장바구니 화면 관련 초기화 부분 끝

  // 발주 내역 화면 관련 초기화 부분 시작
  // 발주 내역 화면에서 단순 화면 스크롤 초기화
  ref.read(orderListScrollPositionProvider.notifier).state = 0.0;
  // 발주 목록 내 데이터를 불러오는 orderlistItemsProvider 초기화
  ref.invalidate(orderlistItemsProvider);
  // 발주 내역 화면 관련 초기화 부분 끝

  // 발주 내역 상세 화면 관련 초기화 부분 시작
  // 발주 화면에서 로그아웃 이벤트를 실시간으로 감지하고 처리하는 로직 (여기에도 발주 화면 내 프로바이더 중 초기화해야하는 것을 로직 구현)
  ref.read(orderListDetailScrollPositionProvider.notifier).state =
      0.0; // 발주 화면 자체의 스크롤 위치 인덱스를 초기화
  // 발주 목록 상세 화면 내 발주내역 데이터를 불러오는 로직 초기화
  ref.invalidate(orderlistDetailItemProvider);
  // 발주 목록 상세 화면 내 '환불' 버튼과 '리뷰 작성' 버튼 활성도 관련 데이터를 불러오는 로직 초기화
  ref.invalidate(buttonInfoProvider);
  // 발주 내역 상세 화면 관련 초기화 부분 끝

  // ----- 발주 화면 관련 초기화 부분 시작
  // 발주 화면에서 단순 화면 스크롤 초기화
  ref.read(orderMainScrollPositionProvider.notifier).state = 0.0;
  // ref.invalidate(orderItemsProvider); // 발주 상품 정보를 불러오는 프로바이더 초기화
  ref.invalidate(deliveryMethodSelectProvider); // 수령방식 선택 정보를 불러오는 프로바이더 초기화
  // 발주 화면 내 수령자 정보 관련 초기화 부분 시작
  ref.invalidate(recipientInfoItemsProvider); // 수령자 정보 목록 초기화
  ref.invalidate(saveRecipientInfoProvider); // 수령자 정보 저장 관련 상태 초기화
  ref.invalidate(recipientInfoItemRepositoryProvider); // 수령자 정보 Repository 초기화
  // 수령자 정보 즐겨찾기 선택 화면 스크롤 위치 초기화
  ref.read(recipientInfoFavoritesSelectScrollPositionProvider.notifier).state =
      0.0; // 스크롤 위치 초기화
  // 발주 화면 내 수령자 정보 관련 초기화 부분 끝
  // ----- 발주 화면 관련 초기화 부분 끝

  // 발주 완료 화면 관련 초기화 부분 시작
  // 발주 완료 화면에서 단순 화면 스크롤 초기화
  ref.read(completePaymentScrollPositionProvider.notifier).state = 0.0;
  // 발주 완료 화면 관련 초기화 부분 끝

  // 찜 목록 화면 관련 초기화 부분 시작
  // 찜 목록 화면에서 단순 화면 스크롤 초기화
  ref.read(wishlistScrollPositionProvider.notifier).state = 0.0;
  ref.invalidate(wishlistItemProvider); // 찜 목록 데이터 초기화
  ref.invalidate(wishlistItemsLoadFutureProvider); // 찜 목록  데이터 로드 초기화
  ref.invalidate(wishlistItemLoadStreamProvider); // 찜 목록 실시간 삭제된 데이터 로드 초기화
  ref.invalidate(wishlistItemCountProvider); // 찜 목록 아이템 갯수 데이터 초기화
  // 찜 목록 화면 관련 초기화 부분 끝

  // 마이페이지 화면 관련 초기화 부분 시작
  ref.read(profileMainScrollPositionProvider.notifier).state =
      0.0; // 마이페이지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(profileMainSmall1BannerPageProvider.notifier).state =
      0; // 마이페이지 소배너 페이지뷰 초기화
  // 머아패아자 화면 관련 초기화 부분 끝

  // 공지사항 화면 관련 초기화 부분 시작
  ref.read(announceScrollPositionProvider.notifier).state =
      0.0; // 공지사항 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(announceDetailScrollPositionProvider.notifier).state =
      0.0; // 공지사항 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  // 공지사항 화면 내 데이터를 불러오는 announceItemsProvider 초기화
  ref.invalidate(announceItemsProvider);
  // 공지사항 상세 화면 내 데이터를 불러오는 announceDetailItemProvider 초기화
  ref.invalidate(announceDetailItemProvider);
  // 공지사항 화면 관련 초기화 부분 끝

  // 문의하기 화면 관련 초기화 부분 시작
  ref.read(inquiryScrollPositionProvider.notifier).state =
      0.0; // 문의하기 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  // 문의하기 화면 관련 초기화 부분 끝

  // 쪽지 관리 화면 관련 초기화 부분 시작
  ref.read(privateMessageScrollPositionProvider.notifier).state =
      0.0; // 쪽지 관리 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.invalidate(currentUserEmailProvider); // 현재 사용자 이메일 데이터 초기화
  // 계정별로 불러오는 마이페이지용 쪽지함 내 메시지 데이터 불러오는 로직 초기화
  ref.invalidate(privateMessageItemsListNotifierProvider);
  ref.invalidate(paymentCompleteDateProvider); // 결제완료일 데이터 초기화
  ref.invalidate(deliveryStartDateProvider); // 배송시작일 데이터 초기화
  // 쪽지 관리 화면 관련 초기화 부분 끝

  // 리뷰 관리 화면 관련 초기화 부분 시작
  ref.read(privateReviewScrollPositionProvider.notifier).state =
      0.0; // 리뷰 관리 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  // ref.invalidate(reviewUserOrdersProvider); // 리뷰 작성 데이터를 초기화
  // ref.read(privateReviewScreenTabProvider.notifier).state =
  //     ReviewScreenTab.create; // 리뷰 작성/목록 탭 초기화
  // // 리뷰 관리 화면 중 리뷰 작성 탭 화면 내 '환불' 버튼과 '리뷰 작성' 버튼 활성도 관련 데이터를 불러오는 로직 초기화
  // ref.invalidate(buttonInfoProvider);
  // ref.invalidate(reviewListProvider); // 리뷰 목록 초기화
  // ref.invalidate(deleteReviewProvider); // 리뷰 삭제 관련 데이터 초기화
  // ref.invalidate(productReviewProvider); // 특정 상품에 대한 리뷰 데이터를 초기화
  ref.invalidate(privateReviewItmesListNotifierProvider); // 리뷰 데이터를 초기화
  // 리뷰 관리 화면 관련 초기화 부분 끝

  // ------ 관리자용 화면인 리뷰관리, 쪽지관리, 발주내역 관리, 찜 목록 괸리, 공지사항 관리 관련 초기화 부분 시작
  // 리뷰 관리 화면 초기화 시작
  ref.read(adminReviewScrollPositionProvider.notifier).state = 0.0;
  // 선택된 사용자 이메일 초기화
  ref.read(adminSelectedUserEmailProvider.notifier).state = null;
  // 사용자 이메일 목록 초기화
  ref.invalidate(adminUsersEmailProvider);
  // 리뷰 목록 초기화 (프로바이더를 무효화)
  ref.invalidate(adminReviewItemsListNotifierProvider);
  // 리뷰 관리 화면 초기화 끝

  // 쪽지 관리 화면 초기화 시작
  ref.read(adminMessageScrollPositionProvider.notifier).state = 0.0;
  // 쪽지 관리 화면 내 발신자 관련 로그인한 이메일 계정 데이터 불러오는 로직 초기화
  ref.invalidate(currentUserProvider);
  // 쪽지 관리 화면 내 users에 있는 이메일 계정 데이터 불러오는 로직 초기화
  ref.invalidate(receiversProvider);
  // 쪽지 관리 화면 내 선택된 이메일 계정 관련 발주번호 데이터 불러오는 로직 초기화
  ref.invalidate(orderNumbersProvider);
  // 쪽지 관리 화면 초기화 시, 내용 선택 관려 드롭다운 메뉴 선택 상태 초기화
  ref.read(adminMessageContentProvider.notifier).state = null;
  // 쪽지 관리 화면 초기화 시, 선택한 메뉴 관려 텍스트 노출 입력칸 노출 상태 초기화
  ref.read(adminCustomMessageProvider.notifier).state = null;
  // 쪽지 관리 화면 초기화 시, 탭 선택 상태 초기화
  ref.read(adminMessageScreenTabProvider.notifier).state =
      MessageScreenTab.create;
  // 관리자용 쪽지 관리 화면 내 '쪽지 목록' 탭 화면에서 선택된 수신자 이메일 상태 초기화
  // 선택된 수신자 이메일 상태 초기화
  ref.read(selectedReceiverProvider.notifier).state = null;
  // 수신자 이메일 목록 초기화
  ref.invalidate(receiversProvider);
  // 쪽지 목록 초기화 (프로바이더를 무효화)
  ref
      .read(adminMessageItemsListNotifierProvider.notifier)
      .resetAndReloadMessages(timeFrame: 30);

  // 쪽지 관리 화면 초기화 끝

  // 발주내역 관리 화면 초기화 시작
  // 발주내역 관리 화면 자체의 스크롤 초기화
  ref.read(adminOrderlistScrollPositionProvider.notifier).state = 0.0;
  // 발주내역 상세 관리 화면 자체의 스크롤 초기화
  ref.read(adminOrderListDetailScrollPositionProvider.notifier).state = 0.0;
  // 선택된 발주자 이메일 초기화
  ref.read(adminSelectedOrdererEmailProvider.notifier).state = null;
  // 발주자 이메일 목록 초기화
  ref.invalidate(adminOrdererEmailProvider);
  // 발주 내역 초기화 (프로바이더를 무효화)
  ref.invalidate(adminOrderlistItemsListNotifierProvider);
  // 발주내역 관리 화면 초기화 끝
  // ------ 관리자용 화면인 리뷰관리, 쪽지관리, 발주내역 관리, 찜 목록 괸리, 공지사항 관리 관련 초기화 부분 끝

  // ------ 상점별 홈 화면, 2차 메인 화면, 상품 상세 화면, 섹션더보기 화면 관련 초기화 부분 시작
  // ------ Aaa 상점 초기화 부분 시작
  // 홈 화면 관련 초기화 부분 시작
  // 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(aaaHomeScrollPositionProvider.notifier).state =
      0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaHomeCurrentTabProvider.notifier).state =
      0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaHomeLargeBannerPageProvider.notifier).state = 0; // 홈 대배너 페이지뷰 초기화
  ref.read(aaaHomeSmall1BannerPageProvider.notifier).state =
      0; // 홈 소배너1 페이지뷰 초기화
  ref.read(aaaHomeSmall2BannerPageProvider.notifier).state =
      0; // 홈 소배너2 페이지뷰 초기화
  ref.read(aaaHomeSmall3BannerPageProvider.notifier).state =
      0; // 홈 소배너3 페이지뷰 초기화
  // 홈 화면 관련 초기화 부분 끝

  // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 시작
  ref.invalidate(aaaMainProductRepositoryProvider);
  ref.invalidate(aaaSectionProductRepositoryProvider);
  // 섹션 더보기 화면과 2차 메인 화면 데이터 불러오는 로직 초기화 부분 끝

  // ------ 2차 메인 화면 관련 부분 시작
  // 블라우스 메인 화면 관련 초기화 부분 시작
  ref.read(aaaBlouseMainScrollPositionProvider.notifier).state =
      0.0; // 블라우스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaBlouseCurrentTabProvider.notifier).state =
      0; // 블라우스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaBlouseMainLargeBannerPageProvider.notifier).state =
      0; // 블라우스 대배너 페이지뷰 초기화
  ref.read(aaaBlouseMainSmall1BannerPageProvider.notifier).state =
      0; // 블라우스 소배너 페이지뷰 초기화
  ref
      .read(aaaBlouseMainProductListProvider.notifier)
      .reset(); // 블라우스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaBlouseMainSortButtonProvider.notifier).state =
      ''; // 블라우스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 블라우스 메인 화면 관련 초기화 부분 끝

  // 가디건 메인 화면 관련 초기화 부분 시작
  ref.read(aaaCardiganMainScrollPositionProvider.notifier).state =
      0.0; // 가디건 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaCardiganCurrentTabProvider.notifier).state =
      0; // 가디건 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaCardiganMainLargeBannerPageProvider.notifier).state =
      0; // 가디건 대배너 페이지뷰 초기화
  ref.read(aaaCardiganMainSmall1BannerPageProvider.notifier).state =
      0; // 가디건 소배너 페이지뷰 초기화
  ref
      .read(aaaCardiganMainProductListProvider.notifier)
      .reset(); // 가디건 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaCardiganMainSortButtonProvider.notifier).state =
      ''; // 가디건 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 가디건 메인 화면 관련 초기화 부분 끝

  // 코트 메인 화면 관련 초기화 부분 시작
  ref.read(aaaCoatMainScrollPositionProvider.notifier).state =
      0.0; // 코트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaCoatCurrentTabProvider.notifier).state =
      0; // 코트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaCoatMainLargeBannerPageProvider.notifier).state =
      0; // 코트 대배너 페이지뷰 초기화
  ref.read(aaaCoatMainSmall1BannerPageProvider.notifier).state =
      0; // 코트 소배너 페이지뷰 초기화
  ref
      .read(aaaCoatMainProductListProvider.notifier)
      .reset(); // 코트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaCoatMainSortButtonProvider.notifier).state =
      ''; // 코트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 코트 메인 화면 관련 초기화 부분 끝

  // 청바지 메인 화면 관련 초기화 부분 시작
  ref.read(aaaJeanMainScrollPositionProvider.notifier).state =
      0.0; // 청바지 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaJeanCurrentTabProvider.notifier).state =
      0; // 청바지 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaJeanMainLargeBannerPageProvider.notifier).state =
      0; // 청바지 대배너 페이지뷰 초기화
  ref.read(aaaJeanMainSmall1BannerPageProvider.notifier).state =
      0; // 청바지 소배너 페이지뷰 초기화
  ref
      .read(aaaJeanMainProductListProvider.notifier)
      .reset(); // 청바지 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaJeanMainSortButtonProvider.notifier).state =
      ''; // 청바지 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 청바지 메인 화면 관련 초기화 부분 끝

  // 맨투맨 메인 화면 관련 초기화 부분 시작
  ref.read(aaaMtmMainScrollPositionProvider.notifier).state =
      0.0; // 맨투맨 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaMtmCurrentTabProvider.notifier).state =
      0; // 맨투맨 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaMtmMainLargeBannerPageProvider.notifier).state =
      0; // 맨투맨 대배너 페이지뷰 초기화
  ref.read(aaaMtmMainSmall1BannerPageProvider.notifier).state =
      0; // 맨투맨 소배너 페이지뷰 초기화
  ref
      .read(aaaMtmMainProductListProvider.notifier)
      .reset(); // 맨투맨 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaMtmMainSortButtonProvider.notifier).state =
      ''; // 맨투맨 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 맨투맨 메인 화면 관련 초기화 부분 끝

  // 니트 메인 화면 관련 초기화 부분 시작
  ref.read(aaaNeatMainScrollPositionProvider.notifier).state =
      0.0; // 니트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaNeatCurrentTabProvider.notifier).state =
      0; // 니트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaNeatMainLargeBannerPageProvider.notifier).state =
      0; // 니트 대배너 페이지뷰 초기화
  ref.read(aaaNeatMainSmall1BannerPageProvider.notifier).state =
      0; // 니트 소배너 페이지뷰 초기화
  ref
      .read(aaaNeatMainProductListProvider.notifier)
      .reset(); // 니트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaNeatMainSortButtonProvider.notifier).state =
      ''; // 니트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 니트 메인 화면 관련 초기화 부분 끝

  // 원피스 메인 화면 관련 초기화 부분 시작
  ref.read(aaaOnepieceMainScrollPositionProvider.notifier).state =
      0.0; // 원피스 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaOnepieceCurrentTabProvider.notifier).state =
      0; // 원피스 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaOnepieceMainLargeBannerPageProvider.notifier).state =
      0; // 원피스 대배너 페이지뷰 초기화
  ref.read(aaaOnepieceMainSmall1BannerPageProvider.notifier).state =
      0; // 원피스 소배너 페이지뷰 초기화
  ref
      .read(aaaOnepieceMainProductListProvider.notifier)
      .reset(); // 원피스 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaOnepieceMainSortButtonProvider.notifier).state =
      ''; // 원피스 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 원피스 메인 화면 관련 초기화 부분 끝

  // 패딩 메인 화면 관련 초기화 부분 시작
  ref.read(aaaPaedingMainScrollPositionProvider.notifier).state =
      0.0; // 패딩 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaPaedingCurrentTabProvider.notifier).state =
      0; // 패딩 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaPaedingMainLargeBannerPageProvider.notifier).state =
      0; // 패딩 대배너 페이지뷰 초기화
  ref.read(aaaPaedingMainSmall1BannerPageProvider.notifier).state =
      0; // 패딩 소배너 페이지뷰 초기화
  ref
      .read(aaaPaedingMainProductListProvider.notifier)
      .reset(); // 패딩 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaPaedingMainSortButtonProvider.notifier).state =
      ''; // 패딩 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 패딩 메인 화면 관련 초기화 부분 끝

  // 팬츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaaPantsMainScrollPositionProvider.notifier).state =
      0.0; // 팬츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaPantsCurrentTabProvider.notifier).state =
      0; // 팬츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaPantsMainLargeBannerPageProvider.notifier).state =
      0; // 팬츠 대배너 페이지뷰 초기화
  ref.read(aaaPantsMainSmall1BannerPageProvider.notifier).state =
      0; // 팬츠 소배너 페이지뷰 초기화
  ref
      .read(aaaPantsMainProductListProvider.notifier)
      .reset(); // 팬츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaPantsMainSortButtonProvider.notifier).state =
      ''; // 팬츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 팬츠 메인 화면 관련 초기화 부분 끝

  // 폴라티 메인 화면 관련 초기화 부분 시작
  ref.read(aaaPolaMainScrollPositionProvider.notifier).state =
      0.0; // 폴라티 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaPolaCurrentTabProvider.notifier).state =
      0; // 폴라티 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaPolaMainLargeBannerPageProvider.notifier).state =
      0; // 폴라티 대배너 페이지뷰 초기화
  ref.read(aaaPolaMainSmall1BannerPageProvider.notifier).state =
      0; // 폴라티 소배너 페이지뷰 초기화
  ref
      .read(aaaPolaMainProductListProvider.notifier)
      .reset(); // 폴라티 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaPolaMainSortButtonProvider.notifier).state =
      ''; // 폴라티 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 폴라티 메인 화면 관련 초기화 부분 끝

  // 티셔츠 메인 화면 관련 초기화 부분 시작
  ref.read(aaaShirtMainScrollPositionProvider.notifier).state =
      0.0; // 티셔츠 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaShirtCurrentTabProvider.notifier).state =
      0; // 티셔츠 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaShirtMainLargeBannerPageProvider.notifier).state =
      0; // 티셔츠 대배너 페이지뷰 초기화
  ref.read(aaaShirtMainSmall1BannerPageProvider.notifier).state =
      0; // 티셔츠 소배너 페이지뷰 초기화
  ref
      .read(aaaShirtMainProductListProvider.notifier)
      .reset(); // 티셔츠 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaShirtMainSortButtonProvider.notifier).state =
      ''; // 티셔츠 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 티셔츠 메인 화면 관련 초기화 부분 끝

  // 스커트 메인 화면 관련 초기화 부분 시작
  ref.read(aaaSkirtMainScrollPositionProvider.notifier).state =
      0.0; // 스커트 메인 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(aaaSkirtCurrentTabProvider.notifier).state =
      0; // 스커트 메인 화면 상단 탭 바 버튼 위치 인덱스를 초기화
  ref.read(aaaSkirtMainLargeBannerPageProvider.notifier).state =
      0; // 스커트 대배너 페이지뷰 초기화
  ref.read(aaaSkirtMainSmall1BannerPageProvider.notifier).state =
      0; // 스커트 소배너 페이지뷰 초기화
  ref
      .read(aaaSkirtMainProductListProvider.notifier)
      .reset(); // 스커트 메인 화면 상단 탭 바의 탭 관련 상품 데이터를 초기화
  ref.read(aaaSkirtMainSortButtonProvider.notifier).state =
      ''; // 스커트 메인 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  // 스커트 메인 화면 관련 초기화 부분 끝
  // ------ 2차 메인 화면 관련 부분 끝

  // ------ 섹션 더보기 화면 관련 부분 시작
  // 신상 더보기 화면 관련 초기화 부분 시작
  ref.read(aaaNewSubMainScrollPositionProvider.notifier).state =
      0.0; // 신상 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaaNewSubMainProductListProvider.notifier)
      .reset(); // 신상 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaaNewSubMainSortButtonProvider.notifier).state =
      ''; // 신상 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaaNewSubMainLargeBannerPageProvider.notifier).state =
      0; // 신상 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaaNewSubMainSmall1BannerPageProvider.notifier).state =
      0; // 신상 더보기 화면 소배너 페이지뷰 초기화
  // 신상 더보기 화면 관련 초기화 부분 끝

  // 최고 더보기 화면 관련 초기화 부분 시작
  ref.read(aaaBestSubMainScrollPositionProvider.notifier).state =
      0.0; // 최고 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaaBestSubMainProductListProvider.notifier)
      .reset(); // 최고 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaaBestSubMainSortButtonProvider.notifier).state =
      ''; // 최고 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaaBestSubMainLargeBannerPageProvider.notifier).state =
      0; // 최고 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaaBestSubMainSmall1BannerPageProvider.notifier).state =
      0; // 최고 더보기 화면 소배너 페이지뷰 초기화
  // 최고 더보기 화면 관련 초기화 부분 끝

  // 할인 더보기 화면 관련 초기화 부분 시작
  ref.read(aaaSaleSubMainScrollPositionProvider.notifier).state =
      0.0; // 할인 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaaSaleSubMainProductListProvider.notifier)
      .reset(); // 할인 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaaSaleSubMainSortButtonProvider.notifier).state =
      ''; // 할인 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaaSaleSubMainLargeBannerPageProvider.notifier).state =
      0; // 할인 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaaSaleSubMainSmall1BannerPageProvider.notifier).state =
      0; // 할인 더보기 화면 소배너 페이지뷰 초기화
  // 할인 더보기 화면 관련 초기화 부분 끝

  // 봄 더보기 화면 관련 초기화 부분 시작
  ref.read(aaaSpringSubMainScrollPositionProvider.notifier).state =
      0.0; // 봄 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaaSpringSubMainProductListProvider.notifier)
      .reset(); // 봄 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaaSpringSubMainSortButtonProvider.notifier).state =
      ''; // 봄 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaaSpringSubMainLargeBannerPageProvider.notifier).state =
      0; // 봄 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaaSpringSubMainSmall1BannerPageProvider.notifier).state =
      0; // 봄 더보기 화면 소배너 페이지뷰 초기화
  // 봄 더보기 화면 관련 초기화 부분 끝

  // 여름 더보기 화면 관련 초기화 부분 시작
  ref.read(aaaSummerSubMainScrollPositionProvider.notifier).state =
      0.0; // 여름 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaaSummerSubMainProductListProvider.notifier)
      .reset(); // 여름 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaaSummerSubMainSortButtonProvider.notifier).state =
      ''; // 여름 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaaSummerSubMainLargeBannerPageProvider.notifier).state =
      0; // 여름 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaaSummerSubMainSmall1BannerPageProvider.notifier).state =
      0; // 여름 더보기 화면 소배너 페이지뷰 초기화
  // 여름 더보기 화면 관련 초기화 부분 끝

  // 가을 더보기 화면 관련 초기화 부분 시작
  ref.read(aaaAutumnSubMainScrollPositionProvider.notifier).state =
      0.0; // 가을 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaaAutumnSubMainProductListProvider.notifier)
      .reset(); // 가을 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaaAutumnSubMainSortButtonProvider.notifier).state =
      ''; // 가을 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaaAutumnSubMainLargeBannerPageProvider.notifier).state =
      0; // 가을 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaaAutumnSubMainSmall1BannerPageProvider.notifier).state =
      0; // 가을 더보기 화면 소배너 페이지뷰 초기화
  // 가을 더보기 화면 관련 초기화 부분 끝

  // 겨울 더보기 화면 관련 초기화 부분 시작
  ref.read(aaaWinterSubMainScrollPositionProvider.notifier).state =
      0.0; // 겨울 더보기 화면 자체의 스크롤 위치 인덱스를 초기화
  ref
      .read(aaaWinterSubMainProductListProvider.notifier)
      .reset(); // 겨울 더보기 화면 내 상품 데이터를 초기화
  ref.read(aaaWinterSubMainSortButtonProvider.notifier).state =
      ''; // 겨울 더보기 화면 가격 순 버튼과 할인율 순 버튼 클릭으로 인한 데이터 정렬 상태 초기화
  ref.read(aaaWinterSubMainLargeBannerPageProvider.notifier).state =
      0; // 겨울 더보기 화면 대배너 페이지뷰 초기화
  ref.read(aaaWinterSubMainSmall1BannerPageProvider.notifier).state =
      0; // 겨울 더보기 화면 소배너 페이지뷰 초기화
  // 겨울 더보기 화면 관련 초기화 부분 끝
  // ------ 섹션 더보기 화면 관련 부분 끝

  // ------ 상품 상세 화면 관련 초기화 부분 시작
  // 화면을 돌아왔을 때 선택된 색상과 사이즈의 상태를 초기화함
  ref.read(colorSelectionIndexProvider.notifier).state = 0;
  ref.read(colorSelectionTextProvider.notifier).state = null;
  ref.read(colorSelectionUrlProvider.notifier).state = null;
  ref.read(sizeSelectionIndexProvider.notifier).state = null;
  // 화면을 돌아왔을 때 수량과 총 가격의 상태를 초기화함
  ref.read(detailQuantityIndexProvider.notifier).state = 1;
  // 페이지가 처음 생성될 때 '상품 정보 펼쳐보기' 버튼이 클릭되지 않은 상태로 초기화
  ref.read(showFullImageProvider.notifier).state = false;
  ref.invalidate(imagesProvider); // 상품정보 탭 이미지 데이터 초기화
  ref.invalidate(productReviewListNotifierProvider); // 리뷰 탭 리뷰 데이터 초기화
  // ------ 상품 상세 화면 관련 초기화 부분 끝
  // ------ Aaa 상점 초기화 부분 끝
  // ------ 상점별 홈 화면, 2차 메인 화면, 상품 상세 화면, 섹션더보기 화면 관련 초기화 부분 끝

}
// ------ 홈,장바구니,발주내역,마이페이지,2차 메인 화면 등 모든 화면화면 자체의 스크롤 위치 초기화 관련 함수 끝 부분