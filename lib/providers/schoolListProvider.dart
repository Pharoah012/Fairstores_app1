import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/schoolmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final selectedSchoolProvider = StateProvider<String>((ref) => "-Select School-");

final schoolsProvider = FutureProvider<List<String>>((ref) async {

  List<String> schoolList = ["-Select School-"];

  QuerySnapshot snapshot = await schoolRef.get();

  for (var doc in snapshot.docs) {
    SchoolModel schoolModel = SchoolModel.fromDocument(doc);

    schoolList.add(schoolModel.schoolname);
  }

  return schoolList;
});