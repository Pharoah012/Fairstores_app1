import 'package:cloud_firestore/cloud_firestore.dart';

final userRef = FirebaseFirestore.instance.collection('Users');

class UserModel {
  String? email;
  String? number;
  String? username;
  String? school;
  final String uid;
  String? password;
  bool ismanager;
  String? signinmethod;

  UserModel({
    this.email,
    this.number,
    required this.ismanager,
    this.username,
    this.signinmethod,
    this.school,
    required this.uid,
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
        username: doc.get('username'));
  }

  //sends data to the server
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'ismanager': ismanager,
      'number': number,
      'password': password,
      'username': username,
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

  Future<void> updateProfileDetails({
    required String email,
    required String phoneNumber
  }) async {

    Map<String, String> info = {
      'email': email,
      'number': phoneNumber
    };

    await userRef.doc(this.uid).update(info);
  }
}
