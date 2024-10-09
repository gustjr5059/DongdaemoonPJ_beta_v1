
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../cart/provider/cart_all_proviers.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../message/provider/message_all_provider.dart';
import '../../product/layout/product_body_parts_layout.dart';
import '../../product/model/product_model.dart';
import '../../review/view/review_create_detail_screen.dart';
import '../provider/order_all_providers.dart';
import '../provider/order_state_provider.dart';
import '../view/complete_payment_screen.dart';
import '../view/order_detail_list_screen.dart';
import '../view/order_postcode_search_screen.dart';
import '../view/refund_policy_guide_screen.dart';


// ------- 발주 화면 내 구매자정보 관련 UI 내용을 구현하는 UserInfoWidget 클래스 내용 시작
// UserInfoWidget 클래스는 구매자의 정보를 화면에 표시하는 역할을 담당.
class UserInfoWidget extends ConsumerWidget {
  final String email; // 이메일 정보를 저장하는 필드

  UserInfoWidget({required this.email}); // 생성자에서 이메일을 받아옴

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치를 설정함

    // 업데이트 요청 화면 내 요소들의 수치 설정
    final double updateRequirePadding =
        screenSize.width * (32 / referenceWidth);
    final double ordererInfoTitleFontSize =
        screenSize.height * (18 / referenceHeight);
    final double updateRequireNoticeFontSize1 =
        screenSize.height * (10 / referenceHeight);
    final double updateRequireNoticeFontSize2 =
        screenSize.height * (9 / referenceHeight);

    final double ordererInfo1Y =
        screenSize.height * (16 / referenceHeight);
    final double ordererInfo2Y =
        screenSize.height * (24 / referenceHeight);
    final double ordererInfo3Y =
        screenSize.height * (8 / referenceHeight);

    final userInfoAsyncValue = ref.watch(userInfoProvider(email)); // Riverpod을 사용하여 사용자 정보 프로바이더를 구독

