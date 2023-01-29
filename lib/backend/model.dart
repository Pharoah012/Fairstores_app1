import 'package:cloud_firestore/cloud_firestore.dart';

class Model {
  String? email;
  String? number;
  String? name;
  String? school;
  String? uid;
  String? password;
  bool ismanager;
  String? signinmethod;

  Model(
      {this.email,
      this.number,
      required this.ismanager,
      this.name,
      this.signinmethod,
      this.school,
      this.uid,
      this.password});

  //recieves data from the server
  factory Model.fromDocument(DocumentSnapshot doc) {
    return Model(
        email: doc.get('email'),
        ismanager: doc.get('ismanager'),
        password: doc.get('password'),
        number: doc.get('number'),
        school: doc.get('school'),
        signinmethod: doc.get('signinmethod'),
        uid: doc.get('uid'),
        name: doc.get('username'));
  }

  //sends data to the server
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'ismanager': ismanager,
      'number': number,
      'password': password,
      'name': name,
      'signinmethod': signinmethod,
      'school': school,
      'uid': uid
    };
  }
}
