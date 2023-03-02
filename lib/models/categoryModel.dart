import 'package:cloud_firestore/cloud_firestore.dart';

final categoryRef = FirebaseFirestore.instance.collection('Categories');

class CategoryModel{
  final String name;
  final String id;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromDocument(DocumentSnapshot doc) {
    return CategoryModel(name: doc.get('name'), id: doc.get('id'));
  }

  static Future<List<CategoryModel>> getCategories({
    required String school
  }) async {
    QuerySnapshot snapshot = await categoryRef
      .doc('FairFood')
      .collection('categories')
      .doc(school)
      .collection('shop_categories')
      .get();

    List<CategoryModel> categoryList = snapshot.docs
        .map((doc) =>
        CategoryModel.fromDocument(doc))
        .toList();

    return categoryList;

  }
}