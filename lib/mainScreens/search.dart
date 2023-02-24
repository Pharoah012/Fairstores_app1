import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/eventshome.dart';
import 'package:fairstores/food/foodtile.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends ConsumerStatefulWidget {
  final bool addappbar;

  const Search({
    Key? key,
    required this.addappbar,
  });

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  String search = '';
  String page = 'food';
  List<FoodTile> foodlist = [];

  @override
  void initState() {
    super.initState();
  }


  pagetoggle(page) {
    if (page == 'food') {
      return StreamBuilder<QuerySnapshot>(
          stream: jointsRef
              .doc(ref.read(userProvider).school)
              .collection('Joints')
              .where('foodjoint_name', isGreaterThanOrEqualTo: search)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('');
            }

            List<FoodTile> foodlist = [];
            for (var doc in snapshot.data!.docs) {
              foodlist.add(
                FoodTile.fromDocument(
                  doc,
                  ref.read(authProvider).currentUser!.uid,
                    ref.read(userProvider).school
                )
              );
            }

            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: foodlist.isEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.30,
                        ),
                        Text(
                          'No Results',
                          style: GoogleFonts.manrope(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  : Column(
                      children: foodlist,
                    ),
            );
          });
    } else if (page == 'events') {
      return FutureBuilder<QuerySnapshot>(
          future: eventsRef
              .doc(ref.read(userProvider).school)
              .collection('events')
              .where('eventname', isGreaterThanOrEqualTo: search)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('');
            }

            List<EventsPageModel> eventlist = [];
            for (var doc in snapshot.data!.docs) {
              eventlist.add(
                EventsPageModel.fromDocument(
                  doc,
                  ref.read(userProvider).school,
                  ref.read(authProvider).currentUser!.uid,
                ));
            }

            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: eventlist.isEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.30,
                        ),
                        Text(
                          'No Results',
                          style: GoogleFonts.manrope(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  : Column(
                      children: eventlist,
                    ),
            );
          });
    }
    return const Text('data');
  }

  searchscreen() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            page = 'food';
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xfff25e37).withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                      height: 33.6,
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                        color: page == 'food' ? kPrimary : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                          child: Text(
                        'Food',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color:
                                page == 'food' ? Colors.white : Colors.black),
                      ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        page = 'events';
                      });
                    },
                    child: Container(
                        height: 33.6,
                        width: 100,
                        decoration: BoxDecoration(
                          color: page == 'events' ? kPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                            child: Text(
                          'Events',
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: page == 'events'
                                  ? Colors.white
                                  : Colors.black),
                        ))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  nosearchscreen() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 200.0,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Icon(
              Icons.search,
              color: Color(0xff8B8380),
            ),
          ),
          Text('Search FairStores',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: const Color(0xff8B8380)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.addappbar == true
            ? AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 14,
                      color: Colors.black,
                    )),
                backgroundColor: Colors.white,
                elevation: 0,
              )
            : PreferredSize(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.048,
                ),
                preferredSize: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 0.4)),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: widget.addappbar == false
                  ? const EdgeInsets.only(top: 30, bottom: 20)
                  : const EdgeInsets.only(top: 8, bottom: 20),
              child: Center(
                child: SizedBox(
                  height: 43,
                  width: 335,
                  child: TextField(
                      onSubmitted: (value) {
                        setState(() {
                          search = value;
                        });
                      },
                      cursorColor: kPrimary,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide(
                                color: kPrimary,
                              )),
                          focusColor: kPrimary,
                          prefixIcon: Icon(
                            Icons.search,
                            color: kPrimary,
                            size: 14,
                          ),
                          labelText: 'Search FairStores app',
                          labelStyle: GoogleFonts.manrope(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: const Color(0xff8B8380)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffE5E5E5),
                              ),
                              borderRadius: BorderRadius.circular(100)))),
                ),
              ),
            ),
            search == '' || search.isEmpty ? const SizedBox() : searchscreen(),
            // search==''||search.isEmpty?SizedBox():pagetoggle(page),
            search == '' || search.isEmpty ? nosearchscreen() : pagetoggle(page)
          ],
        )));
  }
}
