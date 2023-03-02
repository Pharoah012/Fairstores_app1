import 'package:cloud_firestore/cloud_firestore.dart';

class OptionModel {
  final String id;
  final String name;
  final int price;
  final String description;
  final bool hassides;
  final String school;
  final String shopid;
  final String categoryid;
  final String tileimage;
  final String userid;
  final String ordername;

  // ignore: use_key_in_widget_constructors
  OptionModel({
    required this.hassides,
    required this.description,
    required this.shopid,
    required this.school,
    required this.ordername,
    required this.tileimage,
    required this.categoryid,
    required this.userid,
    required this.id,
    required this.price,
    required this.name
  });

  factory OptionModel.fromDocument(DocumentSnapshot doc, school, shopid,
      categoryid, userid, ordername) {
    return OptionModel(
        school: school,
        categoryid: categoryid,
        userid: userid,
        shopid: shopid,
        ordername: ordername,
        hassides: doc.get('hassides'),
        tileimage: doc.get('image'),
        description: doc.get('description'),
        price: doc.get('price'),
        id: doc.get('id'),
        name: doc.get('name'));
  }
}