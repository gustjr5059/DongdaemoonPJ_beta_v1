import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../message/provider/message_all_provider.dart';
import '../../order/provider/order_all_providers.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/model/product_model.dart';
import '../provider/review_all_provider.dart';
import '../provider/review_state_provider.dart';
import '../view/review_create_detail_screen.dart';


// ------ 마이페이지용 리뷰 관리 화면 내 '리뷰 작성', '리뷰 목록' 탭 선택해서 해당 내용을 보여주는 UI 관련 PrivateReviewScreenTabs 클래스 내용 시작
// 마이페이지용 리뷰 관리 화면에서 '리뷰 작성'과 '리뷰 목록' 탭을 선택하여 해당 내용을 보여주는 UI 클래스인 PrivateReviewScreenTabs 정의
class PrivateReviewScreenTabs extends ConsumerWidget {
  final List<Map<String, dynamic>> orders; // 여러 발주 데이터를 받도록 변경

  // PrivateReviewScreenTabs 생성자, orders 매개변수를 필수로 받음
  PrivateReviewScreenTabs({required this.orders});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭을 가져옴.
    final currentTab = ref.watch(privateReviewScreenTabProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 탭 버튼을 빌드하는 메서드를 호출.
        _buildTabButtons(ref, currentTab),
        SizedBox(height: 20),
        // 현재 선택된 탭의 내용을 빌드하는 메서드를 호출.
        _buildTabContent(currentTab),  // 'order' 데이터를 _buildTabContent로 전달
      ],
    );
  }

  // 탭 버튼을 빌드하는 메서드.
  Widget _buildTabButtons(WidgetRef ref, ReviewScreenTab currentTab) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // '리뷰 작성' 탭 버튼을 빌드.
        _buildTabButton(ref, ReviewScreenTab.create, currentTab, '리뷰 작성'),
        // '리뷰 목록' 탭 버튼을 빌드.
        _buildTabButton(ref, ReviewScreenTab.list, currentTab, '리뷰 목록'),
      ],
    );
  }

  // 개별 탭 버튼을 빌드하는 메서드.
  Widget _buildTabButton(WidgetRef ref, ReviewScreenTab tab, ReviewScreenTab currentTab, String text) {
    final isSelected = tab == currentTab; // 현재 선택된 탭인지 확인.

    return GestureDetector(
      onTap: () {
        // 탭을 클릭했을 때 현재 탭 상태를 변경.
        ref.read(privateReviewScreenTabProvider.notifier).state = tab;
      },
      child: Column(
        children: [
          // 탭 텍스트를 빌드.
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 18, // 텍스트 크기 조정
            ),
          ),
          // 현재 선택된 탭이면 아래에 밑줄을 표시.
          if (isSelected)
            Container(
              width: 60,
              height: 2,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  // 현재 선택된 탭의 내용을 빌드하는 메서드.
  Widget _buildTabContent(ReviewScreenTab tab) {
    switch (tab) {
      case ReviewScreenTab.create:
      // '리뷰 작성' 화면을 반환. 각 order 전달
        return Column(
          children: orders.map((order) {
            return PrivateReviewCreateFormScreen(order: order);
          }).toList(),
        );
    // case ReviewScreenTab.list:
    //   return PrivateReviewListScreen(); // '리뷰 목록' 화면을 반환.
      default:
        return Container(); // 기본적으로 빈 컨테이너를 반환.
    }
  }
}
// ------ 마이페이지용 리뷰 관리 화면 내 '리뷰 작성', '리뷰 목록' 탭 선택해서 해당 내용을 보여주는 UI 관련 PrivateReviewScreenTabs 클래스 내용 끝

// ------ 리뷰 관리 화면 내 '리뷰 작성' 탭 화면 UI 구현 관련 PrivateReviewCreateFormScreen 내용 시작 부분
// 리뷰 관리 화면의 '리뷰 작성' 탭에서 리뷰 작성 폼을 보여주는 클래스 PrivateReviewCreateFormScreen 정의
class PrivateReviewCreateFormScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> order; // 발주 정보를 담는 order 변수

  // PrivateReviewCreateFormScreen 생성자, order 매개변수를 필수로 받음
  PrivateReviewCreateFormScreen({required this.order});

  @override
  _PrivateReviewCreateFormScreenState createState() => _PrivateReviewCreateFormScreenState();
}

class _PrivateReviewCreateFormScreenState extends ConsumerState<PrivateReviewCreateFormScreen> {
  // State 클래스에서 사용될 변수를 선언
  Map<String, dynamic>? orderData;

  @override
  void initState() {
    super.initState();
    // 위젯이 생성될 때 바로 초기화 함수를 호출하면,
    // 다른 위젯들이 아직 완전히 초기화되지 않았을 가능성이 있으므로,
    // Future.microtask를 사용하여 이벤트 루프가 한 번 돌아간 후 초기화 함수를 호출
    Future.microtask(() => _resetForm());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 종속성이 변경될 때 초기화 함수를 호출
    Future.microtask(() => _resetForm());
  }

  // 폼을 초기화하는 함수
  void _resetForm() {
    setState(() {
      orderData = widget.order; // 초기화 시 전달된 order 데이터를 상태에 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    // orderData가 null이 아닌지 확인 후 처리
    if (orderData == null) {
      return Center(child: CircularProgressIndicator()); // 초기화 되지 않은 경우 로딩 표시
    }

    // 날짜 형식을 지정하기 위한 DateFormat 인스턴스
    final dateFormat = DateFormat('yyyy-MM-dd');
    // 숫자 형식을 지정하기 위한 NumberFormat 인스턴스
    final numberFormat = NumberFormat('###,###');
    // 상품 상세 화면으로 이동하는 기능을 위한 navigator 인스턴스
    final navigatorProductDetailScreen = ProductInfoDetailScreenNavigation(ref);

    // 발주 날짜를 가져와 DateTime으로 변환하거나 null을 할당
    final orderDate = orderData!['numberInfo']['order_date'] != null
        ? (orderData!['numberInfo']['order_date'] as Timestamp).toDate()
        : null;

    // 발주 번호를 가져오거나 에러 메시지를 할당
    final orderNumber = orderData!['numberInfo']['order_number'] ?? '에러 발생';

    // 결제 완료 날짜를 비동기로 가져오기 위해 AsyncValue로 저장
    final paymentCompleteDateAsyncValue = ref.watch(paymentCompleteDateProvider(orderNumber));
    // 배송 시작 날짜를 비동기로 가져오기 위해 AsyncValue로 저장
    final deliveryStartDateAsyncValue = ref.watch(deliveryStartDateProvider(orderNumber));
    // 버튼 활성화 정보를 비동기로 가져오는 provider를 호출하고 결과를 buttonInfoAsyncValue에 저장
    final buttonInfoAsyncValue = ref.watch(buttonInfoProvider(orderNumber));

    // 상품 정보 리스트를 가져오거나 빈 리스트를 할당
    final List<dynamic> productInfoList = orderData!['productInfo'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 각 상품 정보를 반복문을 통해 출력
        for (var productInfo in productInfoList)
          CommonCardView(
            backgroundColor: BEIGE_COLOR,
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 발주 번호를 표시하는 행을 빌드
                  _buildProductInfoRow(
                      '발주번호: ',
                      orderNumber,
                      bold: true,
                      fontSize: 14),
                  // 상품 번호를 표시하는 행을 빌드
                  _buildProductInfoRow(
                      '상품번호: ',
                      productInfo['product_number']?.toString().isNotEmpty == true
                          ? productInfo['product_number']
                          : '에러 발생',
                      bold: true,
                      fontSize: 14),
                  SizedBox(height: 8),
                  // 상품 소개를 표시하는 행을 빌드
                  _buildProductInfoRow(
                      productInfo['brief_introduction']?.toString().isNotEmpty == true
                          ? productInfo['brief_introduction']
                          : '에러 발생',
                      '',
                      bold: true,
                      fontSize: 18),
                  SizedBox(height: 2),
                  // 상품 이미지를 클릭했을 때 상품 상세 화면으로 이동하는 기능을 추가
                  GestureDetector(
                    onTap: () {
                      final product = ProductContent(
                        docId: productInfo['product_id'] ?? '',
                        category: productInfo['category']?.toString() ?? '에러 발생',
                        productNumber: productInfo['product_number']?.toString() ?? '에러 발생',
                        thumbnail: productInfo['thumbnails']?.toString() ?? '',
                        briefIntroduction: productInfo['brief_introduction']?.toString() ?? '에러 발생',
                        originalPrice: productInfo['original_price'] ?? 0,
                        discountPrice: productInfo['discount_price'] ?? 0,
                        discountPercent: productInfo['discount_percent'] ?? 0,
                      );
                      // 상품 상세 화면으로 이동
                      navigatorProductDetailScreen.navigateToDetailScreen(context, product);
                    },
                    child: CommonCardView(
                      backgroundColor: Colors.white,
                      content: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // 상품 썸네일 이미지를 표시하거나 기본 아이콘을 표시
                                Expanded(
                                  flex: 3,
                                  child: productInfo['thumbnails']?.toString().isNotEmpty == true
                                      ? Image.network(productInfo['thumbnails'], fit: BoxFit.cover)
                                      : Icon(Icons.image_not_supported),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 원래 가격을 표시하고, 취소선 스타일 적용
                                      Text(
                                        '${numberFormat.format(productInfo['original_price'] ?? 0)} 원',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                      // 할인 가격과 할인율을 표시
                                      Row(
                                        children: [
                                          Text(
                                            '${numberFormat.format(productInfo['discount_price'] ?? 0)} 원',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '${(productInfo['discount_percent'] ?? 0).toInt()}%',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // 선택된 색상과 사이즈를 표시
                                      Row(
                                        children: [
                                          productInfo['selected_color_image']?.toString().isNotEmpty == true
                                              ? Image.network(
                                            productInfo['selected_color_image'],
                                            height: 18,
                                            width: 18,
                                            fit: BoxFit.cover,
                                          )
                                              : Icon(Icons.image_not_supported, size: 20),
                                          SizedBox(width: 8),
                                          Text(
                                            productInfo['selected_color_text']?.toString() ?? '에러 발생',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      // 선택된 사이즈와 수량을 표시
                                      Text('사이즈: ${productInfo['selected_size']?.toString() ?? '에러 발생'}'),
                                      Text('수량: ${productInfo['selected_count']?.toString() ?? '0 개'}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // 발주 일자를 표시하는 행을 빌드
                  _buildProductInfoRow(
                      '발주일자: ',
                      orderDate != null ? dateFormat.format(orderDate) : '에러 발생',
                      bold: true,
                      fontSize: 16),
                  // 결제 완료 일자를 표시하거나 로딩 중 표시 또는 오류 메시지를 표시
                  paymentCompleteDateAsyncValue.when(
                    data: (date) {
                      if (date != null) {
                        return Text(
                          '결제완료일: ${DateFormat('yyyy-MM-dd').format(date)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                    loading: () => CircularProgressIndicator(),
                    error: (error, stack) => Text('오류 발생'),
                  ),
                  // 배송 시작 일자를 표시하거나 로딩 중 표시 또는 오류 메시지를 표시
                  deliveryStartDateAsyncValue.when(
                    data: (date) {
                      if (date != null) {
                        return Text(
                          '배송시작일: ${DateFormat('yyyy-MM-dd').format(date)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                    loading: () => CircularProgressIndicator(),
                    error: (error, stack) => Text('오류 발생'),
                  ),
                  Divider(color: Colors.grey),
                  // 리뷰 버튼을 표시하고, 버튼 활성화 상태에 따라 UI를 제어하는 로직을 추가
                  buttonInfoAsyncValue.when(
                  data: (buttonInfo) {
                  final boolReviewWriteBtn = buttonInfo['boolReviewWriteBtn'] ?? false;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: boolReviewWriteBtn
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewCreateDetailScreen(),
                            ),
                          );
                        }
                            : null, // 리뷰 작성 버튼 활성화 여부에 따라 동작
                        style: ElevatedButton.styleFrom(
                          foregroundColor: boolReviewWriteBtn ? BUTTON_COLOR : Colors.grey,
                          backgroundColor: BACKGROUND_COLOR,
                          side: BorderSide(color: boolReviewWriteBtn ? BUTTON_COLOR : Colors.grey),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        ),
                        child: Text('리뷰 작성', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                  },
                    loading: () => CircularProgressIndicator(), // 버튼 정보 로딩 중일 때 로딩 인디케이터 표시
                    error: (error, stack) => Text('버튼 상태를 불러오는 중 오류 발생'), // 오류 발생 시 메시지 표시
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
// ------ 리뷰 관리 화면 내 '리뷰 작성' 탭 화면 UI 구현 관련 PrivateReviewCreateFormScreen 내용 끝 부분

// 상품 정보를 표시하는 행을 구성하는 함수
Widget _buildProductInfoRow(String label, String value, {bool bold = false, double fontSize = 16}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 라벨을 표시하는 텍스트
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        // 라벨과 값 사이의 공간을 제거
        SizedBox(width: 4), // 필요에 따라 사이즈 조정 가능
        // 값을 표시하는 텍스트 (말줄임 표시와 줄바꿈 가능)
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.start, // 텍스트를 시작 부분에 맞춤
            softWrap: true, // 텍스트가 한 줄을 넘길 때 자동으로 줄바꿈이 되도록 설정
            overflow: TextOverflow.ellipsis, // 텍스트가 길 경우 말줄임 표시
          ),
        ),
      ],
    ),
  );
}