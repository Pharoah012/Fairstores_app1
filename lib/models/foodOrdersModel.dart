import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

final foodCartRef = FirebaseFirestore.instance.collection('FoodCart');

class FoodOrdersModel{

  final String status;
  final String image;
  int quantity;
  final String foodName;
  final String orderID;
  final dynamic price;
  final String jointID;
  final List sides;
  final String cartID;

  FoodOrdersModel({
    required this.sides,
    required this.jointID,
    required this.orderID,
    required this.price,
    required this.image,
    required this.foodName,
    required this.quantity,
    required this.status,
    required this.cartID
  });

  factory FoodOrdersModel.fromDocument(DocumentSnapshot doc) {
    return FoodOrdersModel(
      sides: doc.get('sides'),
      status: doc.get('status'),
      jointID: doc.get('shopid'),
      price: doc.get('total'),
      orderID: doc.get('orderid'),
      foodName: doc.get('ordername'),
      quantity: doc.get('quantity'),
      image: doc.get('image'),
      cartID: doc.get("cartid")
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "status": this.status,
      "image": this.image,
      "quantity": this.quantity,
      "ordername": this.foodName,
      "orderid": this.orderID,
      "total": this.price,
      "shopid": this.jointID,
      "sides": this.sides,
      "cartid": this.cartID,
    };
  }

  // place an order
  Future<void> placeOrder({
    required String userID
  }) async {

    // place the order
    await foodCartRef
      .doc(userID)
      .collection('Orders')
      .doc(this.orderID)
      .set(toJson());
  }

  // remove the given order
  Future<void> removeOrder({
    required String userID,
  }) async {

    // delete the order
    await foodCartRef
        .doc(userID)
        .collection('Orders')
        .doc(this.orderID)
        .delete();
  }

  // update the given order
  Future<void> updateOrder({
    required String userID,
  }) async {

    // update the order
    await foodCartRef
        .doc(userID)
        .collection('Orders')
        .doc(this.orderID)
        .update(toJson());
  }

  // get all the orders from the given joint
  static Future<Map<String, FoodOrdersModel>> getCart({
    required String jointID,
    required String userID
  }) async {

    QuerySnapshot snapshot = await foodCartRef
      .doc(userID)
      .collection('Orders')
      .where('shopid', isEqualTo: jointID)
      .get();

    Map<String, FoodOrdersModel> cart = {};

    for (var item in snapshot.docs){
      FoodOrdersModel order = FoodOrdersModel.fromDocument(item);

      cart[order.orderID] = order;
    }

    return cart;

  }

  // check if the user has an order from another joint
  // Return the jointID if it is not available and null if it is
  static Future<String?> isCartAvailable({
    required String userID,
    required String jointID
  }) async {
    QuerySnapshot snapshot = await foodCartRef
      .doc(userID)
      .collection('Orders')
      .where('shopid', isNotEqualTo: jointID)
      .get();

    if (snapshot.docs.isEmpty){
      return null;
    }

    return FoodOrdersModel.fromDocument(snapshot.docs.first).jointID;
  }

  // clear a joint's cart
  static Future<bool> clearCart({
    required String userID,
    required String jointID
  }) async {
    // Get the user's order from the given store
    QuerySnapshot snapshot = await foodCartRef
      .doc(userID)
      .collection('Orders')
      .where("shopid", isEqualTo: jointID)
      .get();

    // delete the orders
    for (var e in snapshot.docs) {
      e.reference.delete();
    }

    return snapshot.docs.isEmpty;
  }

  // update the existing card with the items in the given list
  static Future<void> updateCart({
    required List<FoodOrdersModel> cartList,
    required String userID
  }) async {

    if (cartList.isNotEmpty){
      for (FoodOrdersModel order in cartList){

        // check if the user has removed the order
        if (order.quantity == 0){
          await order.removeOrder(
            userID: userID,
          );
        }
        else{
          await order.updateOrder(
              userID: userID
          );
        }
      }
    }
  }

}