
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/product_model.dart';

class ProductsRepository {
  final FirebaseFirestore firestore;

  ProductsRepository(this.firestore);

  Future<ProductContent> fetchProductDetails(String docId) async {
    DocumentSnapshot doc = await firestore.collection('item').doc(docId).get();
    return ProductContent.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}
