import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/announce_repository.dart';

// AnnouncementRepository 클래스를 제공하기 위한 Provider 정의
final announcementRepositoryProvider = Provider((ref) => AnnouncementRepository());

// 공지사항 목록을 가져오기 위한 FutureProvider 정의
final announcementsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(announcementRepositoryProvider); // announcementRepositoryProvider를 통해 Repository 인스턴스를 참조함
  return repository.fetchAnnouncements(); // 공지사항 목록을 가져오는 비동기 함수 호출
});

// 특정 공지사항의 세부 정보를 가져오기 위한 FutureProvider.family 정의
final announcementDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, documentId) async {
  final repository = ref.watch(announcementRepositoryProvider); // announcementRepositoryProvider를 통해 Repository 인스턴스를 참조함
  return repository.fetchAnnouncementById(documentId); // documentId를 기반으로 특정 공지사항의 세부 정보를 가져오는 비동기 함수 호출
});