import 'package:cloud_firestore/cloud_firestore.dart';

class JointMenuOptionModel {
  final String id;
  final String name;

  const JointMenuOptionModel({
    required this.id,
    required this.name
  });

  factory JointMenuOptionModel.fromDocument(DocumentSnapshot doc) {
    return JointMenuOptionModel(
      id: doc.get('id'),
      name: doc.get('name')
    );
  }
}

