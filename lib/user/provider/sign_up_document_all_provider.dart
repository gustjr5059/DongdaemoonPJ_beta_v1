
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/sign_up_document_repository.dart';


// SignUpDocumentRepository 클래스를 제공하기 위한 Provider 정의
final signUpDocumentItemRepositoryProvider = Provider((ref) => SignUpDocumentRepository(
  firestore: FirebaseFirestore.instance, // Firebase Firestore 인스턴스를 전달
));