import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/const/colors.dart';
import '../../common/layout/common_body_parts_layout.dart';
import '../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../home/view/main_home_screen.dart';
import '../provider/sns_login_all_provider.dart';
import '../repository/sns_login_repository.dart';

// ------ 회원가입 화면 클래스 시작 ------
class SignUpScreen extends ConsumerStatefulWidget {
  final String appleId; // 애플 계정에서 불러온 애플 ID

  const SignUpScreen({required this.appleId, Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _appleIdController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isAgreedToAll = false;
  bool isAgreedToTerms = false;
  bool isAgreedToPrivacy = false;
  bool isOverAge = false;
  bool isLoading = false;

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();

  late ScrollController signUpScreenPointScrollController; // 스크롤 컨트롤러 선언

  NetworkChecker? _networkChecker; // NetworkChecker 인스턴스 저장

  // ------ 앱 실행 생명주기 관리 관련 함수 시작
  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void initState() {
    super.initState();
    // ScrollController를 초기화
    signUpScreenPointScrollController = ScrollController();

    _appleIdController = TextEditingController(text: widget.appleId);

    // WidgetsBindingObserver를 추가하여 앱의 생명주기 변화 감지
    WidgetsBinding.instance.addObserver(this); // 생명주기 옵저버 등록

    // 상태표시줄 색상을 안드로이드와 ios 버전에 맞춰서 변경하는데 사용되는 함수-앱 실행 생명주기에 맞춰서 변경
    updateStatusBar();

    // 네트워크 상태 체크 시작
    _networkChecker = NetworkChecker(context);
    _networkChecker?.checkNetworkStatus();
  }

  // ------ 페이지 초기 설정 기능인 initState() 함수 관련 구현 내용 끝 (앱 실행 생명주기 관련 함수)

  // didChangeAppLifecycleState 함수 관련 구현 내용 시작
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      updateStatusBar();
    }
  }

  // didChangeAppLifecycleState 함수 관련 구현 내용 끝

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 시작 (앱 실행 생명주기 관련 함수)
  @override
  void dispose() {
    // WidgetsBinding 인스턴스에서 이 객체를 옵저버 목록에서 제거함.
    // 앱 생명주기 이벤트를 더 이상 수신하지 않겠다는 의도임.
    WidgetsBinding.instance.removeObserver(this);

    _appleIdController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();

    signUpScreenPointScrollController.dispose(); // ScrollController 해제

    // 네트워크 체크 해제
    _networkChecker?.dispose();

    super.dispose();
  }

  // ------ 기능 실행 중인 위젯 및 함수 종료하는 제거 관련 함수 구현 내용 끝 (앱 실행 생명주기 관련 함수)
  // ------ 앱 실행 생명주기 관리 관련 함수 끝

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // AppBar 관련 수치 동적 적용
    final double signUpAppBarTitleWidth =
        screenSize.width * (240 / referenceWidth);
    final double signUpAppBarTitleHeight =
        screenSize.height * (22 / referenceHeight);
    final double signUpAppBarTitleX = screenSize.width * (5 / referenceHeight);
    final double signUpAppBarTitleY =
        screenSize.height * (11 / referenceHeight);

    // 이전화면으로 이동 아이콘 관련 수치 동적 적용
    final double signUpChevronIconWidth =
        screenSize.width * (24 / referenceWidth);
    final double signUpChevronIconHeight =
        screenSize.height * (24 / referenceHeight);
    final double signUpChevronIconX = screenSize.width * (10 / referenceWidth);
    final double signUpChevronIconY = screenSize.height * (9 / referenceHeight);

    final double interval1X = screenSize.width * (10 / referenceWidth);
    final double interval1Y = screenSize.height * (5 / referenceHeight);
    final double interval2Y = screenSize.height * (10 / referenceHeight);
    final double interval3Y = screenSize.height * (20 / referenceHeight);
    final double interval4Y = screenSize.height * (40 / referenceHeight);

    final double allAgreeCheckBoxTextFontSize =
        screenSize.height * (20 / referenceHeight);

    final double signUpBtnHeight = screenSize.height * (50 / referenceHeight);
    final double signUpBtnWidth = screenSize.width * (130 / referenceWidth);
    final double signUpBtnFontSize = screenSize.height * (16 / referenceHeight);

