import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

final jointsRef = FirebaseFirestore.instance.collection('foodJoints');

class JointModel{
  final String name;
  final int price;
  final double rating;
  final bool deliveryAvailable;
  final bool pickupAvailable;
  final String jointID;
  final String deliveryTime;
  final String category;
  final List favourites;
  final String logo;
  final bool lockshop;
  final String location;
  final int favouritescount;
  final String headerImage;
  bool isFavorite;

  JointModel({
    required this.rating,
    required this.deliveryAvailable,
    required this.pickupAvailable,
    required this.headerImage,
    required this.logo,
    required this.location,
    required this.lockshop,
    required this.favouritescount,
    required this.category,
    required this.name,
    required this.jointID,
    required this.favourites,
    required this.deliveryTime,
    required this.price,
    this.isFavorite = false
  });

  factory JointModel.fromDocument(DocumentSnapshot doc, user, school) {
    JointModel model = JointModel(
        deliveryAvailable: doc.get('delivery_available'),
        pickupAvailable: doc.get('pickup_available'),
        rating: doc.get('foodjoint_ratings'),
        logo: doc.get('foodjoint_logo'),
        headerImage: doc.get('foodjoint_header'),
        location: doc.get('foodjoint_location'),
        lockshop: doc.get('lockshop'),
        favouritescount: doc.get('foodjoint_favourite_count'),
        category: doc.get('categoryid'),
        jointID: doc.get('foodjoint_id'),
        favourites: doc.get('foodjoint_favourites'),
        name: doc.get("foodjoint_name"),
        deliveryTime: doc.get('foodjoint_deliverytime'),
        price: doc.get('foodjoint_price')
    );

    // check if the user has favorited this item
    // and update the isFavorite variable
    for (String element in model.favourites) {
      if (element == user) {
        model.isFavorite = true;
      }
    }

    return model;
  }

  static Future<List<JointModel>> getJoints({
    required String school,
    required String category,
    required String userID
  }) async {

    late QuerySnapshot snapshot;

    if (category == "All"){
      snapshot = await jointsRef
          .doc(school)
          .collection('Joints')
          .orderBy('lockshop', descending: false)
          .get();
    }
    else{
      snapshot = await jointsRef
          .doc(school)
          .collection('Joints')
          .where('categoryid', isEqualTo: category)
          .orderBy('lockshop', descending: false)
          .get();
    }

    List<JointModel>  jointList = snapshot.docs
        .map((doc) => JointModel.fromDocument(doc, userID, school))
        .toList();

    return jointList;
  }

  static Future<List<JointModel>> getBestSellers({
    required String school,
    required String category,
    required String userID
  }) async {

    late QuerySnapshot snapshot;

    // log(category);

    if (category == "All"){
      snapshot = await jointsRef
        .doc(school)
        .collection('Joints')
        .orderBy('foodjoint_favourite_count', descending: true)
        .limit(4)
        .get();
    }
    else{
      snapshot = await jointsRef
        .doc(school)
        .collection('Joints')
        .where('categoryid', isEqualTo: category)
        .orderBy('foodjoint_favourite_count', descending: true)
        .limit(4)
        .get();
    }

    List<JointModel>  jointList = snapshot.docs
        .map((doc) => JointModel.fromDocument(doc, userID, school))
        .toList();

    return jointList;
  }

  static Future<List<JointModel>> getFavoriteJoints({
    required String school,
    required String userID
  }) async {

    QuerySnapshot snapshot = await jointsRef
        .doc(school)
        .collection('Joints')
        .where('foodjoint_favourites', arrayContains: userID)
        .get();

    List<JointModel>  jointList = snapshot.docs
        .map((doc) => JointModel.fromDocument(doc, userID, school))
        .toList();

    return jointList;
  }

  static Future<List<JointModel>> getSearchResults({
    required String school,
    required String searchValue,
    required String userID
  }) async {

    QuerySnapshot snapshot = await jointsRef
        .doc(school)
        .collection('Joints')
        .orderBy("foodjoint_name")
        .startAt([searchValue])
        .endAt([searchValue + '\uf8ff'])
        .get();

    List<JointModel> jointList = snapshot.docs
        .map((doc) =>
        JointModel.fromDocument(doc, school, userID))
        .toList();

    return jointList;
  }

  static Future<JointModel> getDeliveryPrice({
    required String school,
    required String foodID,
    required String userID
  }) async {
    DocumentSnapshot doc = await jointsRef
        .doc(school)
        .collection('Joints')
        .doc(foodID)
        .get();

    return JointModel.fromDocument(doc, userID, school);
  }

  static Future<JointModel> getShop({
    required String school,
    required String shopID,
    required String userID
  }) async {
    DocumentSnapshot doc = await jointsRef
        .doc(school)
        .collection('Joints')
        .doc(shopID)
        .get();

    return JointModel.fromDocument(doc, userID, school);
  }

  Future<bool> updateFavorites({
    required String userID,
    required String school
  }) async{

    // check if the user has favorited the food
    // and remove them from list of favorites
    if (this.isFavorite){
      this.favourites.remove(userID);
    }
    else{
      // add the user to the favorites
      this.favourites.add(userID);
    }

    // update the favorites list in firestore
    await jointsRef
      .doc(school)
      .collection('Joints')
      .doc(this.jointID)
      .update({'foodjoint_favourites': this.favourites});

    // update the isFavorite variable
    this.isFavorite = !isFavorite;

    return this.isFavorite;
  }

}