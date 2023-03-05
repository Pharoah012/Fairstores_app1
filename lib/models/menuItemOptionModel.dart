import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemOptionModel {
  final String id;
  final String name;
  final bool isrequired;
  final int maxitems;
  final int index;

  const MenuItemOptionModel({
    required this.id,
    required this.isrequired,
    required this.index,
    required this.maxitems,
    required this.name
  });

  factory MenuItemOptionModel.fromDocument(DocumentSnapshot doc) {
    log(doc.data().toString());
    if (!(doc.data() as Map<String, dynamic>).containsKey('price')){
      return MenuItemOptionModel(
          maxitems: doc.get('maxitems') ?? 0,
          index: doc.get('index'),
          id: doc.get('id'),
          isrequired: doc.get('isrequired'),
          name: doc.get('name')
      );
    }

    return MenuItemOptionModel(
        maxitems: 0,
        index: 1,
        id: "1",
        isrequired: false,
        name: "name"
    );

  }
}