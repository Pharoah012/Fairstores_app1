import 'package:cloud_firestore/cloud_firestore.dart';

class SideMenuCategoryOptionModel {
  final String? id;
  final String? name;

  const SideMenuCategoryOptionModel({
    this.id,
    this.name
  });

  factory SideMenuCategoryOptionModel.fromDocument(DocumentSnapshot doc) {
    return SideMenuCategoryOptionModel(
      id: doc.get('id'),
      name: doc.get('name')
    );
  }
}