    return userInfoAsyncValue.when(
      data: (userInfo) {
        // userInfo가 null인 경우에도 표를 유지하고, 데이터 필드에 '-'를 표시
        final name = userInfo?['name'] ?? '-';
        final email = userInfo?['email'] ?? '-';
        final phoneNumber = userInfo?['phone_number'] ?? '-';

        // // 휴대폰 번호 입력 필드에 사용할 컨트롤러 생성
        // // 파이어베이스 내 휴대폰 번호 데이터가 있을 시, 불러오고 없으면 직접 입력 부분이 바로 구현
        // // 휴대폰 번호를 불러온 경우에도 커서를 갖다대면 직접 입력 부분이 활성화
        // TextEditingController phoneNumberController = TextEditingController(text: phoneNumber);

        return Padding(
          padding: EdgeInsets.only(left: updateRequirePadding, right: updateRequirePadding, top: updateRequirePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
            mainAxisSize: MainAxisSize.min, // 부모의 제약 조건을 준수하도록 설정
            children: [
              Text(
                '발주자 정보', // 발주자 정보 제목 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: ordererInfoTitleFontSize,
                  fontWeight: FontWeight.bold, // 텍스트 굵게 설정
                  color: Colors.black,
                ),
              ),
              SizedBox(height: ordererInfo1Y),
              // _buildInfoRow를 사용하여 이름과 이메일 정보를 표시
              _buildInfoRow(context, '이름', name),
              _buildInfoRow(context, '이메일', email),
              _buildInfoRow(context, '휴대폰 번호', phoneNumber),
              // // 수정 가능한 휴대폰 번호 행 추가
              // _buildEditablePhoneNumberRow(context, '휴대폰 번호', phoneNumberController),
              SizedBox(height: ordererInfo2Y),
              Text(
                '[정보 불일치로 인한 불이익시 당사가 책임지지 않습니다.]', // 안내문 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireNoticeFontSize1,
                  color: Color(0xFF585858),
                  fontWeight: FontWeight.bold, // 텍스트 색상을 회색으로 설정
                ),
              ),
              SizedBox(height: ordererInfo3Y),
              Text(
                '* 해당 정보의 변경이 필요할 시, 로그인 화면 내 회원가입 절차를 통해 변경된 내용으로 재전송 해주세요.',
                // 안내문 텍스트
                style: TextStyle(
                  fontFamily: 'NanumGothic',
                  fontSize: updateRequireNoticeFontSize2, // 텍스트 크기 12
                  color: Color(0xFF585858),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()), // 로딩 상태 처리
      error: (error, stack) => Center(child: Text('Error: $error')), // 에러 상태 처리
    );
  }

  // 각 정보 행을 구성하는 함수
  Widget _buildInfoRow(BuildContext context, String label, String value) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 발주자 정보 표 부분 수치
    final double ordererInfoTextFontSize =
        screenSize.height * (13 / referenceHeight);
    final double ordererInfoDataFontSize =
        screenSize.height * (12 / referenceHeight);
    final double ordererInfoTextPartWidth =
        screenSize.width * (97 / referenceWidth);
    final double ordererInfoTextPartHeight =
        screenSize.height * (30 / referenceHeight);
    // 행 간 간격 수치
    final double ordererInfo4Y =
        screenSize.height * (2 / referenceHeight);
    final double ordererInfo5Y =
        screenSize.height * (4 / referenceHeight);
    // 데이터 부분 패딩 수치
    final double ordererInfoDataPartX =
        screenSize.width * (8 / referenceWidth);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: ordererInfo4Y),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              height: ordererInfoTextPartHeight,
              width: ordererInfoTextPartWidth,
              // 라벨 셀의 너비 설정
              color: Color(0xFFF2F2F2),
              // color: Colors.green,
              // 배경 색상 설정
              alignment: Alignment.center,
              // 텍스트 정렬
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumGothic',
                  fontSize: ordererInfoTextFontSize,
                  color: Colors.black,
                ), // 텍스트 스타일 설정
              ),
            ),
            SizedBox(width: ordererInfo5Y), // 왼쪽과 오른쪽 사이 간격 추가
            Expanded(
              child: Container(
                color: Color(0xFFFBFBFB), // 배경 색상 설정
                // color: Colors.red, // 배경 색상 설정
                padding: EdgeInsets.only(left: ordererInfoDataPartX),
                alignment: Alignment.centerLeft, // 텍스트 정렬
                child: Text(value,
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: ordererInfoDataFontSize,
                    color: Colors.black,
                  ),
                ), // 값 표시
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ------ 발주 화면 내 발주자 정보 관련 UI 내용을 구현하는 UserInfoWidget 클래스 내용 끝

// ------ 발주 화면 내 받는사람정보 관련 UI 내용을 구현하는 RecipientInfoWidget 클래스 내용 시작
// RecipientInfoWidget 클래스는 수령자의 정보를 입력받고 화면에 표시하는 역할을 담당.
class RecipientInfoWidget extends StatefulWidget {
  final String email; // 이메일 정보를 저장하는 필드
  final TextEditingController nameController; // 이름 입력 컨트롤러
  final TextEditingController phoneNumberController; // 휴대폰 번호 입력 컨트롤러
  final TextEditingController addressController; // 주소 입력 컨트롤러
  final TextEditingController postalCodeController; // 우편번호 입력 컨트롤러
  final TextEditingController detailAddressController; // 상세 주소 입력 컨트롤러
  final TextEditingController customMemoController; // 사용자 지정 메모 입력 컨트롤러
  final String selectedMemo; // 선택된 메모
  final bool isCustomMemo; // 사용자 지정 메모 여부
  final void Function(bool, String, String) onMemoChanged; // 콜백 함수 타입 변경

  RecipientInfoWidget({
    required this.email,
    required this.nameController,
    required this.phoneNumberController,
    required this.addressController,
    required this.postalCodeController,
    required this.detailAddressController,
    required this.customMemoController,
    required this.selectedMemo,
    required this.isCustomMemo,
    required this.onMemoChanged,
  });

  @override
  _RecipientInfoWidgetState createState() => _RecipientInfoWidgetState();
}

class _RecipientInfoWidgetState extends State<RecipientInfoWidget> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _postalCodeController;
  late TextEditingController _detailAddressController;
  late TextEditingController _customMemoController;

  late String _selectedMemo;
  late bool _isCustomMemo;

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  FocusNode _addressFocusNode = FocusNode();
  FocusNode _postalCodeFocusNode = FocusNode();
  FocusNode _detailAddressFocusNode = FocusNode();
  FocusNode _customMemoFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = widget.nameController;
    _phoneNumberController = widget.phoneNumberController;
    _addressController = widget.addressController;
    _postalCodeController = widget.postalCodeController;
    _detailAddressController = widget.detailAddressController;
    _customMemoController = widget.customMemoController;

    _selectedMemo = widget.selectedMemo;
    _isCustomMemo = widget.isCustomMemo;

    print('Initial Custom Memo Controller Text: ${_customMemoController.text}'); // 초기 값 확인
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _addressFocusNode.dispose();
    _postalCodeFocusNode.dispose();
    _detailAddressFocusNode.dispose();
    _customMemoFocusNode.dispose();
    super.dispose();
  }

  // 우편번호 검색 화면을 열고 결과를 받아오는 함수
  Future<void> _openPostcodeSearch() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderPostcodeSearchScreen()),
    );

    if (result != null && result is List<String>) {
      setState(() {
        _addressController.text = result[0];
        _postalCodeController.text = result[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Build Custom Memo Controller Text: ${_customMemoController.text}'); // 빌드 시 값 확인
    print('Is Custom Memo: $_isCustomMemo'); // isCustomMemo 값 확인

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // 화면을 탭할 때 키보드 숨기기
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 위젯의 모든 면에 16.0 픽셀의 여백 추가
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
          mainAxisSize: MainAxisSize.min, // 부모의 제약 조건을 준수하도록 설정
          children: [
            Text(
              '수령자 정보', // 수령자 정보 제목 텍스트
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16), // 제목과 폼 사이에 16 픽셀 높이의 여백 추가
            Column(
              children: [
                _buildDropdownRow('배송지', '배송지를 선택해주세요'), // 드롭다운 행 생성
                _buildEditableRow('이름', _nameController, _nameFocusNode, "'성'을 붙여서 이름을 기입해주세요."), // 수정 가능한 이름 행 생성
                _buildEditableRow('연락처', _phoneNumberController, _phoneNumberFocusNode, "'-'를 붙여서 연락처를 기입해주세요."), // 수정 가능한 연락처 행 생성
                _buildFixedValueRowWithButton('우편번호', _postalCodeController, '우편번호 찾기'), // 우편번호 찾기 버튼이 포함된 행 생성
                _buildFixedValueRow('주소', _addressController), // 고정된 값이 있는 주소 행 생성
                _buildEditableRow(
                  '상세주소',
                  _detailAddressController,
                  _detailAddressFocusNode,
                  "우편번호 및 주소를 선택 후 기입해주세요.",
                  isEnabled: _addressController.text != '없음' && _postalCodeController.text != '없음', // 우편번호와 주소가 없을 때는 비활성화
                ),
                _buildDropdownMemoRow(), // 드롭다운 메모 행 생성
                if (_isCustomMemo)
                  _buildEditableRow(
                    '배송메모', _customMemoController, _customMemoFocusNode, '메모를 직접 기입해주세요.', isEnabled: _isCustomMemo,), // 사용자 지정 메모가 활성화된 경우 수정 가능한 배송 메모 행 생성
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 드롭다운 행을 생성하는 함수
  Widget _buildDropdownRow(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), // 행의 상하단에 2.0 픽셀의 여백 추가
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              width: 80, // 셀의 너비 설정
              color: Colors.grey.shade200, // 셀 배경색 설정
              padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
              alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
              child: Text(
                label, // 셀에 표시될 텍스트
                style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white, // 셀 배경색 설정
                padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: hint, // 드롭다운의 기본값 설정
                    onChanged: (String? newValue) {}, // 변경 이벤트 처리
                    items: <String>[hint].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value), // 드롭다운에 표시될 텍스트
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 수정 가능한 행을 생성하는 함수
  Widget _buildEditableRow(String label, TextEditingController controller, FocusNode focusNode, String hintText, {bool isEnabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), // 행의 상하단에 2.0 픽셀의 여백 추가
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              width: 80, // 셀의 너비 설정
              color: Colors.grey.shade200, // 셀 배경색 설정
              padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
              alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
              child: Text(
                label, // 셀에 표시될 텍스트
                style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white, // 셀 배경색 설정
                padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
                child: GestureDetector(
                  onTap: isEnabled
                      ? () {
                    FocusScope.of(context).requestFocus(focusNode); // 행을 탭할 때 포커스를 설정
                  }
                      : null,
                  child: AbsorbPointer(
                    absorbing: !isEnabled, // isEnabled가 false일 때 입력 차단
                    child: TextField(
                      controller: controller, // 텍스트 필드 컨트롤러 설정
                      focusNode: focusNode, // 텍스트 필드 포커스 노드 설정
                      style: TextStyle(fontSize: 14), // 텍스트 필드 스타일 설정
                      decoration: InputDecoration(
                        hintText: hintText, // 힌트 텍스트 설정
                        hintStyle: TextStyle(color: Colors.grey.shade400), // 힌트 텍스트 색상 설정
                        hintMaxLines: 2, // 힌트 텍스트 최대 줄 수 설정
                        border: InputBorder.none, // 입력 경계선 제거
                        isDense: true, // 간격 설정
                        contentPadding: EdgeInsets.zero, // 내용 여백 제거
                      ),
                      maxLines: null, // 최대 줄 수 설정
                      onChanged: (value) {
                        print('TextField $label changed: $value'); // 디버깅 메시지 추가
                        if (label == '배송메모') {
                          widget.onMemoChanged(_isCustomMemo, value, _selectedMemo); // 배송메모 변경 시 콜백 호출
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 고정된 값을 가진 행을 생성하는 함수
  Widget _buildFixedValueRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), // 행의 상하단에 2.0 픽셀의 여백 추가
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              width: 80, // 셀의 너비 설정
              color: Colors.grey.shade200, // 셀 배경색 설정
              padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
              alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
              child: Text(
                label, // 셀에 표시될 텍스트
                style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white, // 셀 배경색 설정
                padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
                child: Text(controller.text), // 고정된 값을 텍스트로 표시
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 버튼이 포함된 고정된 값을 가진 행을 생성하는 함수
  Widget _buildFixedValueRowWithButton(String label, TextEditingController controller, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), // 행의 상하단에 2.0 픽셀의 여백 추가
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              width: 80, // 셀의 너비 설정
              color: Colors.grey.shade200, // 셀 배경색 설정
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // 셀 내부 여백 설정
              alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
              child: Text(
                label, // 셀에 표시될 텍스트
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white, // 셀 배경색 설정
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // 셀 내부 여백 설정
                child: Row(
                  children: [
                    Expanded(child: Text(controller.text)), // 고정된 값을 텍스트로 표시
                    ElevatedButton(
                      onPressed: _openPostcodeSearch, // 우편번호 찾기 버튼을 눌렀을 때 실행되는 함수
                      style: ElevatedButton.styleFrom(
                        foregroundColor: BUTTON_COLOR, // 버튼 텍스트 색상
                        backgroundColor: BACKGROUND_COLOR, // 버튼 배경색
                        side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 색상
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // 버튼 패딩 (상하 12, 좌우 16)
                      ),
                      child: Text(buttonText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // 버튼 텍스트
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 드롭다운 메모 행을 생성하는 함수
  Widget _buildDropdownMemoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), // 행의 상하단에 2.0 픽셀의 여백 추가
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              width: 80, // 셀의 너비 설정
              color: Colors.grey.shade200, // 셀 배경색 설정
              padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
              alignment: Alignment.centerLeft, // 텍스트를 왼쪽 정렬
              child: Text(
                '배송메모', // 셀에 표시될 텍스트
                style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white, // 셀 배경색 설정
                padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedMemo, // 드롭다운의 기본값 설정
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMemo = newValue!; // 선택된 메모 값 업데이트
                        _isCustomMemo = _selectedMemo == '직접입력'; // 직접 입력 여부 설정
                        if (!_isCustomMemo) {
                          widget.customMemoController.clear(); // 직접 입력이 아닌 경우 내용 지우기
                        }
                        print('Selected Memo: $_selectedMemo'); // 디버깅 메시지 추가
                        widget.onMemoChanged(_isCustomMemo, widget.customMemoController.text, _selectedMemo); // 메모 변경 시 콜백 호출
                      });
                    },
                    items: <String>[
                      '기사님께 보여지는 메모입니다.',
                      '경비실에 맡겨주세요',
                      '문 앞에 놓아 주세요.',
                      '벨은 누르지 말아주세요',
                      '직접입력',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value), // 드롭다운에 표시될 텍스트
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ------- 발주 화면 내 받는사람정보 관련 UI 내용을 구현하는 RecipientInfoWidget 클래스 내용 끝

// ------- 발주 화면 내 결제금액 관련 UI 내용을 구현하는 TotalPaymentWidget 클래스 내용 시작
// TotalPaymentWidget 클래스는 결제 금액 정보를 화면에 표시하는 역할을 담당.
class TotalPaymentWidget extends StatelessWidget {
  final double totalPaymentPrice; // 총 결제금액을 저장하는 변수
  final double totalProductPrice; // 총 상품금액을 저장하는 변수
  final double productDiscountPrice; // 상품 할인금액을 저장하는 변수

  TotalPaymentWidget({
    required this.totalPaymentPrice, // 필수 매개변수로 총 결제금액을 받음
    required this.totalProductPrice, // 필수 매개변수로 총 상품금액을 받음
    required this.productDiscountPrice, // 필수 매개변수로 상품 할인금액을 받음
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('###,###'); // 숫자를 포맷하기 위한 NumberFormat 객체 생성

    return Padding(
      padding: const EdgeInsets.all(16.0), // 위젯의 모든 면에 16.0 픽셀의 여백 추가
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
        children: [
          Text(
            '금액 정보', // 결제금액 제목 텍스트
            style: TextStyle(
              fontSize: 18, // 텍스트 크기 18
              fontWeight: FontWeight.bold, // 텍스트 굵게 설정
            ),
          ),
          SizedBox(height: 16), // 텍스트와 테이블 사이에 16 픽셀 높이의 여백 추가
          Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.grey.shade300), // 테이블 내부 경계선 색상 설정
            ),
            columnWidths: {
              0: FlexColumnWidth(1), // 첫 번째 열의 너비 비율 설정
              1: FlexColumnWidth(2), // 두 번째 열의 너비 비율 설정
            },
            children: [
              _buildTableRow('총 상품금액', '${numberFormat.format(totalProductPrice)}원'), // 총 상품금액 행 생성
              _buildTableRow('상품 할인금액', '-${numberFormat.format(productDiscountPrice)}원'), // 상품 할인금액 행 생성
              _buildTableRow('총 결제금액', '${numberFormat.format(totalPaymentPrice)}원', isTotal: true), // 총 결제금액 행 생성
            ],
          ),
        ],
      ),
    );
  }

  // 테이블의 행을 생성하는 함수
  TableRow _buildTableRow(String label, String value, {bool isTotal = false}) {
    return TableRow(
      children: [
        Container(
          color: Colors.grey.shade200, // 셀 배경색 설정
          padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
          child: Text(
            label, // 셀에 표시될 텍스트
            style: TextStyle(fontWeight: FontWeight.bold), // 텍스트를 굵게 설정
          ),
        ),
        Container(
          color: Colors.white, // 셀 배경색 설정
          padding: const EdgeInsets.all(8.0), // 셀 내부 여백 설정
          alignment: Alignment.centerRight, // 텍스트를 오른쪽 정렬
          child: Text(
            value, // 셀에 표시될 값
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, // 총 결제금액인 경우 텍스트 굵게 설정
              color: isTotal ? Colors.red : Colors.black, // 총 결제금액인 경우 텍스트 색상을 빨간색으로 설정
            ),
          ),
        ),
      ],
    );
  }
}
// -------- 발주 화면 내 결제금액 관련 UI 내용을 구현하는 TotalPaymentWidget 클래스 내용 끝

// ------- 발주 화면 내 결제 방법 정보 관련 UI 내용을 구현하는 PaymentMethodInfoWidget 클래스 내용 시작
// PaymentMethodInfoWidget 클래스는 결제 방법 정보를 화면에 표시하는 역할을 담당.
class PaymentMethodInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // 위젯의 모든 면에 16.0 픽셀의 여백 추가
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
        children: [
          Text(
            '결제 방법', // 결제 방법 제목 텍스트
            style: TextStyle(
              fontSize: 18, // 텍스트 크기 18
              fontWeight: FontWeight.bold, // 텍스트 굵게 설정
            ),
          ),
          SizedBox(height: 16), // 텍스트와 설명 텍스트 사이에 16 픽셀 높이의 여백 추가
          Text(
            "결제 방법은 무조건 계좌이체이며, '결제하기' 버튼 클릭 후 안내하는 계좌로 이체 진행해주세요.", // 설명 텍스트
            style: TextStyle(
              fontSize: 14, // 텍스트 크기 14
              color: Colors.grey, // 텍스트 색상을 회색으로 설정
            ),
          ),
        ],
      ),
    );
  }
}
// ------ 발주 화면 내 결제 방법 정보 관련 UI 내용을 구현하는 PaymentMethodInfoWidget 클래스 내용 끝

// ------- 주문 완료 버튼을 구성하는 UI 관련 CompleteOrderButton 클래스 내용 시작 부분
class CompleteOrderButton extends ConsumerWidget {
  final double totalProductPrice; // 총 상품금액
  final double productDiscountPrice; // 상품 할인금액
  final double totalPaymentPrice; // 총 결제금액
  final Map<String, dynamic> ordererInfo; // 발주자 정보
  final TextEditingController nameController; // 이름 입력 컨트롤러
  final TextEditingController phoneNumberController; // 휴대폰 번호 입력 컨트롤러
  final TextEditingController addressController; // 주소 입력 컨트롤러
  final TextEditingController postalCodeController; // 우편번호 입력 컨트롤러
  final TextEditingController detailAddressController; // 상세 주소 입력 컨트롤러
  final TextEditingController customMemoController; // 사용자 지정 메모 입력 컨트롤러
  final String selectedMemo; // 선택된 메모 값
  final bool isCustomMemo; // 사용자 지정 메모 여부
  final List<ProductContent> orderItems; // 주문 상품 목록

  CompleteOrderButton({
    required this.totalProductPrice, // 생성자에서 총 상품금액을 받아옴
    required this.productDiscountPrice, // 생성자에서 상품 할인금액을 받아옴
    required this.totalPaymentPrice, // 생성자에서 총 결제금액을 받아옴
    required this.ordererInfo, // 생성자에서 발주자 정보를 받아옴
    required this.nameController, // 생성자에서 이름 입력 컨트롤러를 받아옴
    required this.phoneNumberController, // 생성자에서 휴대폰 번호 입력 컨트롤러를 받아옴
    required this.addressController, // 생성자에서 주소 입력 컨트롤러를 받아옴
    required this.postalCodeController, // 생성자에서 우편번호 입력 컨트롤러를 받아옴
    required this.detailAddressController, // 생성자에서 상세 주소 입력 컨트롤러를 받아옴
    required this.customMemoController, // 생성자에서 사용자 지정 메모 입력 컨트롤러를 받아옴
    required this.selectedMemo, // 생성자에서 선택된 메모 값을 받아옴
    required this.isCustomMemo, // 생성자에서 사용자 지정 메모 여부를 받아옴
    required this.orderItems, // 생성자에서 주문 상품 목록을 받아옴
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // 자식 위젯들을 중앙 정렬
      children: [
        Center( // '15,000원 이상 금액부터 결제가 가능합니다.' 텍스트를 중앙에 위치시킴
          child: Text(
            '결제하기 버튼은 15,000원 이상일 시 진행 가능합니다.', // 알림 텍스트
            style: TextStyle(
              fontSize: 14, // 텍스트 크기
              color: Colors.black, // 텍스트 색상 검정
            ),
          ),
        ),
        SizedBox(height: 8), // 알림 텍스트와 버튼 사이에 여백 추가
        Center( // '결제하기' 버튼을 중앙에 위치시킴
          child: ElevatedButton(
            onPressed: totalPaymentPrice >= 15000 ? () async {
              // extra_memo 설정 로직 수정
              final extraMemo = isCustomMemo ? customMemoController.text : '';

              print('Custom Memo Controller Text: ${customMemoController.text}'); // 디버깅 메시지 추가
              print('Is Custom Memo: $isCustomMemo'); // 디버깅 메시지 추가
              print('Extra Memo: $extraMemo'); // 디버깅 메시지 추가

              final recipientInfo = {
                'name': nameController.text, // 수령자 이름
                'phone_number': phoneNumberController.text, // 수령자 휴대폰 번호
                'postal_code': postalCodeController.text, // 우편번호
                'address': addressController.text, // 주소
                'detail_address': detailAddressController.text, // 상세 주소
                'memo': selectedMemo, // 선택된 메모
                'extra_memo': extraMemo, // 사용자 지정 메모
              };

              print('Recipient Info: $recipientInfo'); // 디버깅 메세지 추가

              // 결제 금액 정보 맵 생성
              final amountInfo = {
                'total_product_price': totalProductPrice, // 총 상품금액
                'product_discount_price': productDiscountPrice, // 상품 할인금액
                'total_payment_price': totalPaymentPrice, // 총 결제금액
              };

              // 발주 요청을 보내고 결과로 발주 ID를 받아옴
              final orderId = await ref.read(placeOrderProvider(PlaceOrderParams(
                ordererInfo: ordererInfo, // 발주자 정보
                recipientInfo: recipientInfo, // 수령자 정보
                amountInfo: amountInfo, // 결제 정보
                productInfo: orderItems, // 상품 정보 리스트
              )).future);

              // 발주 완료 메시지를 스낵바로 표시
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('발주가 완료되었습니다. 이메일이 전송되었습니다.')));

              // navigateToScreenAndRemoveUntil 함수를 사용하여 발주완료 화면으로 이동
              navigateToScreenAndRemoveUntil(
                context,
                ref,
                CompletePaymentScreen(orderId: orderId), // 발주 ID를 전달
                4, // 탭 인덱스 업데이트 (하단 탭 바 내 4개 버튼 모두 비활성화)
              );
            } : () {
              // 결제금액이 15,000원 미만일 경우 경고 메시지 표시
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('15,000원 이상 금액부터 결제가 가능합니다.')));
            }, // 결제금액이 15,000원 이상일 경우에만 onPressed 동작 설정, 미만일 경우 메시지 표시
            style: ElevatedButton.styleFrom(
              foregroundColor: BUTTON_COLOR, // 버튼 텍스트 색상 설정
              backgroundColor: BACKGROUND_COLOR, // 버튼 배경 색상 설정
              side: BorderSide(color: BUTTON_COLOR), // 버튼 테두리 색상 설정
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50), // 패딩을 늘려 버튼 크기를 조정
            ),
            child: Text('결제하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // 버튼 텍스트 설정
          ),
        ),
      ],
    );
  }
}
// ------- 주문 완료 버튼을 구성하는 UI 관련 CompleteOrderButton 클래스 내용 끝 부분

// // ------- 상품 상세 화면과 장바구니 화면에서 상품 데이터를 발주 화면으로 전달되는 부분을 UI로 구현한 OrderItemWidget 클래스 내용 시작
// // OrderItemWidget 클래스는 상품의 상세 정보를 화면에 표시하는 역할을 담당.
// class OrderItemWidget extends StatelessWidget {
//   final ProductContent product; // 상품 정보를 저장하는 필드
//
//   OrderItemWidget({required this.product}); // 생성자에서 상품 정보를 받아옴
//
//   @override
//   Widget build(BuildContext context) {
//     final numberFormat = NumberFormat('###,###'); // 숫자를 포맷하기 위한 NumberFormat 객체 생성
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0), // 카드 내부 여백 설정
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
//           children: [
//             if (product.briefIntroduction != null) // briefIntroduction가 null이 아닌 경우에만 표시
//               Text(
//                 product.briefIntroduction!,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 글자 크기 18, 굵게 설정
//               ),
//             if (product.productNumber != null) // productNumber가 null이 아닌 경우에만 표시
//               Text(
//                 '상품번호: ${product.productNumber}', // productNumber 내용을 표시
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 글자 크기를 14로 설정
//               ),
//             SizedBox(height: 8), // 텍스트와 이미지 사이에 8 픽셀 높이의 여백 추가
//             Row(
//               children: [
//                 if (product.thumbnail != null) // thumbnail이 null이 아닌 경우에만 표시
//                   Image.network(
//                     product.thumbnail!,
//                     height: 100, // 이미지 높이 100 픽셀
//                     width: 100, // 이미지 너비 100 픽셀
//                     fit: BoxFit.cover, // 이미지를 잘라서 맞춤
//                   ),
//                 SizedBox(width: 8), // 이미지와 텍스트 사이에 8 픽셀 너비의 여백 추가
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
//                   children: [
//                     Text(
//                       '${numberFormat.format(product.originalPrice)}원',
//                       style: TextStyle(
//                         fontSize: 14, // 글자 크기 14
//                         color: Colors.grey[500], // 글자 색상 회색
//                         decoration: TextDecoration.lineThrough, // 취소선 스타일 적용
//                       ),
//                     ),
//                     Text(
//                       '${numberFormat.format(product.discountPrice)}원',
//                       style: TextStyle(
//                         fontSize: 18, // 글자 크기 18
//                         fontWeight: FontWeight.bold, // 글자 굵게 설정
//                       ),
//                     ),
//                     Text(
//                       '${product.discountPercent?.round()}%',
//                       style: TextStyle(
//                         fontSize: 18, // 글자 크기 18
//                         color: Colors.red, // 글자 색상 빨간색
//                         fontWeight: FontWeight.bold, // 글자 굵게 설정
//                       ),
//                     ),
//                     Text('수량: ${product.selectedCount}'), // 수량 표시
//                     if (product.selectedColorImage != null) // selectedColorImage가 null이 아닌 경우에만 표시
//                       Image.network(
//                         product.selectedColorImage!,
//                         height: 20, // 이미지 높이 20 픽셀
//                         width: 20, // 이미지 너비 20 픽셀
//                         fit: BoxFit.cover, // 이미지를 잘라서 맞춤
//                       ),
//                     Text('색상: ${product.selectedColorText}'), // 색상 텍스트 표시
//                     Text('사이즈: ${product.selectedSize}'), // 사이즈 텍스트 표시
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // ------ 상품 상세 화면과 장바구니 화면에서 상품 데이터를 발주 화면으로 전달되는 부분을 UI로 구현한 OrderItemWidget 클래스 내용 끝

// ------ 발주 목록 화면 내 발주 리스트 아이템을 표시하는 위젯 클래스인 OrderListItemWidget 내용 시작
class OrderListItemWidget extends ConsumerWidget {
  // 발주 데이터를 담고 있는 맵 객체를 멤버 변수로 선언.
  final Map<String, dynamic>? order;

  // 생성자를 통해 발주 데이터를 초기화.
  OrderListItemWidget({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 발주내역 화면 내 카드뷰 섹션의 가로와 세로 비율 계산
    final double orderlistInfoCardViewWidth =
        screenSize.width * (360 / referenceWidth); // 가로 비율 계산
    final double orderlistInfoCardViewHeight =
        screenSize.height * (160 / referenceHeight); // 세로 비율 계산

    // body 부분 전체 패딩 수치 계산
    final double orderlistInfoCardViewPaddingX = screenSize.width * (15 / referenceWidth); // 좌우 패딩 계산
    final double orderlistInfoCardViewPadding1Y = screenSize.height * (10 / referenceHeight); // 상하 패딩 계산

    // 텍스트 크기 계산
    final double orderlistInfoOrderDateDataFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistInfoOrderStatusDataFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistInfoOrderNumberDataFontSize =
        screenSize.height * (15 / referenceHeight); // 텍스트 크기 비율 계산

    // 발주내역 상세보기 버튼과 삭제 버튼의 가로, 세로 비율 계산
    final double orderlistInfoDetailViewBtn1X =
        screenSize.width * (150 / referenceWidth); // 발주내역 상세보기 버튼 가로 비율 계산
    final double orderlistInfoDetailViewBtn1Y =
        screenSize.height * (45 / referenceHeight); // 발주내역 상세보기 버튼 세로 비율 계산
    final double orderlistInfoDetailViewBtnFontSize =
        screenSize.height * (14 / referenceHeight); // 발주내역 상세보기 버튼 텍스트 크기 비율 계산
    final double orderlistInfoDetailViewBtnPaddingX = screenSize.width * (12 / referenceWidth); // 발주내역 상세보기 버튼 좌우 패딩 계산
    final double orderlistInfoDetailViewBtnPaddingY = screenSize.height * (5 / referenceHeight); // 발주내역 상세보기 버튼 상하 패딩 계산
    final double deleteBtn1X =
        screenSize.width * (80 / referenceWidth); // 삭제 버튼 가로 비율 계산
    final double deleteBtn1Y =
        screenSize.height * (45 / referenceHeight); // 삭제 버튼 세로 비율 계산
    final double deleteBtnFontSize =
        screenSize.height * (14 / referenceHeight); // 삭제 버튼 텍스트 크기 비율 계산
    final double deleteBtnPaddingX = screenSize.width * (12 / referenceWidth); // 삭제 버튼 좌우 패딩 계산
    final double deleteBtnPaddingY = screenSize.height * (5 / referenceHeight); // 삭제 버튼 상하 패딩 계산

    // 발주내역 카드뷰 섹션 내 컨텐츠 사이의 간격 계산
    final double interval1Y = screenSize.height * (8 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y = screenSize.height * (12 / referenceHeight); // 세로 간격 2 계산
    final double interval1X = screenSize.width * (50 / referenceWidth); // 가로 간격 1 계산
    final double interval2X = screenSize.width * (10 / referenceWidth); // 가로 간격 2 계산

    // // 발주 데이터가 없는 경우 '발주 내역이 없습니다.' 메시지 표시
    // if (order == null || order!.isEmpty) {
    //   return Center(
    //     child: Text('발주 내역이 없습니다.'),
    //   );
    // }

    // 날짜 포맷을 지정.
    final dateFormat = DateFormat('yyyy-MM-dd');
    // 발주일자를 타임스탬프에서 DateTime 객체로 변환.
    final orderDate = (order!['numberInfo']['order_date'] as Timestamp).toDate();
    // 발주번호를 가져옴.
    final orderNumber = order!['numberInfo']['order_number'];
    // 발주 상태를 orderStatus 필드에서 가져옴.
    final orderStatus = order!['orderStatus']; // 발주 상태 데이터

    // 클립 위젯을 사용하여 모서리를 둥글게 설정함
    return ClipRRect(
        borderRadius: BorderRadius.circular(10), // 모서리 반경 설정
        child: Container(
          width: orderlistInfoCardViewWidth, // 카드뷰 가로 크기 설정
          height: orderlistInfoCardViewHeight, // 카드뷰 세로 크기 설정
          color: Color(0xFFF3F3F3), // 배경색 설정
          child: CommonCardView( // 공통 카드뷰 위젯 사용
            backgroundColor: Color(0xFFF3F3F3), // 배경색 설정
            elevation: 0, // 그림자 깊이 설정
            content: Padding( // 패딩 설정
              padding: EdgeInsets.symmetric(vertical: orderlistInfoCardViewPadding1Y, horizontal: orderlistInfoCardViewPaddingX), // 상하 좌우 패딩 설정
              child: Column( // 컬럼 위젯으로 구성함
                // 자식 위젯들을 왼쪽 정렬.
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 행(Row) 위젯을 사용하여 발주일자와 발주상태를 배치.
                  Row(
                    // 자식 위젯들을 양쪽 끝에 배치.
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 발주일자를 텍스트로 표시.
                      Text(
                      '발주일자: ${orderDate != null ? dateFormat.format(orderDate) : '에러 발생'}',
                      style: TextStyle(
                        fontSize: orderlistInfoOrderDateDataFontSize, // 텍스트 크기 설정
                        fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                        fontFamily: 'NanumGothic', // 글꼴 설정
                        color: Colors.black, // 텍스트 색상 설정
                        ),
                      ),
                      // 발주상태를 텍스트로 표시.
                      Text(
                        orderStatus,
                        style: TextStyle(
                          fontSize: orderlistInfoOrderStatusDataFontSize, // 텍스트 크기 설정
                          fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                          fontFamily: 'NanumGothic', // 글꼴 설정
                          color: Colors.red, // 텍스트 색상 설정
                        ),
                      ),
                    ],
                  ),
                  // 여백을 추가.
                  SizedBox(height: interval1Y),
                  // 발주번호를 텍스트로 표시.
                  Text(
                    '발주번호: $orderNumber',
                    style: TextStyle(
                      fontSize: orderlistInfoOrderNumberDataFontSize, // 텍스트 크기 설정
                      fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                      fontFamily: 'NanumGothic', // 글꼴 설정
                      color: Color(0xFF676767), // 텍스트 색상 설정
                    ),
                  ),
                  // 여백을 추가.
                  SizedBox(height: interval2Y),
                  // 회원정보 수정 및 로그아웃 버튼을 행(Row)으로 배치함
                  Row(
                    children: [
                      Container(
                        width: orderlistInfoDetailViewBtn1X, // 발주내역 상세보기 버튼 가로 설정
                        height: orderlistInfoDetailViewBtn1Y, // 발주내역 상세보기 버튼 세로 설정
                        margin: EdgeInsets.only(left: interval1X), // 왼쪽 여백 설정
                        child: ElevatedButton( // ElevatedButton 위젯을 사용하여 버튼을 생성함
                          onPressed: () { // 버튼이 눌렸을 때 실행될 함수를 정의함
                            Navigator.push( // 새 화면으로 전환하기 위해 Navigator.push를 호출함
                              context, // 현재 화면의 컨텍스트를 전달함
                              MaterialPageRoute( // 새로운 화면으로 전환하기 위한 MaterialPageRoute를 생성함
                                builder: (context) => // 새 화면을 빌드할 함수를 전달함
                                OrderListDetailScreen(orderNumber: orderNumber), // OrderListDetailScreen을 생성하고, orderNumber를 전달함
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom( // 버튼의 스타일을 설정함
                            foregroundColor: Color(0xFF6FAD96), // 버튼의 글자 색상을 설정함
                            backgroundColor: Color(0xFF6FAD96), // 버튼의 배경 색상을 설정함
                            padding: EdgeInsets.symmetric(vertical: orderlistInfoDetailViewBtnPaddingY, horizontal: orderlistInfoDetailViewBtnPaddingX), // 패딩 설정
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45), // 모서리 둥글게 설정
                            ),
                          ),
                          child: Text( // 버튼에 표시될 텍스트를 정의함
                            '발주 내역 상세보기', // 텍스트 내용으로 '발주 내역 상세보기'를 설정함
                            style: TextStyle(
                              fontSize: orderlistInfoDetailViewBtnFontSize, // 텍스트 크기 설정
                              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                              fontFamily: 'NanumGothic', // 글꼴 설정
                              color: Colors.white, // 텍스트 색상 설정
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: deleteBtn1X, // 삭제 버튼 가로 설정
                        height: deleteBtn1Y, // 삭제 버튼 세로 설정
                        margin: EdgeInsets.only(left: interval2X), // 왼쪽 여백 설정
                        child: ElevatedButton( // 두 번째 ElevatedButton 위젯을 생성함
                          onPressed: () async { // 비동기 함수로 버튼이 눌렸을 때 실행될 함수를 정의함
                            await showSubmitAlertDialog( // 알림 대화상자를 표시하기 위해 showSubmitAlertDialog를 호출함
                              context, // 현재 화면의 컨텍스트를 전달함
                              title: '[발주 내역 삭제]', // 대화상자의 제목으로 '발주 내역 삭제'를 설정함
                              content: '삭제 시, 해당 내역은 영구적으로 삭제됩니다.\n작성하신 발주 내역을 삭제하시겠습니까?', // 대화상자의 내용으로 경고 메시지를 설정함
                              actions: buildAlertActions( // 대화상자에 표시될 액션 버튼들을 설정함
                                context, // 현재 화면의 컨텍스트를 전달함
                                noText: '아니요', // '아니요' 버튼의 텍스트를 설정함
                                yesText: '예', // '예' 버튼의 텍스트를 설정함
                                noTextStyle: TextStyle( // '아니요' 버튼의 텍스트 스타일을 설정함
                                  color: Colors.black, // '아니요' 버튼의 글자 색상을 검정색으로 설정함
                                  fontWeight: FontWeight.bold, // '아니요' 버튼의 글자 굵기를 굵게 설정함
                                ),
                                yesTextStyle: TextStyle( // '예' 버튼의 텍스트 스타일을 설정함
                                  color: Colors.red, // '예' 버튼의 글자 색상을 빨간색으로 설정함
                                  fontWeight: FontWeight.bold, // '예' 버튼의 글자 굵기를 굵게 설정함
                                ),
                                onYesPressed: () async { // '예' 버튼이 눌렸을 때 실행될 비동기 함수를 정의함
                                  try {
                                    // orderlistItemsProvider에서 OrderlistItemsNotifier를 읽어와 호출함.
                                    await ref.read(orderlistItemsProvider.notifier)
                                    // deleteOrderItem 함수에 발주 번호를 매개변수로 전달하여 발주 항목 삭제 요청을 보냄.
                                        .deleteOrderItem(orderNumber);
                                    Navigator.of(context).pop(); // 성공적으로 삭제된 후 대화상자를 닫음
                                    showCustomSnackBar(context, '발주 내역이 삭제되었습니다.'); // 삭제 성공 메시지를 스낵바로 표시함(성공 메시지 텍스트를 설정함)
                                  } catch (e) { // 삭제 중 오류가 발생했을 때의 예외 처리를 정의함
                                    showCustomSnackBar(context, '발주 내역 삭제 중 오류가 발생했습니다: $e'); // 오류 메시지를 스낵바로 표시함
                                  }
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom( // 두 번째 버튼의 스타일을 설정함
                            foregroundColor: Color(0xFF6FAD96), // 두 번째 버튼의 글자 색상을 설정함
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 버튼 배경색을 앱 배경색으로 설정
                            side: BorderSide(color: Color(0xFF6FAD96)), // 버튼 테두리 색상 설정
                            padding: EdgeInsets.symmetric(vertical: deleteBtnPaddingY, horizontal: deleteBtnPaddingX), // 패딩 설정
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45), // 모서리 둥글게 설정
                            ),
                          ),
                          child: Text( // 두 번째 버튼에 표시될 텍스트를 정의함
                            '삭제', // 텍스트 내용으로 '삭제'를 설정함
                            style: TextStyle(
                              fontSize: deleteBtnFontSize, // 텍스트 크기 설정
                              fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                              fontFamily: 'NanumGothic', // 글꼴 설정
                              color: Color(0xFF6FAD96), // 텍스트 색상 설정
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
// ------ 발주 목록 화면 내 발주 리스트 아이템을 표시하는 위젯 클래스인 OrderListItemWidget 내용 끝

// 발주 목록 상세 화면 내 발주 목록 상세 내용을 표시하는 위젯 클래스인 OrderListDetailItemWidget 시작
class OrderListDetailItemWidget extends ConsumerStatefulWidget {
  // 발주 데이터를 담고 있는 Map<String, dynamic> 형태의 order 필드를 선언
  final Map<String, dynamic>? order;

  // 생성자에서 order 필드를 필수로 받도록 설정함
  OrderListDetailItemWidget({required this.order});

  // 위젯의 상태를 생성하는 메서드를 오버라이드함
  @override
  _OrderListDetailItemWidgetState createState() =>
      _OrderListDetailItemWidgetState();
}

// 위젯의 상태를 정의하는 클래스 _OrderListDetailItemWidgetState 시작
class _OrderListDetailItemWidgetState
    extends ConsumerState<OrderListDetailItemWidget> {
  @override
  Widget build(BuildContext context) {

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 발주내역 상세 화면 내 카드뷰 섹션의 가로와 세로 비율 계산
    final double orderlistDtInfo1CardViewWidth =
        screenSize.width * (360 / referenceWidth); // 가로 비율 계산
    final double orderlistDtInfo1CardViewHeight =
        screenSize.height * (95 / referenceHeight); // 세로 비율 계산
    final double orderlistDtInfo2CardViewWidth =
        screenSize.width * (360 / referenceWidth); // 가로 비율 계산
    final double orderlistDtInfo2CardViewHeight =
        screenSize.height * (220 / referenceHeight); // 세로 비율 계산
    final double orderlistDtInfo3CardViewWidth =
        screenSize.width * (360 / referenceWidth); // 가로 비율 계산
    final double orderlistDtInfo3CardViewHeight =
        screenSize.height * (200 / referenceHeight); // 세로 비율 계산

    // body 부분 전체 패딩 수치 계산
    final double orderlistDtInfoCardViewPaddingX = screenSize.width * (5 / referenceWidth); // 좌우 패딩 계산
    final double orderlistDtInfoCardViewPadding1Y = screenSize.height * (5 / referenceHeight); // 상하 패딩 계산

    // 텍스트 크기 계산
    final double orderlistDtInfoOrderDateDataFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoOrderNumberDataFontSize =
        screenSize.height * (15 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoBriefIntroDataFontSize =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoProdNumberDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoOriginalPriceDataFontSize =
        screenSize.height * (14 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoDiscountPriceDataFontSize =
        screenSize.height * (24 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoDiscountPercentDataFontSize =
        screenSize.height * (22 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoColorImageDataWidth =
        screenSize.width * (18 / referenceWidth); // 색상 이미지 가로 크기 설정함
    final double orderlistDtInfoColorImageDataHeight =
        screenSize.width * (18 / referenceWidth); // 색상 이미지 세로 크기 설정함
    final double orderlistDtInfoColorTextDataFontSize =
        screenSize.height * (18 / referenceHeight); // 텍스트 크기 비율 계산
    final double orderlistDtInfoSizeTextDataFontSize =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기 비율 계산

    // 발주내역 카드뷰 섹션 내 컨텐츠 사이의 간격 계산
    final double interval1Y = screenSize.height * (4 / referenceHeight); // 세로 간격 1 계산
    final double interval2Y = screenSize.height * (8 / referenceHeight); // 세로 간격 2 계산
    final double interval3Y = screenSize.height * (15 / referenceHeight); // 세로 간격 3 계산
    final double interval1X = screenSize.width * (40 / referenceWidth); // 가로 간격 1 계산
    final double interval2X = screenSize.width * (10 / referenceWidth); // 가로 간격 2 계산

    // 날짜 형식을 'yyyy-MM-dd'로 지정함
    final dateFormat = DateFormat('yyyy-MM-dd');

    // order 정보에서 발주 날짜를 가져오고, 값이 유효하면 Timestamp를 DateTime으로 변환함
    final orderDate = widget.order!['numberInfo']['order_date']
        ?.toString()
        .isNotEmpty ==
        true
        ? (widget.order!['numberInfo']['order_date'] as Timestamp).toDate()
        : null;

    // order 정보에서 발주 번호를 가져오고, 값이 유효하지 않으면 '에러 발생'을 반환함
    final orderNumber = widget.order!['numberInfo']['order_number']
        ?.toString()
        .isNotEmpty ==
        true
        ? widget.order!['numberInfo']['order_number']
        : '에러 발생';

    // 결제 완료일 데이터를 비동기로 가져오는 provider를 호출하고 결과를 paymentCompleteDateAsyncValue에 저장함
    final paymentCompleteDateAsyncValue =
    ref.watch(paymentCompleteDateProvider(orderNumber));

    // 버튼 활성화 정보를 비동기로 가져오는 provider를 호출하고 결과를 buttonInfoAsyncValue에 저장함
    final buttonInfoAsyncValue = ref.watch(buttonInfoProvider(orderNumber));

    // 숫자 형식을 '###,###'로 지정함
    final numberFormat = NumberFormat('###,###');

    // order 정보에서 총 상품 금액, 상품 할인 금액, 총 결제 금액을 가져오고, 값이 유효하지 않으면 0.0으로 설정함
    final totalProductPrice = widget.order!['amountInfo']['total_product_price']
        ?.toString()
        .isNotEmpty ==
        true
        ? (widget.order!['amountInfo']['total_product_price'] as num).toDouble()
        : 0.0;
    final productDiscountPrice =
    widget.order!['amountInfo']['product_discount_price']
        ?.toString()
        .isNotEmpty ==
        true
        ? (widget.order!['amountInfo']['product_discount_price'] as num)
        .toDouble()
        : 0.0;
    final totalPaymentPrice = widget.order!['amountInfo']['total_payment_price']
        ?.toString()
        .isNotEmpty ==
        true
        ? (widget.order!['amountInfo']['total_payment_price'] as num).toDouble()
        : 0.0;

    // 수령자 정보가 null인지 확인하고 각 필드를 안전하게 접근함
    final recipientInfo = widget.order!['recipientInfo'] ?? {};

    // 수령자 정보에서 이름, 연락처, 주소, 상세주소, 우편번호를 가져오고, 값이 유효하지 않으면 기본 메시지를 설정함
    final recipientName = recipientInfo['name']?.toString().isNotEmpty == true
        ? recipientInfo['name']
        : '이름 없음';
    final recipientPhone =
    recipientInfo['phone_number']?.toString().isNotEmpty == true
        ? recipientInfo['phone_number']
        : '연락처 없음';
    final recipientAddress =
    recipientInfo['address']?.toString().isNotEmpty == true
        ? recipientInfo['address']
        : '주소 없음';
    final recipientDetailAddress =
    recipientInfo['detail_address']?.toString().isNotEmpty == true
        ? recipientInfo['detail_address']
        : '상세주소 없음';
    final recipientPostalCode =
    recipientInfo['postal_code']?.toString().isNotEmpty == true
        ? recipientInfo['postal_code']
        : '우편번호 없음';

    // 배송 메모 데이터를 처리하고, '직접입력'일 경우 추가 메모를 가져옴
    String deliveryMemo =
    recipientInfo['memo']?.toString().isNotEmpty == true
        ? recipientInfo['memo']
        : '배송 메모 없음';
    if (deliveryMemo == '직접입력') {
      deliveryMemo =
      recipientInfo['extra_memo']?.toString().isNotEmpty == true
          ? recipientInfo['extra_memo']
          : '추가 메모 없음';
    }

    // productInfo 리스트를 가져와서 해당 발주번호 관련 상품별로 productInfo 데이터를 구현 가능하도록 하는 로직
    final List<dynamic> productInfoList = widget.order!['productInfo'] ?? [];

    // ProductInfoDetailScreenNavigation 인스턴스를 생성하여 상품 상세 화면으로 이동할 수 있도록 설정함
    final navigatorProductDetailScreen =
    ProductInfoDetailScreenNavigation(ref);

    // 발주 상세 정보를 화면에 렌더링하는 위젯을 구성함
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 발주 날짜와 발주 번호, 결제 완료일을 표시하는 섹션
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 발주 일자를 표시
              Text(
                '발주일자: ${orderDate != null ? dateFormat.format(orderDate) : '에러 발생'}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // 발주 번호를 표시
              Text(
                '발주번호: $orderNumber',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // 결제완료일 데이터를 표시, 비동기 데이터 처리 로직을 추가
              paymentCompleteDateAsyncValue.when(
                data: (date) {
                  if (date != null) {
                    return Text(
                      '결제완료일: ${DateFormat('yyyy-MM-dd').format(date)}',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    );
                  } else {
                    return SizedBox.shrink(); // UI에 아무것도 표시하지 않음
                  }
                },
                loading: () => CircularProgressIndicator(), // 로딩 상태 처리
                error: (error, stack) => Text('오류 발생'), // 오류 상태 처리
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        // 결제 정보를 표시하는 카드뷰
        CommonCardView(
          backgroundColor: BEIGE_COLOR,
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 결제 정보를 나타내는 제목 텍스트
                Text(
                  '결제 정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                // 각 결제 정보 항목을 표시하는 _buildAmountRow 함수 호출
                _buildAmountRow(
                    '총 상품금액', '${numberFormat.format(totalProductPrice)} 원'),
                _buildAmountRow('상품 할인금액',
                    '-${numberFormat.format(productDiscountPrice)} 원'),
                _buildAmountRow('배송비', '0 원'),
                Divider(),
                _buildAmountRow(
                  '총 결제금액',
                  '${numberFormat.format(totalPaymentPrice)} 원',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        // 수령자 정보를 표시하는 카드뷰
        CommonCardView(
          backgroundColor: BEIGE_COLOR,
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 수령자 정보를 나타내는 제목 텍스트
                Text(
                  '수령자 정보',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                // 수령자 정보 각 항목을 표시하는 _buildRecipientInfoRow 함수 호출
                _buildRecipientInfoRow('수령자명', recipientName),
                _buildRecipientInfoRow('수령자 연락처', recipientPhone),
                _buildRecipientInfoRow('주소(상세주소)', ''),
                _buildRecipientInfoRow(
                    '$recipientAddress ($recipientDetailAddress) ($recipientPostalCode)',
                    ''),
                Divider(color: Colors.grey),
                _buildRecipientInfoRow('배송메모', ''),
                _buildRecipientInfoRow(deliveryMemo, ''),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        // 각 상품 정보를 표시하는 로직을 반복문으로 구성함
        for (var productInfo in productInfoList)
          CommonCardView(
            backgroundColor: BEIGE_COLOR,
            content: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 환불 완료 상태인 경우 '환불 완료' 텍스트를 표시함.
                  if (productInfo['boolRefundCompleteBtn'] == true)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0), // 하단에 8.0의 패딩을 추가함.
                      child: Text(
                        '환불 완료', // '환불 완료' 텍스트를 표시함.
                        style: TextStyle(
                          color: Colors.red, // 텍스트 색상을 빨간색으로 설정함.
                          fontWeight: FontWeight.bold, // 텍스트를 굵게 표시함.
                          fontSize: 16, // 텍스트 크기를 16으로 설정함.
                        ),
                      ),
                    ),
                  // 상품 번호와 간략 소개를 표시하는 _buildProductInfoRow 함수 호출
                  _buildProductInfoRow(
                      productInfo['product_number']?.toString().isNotEmpty ==
                          true
                          ? productInfo['product_number']
                          : '에러 발생',
                      '',
                      bold: true,
                      fontSize: 14),
                  _buildProductInfoRow(
                      productInfo['brief_introduction']
                          ?.toString()
                          .isNotEmpty ==
                          true
                          ? productInfo['brief_introduction']
                          : '에러 발생',
                      '',
                      bold: true,
                      fontSize: 18),
                  SizedBox(height: 8),
                  // 새로운 흰색 카드뷰 섹션을 추가함
                  GestureDetector(
                    onTap: () {
                      // 상품 상세 화면으로 이동함
                      final product = ProductContent(
                        docId: productInfo['product_id'] ?? '',
                        category: productInfo['category']?.toString() ??
                            '에러 발생',
                        productNumber: productInfo['product_number']
                            ?.toString() ??
                            '에러 발생',
                        thumbnail:
                        productInfo['thumbnails']?.toString() ?? '',
                        briefIntroduction: productInfo['brief_introduction']
                            ?.toString() ??
                            '에러 발생',
                        originalPrice: productInfo['original_price'] ?? 0,
                        discountPrice: productInfo['discount_price'] ?? 0,
                        discountPercent: productInfo['discount_percent'] ?? 0,
                      );
                      navigatorProductDetailScreen.navigateToDetailScreen(
                          context, product);
                    },
                    child: CommonCardView(
                      backgroundColor: Colors.white, // 배경색을 흰색으로 설정함
                      content: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 상품의 썸네일 이미지와 가격 정보를 표시하는 행
                            Row(
                              children: [
                                // 썸네일 이미지를 표시하고, 없을 경우 대체 아이콘 표시
                                Expanded(
                                    flex: 3,
                                    child: productInfo['thumbnails']
                                        ?.toString()
                                        .isNotEmpty ==
                                        true
                                        ? Image.network(productInfo['thumbnails'],
                                        fit: BoxFit.cover)
                                        : Icon(Icons.image_not_supported)),
                                SizedBox(width: 8),
                                // 상품의 가격, 색상, 사이즈, 수량 정보를 표시
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${numberFormat.format(productInfo['original_price']?.toString().isNotEmpty == true ? productInfo['original_price'] as num : 0.0)} 원',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                          decoration:
                                          TextDecoration.lineThrough,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${numberFormat.format(productInfo['discount_price']?.toString().isNotEmpty == true ? productInfo['discount_price'] as num : 0.0)} 원',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '${(productInfo['discount_percent']?.toString().isNotEmpty == true ? productInfo['discount_percent'] as num : 0.0).toInt()}%',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // 선택된 색상 이미지를 표시하고, 없을 경우 대체 아이콘 표시
                                          productInfo['selected_color_image']
                                              ?.toString()
                                              .isNotEmpty ==
                                              true
                                              ? Image.network(
                                            productInfo[
                                            'selected_color_image'],
                                            height: 18,
                                            width: 18,
                                            fit: BoxFit.cover,
                                          )
                                              : Icon(
                                              Icons.image_not_supported,
                                              size: 20),
                                          SizedBox(width: 8),
                                          // 선택된 색상 텍스트를 표시
                                          Text(
                                            productInfo['selected_color_text']
                                                ?.toString()
                                                .isNotEmpty ==
                                                true
                                                ? productInfo[
                                            'selected_color_text']
                                                : '에러 발생',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      // 선택된 사이즈와 수량을 표시
                                      Text(
                                          '사이즈: ${productInfo['selected_size']?.toString().isNotEmpty == true ? productInfo['selected_size'] : '에러 발생'}'),
                                      Text(
                                          '수량: ${productInfo['selected_count']?.toString().isNotEmpty == true ? '${productInfo['selected_count']} 개' : '0 개'}'),
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
                  Divider(color: Colors.grey),
                  // 환불 및 리뷰 버튼을 표시하고, 버튼 활성화 상태에 따라 UI를 제어하는 로직을 추가함
                  buttonInfoAsyncValue.when(
                    data: (buttonInfo) {
                      final boolRefundBtn = buttonInfo['boolRefundBtn'] ?? false;
                      final boolReviewWriteBtn =
                          buttonInfo['boolReviewWriteBtn'] ?? false;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: boolRefundBtn && !(productInfo['boolRefundCompleteBtn'] ?? false)
                                ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RefundPolicyGuideScreen(
                                          orderNumber: widget.order?[
                                          'numberInfo']
                                          ['order_number']),
                                ),
                              );
                            }
                                : null, // 환불 버튼 활성화 여부에 따라 동작함
                            style: ElevatedButton.styleFrom(
                              foregroundColor: boolRefundBtn
                                  ? BUTTON_COLOR
                                  : Colors.grey,
                              backgroundColor: BACKGROUND_COLOR,
                              side: BorderSide(
                                  color: boolRefundBtn
                                      ? BUTTON_COLOR
                                      : Colors.grey),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                            ),
                            child: Text('환불',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                          ElevatedButton(
                            // 'boolReviewWriteBtn' 필드값과 'boolReviewCompleteBtn' 필드값을 조건으로 활성화 / 비활성화를 동작
                            // 'boolReviewWriteBtn' 필드값이 'true'가 되면 활성화되자만, 이 중 'boolReviewCompleteBtn' 필드값이 'ture'가 되면 비활성화로 변경
                            onPressed: boolReviewWriteBtn && !(productInfo['boolReviewCompleteBtn'] ?? false)
                                ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewCreateDetailScreen(
                                        productInfo: productInfo,
                                        // 개별 상품 데이터를 전달함
                                        numberInfo: widget.order!['numberInfo'],
                                        // 개별 상품 발주번호 및 발주일자 전달함
                                        userEmail: FirebaseAuth.instance
                                            .currentUser!.email!,
                                      ),
                                ),
                              );
                            }
                                : null, // 리뷰 작성 버튼 활성화 여부에 따라 동작함
                            style: ElevatedButton.styleFrom(
                              foregroundColor: boolReviewWriteBtn
                                  ? BUTTON_COLOR
                                  : Colors.grey,
                              backgroundColor: BACKGROUND_COLOR,
                              side: BorderSide(
                                  color: boolReviewWriteBtn
                                      ? BUTTON_COLOR
                                      : Colors.grey),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                            ),
                            child: Text('리뷰 작성',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              onOrderAddToCartButtonPressed(
                                  context, ref, productInfo);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: BUTTON_COLOR,
                              backgroundColor: BACKGROUND_COLOR,
                              side: BorderSide(color: BUTTON_COLOR),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                            ),
                            child: Text('장바구니 담기',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      );
                    },
                    loading: () => CircularProgressIndicator(),
                    // 버튼 정보 로딩 중일 때 로딩 인디케이터 표시함
                    error: (error, stack) =>
                        Text('버튼 상태를 불러오는 중 오류 발생'), // 오류 발생 시 메시지 표시
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
// 발주 목록 상세 화면 내 발주 목록 상세 내용을 표시하는 위젯 클래스인 OrderListDetailItemWidget 끝

// 결제 정보를 표시하는 행을 구성하는 함수
Widget _buildAmountRow(String label, String value,
    {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 라벨을 표시하는 텍스트
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        // 값을 표시하는 텍스트
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.red : Colors.black,
          ),
        ),
      ],
    ),
  );
}

// 수령자 정보를 표시하는 행을 구성하는 함수
Widget _buildRecipientInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 라벨을 표시하는 텍스트
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        // 값을 표시하는 텍스트 (말줄임 표시와 줄바꿈 가능)
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.end,
            softWrap: true, // 텍스트가 한 줄을 넘길 때 자동으로 줄바꿈이 되도록 설정함
          ),
        ),
      ],
    ),
  );
}

// 상품 정보를 표시하는 행을 구성하는 함수
Widget _buildProductInfoRow(String label, String value,
    {bool bold = false, double fontSize = 16}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
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
        // 값을 표시하는 텍스트 (말줄임 표시와 줄바꿈 가능)
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.end,
            softWrap: true, // 텍스트가 한 줄을 넘길 때 자동으로 줄바꿈이 되도록 설정함
            overflow: TextOverflow.ellipsis, // 텍스트가 길 경우 말줄임 표시
          ),
        ),
      ],
    ),
  );
}

// 장바구니 담기 버튼 클릭 시 호출되는 함수
void onOrderAddToCartButtonPressed(BuildContext context, WidgetRef ref,
    Map<String, dynamic> productInfo) {
  final cartRepository = ref.read(
      cartItemRepositoryProvider); // cartItemRepositoryProvider를 사용하여 장바구니 레포지토리를 읽음

  final product = ProductContent(
    docId: productInfo['product_id'], // 제품 문서 ID를 설정함
    category: productInfo['category'], // 제품 카테고리를 설정함
    productNumber: productInfo['product_number'], // 제품 번호를 설정함
    thumbnail: productInfo['thumbnails'], // 제품 썸네일 이미지를 설정함
    briefIntroduction: productInfo['brief_introduction'], // 제품의 간단한 소개를 설정함
    originalPrice: productInfo['original_price'], // 원래 가격을 설정함
    discountPrice: productInfo['discount_price'], // 할인된 가격을 설정함
    discountPercent: productInfo['discount_percent'], // 할인 퍼센트를 설정함
    selectedCount: productInfo['selected_count'], // 선택한 수량을 설정함
    selectedColorImage: productInfo['selected_color_image'], // 선택한 색상 이미지 URL을 설정함
    selectedColorText: productInfo['selected_color_text'], // 선택한 색상 텍스트를 설정함
    selectedSize: productInfo['selected_size'], // 선택한 사이즈를 설정함
  );

  // 장바구니 레포지토리에 제품을 추가하고, 성공 시 메시지를 표시함
  cartRepository
      .addToCartItem(context, product, product.selectedColorText,
      product.selectedColorImage, product.selectedSize, product.selectedCount ?? 1)
      .then((isAdded) { // addToCartItem에서 성공 여부를 받아 처리
    if (isAdded) { // 만약 데이터가 실제로 추가되었다면 성공 메시지를 표시
      showCustomSnackBar(context, '해당 상품이 장바구니 목록에 담겼습니다.'); // 성공 메시지를 화면에 표시
    }
  }).catchError((error) {
    // 에러가 발생할 경우
    showCustomSnackBar(context, '장바구니에 상품을 담는 중 오류가 발생했습니다.'); // 오류 메시지를 화면에 표시
  });
}

// ------ 카카오 API를 가져와서 주소검색 서비스 UI 내용을 구현하는 AddressSearchWidget 클래스 내용 시작
// AddressSearchWidget 클래스는 주소 검색 기능을 제공하는 내용.
class AddressSearchWidget extends ConsumerStatefulWidget {
  @override
  _AddressSearchWidgetState createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends ConsumerState<AddressSearchWidget> {
  final TextEditingController _controller = TextEditingController(); // 주소 입력 컨트롤러
  String _query = ''; // 검색 쿼리
  bool _isFirstLoad = true; // 첫 로드 여부

  // 주소 검색 함수
  void _search() {
    setState(() {
      _query = _controller.text; // 검색 쿼리 설정
      _isFirstLoad = false; // 첫 로드 여부 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressSearchResult = ref.watch(addressSearchProvider(_query)); // Riverpod을 사용하여 주소 검색 프로바이더를 구독

    return Column(
      mainAxisSize: MainAxisSize.min, // 부모의 제약 조건을 준수하도록 설정
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0), // 텍스트 필드 주변 여백 설정
          child: TextField(
            controller: _controller, // 텍스트 필드 컨트롤러 설정
            decoration: InputDecoration(
              labelText: '주소 검색', // 텍스트 필드 라벨 텍스트
              suffixIcon: IconButton(
                icon: Icon(Icons.search), // 검색 아이콘
                onPressed: _search, // 검색 버튼을 눌렀을 때 실행되는 함수
              ),
            ),
          ),
        ),
        if (_query.isNotEmpty && !_isFirstLoad) // 빈 쿼리와 첫 로드를 처리
          Flexible( // Expanded 대신 Flexible 사용
            child: addressSearchResult.when(
              data: (addresses) => ListView.builder(
                shrinkWrap: true, // 내부 컨텐츠에 맞춰 크기 조정
                itemCount: addresses.length, // 검색 결과 개수
                itemBuilder: (context, index) {
                  final address = addresses[index]; // 주소 정보
                  final roadAddress = address['road_address']; // 도로명 주소
                  final zoneNo = roadAddress != null ? roadAddress['zone_no'] : ''; // 우편번호
                  final fullAddress = roadAddress != null ? roadAddress['address_name'] : address['address_name']; // 전체 주소
                  final displayAddress = zoneNo.isNotEmpty ? '$fullAddress [$zoneNo]' : fullAddress; // 표시할 주소
                  return ListTile(
                    title: Text(displayAddress), // 리스트 아이템의 제목 설정
                    onTap: () {
                      Navigator.pop(context, displayAddress); // 주소를 선택했을 때 이전 화면으로 반환
                    },
                  );
                },
              ),
              loading: () => Center(child: CircularProgressIndicator()), // 로딩 상태 처리
              error: (error, stack) => Center(child: Text('Error: $error')), // 에러 상태 처리
            ),
          ),
      ],
    );
  }
}
// ------- 카카오 API를 가져와서 주소검색 서비스 UI 내용을 구현하는 AddressSearchWidget 클래스 내용 끝
