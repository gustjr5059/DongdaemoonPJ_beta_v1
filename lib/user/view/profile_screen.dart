import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // FirebaseAuth 인스턴스를 사용하여 로그아웃 처리
          await FirebaseAuth.instance.signOut();
          // 로그아웃 후 로그인 화면으로 이동하거나 다른 처리 수행
        },
        child: Text('로그아웃'),
      ),
    );
  }
}
