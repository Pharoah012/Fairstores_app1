import 'package:cloud_firestore/cloud_firestore.dart';

final jointsRef = FirebaseFirestore.instance.collection('foodJoints');

class FoodModel{
  final String user;
  final String school;
  final String tilename;
  final int tileprice;
  final dynamic rating;
  final bool deliveryavailable;
  final bool pickupavailable;
  final String tileid;
  final String tiledistancetime;
  final String tilecategory;
  final List favourites;
  final String logo;
  final bool lockshop;
  final String location;
  final int favouritescount;
  final String headerimage;

  const FoodModel({
    required this.rating,
    required this.deliveryavailable,
    required this.pickupavailable,
    required this.headerimage,
    required this.logo,
    required this.location,
    required this.lockshop,
    required this.favouritescount,
    required this.school,
    required this.tilecategory,
    required this.user,
    required this.tilename,
    required this.tileid,
    required this.favourites,
    required this.tiledistancetime,
    required this.tileprice
  });

  factory FoodModel.fromDocument(DocumentSnapshot doc, user, school) {
    return FoodModel(
        school: school,
        user: user,
        deliveryavailable: doc.get('delivery_available'),
        pickupavailable: doc.get('pickup_available'),
        rating: doc.get('foodjoint_ratings'),
        logo: doc.get('foodjoint_logo'),
        headerimage: doc.get('foodjoint_header'),
        location: doc.get('foodjoint_location'),
        lockshop: doc.get('lockshop'),
        favouritescount: doc.get('foodjoint_favourite_count'),
        tilecategory: doc.get('categoryid'),
        tileid: doc.get('foodjoint_id'),
        favourites: doc.get('foodjoint_favourites'),
        tilename: doc.get("foodjoint_name"),
        tiledistancetime: doc.get('foodjoint_deliverytime'),
        tileprice: doc.get('foodjoint_price'));
  }

  static Future<List<FoodModel>> getFavoriteFoods({
    required String school,
    required String userID
  }) async {
    QuerySnapshot snapshot = await jointsRef
        .doc(school)
        .collection('Joints')
        .where('foodjoint_favourites', arrayContains: userID)
        .get();

    List<FoodModel>  foodList = snapshot.docs
        .map((doc) => FoodModel.fromDocument(doc, userID, school))
        .toList();

    return foodList;
  }

  static Future<List<FoodModel>> getSearchResults({
    required String school,
    required String searchValue,
    required String userID
  }) async {
    QuerySnapshot snapshot = await jointsRef
        .doc(school)
        .collection('Joints')
        .where('foodjoint_name', isGreaterThanOrEqualTo: searchValue)
        .get();

    List<FoodModel> foodList = snapshot.docs
        .map((doc) =>
        FoodModel.fromDocument(doc, school, userID))
        .toList();

    return foodList;
  }

  static Future<FoodModel> getDeliveryPrice({
    required String school,
    required String foodID,
    required String userID
  }) async {
    DocumentSnapshot doc = await jointsRef
        .doc(school)
        .collection('Joints')
        .doc(foodID)
        .get();

    return FoodModel.fromDocument(doc, userID, school);
  }

  static Future<FoodModel> getShop({
    required String school,
    required String shopID,
    required String userID
  }) async {
    DocumentSnapshot doc = await jointsRef
        .doc(school)
        .collection('Joints')
        .doc(shopID)
        .get();

    return FoodModel.fromDocument(doc, userID, school);
  }
}