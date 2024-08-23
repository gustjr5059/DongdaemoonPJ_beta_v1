import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../message/provider/message_all_provider.dart';
import '../../order/provider/order_all_providers.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/model/product_model.dart';
import '../provider/review_all_provider.dart';
import '../provider/review_state_provider.dart';
import '../view/review_create_detail_screen.dart';
import 'package:image_picker/image_picker.dart'; // image_picker 패키지를 가져옴.
import 'dart:io'; // 파일 처리를 위해 dart:io 패키지를 가져옴.


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
                              builder: (context) => ReviewCreateDetailScreen(
                                productInfo: productInfo, // 개별 상품 데이터를 전달
                                numberInfo: orderData!['numberInfo'], // 개별 상품 발주번호 및 발주일자 전달
                                userEmail: FirebaseAuth.instance.currentUser!.email!, // 현재 로그인한 이메일 계정 전달
                              ),
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

// ------- 리뷰 작성 상세 화면 관련 UI 내용인 PrivateReviewCreateDetailFormScreen 클래스 시작
class PrivateReviewCreateDetailFormScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> productInfo; // 특정 상품 정보를 담는 변수
  final Map<String, dynamic> numberInfo; // 발주 정보를 담는 변수
  final String userEmail; // 사용자의 이메일을 저장하기 위한 변수
  final TextEditingController titleController =
  TextEditingController(); // 리뷰 제목을 입력받기 위한 컨트롤러
  final TextEditingController contentController =
  TextEditingController(); // 리뷰 내용을 입력받기 위한 컨트롤러

  // 생성자에서 productInfo, numberInfo, userEmail을 필수로 받아옴
  PrivateReviewCreateDetailFormScreen({
    required this.productInfo,
    required this.numberInfo,
    required this.userEmail,
  });

  // 상태를 생성하는 메서드
  @override
  _PrivateReviewCreateDetailFormScreenState createState() =>
      _PrivateReviewCreateDetailFormScreenState();
}

