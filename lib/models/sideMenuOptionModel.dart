import 'package:cloud_firestore/cloud_firestore.dart';

class SideMenuOptionModel {
  final String? id;
  final String? name;

  const SideMenuOptionModel({
    this.id,
    this.name
  });

  factory SideMenuOptionModel.fromDocument(DocumentSnapshot doc) {
    return SideMenuOptionModel(
      id: doc.get('id'),
      name: doc.get('name')
    );
  }
}