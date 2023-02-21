import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/eventshome.dart';

import 'package:fairstores/food/foodtile.dart';
import 'package:fairstores/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedItems extends StatefulWidget {
  final String school;
  final String user;
  const SavedItems({Key? key, required this.school, required this.user})
      : super(key: key);

  @override
  State<SavedItems> createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {
  String page = 'food';
  List<FoodTile> foodlist = [];
  List<EventsPageModel> eventlist = [];

  @override
  void initState() {
    super.initState();
    getfavoritesfood();
    geteventsfavorite();
  }

  geteventsfavorite() async {
    QuerySnapshot snapshot = await eventsref
        .doc(widget.school)
        .collection('events')
        .where('favourites_list', arrayContains: widget.user)
        .get();
    List<EventsPageModel> eventlist = [];

    eventlist = snapshot.docs
        .map((doc) =>
            EventsPageModel.fromDocument(doc, widget.school, widget.user))
        .toList();
    setState(() {
      this.eventlist = eventlist;
    });
  }

  getfavoritesfood() async {
    QuerySnapshot snapshot = await jointsref
        .doc(widget.school)
        .collection('Joints')
        .where('foodjoint_favourites', arrayContains: widget.user)
        .get();
    List<FoodTile> foodlist = [];

    foodlist = snapshot.docs
        .map((doc) => FoodTile.fromDocument(doc, widget.user, widget.school))
        .toList();
    setState(() {
      this.foodlist = foodlist;
    });
  }

  pagetoggle(page) {
    if (page == 'food') {
      return foodlist.isEmpty
          ? Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  Text(
                    'No Favorites',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: foodlist,
              ),
            );
    } else if (page == 'events') {
      return eventlist.isEmpty
          ? Center(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  Text(
                    'No Favorites',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: eventlist,
              ),
            );
    }
    return const Text('data');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 16,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text('Favorites',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black))),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  page = 'food';
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.59,
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
                              color:
                                  page == 'food' ? kPrimary : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                                child: Text(
                              'Food',
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: page == 'food'
                                      ? Colors.white
                                      : Colors.black),
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
                                color: page == 'events'
                                    ? kPrimary
                                    : Colors.transparent,
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
          ),
          pagetoggle(page)
        ],
      )),
    );
  }
}