// ------ PrivateReviewCreateDetailFormScreen의 상태를 정의하는 클래스
class _PrivateReviewCreateDetailFormScreenState
    extends ConsumerState<PrivateReviewCreateDetailFormScreen> {
  final List<File> _images = []; // 최대 3개의 이미지를 저장하기 위한 리스트
  final ImagePicker _picker = ImagePicker(); // 갤러리에서 이미지를 선택하기 위한 ImagePicker 객체

  // ----- 리뷰 사진 업로드 관련 함수 시작 부분
  // 권한 요청 함수
  Future<bool> _requestPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      // 안드로이드 권한 요청
      PermissionStatus status = await Permission.photos.status;
      if (status.isGranted) {
        // 권한이 이미 허용된 경우
        return true;
      } else if (status.isDenied || status.isPermanentlyDenied) {
        // 권한이 거부되었거나 영구적으로 거부된 경우
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('갤러리 접근 권한'),
              content: Text('갤러리 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
              actions: <Widget>[
                TextButton(
                  child: Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
                TextButton(
                  child: Text('승인'),
                  onPressed: () {
                    openAppSettings(); // 설정 화면으로 이동함
                  },
                ),
              ],
            );
          },
        );
        return false;
      }
    } else if (Platform.isIOS) {
      // iOS 권한 요청
      PermissionStatus status = await Permission.photos.status;
      if (status.isGranted) {
        // 권한이 이미 허용된 경우
        return true;
      } else if (status.isDenied || status.isPermanentlyDenied) {
        // 권한이 거부되었거나 영구적으로 거부된 경우
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('갤러리 접근 권한'),
              content: Text('갤러리 접근 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
                CupertinoDialogAction(
                  child: Text('승인'),
                  onPressed: () {
                    openAppSettings(); // 설정 화면으로 이동함
                  },
                ),
              ],
            );
          },
        );
        return false;
      }
    }
    return false;
  }

  // 이미지 선택 함수
  Future<void> _pickImage(BuildContext context) async {
    if (_images.length >= 3) {
      // 이미지가 3개 이상이면 업로드 제한 메시지를 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사진은 최대 3개까지 업로드할 수 있습니다.')),
      );
      return;
    }

    // await _requestPermission(context); // 권한 요청 수행 (주석 처리됨)

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // 이미지가 선택된 경우 리스트에 추가하고 성공 메시지를 표시
      setState(() {
        _images.add(File(image.path));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사진이 성공적으로 업로드되었습니다.')),
      );
    }
  }

  // 사진 삭제 함수
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index); // 선택된 이미지를 리스트에서 삭제함
    });
  }
  // ----- 리뷰 사진 업로드 관련 함수 끝 부분

  @override
  Widget build(BuildContext context) {
    // 화면의 UI를 그리기 위한 build 메소드

    final numberFormat = NumberFormat('###,###'); // 숫자 형식을 지정하기 위한 formatter

    // 결제 완료 날짜를 비동기로 가져오기 위해 AsyncValue로 저장
    final paymentCompleteDateAsyncValue =
    ref.watch(paymentCompleteDateProvider(widget.numberInfo['order_number']));

    // 배송 시작 날짜를 비동기로 가져오기 위해 AsyncValue로 저장
    final deliveryStartDateAsyncValue =
    ref.watch(deliveryStartDateProvider(widget.numberInfo['order_number']));

    // 발주 날짜를 가져와 DateTime으로 변환하거나 null을 할당
    final orderDate = widget.numberInfo['order_date'] != null
        ? (widget.numberInfo['order_date'] as Timestamp).toDate()
        : null;

    // 상품 상세 화면으로 이동하는 기능을 위한 navigator 인스턴스
    final navigatorProductDetailScreen = ProductInfoDetailScreenNavigation(ref);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('[리뷰 상품 내용]', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 20), // 요소 간의 간격을 추가
        // 상품 정보 표시 UI
        CommonCardView(
          backgroundColor: BEIGE_COLOR, // 배경색 설정
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 발주번호를 표시하는 행을 빌드함
                _buildProductInfoRow('발주번호: ', widget.numberInfo['order_number'],
                    bold: true, fontSize: 14),
                // 상품번호를 표시하는 행을 빌드함
                _buildProductInfoRow(
                    '상품번호: ',
                    widget.productInfo['product_number']?.toString().isNotEmpty == true
                        ? widget.productInfo['product_number']
                        : '에러 발생',
                    bold: true,
                    fontSize: 14),
                SizedBox(height: 8), // 요소 간의 간격을 추가
                // 상품 간단 소개를 표시하는 행을 빌드함
                _buildProductInfoRow(
                    widget.productInfo['brief_introduction']?.toString().isNotEmpty ==
                        true
                        ? widget.productInfo['brief_introduction']
                        : '에러 발생',
                    '',
                    bold: true,
                    fontSize: 18),
                SizedBox(height: 2), // 요소 간의 간격을 추가
                // 상품 이미지를 클릭했을 때 상품 상세 화면으로 이동하는 기능을 추가함
                GestureDetector(
                  onTap: () {
                    final product = ProductContent(
                      docId: widget.productInfo['product_id'] ?? '',
                      category: widget.productInfo['category']?.toString() ?? '에러 발생',
                      productNumber:
                      widget.productInfo['product_number']?.toString() ??
                          '에러 발생',
                      thumbnail: widget.productInfo['thumbnails']?.toString() ??
                          '',
                      briefIntroduction:
                      widget.productInfo['brief_introduction']?.toString() ??
                          '에러 발생',
                      originalPrice: widget.productInfo['original_price'] ?? 0,
                      discountPrice: widget.productInfo['discount_price'] ?? 0,
                      discountPercent:
                      widget.productInfo['discount_percent'] ?? 0,
                    );
                    // 상품 상세 화면으로 이동
                    navigatorProductDetailScreen.navigateToDetailScreen(
                        context, product);
                  },
                  // 상품 정보를 표시하는 카드뷰 생성
                  child: CommonCardView(
                    backgroundColor: Colors.white, // 카드 배경색 설정
                    content: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                // 상품 썸네일 이미지를 표시하고, 이미지가 없을 경우 대체 아이콘을 표시함
                                child: widget.productInfo['thumbnails']
                                    ?.toString()
                                    .isNotEmpty ==
                                    true
                                    ? Image.network(
                                    widget.productInfo['thumbnails'],
                                    fit: BoxFit.cover)
                                    : Icon(Icons.image_not_supported),
                              ),
                              SizedBox(width: 8), // 요소 간의 간격을 추가
                              Expanded(
                                flex: 7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 원래 가격을 표시하는 텍스트
                                    Text(
                                      '${numberFormat.format(widget.productInfo['original_price'] ?? 0)} 원',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 14,
                                        decoration:
                                        TextDecoration.lineThrough, // 취소선 추가
                                      ),
                                    ),
                                    // 할인된 가격과 할인율을 표시하는 행을 빌드함
                                    Row(
                                      children: [
                                        Text(
                                          '${numberFormat.format(widget.productInfo['discount_price'] ?? 0)} 원',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 8), // 요소 간의 간격을 추가
                                        Text(
                                          '${(widget.productInfo['discount_percent'] ?? 0).toInt()}%',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // 선택한 색상 이미지를 표시하고, 이미지가 없을 경우 대체 아이콘을 표시함
                                    Row(
                                      children: [
                                        widget.productInfo['selected_color_image']
                                            ?.toString()
                                            .isNotEmpty ==
                                            true
                                            ? Image.network(
                                          widget.productInfo[
                                          'selected_color_image'],
                                          height: 18,
                                          width: 18,
                                          fit: BoxFit.cover,
                                        )
                                            : Icon(Icons.image_not_supported,
                                            size: 20),
                                        SizedBox(width: 8), // 요소 간의 간격을 추가
                                        // 선택한 색상 텍스트를 표시함
                                        Text(
                                          widget.productInfo[
                                          'selected_color_text']
                                              ?.toString() ??
                                              '에러 발생',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    // 선택한 사이즈와 수량을 표시하는 텍스트
                                    Text(
                                        '사이즈: ${widget.productInfo['selected_size']?.toString() ?? '에러 발생'}'),
                                    Text(
                                        '수량: ${widget.productInfo['selected_count']?.toString() ?? '0 개'}'),
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
                SizedBox(height: 10), // 요소 간의 간격을 추가
                // 발주 일자를 표시하는 행을 빌드함
                _buildProductInfoRow(
                    '발주일자: ',
                    orderDate != null
                        ? DateFormat('yyyy-MM-dd').format(orderDate)
                        : '에러 발생',
                    bold: true,
                    fontSize: 16),
                // 결제 완료 일자를 표시하거나 로딩 중 표시 또는 오류 메시지를 표시함
                paymentCompleteDateAsyncValue.when(
                  data: (date) {
                    if (date != null) {
                      return Text(
                        '결제완료일: ${DateFormat('yyyy-MM-dd').format(date)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                  loading: () => CircularProgressIndicator(),
                  error: (error, stack) => Text('오류 발생'),
                ),
                // 배송 시작 일자를 표시하거나 로딩 중 표시 또는 오류 메시지를 표시함
                deliveryStartDateAsyncValue.when(
                  data: (date) {
                    if (date != null) {
                      return Text(
                        '배송시작일: ${DateFormat('yyyy-MM-dd').format(date)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                  loading: () => CircularProgressIndicator(),
                  error: (error, stack) => Text('오류 발생'),
                ),
                // 추가적인 상품 정보 표시 또는 기타 UI 요소
              ],
            ),
          ),
        ),
        SizedBox(height: 30), // 요소 간의 간격을 추가
        Text('[리뷰 작성 상세 내용]',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 20), // 요소 간의 간격을 추가
        // 리뷰 제목을 입력할 수 있는 입력 필드를 빌드하는 함수 호출
        _buildTitleRow('리뷰 제목', widget.titleController, '50자 이내로 작성 가능합니다.'),
        SizedBox(height: 8), // 요소 간의 간격을 추가
        // 작성자 정보를 표시하는 행을 빌드하는 함수 호출
        _buildUserRow(ref, '작성자', widget.userEmail),
        SizedBox(height: 8), // 요소 간의 간격을 추가
        // 사진 업로드 버튼을 빌드하는 함수 호출
        _buildPhotoUploadRow(context),
        SizedBox(height: 8), // 요소 간의 간격을 추가
        // 리뷰 내용을 입력할 수 있는 입력 필드를 빌드하는 함수 호출
        _buildContentsRow(
            '리뷰 내용', widget.contentController, '300자 이내로 작성 가능합니다.'),
        SizedBox(height: 10), // 제출 버튼과의 간격을 위해 여백 추가
        // 제출 버튼을 빌드하는 함수 호출
        _buildSubmitButton(context),
      ],
    );
  }

// 제목 행을 생성하는 함수
  Widget _buildTitleRow(String label, TextEditingController controller, String hintText) {
    return Padding( // 패딩을 추가하여 요소 주위에 여백을 줌
      padding: const EdgeInsets.symmetric(vertical: 2.0), // 행의 상하단에 2.0 픽셀의 여백 추가
      child: Column( // 요소들을 세로로 배치하기 위해 Column 사용
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 요소들을 왼쪽 정렬
        children: [
          IntrinsicHeight( // 왼쪽 Container와 오른쪽 TextField의 높이를 동일하게 맞추기 위해 사용
            child: Row( // 요소들을 가로로 배치하기 위해 Row 사용
              crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
              children: [
                Container( // 제목 라벨을 위한 컨테이너 생성
                  width: 70, // 왼쪽 라벨 부분의 너비 설정
                  color: Colors.grey.shade200, // 셀 배경색 설정
                  padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
                  alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
                  child: Text(
                    label, // 셀에 표시될 텍스트
                    style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
                  ),
                ),
                SizedBox(width: 4), // 라벨과 텍스트 필드 사이의 간격
                Expanded( // 오른쪽 TextField가 남은 공간을 채우도록 설정
                  child: TextField( // 사용자로부터 텍스트를 입력받기 위한 필드
                    controller: controller, // 텍스트 필드 컨트롤러 설정
                    maxLength: 50, // 최대 글자 수 설정
                    maxLines: null, // 텍스트가 길어질 때 자동으로 줄바꿈 되도록 설정
                    decoration: InputDecoration( // 텍스트 필드의 외관을 설정
                      hintText: hintText, // 힌트 텍스트 설정
                      border: OutlineInputBorder(), // 입력 경계선 설정
                      focusedBorder: OutlineInputBorder( // 활성화 상태의 테두리 설정
                        borderSide: BorderSide(color: BUTTON_COLOR, width: 2.0), // 활성화 상태의 테두리 색상을 BUTTON_COLOR로 설정
                      ),
                      counterText: '', // 글자수 표시를 비워둠 (아래에 별도로 표시)
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4), // TextField와 글자 수 표시 사이의 여백
          Align( // 글자 수 표시를 오른쪽에 맞춤
            alignment: Alignment.centerRight, // 오른쪽에 글자 수 표시
            child: ValueListenableBuilder<TextEditingValue>( // 텍스트 입력 시마다 변경사항을 반영
              valueListenable: controller, // 텍스트 필드의 변경사항을 모니터링
              builder: (context, value, child) {
                return Text( // 입력된 글자 수를 표시
                  '${value.text.length}/50', // 글자 수를 반영
                  style: TextStyle(color: Colors.grey), // 글자 수 표시 스타일
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 사용자 정보를 표시하는 행을 생성하는 함수
  Widget _buildUserRow(WidgetRef ref, String label, String email) {
    final userNameAsyncValue = ref.watch(userNameProvider(email)); // 사용자 이름을 비동기적으로 가져오기 위해 프로바이더를 사용

    return userNameAsyncValue.when( // 비동기 상태에 따라 위젯을 생성
      data: (userName) { // 데이터가 성공적으로 로드된 경우
        String obscuredName = userName[0] + '*' * (userName.length - 1); // 사용자 이름을 첫 글자만 남기고 나머지는 *로 표시
        return _buildFixedValueRow(label, obscuredName); // 이름을 표시하는 행을 생성
      },
      loading: () => CircularProgressIndicator(), // 로딩 중인 경우 로딩 인디케이터를 표시
      error: (error, stack) => Text('알 수 없음'), // 에러가 발생한 경우 '알 수 없음'을 표시
    );
  }

  // 내용 입력 필드를 생성하는 함수
  Widget _buildContentsRow(String label, TextEditingController controller, String hintText) {
    return Padding( // 패딩을 추가하여 요소 주위에 여백을 줌
      padding: const EdgeInsets.symmetric(vertical: 2.0), // 행의 상하단에 2.0 픽셀의 여백 추가
      child: Column( // 요소들을 세로로 배치하기 위해 Column 사용
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 요소들을 왼쪽 정렬
        children: [
          IntrinsicHeight( // 왼쪽 Container와 오른쪽 TextField의 높이를 동일하게 맞추기 위해 사용
            child: Row( // 요소들을 가로로 배치하기 위해 Row 사용
              crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
              children: [
                Container( // 제목 라벨을 위한 컨테이너 생성
                  width: 70, // 왼쪽 라벨 부분의 너비 설정
                  color: Colors.grey.shade200, // 셀 배경색 설정
                  padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
                  alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
                  child: Text(
                    label, // 셀에 표시될 텍스트
                    style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
                  ),
                ),
                SizedBox(width: 4), // 라벨과 텍스트 필드 사이의 간격
                Expanded( // 오른쪽 TextField가 남은 공간을 채우도록 설정
                  child: TextField( // 사용자로부터 텍스트를 입력받기 위한 필드
                    controller: controller, // 텍스트 필드 컨트롤러 설정
                    maxLength: 300, // 최대 글자 수 설정
                    maxLines: null, // 텍스트가 길어질 때 자동으로 줄바꿈 되도록 설정
                    decoration: InputDecoration( // 텍스트 필드의 외관을 설정
                      hintText: hintText, // 힌트 텍스트 설정
                      border: OutlineInputBorder(), // 입력 경계선 설정
                      focusedBorder: OutlineInputBorder( // 활성화 상태의 테두리 설정
                        borderSide: BorderSide(color: BUTTON_COLOR, width: 2.0), // 활성화 상태의 테두리 색상을 BUTTON_COLOR로 설정
                      ),
                      counterText: '', // 글자수 표시를 비워둠 (아래에 별도로 표시)
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4), // TextField와 글자 수 표시 사이의 여백
          Align( // 글자 수 표시를 오른쪽에 맞춤
            alignment: Alignment.centerRight, // 오른쪽에 글자 수 표시
            child: ValueListenableBuilder<TextEditingValue>( // 텍스트 입력 시마다 변경사항을 반영
              valueListenable: controller, // 텍스트 필드의 변경사항을 모니터링
              builder: (context, value, child) {
                return Text( // 입력된 글자 수를 표시
                  '${value.text.length}/300', // 글자 수를 반영
                  style: TextStyle(color: Colors.grey), // 글자 수 표시 스타일
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 고정된 값을 표시하는 행을 생성하는 함수
  Widget _buildFixedValueRow(String label, String value) {
    return Padding( // 패딩을 추가하여 요소 주위에 여백을 줌
      padding: const EdgeInsets.symmetric(vertical: 2.0), // 행의 상하단에 2.0 픽셀의 여백 추가
      child: Column( // 요소들을 세로로 배치하기 위해 Column 사용
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 요소들을 왼쪽 정렬
        children: [
          IntrinsicHeight( // 왼쪽 Container와 오른쪽 TextField의 높이를 동일하게 맞추기 위해 사용
            child: Row( // 요소들을 가로로 배치하기 위해 Row 사용
              crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
              children: [
                Container( // 라벨을 위한 컨테이너 생성
                  width: 70, // 왼쪽 라벨 부분의 너비 설정
                  color: Colors.grey.shade200, // 셀 배경색 설정
                  padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
                  alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
                  child: Text(
                    label, // 셀에 표시될 텍스트
                    style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
                  ),
                ),
                SizedBox(width: 4), // 라벨과 고정된 값 사이의 간격
                Expanded( // 오른쪽 Container가 남은 공간을 채우도록 설정
                  child: Container( // 고정된 값을 표시하기 위한 컨테이너
                    padding: const EdgeInsets.all(8.0), // 컨테이너 내부 여백 설정
                    color: Colors.grey.shade200, // 컨테이너 배경색 설정
                    child: Text(value), // 고정된 값을 텍스트로 표시
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// 사진 업로드 버튼을 생성하는 함수
  Widget _buildPhotoUploadRow(BuildContext context) {
    return Padding( // 패딩을 추가하여 요소 주위에 여백을 줌
      padding: const EdgeInsets.symmetric(vertical: 2.0), // 행의 상하단에 2.0 픽셀의 여백 추가
      child: Column( // 요소들을 세로로 배치하기 위해 Column 사용
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 요소들을 왼쪽 정렬
        children: [
          IntrinsicHeight( // 왼쪽 Container와 오른쪽 버튼의 높이를 동일하게 맞추기 위해 사용
            child: Row( // 요소들을 가로로 배치하기 위해 Row 사용
              crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
              children: [
                Container( // 라벨을 위한 컨테이너 생성
                  width: 70, // 왼쪽 라벨 부분의 너비 설정
                  color: Colors.grey.shade200, // 셀 배경색 설정
                  padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
                  alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
                  child: Text(
                    '리뷰 사진', // 셀에 표시될 텍스트
                    style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
                  ),
                ),
                SizedBox(width: 4), // 라벨과 버튼 사이의 간격
                Expanded( // 오른쪽 영역이 남은 공간을 채우도록 설정
                  child: SingleChildScrollView( // 사진 목록을 스크롤 가능하게 설정
                    scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                    child: Row( // 사진을 가로로 나열하기 위해 Row 사용
                      children: [
                        Row( // 이미지를 담고 있는 Row 생성
                          children: _images.asMap().entries.map((entry) { // 이미지 리스트를 순회하며 각각의 항목을 추가
                            int index = entry.key; // 이미지의 인덱스
                            File image = entry.value; // 이미지 파일
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0), // 사진 간의 간격 추가
                              child: Stack( // 이미지와 삭제 버튼을 겹치기 위해 Stack 사용
                                children: [
                                  Image.file(
                                    image, // 파일 이미지 표시
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover, // 이미지 크기 조정
                                  ),
                                  Positioned(
                                    right: -10,
                                    top: -10,
                                    child: IconButton(
                                      icon: Icon(Icons.cancel, color: Colors.white), // 삭제 버튼 아이콘 설정
                                      onPressed: () => _removeImage(index), // 삭제 버튼 클릭 시 이미지 삭제 함수 호출
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(width: 4.0), // 톱니바퀴 버튼과 업로드 버튼 사이의 간격 추가
                        ElevatedButton( // 이미지 업로드 버튼 생성
                          onPressed: () async {
                            await _pickImage(context); // 버튼 클릭 시 이미지 선택 함수 호출
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, // 버튼 텍스트 색상 설정
                            backgroundColor: BUTTON_COLOR, // 버튼 배경색 설정
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // 버튼 내부 여백 설정
                          ),
                          child: Icon(Icons.camera_alt, size: 30), // 카메라 아이콘 추가
                        ),
                        SizedBox(width: 4.0), // 마지막 사진과 버튼들 사이의 간격 추가
                        ElevatedButton( // 톱니바퀴 아이콘 버튼 생성
                          onPressed: () async {
                            await _requestPermission(context); // 버튼 클릭 시 권한 요청 함수 호출
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, // 버튼 텍스트 색상 설정
                            backgroundColor: BUTTON_COLOR, // 버튼 배경색 설정
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // 버튼 내부 여백 설정
                          ),
                          child: Icon(Icons.settings, size: 30), // 톱니바퀴 아이콘 추가
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8), // 행과 경고 메시지 사이의 간격 추가
          RichText( // 다양한 스타일을 조합하기 위해 RichText 사용
            text: TextSpan(
              children: [
                TextSpan(
                  text: "[필수] ", // 빨간색으로 강조된 부분
                  style: TextStyle(
                    color: Colors.red, // 텍스트 색상 빨간색
                    fontWeight: FontWeight.bold, // 굵은 글씨
                    fontSize: 18
                  ),
                ),
                TextSpan(
                  text: "설정 버튼을 클릭한 후, 사진 앱 권한 허용해야만 사진 업로드가 가능합니다.", // 검은색으로 강조된 부분
                  style: TextStyle(
                    color: Colors.black, // 텍스트 색상 검은색
                    fontWeight: FontWeight.bold, // 굵은 글씨
                    fontSize: 16
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// '리뷰 작성 완료' 버튼을 생성하는 함수
  Widget _buildSubmitButton(BuildContext context) {
    return Center(  // 버튼을 화면의 중앙에 배치함
      child: ElevatedButton(  // 눌러서 실행할 수 있는 버튼 위젯을 생성함
        onPressed: () async {  // 버튼이 눌렸을 때 실행되는 비동기 함수임
          try {  // 예외 발생을 처리하기 위해 try 블록을 사용함
            await ref.read(submitReviewProvider)(  // 리뷰 제출을 위한 프로바이더 함수를 호출함
              userEmail: widget.userEmail,  // 사용자 이메일을 전달함
              orderNumber: widget.numberInfo['order_number'],  // 주문 번호를 전달함
              reviewTitle: widget.titleController.text,  // 리뷰 제목을 전달함
              reviewContents: widget.contentController.text,  // 리뷰 내용을 전달함
              images: _images,  // 리뷰에 첨부할 이미지 목록을 전달함
              productInfo: widget.productInfo,  // 제품 정보를 전달함
              numberInfo: widget.numberInfo,  // 주문 번호 관련 정보를 전달함
              userName: await ref.read(userNameProvider(widget.userEmail).future),  // 사용자 이름을 비동기로 받아 전달함
              paymentCompleteDate: await ref.read(paymentCompleteDateProvider(widget.numberInfo['order_number']).future),  // 결제 완료 날짜를 비동기로 받아 전달함
              deliveryStartDate: await ref.read(deliveryStartDateProvider(widget.numberInfo['order_number']).future),  // 배송 시작 날짜를 비동기로 받아 전달함
            );

            ScaffoldMessenger.of(context).showSnackBar(  // 리뷰 작성 성공 메시지를 표시함
              SnackBar(content: Text('리뷰가 작성되었습니다.')),  // 스낵바에 표시할 메시지를 설정함
            );
          } catch (e) {  // 예외가 발생한 경우 처리함
            ScaffoldMessenger.of(context).showSnackBar(  // 리뷰 작성 실패 메시지를 표시함
              SnackBar(content: Text('리뷰 작성 중 오류가 발생했습니다: $e')),  // 스낵바에 표시할 오류 메시지를 설정함
            );
          }
        },
        style: ElevatedButton.styleFrom(  // 버튼의 스타일을 설정함
          foregroundColor: Colors.white,  // 버튼 글자 색상을 흰색으로 설정함
          backgroundColor: BUTTON_COLOR,  // 버튼 배경 색상을 설정함
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),  // 버튼의 여백을 설정함
        ),
        child: Text('리뷰 작성 완료', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),  // 버튼에 표시할 텍스트와 스타일을 설정함
      ),
    );
  }
}
// ------ 리뷰 작성 상세 화면 관련 UI 내용인 PrivateReviewCreateDetailFormScreen 클래스 내용 끝 부분

