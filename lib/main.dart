import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Firebase 초기화 코드(Firebase와 Flutter 프로젝트가 통합되어 Firebase 서비스를 사용가능)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Flutter 3.16.0 버전부터 기본 테마가 Material3로 변경
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: LoginPage(),
    );
  }


}

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth 객체 초기화
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("로그인")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 현재 유저 로그인 상태
            Center(
              child: Text(
                "로그인해 주세요 🙂",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 32),

            /// 이메일
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: "이메일"),
            ),

            /// 비밀번호
            TextField(
              controller: passwordController,
              obscureText: false, // 비밀번호 안보이게
              decoration: InputDecoration(hintText: "비밀번호"),
            ),
            SizedBox(height: 32),

            /// 로그인 버튼
            ElevatedButton(
              child: Text("로그인", style: TextStyle(fontSize: 21)),
              onPressed: () async {
                try {
                  // 이메일과 비밀번호로 로그인 시도
                  await _auth.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  // 로그인 성공 시 HomePage로 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                  );
                } on FirebaseAuthException catch (e) {
                  // 로그인 실패 시 오류 메시지 처리
                  // 예를 들어, Toast 메시지로 오류 표시
                }
              },
            ),

            /// 회원가입 버튼
            ElevatedButton(
              child: Text("회원가입", style: TextStyle(fontSize: 21)),
              onPressed: () async {
                try {
                  // 이메일과 비밀번호를 사용하여 회원가입 시도
                  await _auth.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  // 회원가입 성공 시, 예를 들어 로그인 화면으로 이동 또는 성공 메시지 표시
                } on FirebaseAuthException catch (e) {
                  // 회원가입 실패 시 오류 메시지 처리
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 홈페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("버킷 리스트"),
        actions: [
          TextButton(
            child: Text(
              "로그아웃",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              // FirebaseAuth 인스턴스를 사용하여 로그아웃 처리
              await FirebaseAuth.instance.signOut();
              // 로그아웃 후 로그인 페이지로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /// 입력창
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                /// 텍스트 입력창
                Expanded(
                  child: TextField(
                    controller: jobController,
                    decoration: InputDecoration(
                      hintText: "하고 싶은 일을 입력해주세요.",
                    ),
                  ),
                ),

                /// 추가 버튼
                ElevatedButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    // create bucket
                    if (jobController.text.isNotEmpty) {
                      print("create bucket");
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1),

          /// 버킷 리스트
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                String job = "$index";
                bool isDone = false;
                return ListTile(
                  title: Text(
                    job,
                    style: TextStyle(
                      fontSize: 24,
                      color: isDone ? Colors.grey : Colors.black,
                      decoration: isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  // 삭제 아이콘 버튼
                  trailing: IconButton(
                    icon: Icon(CupertinoIcons.delete),
                    onPressed: () {
                      // 삭제 버튼 클릭시
                    },
                  ),
                  onTap: () {
                    // 아이템 클릭하여 isDone 업데이트
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}