import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/schoolmodel.dart';
import 'package:fairstores/providers/dropdown_provider.dart';
import 'package:fairstores/widgets/customDropdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final _selectedSchoolProvider = StateProvider<String>((ref) => "-Select School-");
final schoolDropdownProvider = StateNotifierProvider<DropdownProvider, CustomDropdown>(
  (ref) => DropdownProvider(
    CustomDropdown(
      items: ["-Select School-"],
      currentValue: _selectedSchoolProvider,
    )
));


final schoolsProvider = FutureProvider<List<String>>((ref) async {

  List<String> schoolList = ["-Select School-"];

  QuerySnapshot snapshot = await schoolRef.get();

  for (var doc in snapshot.docs) {
    SchoolModel schoolModel = SchoolModel.fromDocument(doc);

    schoolList.add(schoolModel.schoolname);
  }

  log(schoolList.toString());

  ref.read(schoolDropdownProvider.notifier).load(
    items: schoolList,
    currentValue: _selectedSchoolProvider
  );

  return schoolList;
});