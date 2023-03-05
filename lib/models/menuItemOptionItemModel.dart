import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemOptionItemModel{
  final String id;
  final String name;
  final String image;
  final double price;

  const MenuItemOptionItemModel({
    required this.id,
    required this.price,
    required this.image,
    required this.name
  });

  factory MenuItemOptionItemModel.fromDocument(DocumentSnapshot doc) {
    return MenuItemOptionItemModel(
        image: doc.get('image'),
        price: double.parse(doc.get('price').toString()),
        id: doc.get('id'),
        name: doc.get('name')
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "image": this.image,
      "price": this.price,
    };
  }
}