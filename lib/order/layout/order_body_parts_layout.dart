import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../common/const/colors.dart';
import '../../product/model/product_model.dart';
import '../provider/order_all_providers.dart';
import '../view/complete_payment_screen.dart';
import '../view/order_postcode_search_screen.dart';

// ------- 발주 화면 내 구매자정보 관련 UI 내용을 구현하는 UserInfoWidget 클래스 내용 시작
// UserInfoWidget 클래스는 구매자의 정보를 화면에 표시하는 역할을 담당.
class UserInfoWidget extends ConsumerWidget {
  final String email; // 이메일 정보를 저장하는 필드

  UserInfoWidget({required this.email}); // 생성자에서 이메일을 받아옴

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoAsyncValue = ref.watch(userInfoProvider(email)); // Riverpod을 사용하여 사용자 정보 프로바이더를 구독

    return userInfoAsyncValue.when(
      data: (userInfo) {
        // userInfo가 null인 경우에도 표를 유지하고, 데이터 필드에 '-'를 표시
        final name = userInfo?['name'] ?? '-';
        final email = userInfo?['email'] ?? '-';
        final phoneNumber = userInfo?['phone_number'] ?? '-';

        return Padding(
          padding: const EdgeInsets.all(16.0), // 위젯의 모든 면에 16.0 픽셀의 여백 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
            mainAxisSize: MainAxisSize.min, // 부모의 제약 조건을 준수하도록 설정
            children: [
              Text(
                '발주자 정보', // 발주자 정보 제목 텍스트
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
                  _buildTableRow('이름', name), // 이름 행 생성
                  _buildTableRow('이메일', email), // 이메일 행 생성
                  _buildTableRow('휴대폰 번호', phoneNumber), // 휴대폰 번호 행 생성
                ],
              ),
              SizedBox(height: 8), // 테이블과 안내문 사이에 8 픽셀 높이의 여백 추가
              Text(
                '* 해당 정보의 변경이 필요할 시, 로그인 화면 내 회원가입 절차를 통해 변경된 내용으로 재전송 해주세요.', // 안내문 텍스트
                style: TextStyle(
                  fontSize: 12, // 텍스트 크기 12
                  color: Colors.grey, // 텍스트 색상을 회색으로 설정
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

  // 표의 행을 빌드하는 함수
  TableRow _buildTableRow(String label, String value) {
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
          child: value == '-' // 값이 '-'인 경우
              ? Center(child: Text(value)) // 가운데 정렬
              : Align(alignment: Alignment.centerLeft, child: Text(value)), // 왼쪽 정렬
        ),
      ],
    );
  }
}
// ------ 발주 화면 내 구매자정보 관련 UI 내용을 구현하는 UserInfoWidget 클래스 내용 끝

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
                      '벨은 누르지 말아주세요',
                      '무인택배함에 넣어주세요',
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

              // 발주 완료 화면으로 이동, 현재 화면을 대체함
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletePaymentScreen(orderId: orderId), // 발주 ID를 전달
                ),
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

// ------- 상품 상세 화면과 장바구니 화면에서 상품 데이터를 발주 화면으로 전달되는 부분을 UI로 구현한 OrderItemWidget 클래스 내용 시작
// OrderItemWidget 클래스는 상품의 상세 정보를 화면에 표시하는 역할을 담당.
class OrderItemWidget extends StatelessWidget {
  final ProductContent product; // 상품 정보를 저장하는 필드

  OrderItemWidget({required this.product}); // 생성자에서 상품 정보를 받아옴

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('###,###'); // 숫자를 포맷하기 위한 NumberFormat 객체 생성
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0), // 카드 내부 여백 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
          children: [
            if (product.briefIntroduction != null) // briefIntroduction가 null이 아닌 경우에만 표시
              Text(
                product.briefIntroduction!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 글자 크기 18, 굵게 설정
              ),
            if (product.productNumber != null) // productNumber가 null이 아닌 경우에만 표시
              Text(
                '상품번호: ${product.productNumber}', // productNumber 내용을 표시
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // 글자 크기를 14로 설정
              ),
            SizedBox(height: 8), // 텍스트와 이미지 사이에 8 픽셀 높이의 여백 추가
            Row(
              children: [
                if (product.thumbnail != null) // thumbnail이 null이 아닌 경우에만 표시
                  Image.network(
                    product.thumbnail!,
                    height: 100, // 이미지 높이 100 픽셀
                    width: 100, // 이미지 너비 100 픽셀
                    fit: BoxFit.cover, // 이미지를 잘라서 맞춤
                  ),
                SizedBox(width: 8), // 이미지와 텍스트 사이에 8 픽셀 너비의 여백 추가
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
                  children: [
                    Text(
                      '${numberFormat.format(product.originalPrice)}원',
                      style: TextStyle(
                        fontSize: 14, // 글자 크기 14
                        color: Colors.grey[500], // 글자 색상 회색
                        decoration: TextDecoration.lineThrough, // 취소선 스타일 적용
                      ),
                    ),
                    Text(
                      '${numberFormat.format(product.discountPrice)}원',
                      style: TextStyle(
                        fontSize: 18, // 글자 크기 18
                        fontWeight: FontWeight.bold, // 글자 굵게 설정
                      ),
                    ),
                    Text(
                      '${product.discountPercent?.round()}%',
                      style: TextStyle(
                        fontSize: 18, // 글자 크기 18
                        color: Colors.red, // 글자 색상 빨간색
                        fontWeight: FontWeight.bold, // 글자 굵게 설정
                      ),
                    ),
                    Text('수량: ${product.selectedCount}'), // 수량 표시
                    if (product.selectedColorImage != null) // selectedColorImage가 null이 아닌 경우에만 표시
                      Image.network(
                        product.selectedColorImage!,
                        height: 20, // 이미지 높이 20 픽셀
                        width: 20, // 이미지 너비 20 픽셀
                        fit: BoxFit.cover, // 이미지를 잘라서 맞춤
                      ),
                    Text('색상: ${product.selectedColorText}'), // 색상 텍스트 표시
                    Text('사이즈: ${product.selectedSize}'), // 사이즈 텍스트 표시
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// 상품 상세 화면과 장바구니 화면에서 상품 데이터를 발주 화면으로 전달되는 부분을 UI로 구현한 OrderItemWidget 클래스 내용 끝

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
