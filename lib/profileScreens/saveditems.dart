import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/eventshome.dart';
import 'package:fairstores/food/foodtile.dart';
import 'package:fairstores/providers/favoriteFoodsProvider.dart';
import 'package:fairstores/providers/getFavoriteEvents.dart';
import 'package:fairstores/widgets/customEventTile.dart';
import 'package:fairstores/widgets/customFoodTile.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final currentPage = StateProvider<String>((ref) => "food");

class SavedItems extends ConsumerStatefulWidget {
  const SavedItems({Key? key}) : super(key: key);

  @override
  ConsumerState<SavedItems> createState() => _SavedItemsState();
}

class _SavedItemsState extends ConsumerState<SavedItems> {
  // String page = 'food';
  // List<FoodTile> foodlist = [];
  // List<EventsPageModel> eventlist = [];

  @override
  void initState() {
    super.initState();
    // getfavoritesfood();
    // geteventsfavorite();
  }

  // geteventsfavorite() async {
  //   QuerySnapshot snapshot = await eventsRef
  //       .doc(widget.school)
  //       .collection('events')
  //       .where('favourites_list', arrayContains: widget.user)
  //       .get();
  //   List<EventsPageModel> eventlist = [];
  //
  //   eventlist = snapshot.docs
  //       .map((doc) =>
  //           EventsPageModel.fromDocument(doc, widget.school, widget.user))
  //       .toList();
  //   setState(() {
  //     this.eventlist = eventlist;
  //   });
  // }
  //
  // getfavoritesfood() async {
  //   QuerySnapshot snapshot = await jointsRef
  //       .doc(widget.school)
  //       .collection('Joints')
  //       .where('foodjoint_favourites', arrayContains: widget.user)
  //       .get();
  //   List<FoodTile> foodlist = [];
  //
  //   foodlist = snapshot.docs
  //       .map((doc) => FoodTile.fromDocument(doc, widget.user, widget.school))
  //       .toList();
  //   setState(() {
  //     this.foodlist = foodlist;
  //   });
  // }

  Widget pagetoggle(page) {

    final _favoriteFoods = ref.watch(favoriteFoodsProvider);
    final _favoriteEvents = ref.watch(favoriteEventsProvider);

    if (page == 'food') {
      return _favoriteFoods.when(
        data: (data){
          if (data.isEmpty){
            return Center(
              child: CustomText(
                text: "No Favorites"
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index){
              return CustomFoodTile(food: data[index]);
            }
          );
        },
        error: (_, err){
          log(err.toString());
          return Center(
            child: CustomText(
                text: "An error occurred while getting your favorite foods"
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: kPrimary,
          ),
        )
      );
    }

    else {
      return _favoriteEvents.when(
          data: (data){
            if (data.isEmpty){
              return Center(
                child: CustomText(
                    text: "No Events"
                ),
              );
            }

            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index){
                  return CustomEventTile(event: data[index]);
                }
            );
          },
          error: (_, err){
            log(err.toString());
            return Center(
              child: CustomText(
                  text: "An error occurred while getting your favorite events"
              ),
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: kPrimary,
            ),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _currentPage = ref.watch(currentPage);

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
        title: CustomText(
          text: 'Favorites',
          fontSize: 16,
          color: Colors.black,
          isMediumWeight: true,
        )
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                ref.read(currentPage.notifier).state = "food";
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
                                  _currentPage == 'food' ? kPrimary : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: CustomText(
                                text: 'Food',
                                color: _currentPage == 'foods'
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 12,
                                isMediumWeight: true,
                              )
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: GestureDetector(
                          onTap: () {
                            ref.read(currentPage.notifier).state = "events";
                          },
                          child: Container(
                            height: 33.6,
                            width: 100,
                            decoration: BoxDecoration(
                              color: _currentPage == 'events'
                                  ? kPrimary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: CustomText(
                                text: 'Events',
                                color: _currentPage == 'events'
                                  ? Colors.white
                                  : Colors.black,
                                fontSize: 12,
                                isMediumWeight: true,
                              )
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          pagetoggle(_currentPage)
        ],
      )),
    );
  }
}
