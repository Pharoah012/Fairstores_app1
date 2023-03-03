import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/mainScreens/search.dart';
import 'package:fairstores/models/eventModel.dart';
import 'package:fairstores/providers/schoolListProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customDropdown.dart';
import 'package:fairstores/widgets/customSearchField.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class EventsPage extends ConsumerStatefulWidget {

  const EventsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {


  Future<QuerySnapshot> customFuture() async {
    var alldocs = await eventsRef.doc('All').collection('events').get().then(
        (value) => eventsRef.doc(ref.read(userProvider).school).collection('events').get());

    return alldocs;
  }

  @override
  Widget build(BuildContext context) {
    final schoolsDropdown = ref.watch(schoolDropdownProvider);
    final schools = ref.watch(schoolsProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: CustomAppBar(isDropdown: true,),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomSearchField(
              onSubmitted: (value){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Search(searchValue: value)
                  )
                );
              },
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 2),
                child: Text(
                  'Upcoming Events',
                  style: GoogleFonts.manrope(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              // StreamBuilder<QuerySnapshot>(
              //     stream: eventsRef.doc('All').collection('events').snapshots(),
              //     builder: (context, snapshot) {
              //       if (!snapshot.hasData) {
              //         print('object');
              //         return const SizedBox();
              //       }
              //
              //       List<EventModel> eventlist = [];
              //       for (var doc in snapshot.data!.docs) {
              //         eventlist.add(EventModel.fromDocument(
              //             doc, ref.read(schoolsDropdown.currentValue), user.uid));
              //       }
              //       return Center(
              //           child: Column(
              //         children: eventlist,
              //       ));
              //     }),
              // StreamBuilder<QuerySnapshot>(
              //     stream: eventsRef
              //         .doc(ref.read(schoolsDropdown.currentValue))
              //         .collection('events')
              //         .snapshots(),
              //     builder: (context, snapshot) {
              //       if (!snapshot.hasData) {
              //         print('object');
              //         return const SizedBox();
              //       }
              //
              //       List<EventModel> eventlist = [];
              //       for (var doc in snapshot.data!.docs) {
              //         eventlist.add(EventModel.fromDocument(
              //             doc,
              //             ref.read(schoolsDropdown.currentValue),
              //             user.uid
              //         ));
              //       }
              //       return Center(
              //           child: Column(
              //         children: eventlist,
              //       ));
              //     }),
            )
          ),
        ]
      )
    );
  }
}