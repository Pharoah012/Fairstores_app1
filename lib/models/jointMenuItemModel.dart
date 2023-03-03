import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/models/sideMenuOptionModel.dart';

final menuRef = FirebaseFirestore.instance.collection('FoodMenu');

class JointMenuItemModel {
  final String id;
  final String name;
  final int price;
  final String description;
  final bool hassides;
  final String tileimage;

  // ignore: use_key_in_widget_constructors
  JointMenuItemModel({
    required this.hassides,
    required this.description,
    required this.tileimage,
    required this.id,
    required this.price,
    required this.name
  });

  factory JointMenuItemModel.fromDocument(DocumentSnapshot doc) {
    return JointMenuItemModel(
        hassides: doc.get('hassides'),
        tileimage: doc.get('image'),
        description: doc.get('description'),
        price: doc.get('price'),
        id: doc.get('id'),
        name: doc.get('name'));
  }

  // Get the side options of a menu item
  Future<List<SideMenuOptionModel>> getSideMenuOptions({
    required String jointID,
    required String categoryID
  }) async {

    QuerySnapshot snapshot = await menuRef
      .doc(jointID)
      .collection('categories')
      .doc(categoryID)
      .collection('options')
      .doc(this.id)
      .collection('sideoptions')
      // .doc("01")
      .get();

    List<SideMenuOptionModel> sides = snapshot.docs
      .map(
          (doc) => SideMenuOptionModel.fromDocument(doc)).toList();

    return sides;
  }
}