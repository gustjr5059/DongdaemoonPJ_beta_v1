
// Cloud Firestore는 Firebase의 NoSQL 클라우드 데이터베이스로, 데이터를 저장하고 동기화하는 데 사용됩니다.
// 이 데이터베이스는 실시간 데이터 동기화를 지원하여 앱의 모든 사용자에게 즉각적인 업데이트를 제공합니다.
// Firestore 패키지를 임포트하여 Flutter 앱에서 Firestore 서비스를 사용할 수 있게 합니다.
import 'package:cloud_firestore/cloud_firestore.dart';
// Riverpod는 Flutter에서 사용할 수 있는 외부 상태 관리 라이브러리입니다.
// 이 라이브러리는 상태를 보다 선언적으로 관리할 수 있게 해주며, 앱의 다양한 부분에서 상태를 쉽게 공유하고 접근할 수 있도록 도와줍니다.
// Riverpod를 임포트하여 애플리케이션의 상태 관리를 간편하고 효과적으로 할 수 있습니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Firestore에서 banners 컬렉션의 이미지 URL을 불러오는 FutureProvider
final largeBannerImagesProvider = FutureProvider<List<String>>((ref) async {
  // 'item' 컬렉션에서 'banners' 문서를 찾아 데이터를 가져옴.
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('item').doc('banners').get();
  // 가져온 snapshot이 실제로 존재하는지 확인함.
  if (snapshot.exists) {
    // snapshot에서 데이터를 Map 형태로 추출함.
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // 'dongdaemoon1', 'dongdaemoon2', 'dongdaemoon3' 키를 가진 값을 리스트로 추출함.
    // whereType<String>()을 사용하여 null이 아닌 String 타입의 데이터만을 필터링하고, toList()로 리스트를 생성함.
    return [data['dongdaemoon1'], data['dongdaemoon2'], data['dongdaemoon3']].whereType<String>().toList();
  }
  // 만약 snapshot이 존재하지 않거나, 데이터를 제대로 불러오지 못했다면 빈 리스트를 반환함.
  return [];
});

// Firestore에서 banners 컬렉션의 이미지 URL을 불러오는 FutureProvider
final small1BannerImagesProvider = FutureProvider<List<String>>((ref) async {
  // 'item' 컬렉션에서 'banners' 문서를 찾아 데이터를 가져옴.
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('item').doc('banners').get();
  // 가져온 snapshot이 실제로 존재하는지 확인함.
  if (snapshot.exists) {
    // snapshot에서 데이터를 Map 형태로 추출함.
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // 'ad_image1', 'ad_image2', 'ad_image3' 키를 가진 값을 리스트로 추출함.
    // whereType<String>()을 사용하여 null이 아닌 String 타입의 데이터만을 필터링하고, toList()로 리스트를 생성함.
    return [data['ad_image1'], data['ad_image2'], data['ad_image3']].whereType<String>().toList();
  }
  // 만약 snapshot이 존재하지 않거나, 데이터를 제대로 불러오지 못했다면 빈 리스트를 반환함.
  return [];
});

// Firestore에서 banners 컬렉션의 이미지 URL을 불러오는 FutureProvider
final small2BannerImagesProvider = FutureProvider<List<String>>((ref) async {
  // 'item' 컬렉션에서 'banners' 문서를 찾아 데이터를 가져옴.
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('item').doc('banners').get();
  // 가져온 snapshot이 실제로 존재하는지 확인함.
  if (snapshot.exists) {
    // snapshot에서 데이터를 Map 형태로 추출함.
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // 'ad_image4', 'ad_image5', 'ad_image6' 키를 가진 값을 리스트로 추출함.
    // whereType<String>()을 사용하여 null이 아닌 String 타입의 데이터만을 필터링하고, toList()로 리스트를 생성함.
    return [data['ad_image4'], data['ad_image5'], data['ad_image6']].whereType<String>().toList();
  }
  // 만약 snapshot이 존재하지 않거나, 데이터를 제대로 불러오지 못했다면 빈 리스트를 반환함.
  return [];
});

// Firestore에서 banners 컬렉션의 이미지 URL을 불러오는 FutureProvider
final small3BannerImagesProvider = FutureProvider<List<String>>((ref) async {
  // 'item' 컬렉션에서 'banners' 문서를 찾아 데이터를 가져옴.
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('item').doc('banners').get();
  // 가져온 snapshot이 실제로 존재하는지 확인함.
  if (snapshot.exists) {
    // snapshot에서 데이터를 Map 형태로 추출함.
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    // 'ad_image7', 'ad_image8', 'ad_image9' 키를 가진 값을 리스트로 추출함.
    // whereType<String>()을 사용하여 null이 아닌 String 타입의 데이터만을 필터링하고, toList()로 리스트를 생성함.
    return [data['ad_image7'], data['ad_image8'], data['ad_image9']].whereType<String>().toList();
  }
  // 만약 snapshot이 존재하지 않거나, 데이터를 제대로 불러오지 못했다면 빈 리스트를 반환함.
  return [];
});