    return GestureDetector(
      onTap: () {
        // 입력 필드 외부를 클릭하면 모든 입력 필드의 포커스를 해제
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              controller: signUpScreenPointScrollController,
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  floating: true,
                  pinned: true,
                  expandedHeight: 0.0,
                  // 확장 높이 설정
                  // FlexibleSpaceBar를 사용하여 AppBar 부분의 확장 및 축소 효과 제공함.
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    // 앱 바 부분을 고정시키는 옵션->앱 바가 스크롤에 의해 사라지고, 그 자리에 상단 탭 바가 있는 bottom이 상단에 고정되도록 하는 기능
                    background: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: BLACK_COLOR, width: 1.0), // 하단 테두리 추가
                        ),
                      ),
                      child: buildCommonAppBar(
                        context: context,
                        ref: ref,
                        title: '회원가입',
                        fontFamily: 'NanumGothic',
                        leadingType: LeadingType.none,
                        buttonCase: 1,
                        appBarTitleWidth: signUpAppBarTitleWidth,
                        appBarTitleHeight: signUpAppBarTitleHeight,
                        appBarTitleX: signUpAppBarTitleX,
                        appBarTitleY: signUpAppBarTitleY,
                        chevronIconWidth: signUpChevronIconWidth,
                        chevronIconHeight: signUpChevronIconHeight,
                        chevronIconX: signUpChevronIconX,
                        chevronIconY: signUpChevronIconY,
                      ),
                    ),
                  ),
                  leading: null,
                  // backgroundColor: BUTTON_COLOR,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: interval1X), // 좌우 패딩 추가
                  child: Column(
                    children: [
                      SizedBox(height: interval2Y),
                      _buildFixedValueRow(
                          context, '애플 ID', _appleIdController.text),
                      SizedBox(height: interval1Y),
                      _buildEditableRow(context, '이름', _nameController,
                          _nameFocusNode, "'성'을 붙여서 이름을 기입해주세요."),
                      SizedBox(height: interval1Y),
                      _buildEditableRow(context, '이메일', _emailController,
                          _emailFocusNode, "이메일을 입력하세요."),
                      SizedBox(height: interval1Y),
                      _buildEditableRow(context, '휴대폰 번호', _phoneController,
                          _phoneNumberFocusNode, "'-'를 붙여서 연락처를 기입해주세요."),
                      SizedBox(height: interval3Y),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1.3, // 체크박스 크기 설정
                            child: Checkbox(
                              value: isAgreedToAll,
                              onChanged: (value) {
                                setState(() {
                                  isAgreedToAll = value ?? false;
                                  isAgreedToTerms = isAgreedToAll;
                                  isAgreedToPrivacy = isAgreedToAll;
                                  isOverAge = isAgreedToAll;
                                });
                              },
                              activeColor: ORANGE56_COLOR, // 활성화된 체크박스 색상 설정
                            ),
                          ),
                          Text(
                            '모든 항목 선택',
                            style: TextStyle(
                              fontSize: allAgreeCheckBoxTextFontSize,
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.bold,
                              color: BLACK_COLOR,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: interval2Y),
                      _buildAgreementRow('이용약관 동의 (필수)', isAgreedToTerms,
                          (value) {
                        setState(() {
                          isAgreedToTerms = value ?? false;
                          _updateAllAgreement();
                        });
                      }),
                      _buildAgreementRow(
                          '개인정보 수집 이용 동의 (필수)', isAgreedToPrivacy, (value) {
                        setState(() {
                          isAgreedToPrivacy = value ?? false;
                          _updateAllAgreement();
                        });
                      }),
                      _buildAgreementRow('본인은 14세 이상입니다. (필수)', isOverAge,
                          (value) {
                        setState(() {
                          isOverAge = value ?? false;
                          _updateAllAgreement();
                        });
                      }),
                      SizedBox(height: interval3Y),
                      Center(
                        child: Container(
                          width: signUpBtnWidth,
                          height: signUpBtnHeight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _isSignUpEnabled()
                                  ? ORANGE56_COLOR
                                  : GRAY62_COLOR,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              side: BorderSide(
                                color: _isSignUpEnabled()
                                    ? ORANGE56_COLOR
                                    : GRAY62_COLOR,
                              ),
                            ),
                            onPressed: _isSignUpEnabled()
                                ? () => _signUp(authRepository)
                                : null,
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    '결제하기',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: signUpBtnFontSize,
                                      color: _isSignUpEnabled()
                                          ? ORANGE56_COLOR
                                          : GRAY40_COLOR,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Firestore에 회원 정보 저장
  Future<void> _signUp(AuthRepository authRepository) async {
    setState(() {
      isLoading = true;
    });
    try {
      await authRepository.signUpUser(
        appleId: _appleIdController.text,
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입이 완료되었습니다!')),
      );

      // 회원가입 후 홈 화면 이동
      Future.microtask(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainHomeScreen()),
          (route) => false,
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 중 문제가 발생했습니다: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildAgreementRow(
      String text, bool value, ValueChanged<bool?> onChanged) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    final double agreeCheckBoxTextFontSize =
        screenSize.height * (14 / referenceHeight);

    // '본인은 14세 이상입니다. (필수)' 항목인지 확인
    bool isOverAgeRow = text == '본인은 14세 이상입니다. (필수)';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: 1.0, // 체크박스 크기 확대
              child: Checkbox(
                value: value,
                activeColor: ORANGE56_COLOR, // 활성화된 색상
                onChanged: onChanged,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: agreeCheckBoxTextFontSize,
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.normal,
                color: BLACK_COLOR,
              ),
            ),
          ],
        ),
        // '본인은 14세 이상입니다. (필수)'가 아니면 '보기' 버튼 표시
        if (!isOverAgeRow)
          GestureDetector(
            onTap: () {
              _showAgreementDetail(text);
            },
            child: Text(
              '보기',
              style: TextStyle(
                color: GRAY83_COLOR,
                decoration: TextDecoration.underline,
                decorationColor: GRAY83_COLOR,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showAgreementDetail(String agreementTitle) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(agreementTitle),
          content: Text('$agreementTitle의 세부 내용이 여기에 표시됩니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('닫기'),
            )
          ],
        );
      },
    );
  }

  bool _isSignUpEnabled() {
    return isAgreedToTerms &&
        isAgreedToPrivacy &&
        isOverAge &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
  }

  void _updateAllAgreement() {
    setState(() {
      isAgreedToAll = isAgreedToTerms && isAgreedToPrivacy && isOverAge;
    });
  }

  // 수정 가능한 행을 생성하는 함수
  Widget _buildEditableRow(BuildContext context, String label,
      TextEditingController controller, FocusNode focusNode, String hintText) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 회원가입 정보 표 부분 수치
    final double signUpInfoTextFontSize =
        screenSize.height * (13 / referenceHeight);
    final double signUpInfoDataFontSize =
        screenSize.height * (12 / referenceHeight);
    final double signUpInfoTextPartWidth =
        screenSize.width * (97 / referenceWidth);
    final double signUpInfoTextPartHeight =
        screenSize.height * (40 / referenceHeight);
    // 행 간 간격 수치
    final double signUpInfo4Y = screenSize.height * (2 / referenceHeight);
    final double signUpInfo1X = screenSize.width * (4 / referenceWidth);
    // 데이터 부분 패딩 수치
    final double signUpInfoDataPartX = screenSize.width * (8 / referenceWidth);

    // FocusNode의 상태 변화 감지 리스너 추가
    return StatefulBuilder(
      builder: (context, setState) {
        // FocusNode의 상태 변화 감지 리스너
        focusNode.addListener(() {
          // FocusNode 상태 변경 시 UI 업데이트
          setState(() {});
        });

        return Padding(
          padding: EdgeInsets.symmetric(vertical: signUpInfo4Y),
          // 행의 상하단에 2.0 픽셀의 여백 추가
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
              children: [
                Container(
                  width: signUpInfoTextPartWidth,
                  // 셀의 너비 설정
                  height: signUpInfoTextPartHeight,
                  // 셀의 높이 설정
                  // 라벨 셀의 너비 설정
                  decoration: BoxDecoration(
                    // color: GRAY96_COLOR,
                    color:
                        Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                    border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  // 텍스트를 중앙 정렬
                  child: Text(
                    label, // 셀에 표시될 텍스트
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NanumGothic',
                      fontSize: signUpInfoTextFontSize,
                      color: BLACK_COLOR,
                    ),
                  ),
                ),
                SizedBox(width: signUpInfo1X), // 왼쪽과 오른쪽 사이 간격 추가
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                      border: Border.all(
                        color: focusNode.hasFocus
                            ? ORANGE56_COLOR
                            : GRAY83_COLOR, // 포커스 여부에 따른 색상 변경
                        width: 1.0,
                      ), // 윤곽선
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: signUpInfoDataPartX),
                    alignment: Alignment.centerLeft, // 텍스트 정렬
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(focusNode); // 행을 탭할 때 포커스를 설정
                      },
                      child: TextField(
                        controller: controller,
                        // 텍스트 필드 컨트롤러 설정
                        focusNode: focusNode,
                        // 텍스트 필드 포커스 노드 설정
                        cursorColor: ORANGE56_COLOR,
                        // 커서 색상 설정
                        style: TextStyle(
                          fontFamily: 'NanumGothic',
                          fontSize: signUpInfoDataFontSize,
                          color: BLACK_COLOR,
                          fontWeight: FontWeight.normal,
                        ),
                        // 텍스트 필드 스타일 설정
                        decoration: InputDecoration(
                          hintText: hintText,
                          // 힌트 텍스트 설정
                          hintStyle: TextStyle(color: GRAY74_COLOR),
                          // 힌트 텍스트 색상 설정
                          hintMaxLines: 2,
                          // 힌트 텍스트 최대 줄 수 설정
                          border: InputBorder.none,
                          // 입력 경계선 제거
                          isDense: true,
                          // 간격 설정
                          contentPadding: EdgeInsets.zero, // 내용 여백 제거
                        ),
                        maxLines: null,
                        // 최대 줄 수 설정
                        onChanged: (value) {
                          print('텍스트 필드 $label 변경됨: $value'); // 디버깅 메시지 추가
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 고정된 값을 가진 행을 생성하는 함수
  Widget _buildFixedValueRow(BuildContext context, String label, String value) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 회원가입 정보 표 부분 수치
    final double signUpInfoTextFontSize =
        screenSize.height * (13 / referenceHeight);
    final double signUpInfoDataFontSize =
        screenSize.height * (8 / referenceHeight);
    final double signUpInfoTextPartWidth =
        screenSize.width * (97 / referenceWidth);
    final double signUpInfoTextPartHeight =
        screenSize.height * (40 / referenceHeight);

    // 행 간 간격 수치
    final double signUpInfo4Y = screenSize.height * (2 / referenceHeight);
    final double signUpInfo1X = screenSize.width * (4 / referenceWidth);

    // 데이터 부분 패딩 수치
    final double signUpInfoDataPartX = screenSize.width * (8 / referenceWidth);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: signUpInfo4Y),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 자식 위젯들을 위아래로 늘림
          children: [
            Container(
              height: signUpInfoTextPartHeight,
              width: signUpInfoTextPartWidth,
              // 라벨 셀의 너비 설정
              decoration: BoxDecoration(
                // color: GRAY96_COLOR,
                color: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
                borderRadius:
                    // BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)), // 왼쪽만 둥글게
                    BorderRadius.circular(6),
              ),
              // 배경 색상 설정
              alignment: Alignment.center,
              // 텍스트 정렬
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'NanumGothic',
                  fontSize: signUpInfoTextFontSize,
                  color: BLACK_COLOR,
                ), // 텍스트 스타일 설정
              ),
            ),
            SizedBox(width: signUpInfo1X), // 왼쪽과 오른쪽 사이 간격 추가
            Expanded(
              child: Container(
                // 데이터 셀의 너비 설정
                decoration: BoxDecoration(
                  // color: GRAY98_COLOR, // 앱 기본 배경색
                  color: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
                  border: Border.all(color: GRAY83_COLOR, width: 1), // 윤곽선
                  // borderRadius: BorderRadius.only(
                  //   topRight: Radius.circular(6),
                  //   bottomRight: Radius.circular(6),
                  // ), // 오른쪽만 둥글게
                  borderRadius: BorderRadius.circular(6),
                ),
                // color: Colors.red, // 배경 색상 설정
                padding: EdgeInsets.symmetric(horizontal: signUpInfoDataPartX),
                alignment: Alignment.centerLeft, // 텍스트 정렬
                child: Text(
                  value ?? '',
                  style: TextStyle(
                    fontFamily: 'NanumGothic',
                    fontSize: signUpInfoDataFontSize,
                    color: BLACK_COLOR,
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
// ------ 회원가입 화면 클래스 끝 ------
