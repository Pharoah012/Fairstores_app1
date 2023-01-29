import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolModel {
  final String schoolname;
  final bool buyandsellaccess;
  final bool foodaccess;
  final bool eventsaccess;
  final bool deliveryaccess;

  SchoolModel({required this.buyandsellaccess, required this.deliveryaccess,required  this.eventsaccess, required this.foodaccess, required this.schoolname});

  factory SchoolModel.fromDocument(DocumentSnapshot doc) {
    return SchoolModel(
      deliveryaccess: doc.get('delivery_access'),
      eventsaccess: doc.get('events_access'),
      buyandsellaccess:doc.get('buy_and_sell_access'),
      foodaccess: doc.get('food_access'),
      schoolname: doc.get('school_name')
    );
  }
}
