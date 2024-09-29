import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/announce_repository.dart';

// AnnouncementRepository 클래스를 제공하기 위한 Provider 정의
final announceItemRepositoryProvider = Provider((ref) => AnnouncementRepository(
  firestore: FirebaseFirestore.instance, // Firebase Firestore 인스턴스를 전달
));