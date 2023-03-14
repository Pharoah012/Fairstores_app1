import 'package:cloud_firestore/cloud_firestore.dart';

class TokenModel {
  final String devtoken;

  TokenModel({
    required this.devtoken
  });

  //recieves data from the server
  factory TokenModel.fromDocument(DocumentSnapshot doc) {
    return TokenModel(devtoken: doc.get('devtoken'));
  }

  //sends data to the server
  Map<String, dynamic> toMap() {
    return {
      'devtoken': devtoken,
    };
  }
}
