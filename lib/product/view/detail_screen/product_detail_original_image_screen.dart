import 'package:carousel_slider/carousel_slider.dart'; // Carousel Slider 패키지 임포트
import 'package:flutter/cupertino.dart'; // Cupertino 디자인 패키지 임포트
import 'package:flutter/material.dart'; // Material 디자인 패키지 임포트
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 상태 관리 패키지 임포트

import '../../../common/const/colors.dart'; // 색상 상수 파일 임포트
import '../../../common/layout/common_body_parts_layout.dart';
import '../../provider/product_state_provider.dart'; // 상태 프로바이더 파일 임포트

class ProductDetailOriginalImageScreen extends ConsumerStatefulWidget { // ConsumerStatefulWidget을 상속받는 클래스 선언
  final List<String> images; // 이미지 리스트
  final int initialPage; // 초기 페이지 인덱스

  ProductDetailOriginalImageScreen({ // 생성자 정의
    required this.images, // 필수 이미지 리스트 파라미터
    required this.initialPage, // 필수 초기 페이지 인덱스 파라미터
  });

  @override
// _ProductDetailOriginalImageScreenState 클래스의 인스턴스를 생성하는 메서드
  _ProductDetailOriginalImageScreenState createState() => _ProductDetailOriginalImageScreenState();
}

class _ProductDetailOriginalImageScreenState extends ConsumerState<ProductDetailOriginalImageScreen> {

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  @override
  void initState() {
    super.initState(); // 부모 클래스의 initState 메서드를 호출하여 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 프레임이 완전히 렌더링된 후에 호출되는 콜백 함수 추가
      ref.read(detailImagePageProvider.notifier).state = widget.initialPage;
      // detailImagePageProvider의 상태를 widget의 초기 페이지로 설정
    });

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();
  }

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void dispose() {
    // 네트워크 체크 해제
    _networkChecker?.dispose();

    super.dispose(); // 위젯의 기본 정리 작업 수행
  }
  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  @override
  Widget build(BuildContext context) { // build 메소드 오버라이드
    final pageIndex = ref.watch(detailImagePageProvider); // 현재 페이지 인덱스를 상태로부터 읽음

    return Scaffold(
      backgroundColor: Colors.black, // 배경색을 검은색으로 설정
      body: Stack( // 여러 위젯을 겹쳐서 배치
        children: [
          Column(
            children: [
              Expanded(
                child: CarouselSlider.builder( // CarouselSlider.builder를 사용하여 이미지 슬라이더 생성
                  itemCount: widget.images.length, // 이미지 개수 설정
                  options: CarouselOptions(
                    initialPage: widget.initialPage, // 초기 페이지 설정
                    height: MediaQuery.of(context).size.height * 0.9, // 화면의 90% 높이만 차지하도록 설정
                    viewportFraction: 1.0, // 한 번에 하나의 이미지만 보이도록 설정
                    onPageChanged: (index, reason) { // 페이지 변경 시 호출되는 콜백 함수
                      ref.read(detailImagePageProvider.notifier).state = index; // 현재 페이지 인덱스 업데이트
                    },
                  ),
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => // 이미지 빌더 함수
                  Image.network(
                    widget.images[itemIndex], // 이미지 URL 설정
                    fit: BoxFit.contain, // 원본 비율을 유지하고 상하가 더 작게 차지하도록 설정
                    width: MediaQuery.of(context).size.width, // 화면의 너비에 맞게 설정
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40, // 위쪽에서 40픽셀 아래에 위치
            right: 20, // 오른쪽에서 20픽셀 안쪽에 위치
            child: IconButton(
              icon: Icon(Icons.close), // 닫기 아이콘 설정
              color: INPUT_BG_COLOR, // 색상 설정
              onPressed: () {
                Navigator.pop(context); // 누르면 이전 화면으로 돌아가기
              },
            ),
          ),
          Positioned(
            top: 52, // 위쪽에서 52픽셀 아래에 위치
            left: 0, // 왼쪽에 위치
            right: 0, // 오른쪽에 위치
            child: Center(
              child: Text(
                '${pageIndex + 1} / ${widget.images.length}', // 현재 페이지와 전체 페이지 수 표시
                style: TextStyle(color: INPUT_BG_COLOR, fontSize: 16), // 색상과 크기 설정
              ),
            ),
          ),
        ],
      ),
    );
  }
}
