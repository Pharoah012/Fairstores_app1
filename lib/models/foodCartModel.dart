import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/food/foodcartmodel.dart';

final foodCartRef = FirebaseFirestore.instance.collection('FoodCart');

class FoodOrdersModel{

  final String status;
  final String image;
  final int quantity;
  final String foodName;
  final String orderID;
  final dynamic price;
  final String jointID;
  final String user;
  final List sides;

  const FoodOrdersModel({
    required this.user,
    required this.sides,
    required this.jointID,
    required this.orderID,
    required this.price,
    required this.image,
    required this.foodName,
    required this.quantity,
    required this.status
  });

  factory FoodOrdersModel.fromDocument(DocumentSnapshot doc, user) {
    return FoodOrdersModel(
      user: user,
      sides: doc.get('sides'),
      status: doc.get('status'),
      jointID: doc.get('shopid'),
      price: doc.get('total'),
      orderID: doc.get('orderid'),
      foodName: doc.get('ordername'),
      quantity: doc.get('quantity'),
      image: doc.get('image'),
    );
  }

  // get all the orders from the given joint
  static Future<List<FoodOrdersModel>> getJointOrders({
    required String jointID,
    required String userID
  }) async {

    QuerySnapshot snapshot = await foodCartRef
      .doc(userID)
      .collection('Orders')
      .where('shopid', isEqualTo: jointID)
      .get();


    List<FoodOrdersModel> orders = snapshot.docs
      .map(
        (doc) => FoodOrdersModel.fromDocument(doc, userID)).toList();

    return orders;

  }

  // check if the user has an order from the given joint
  static Future<bool> isOrderFromJointInCart({
    required String userID,
    required String jointID
  }) async {
    QuerySnapshot snapshot = await foodCartRef
      .doc(userID)
      .collection('Orders')
      .where('shopid', isNotEqualTo: jointID)
      .get();

    return snapshot.size >= 1;
  }

}