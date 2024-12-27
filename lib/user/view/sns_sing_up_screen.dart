
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/view/main_home_screen.dart';
import '../provider/sns_login_all_provider.dart';
import '../repository/sns_login_repository.dart';


// ------ 회원가입 화면 클래스 시작 ------
class SignUpScreen extends ConsumerStatefulWidget {
  final String email;
  final String fullName;

  const SignUpScreen({required this.email, required this.fullName, Key? key})
      : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _nameController;
  final TextEditingController _phoneController = TextEditingController();
  bool isAgreed = false;
  bool isLoading = false; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _nameController = TextEditingController(text: widget.fullName);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = ref.watch(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 이름 입력 필드
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            // 이메일 입력 필드
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            // 휴대폰 번호 입력 필드
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: '휴대폰 번호'),
            ),
            // 약관 동의 체크박스
            Row(
              children: [
                Checkbox(
                  value: isAgreed,
                  onChanged: (value) {
                    setState(() {
                      isAgreed = value ?? false;
                    });
                  },
                ),
                Text('약관에 동의합니다.'),
              ],
            ),
            // 회원가입 버튼
            ElevatedButton(
              onPressed: isAgreed &&
                  _nameController.text.isNotEmpty &&
                  _emailController.text.isNotEmpty &&
                  _phoneController.text.isNotEmpty
                  ? () => _signUp(authRepository) // <-- 람다로 감싸기
                // (VoidCallback? 유형과 일치하게 되어 오류가 해결)
                  : null,
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('가입하기'),
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
        _nameController.text,
        _emailController.text,
        _phoneController.text,
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
}
// ------ 회원가입 화면 클래스 끝 ------

