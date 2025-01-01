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
import '../../market/aaa/common/layout/aaa_common_body_parts_layout.dart';
import '../../market/aab/common/layout/aab_common_body_parts_layout.dart';
import '../../market/aac/common/layout/aac_common_body_parts_layout.dart';
import '../../market/aad/common/layout/aad_common_body_parts_layout.dart';
import '../../market/aae/common/layout/aae_common_body_parts_layout.dart';
import '../../market/aaf/common/layout/aaf_common_body_parts_layout.dart';
import '../../market/aag/common/layout/aag_common_body_parts_layout.dart';
import '../../market/aah/common/layout/aah_common_body_parts_layout.dart';
import '../../market/aai/common/layout/aai_common_body_parts_layout.dart';
import '../../market/aaj/common/layout/aaj_common_body_parts_layout.dart';
import '../../market/aak/common/layout/aak_common_body_parts_layout.dart';
import '../../market/aal/common/layout/aal_common_body_parts_layout.dart';
import '../../market/aam/common/layout/aam_common_body_parts_layout.dart';
import '../../market/aan/common/layout/aan_common_body_parts_layout.dart';
import '../../market/aao/common/layout/aao_common_body_parts_layout.dart';
import '../../market/aap/common/layout/aap_common_body_parts_layout.dart';
import '../../market/aaq/common/layout/aaq_common_body_parts_layout.dart';
import '../../market/aar/common/layout/aar_common_body_parts_layout.dart';
import '../../market/aas/common/layout/aas_common_body_parts_layout.dart';
import '../../market/aat/common/layout/aat_common_body_parts_layout.dart';
import '../../market/aau/common/layout/aau_common_body_parts_layout.dart';
import '../../market/aav/common/layout/aav_common_body_parts_layout.dart';
import '../../market/aaw/common/layout/aaw_common_body_parts_layout.dart';
import '../../market/aax/common/layout/aax_common_body_parts_layout.dart';
import '../../market/aay/common/layout/aay_common_body_parts_layout.dart';
import '../../market/aaz/common/layout/aaz_common_body_parts_layout.dart';
import '../../market/aba/common/layout/aba_common_body_parts_layout.dart';
import '../../market/abb/common/layout/abb_common_body_parts_layout.dart';
import '../../market/abc/common/layout/abc_common_body_parts_layout.dart';
import '../../market/abd/common/layout/abd_common_body_parts_layout.dart';
import '../../message/provider/message_all_provider.dart';
import '../../message/provider/message_state_provider.dart';
import '../../order/provider/complete_payment_provider.dart';
import '../../order/provider/order_all_providers.dart';
import '../../order/provider/order_state_provider.dart';
import '../../product/provider/product_state_provider.dart';
import '../../review/provider/review_state_provider.dart';
import '../../wishlist/provider/wishlist_all_providers.dart';
import '../../wishlist/provider/wishlist_state_provider.dart';
import '../provider/profile_all_providers.dart';
import '../provider/profile_state_provider.dart';
import '../provider/sns_login_state_provider.dart';


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

  // 간편 로그인 및 회원가입 화면 관련 초기화 부분 시작
  // (첫 회원가입 후 로그아웃 -> 로그인 버튼 클릭 시, 회원가입 화면으로 이동하던 이슈 해결!!)
  ref.invalidate(appleSignInNotifierProvider); // 애플 로그인한 상태 초기화 로직
  ref.invalidate(googleSignInNotifierProvider); // 구글 로그인한 상태 초기화 로직
  // 간편 로그인 및 회원가입 화면 관련 초기화 부분 끝

  // 홈 화면 관련 초기화 부분 시작
  // 스크롤 위치 및 현재 탭 인덱스 초기화
  ref.read(homeScrollPositionProvider.notifier).state =
      0.0; // 홈 화면 자체의 스크롤 위치 인덱스를 초기화
  ref.read(homeCurrentTabProvider.notifier).state =
      0; // 홈 화면 상단 탭 바 버튼 위치 인덱스를 초기화
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
  ref.invalidate(profileUserInfoProvider); // 마이페이지 회원정보 데이터 초기화
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

  // ------ 상점별 홈 화면, 2차 메인 화면, 상품 상세 화면, 섹션더보기 화면 관련 초기화 부분 시작
   // 상점별 초기화
  AaaStoreInitializer(ref).reset();
  AabStoreInitializer(ref).reset();
  AacStoreInitializer(ref).reset();
  AadStoreInitializer(ref).reset();
  AaeStoreInitializer(ref).reset();
  AafStoreInitializer(ref).reset();
  AagStoreInitializer(ref).reset();
  AahStoreInitializer(ref).reset();
  AaiStoreInitializer(ref).reset();
  AajStoreInitializer(ref).reset();
  AakStoreInitializer(ref).reset();
  AalStoreInitializer(ref).reset();
  AamStoreInitializer(ref).reset();
  AanStoreInitializer(ref).reset();
  AaoStoreInitializer(ref).reset();
  AapStoreInitializer(ref).reset();
  AaqStoreInitializer(ref).reset();
  AarStoreInitializer(ref).reset();
  AasStoreInitializer(ref).reset();
  AatStoreInitializer(ref).reset();
  AauStoreInitializer(ref).reset();
  AavStoreInitializer(ref).reset();
  AawStoreInitializer(ref).reset();
  AaxStoreInitializer(ref).reset();
  AayStoreInitializer(ref).reset();
  AazStoreInitializer(ref).reset();
  AbaStoreInitializer(ref).reset();
  AbbStoreInitializer(ref).reset();
  AbcStoreInitializer(ref).reset();
  AbdStoreInitializer(ref).reset();
  // ------ 상점별 홈 화면, 2차 메인 화면, 상품 상세 화면, 섹션더보기 화면 관련 초기화 부분 끝
}
// ------ 홈,장바구니,발주내역,마이페이지,2차 메인 화면 등 모든 화면화면 자체의 스크롤 위치 초기화 관련 함수 끝 부분
