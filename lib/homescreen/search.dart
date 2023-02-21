import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/eventshome.dart';
import 'package:fairstores/food/foodtile.dart';
import 'package:fairstores/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {
  final bool addappbar;
  final String user;
  final String? school;

  const Search(
      {Key? key, this.school, required this.addappbar, required this.user})
      : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  UserModel model = UserModel(ismanager: false);
  String search = '';
  String page = 'food';
  List<FoodTile> foodlist = [];

  @override
  void initState() {
    super.initState();
    getUser();
    //print(search);
  }

  getUser() async {
    DocumentSnapshot doc = await userref.doc(widget.user).get();
    UserModel model = UserModel.fromDocument(doc);
    setState(() {
      this.model = model;
    });
  }

  pagetoggle(page) {
    if (page == 'food') {
      return StreamBuilder<QuerySnapshot>(
          stream: jointsref
              .doc(widget.school ?? model.school)
              .collection('Joints')
              .where('foodjoint_name', isGreaterThanOrEqualTo: search)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('');
            }

            List<FoodTile> foodlist = [];
            for (var doc in snapshot.data!.docs) {
              foodlist
                  .add(FoodTile.fromDocument(doc, widget.user, model.school));
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
          future: eventsref
              .doc(widget.school ?? model.school)
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
                  EventsPageModel.fromDocument(doc, model.school, widget.user));
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
