import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:actual/user/provider/user_me_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<void> signOut() async {
      try {
        await _auth.signOut();
        // Handle successful logout here
        // For example, navigate back to the login screen
      } catch (e) {
        // Handle logout error here
        // For example, show an error message
      }
    }

    return Center(
      child: ElevatedButton(
        onPressed: () {
          signOut();
        },
        child: const Text('로그아웃'),
      ),
    );
  }
}
