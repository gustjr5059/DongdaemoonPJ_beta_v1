
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/layout/common_exception_parts_of_body_layout.dart';
import '../../layout/product_body_parts_layout.dart';
import '../../provider/product_future_provider.dart';

class SkirtDetailProductScreen extends ConsumerWidget {
  final String fullPath;
  const SkirtDetailProductScreen({Key? key, required this.fullPath}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productContent = ref.watch(skirtProdDetailFirestoreDataProvider(fullPath));
    // Firestore 데이터 제공자를 통해 특정 문서 ID(docId)의 상품 데이터를 구독.
    return Scaffold(
      // Scaffold를 사용하여 기본적인 머티리얼 디자인 레이아웃을 제공.
      appBar: buildCommonAppBar(
          context: context, title: '스커트 상세', pageBackButton: true),
      // 앱바를 구성하며, '스커트 상세'라는 제목과 페이지 뒤로 가기 버튼을 포함.
      body: productContent.when(
        data: (product) {
          return buildProductDetails(context, ref, product);
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('오류 발생: $error')),
      ),
    );
  }
}
