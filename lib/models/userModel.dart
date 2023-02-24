import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final userRef = FirebaseFirestore.instance.collection('Users');

  String? email;
  String? number;
  String? name;
  String? school;
  String? uid;
  String? password;
  bool ismanager;
  String? signinmethod;

  UserModel({
    this.email,
    this.number,
    required this.ismanager,
    this.name,
    this.signinmethod,
    this.school,
    this.uid,
    this.password
  });

  //recieves data from the server
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
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

  Future<void> createUser(UserModel userModel) async {
    return await userRef.doc(userModel.uid).set(userModel.toMap());
  }

  Future<void> updateUserDetails() async {
    await userRef.doc(this.uid).update(toMap());
  }
}
