import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemOptionItemModel{
  final String id;
  final String name;
  final String image;
  final int price;

  const MenuItemOptionItemModel({
    required this.id,
    required this.price,
    required this.image,
    required this.name
  });

  factory MenuItemOptionItemModel.fromDocument(DocumentSnapshot doc) {
    return MenuItemOptionItemModel(
        image: doc.get('image'),
        price: doc.get('price'),
        id: doc.get('id'),
        name: doc.get('name')
    );
  }

}