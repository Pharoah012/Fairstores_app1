import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/ads/adsmodel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodhome.dart';
import 'package:fairstores/food/foodtile.dart';
import 'package:fairstores/mainScreens/search.dart';
import 'package:fairstores/models/schoolmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodPage extends StatefulWidget {

  const FoodPage({Key? key})
      : super(key: key);

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<String> schoollist = [];
  List<AdsModel> adslist = [];
  List<AdsModel> adsgenerallist = [];
  String selectedSchool = '';
  String buttonSelected = 'On Campus';
  String categorySelection = '01';
  @override
  void initState() {
    super.initState();
    // schoolList();
    // getads();
    // getcategories();
    // //getbestsellers();
    // // getjoints();
    // setState(() {
    //   selectedSchool = widget.school;
    // });
  }

  // getcategories() {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: categoryRef
  //           .doc('FairFood')
  //           .collection('categories')
  //           .doc(selectedSchool.isEmpty ? widget.school : selectedSchool)
  //           .collection('shop_categories')
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return const Text('');
  //         }
  //         print(selectedSchool);
  //         List<GestureDetector> foodlist = [];
  //         for (var doc in snapshot.data!.docs) {
  //           CategoryTileModel categoryTileModel =
  //               CategoryTileModel.fromDocument(doc);
  //           foodlist.add(
  //             GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   categorySelection = categoryTileModel.id;
  //                 });
  //               },
  //               child: Padding(
  //                 padding: const EdgeInsets.only(left: 6.0),
  //                 child: Container(
  //                     decoration: BoxDecoration(
  //                       border: Border.all(color: Color(0xffEBEAEB)),
  //                       color: categorySelection == categoryTileModel.id
  //                           ? kPrimary
  //                           : Colors.white,
  //                       borderRadius: BorderRadius.circular(100),
  //                     ),
  //                     child: Center(
  //                         child: Padding(
  //                       padding: const EdgeInsets.only(
  //                           left: 19.0, right: 19, top: 8, bottom: 8),
  //                       child: Text(
  //                         categoryTileModel.name,
  //                         style: GoogleFonts.manrope(
  //                             fontWeight: FontWeight.w600,
  //                             fontSize: 12,
  //                             color: categorySelection == categoryTileModel.id
  //                                 ? Colors.white
  //                                 : Color(0xff777777)),
  //                       ),
  //                     ))),
  //               ),
  //             ),
  //           );
  //         }
  //
  //         return Padding(
  //           padding: const EdgeInsets.only(
  //               top: 10, left: 16, right: 20, bottom: 14.5),
  //           child: SizedBox(
  //             width: MediaQuery.of(context).size.width,
  //             height: 33,
  //             child: ListView(
  //               scrollDirection: Axis.horizontal,
  //               children: foodlist,
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // getads() async {
  //   QuerySnapshot snapshot1 =
  //       await adsRef.doc('General').collection('content').get();
  //
  //   QuerySnapshot snapshot2 = await adsRef
  //       .doc(selectedSchool.isEmpty ? widget.school : selectedSchool)
  //       .collection('content')
  //       .get();
  //
  //   List<AdsModel> adsgenerallist = [];
  //   List<AdsModel> adslist = [];
  //   for (var doc in snapshot1.docs) {
  //     adslist.add(AdsModel.fromDocument(doc));
  //   }
  //   for (var doc in snapshot2.docs) {
  //     adslist.add(AdsModel.fromDocument(doc));
  //   }
  //
  //   setState(() {
  //     this.adslist = adslist;
  //   });
  // }
  //
  // getjoints() {
  //   if (categorySelection == '01') {
  //     return StreamBuilder<QuerySnapshot>(
  //         stream: jointsRef
  //             .doc(selectedSchool)
  //             .collection('Joints')
  //             .orderBy('lockshop', descending: false)
  //             .snapshots(),
  //         builder: (context, snapshot) {
  //           if (!snapshot.hasData) {
  //             return const Text('');
  //           }
  //
  //           List<FoodTile> foodlist = [];
  //           for (var doc in snapshot.data!.docs) {
  //             foodlist
  //                 .add(FoodTile.fromDocument(doc, widget.user, selectedSchool));
  //           }
  //
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 10.0),
  //             child: Column(
  //               children: foodlist,
  //             ),
  //           );
  //         });
  //   } else {
  //     return StreamBuilder<QuerySnapshot>(
  //         stream: jointsRef
  //             .doc(selectedSchool)
  //             .collection('Joints')
  //             .where('categoryid', isEqualTo: categorySelection)
  //             .orderBy('lockshop', descending: false)
  //             .snapshots(),
  //         builder: (context, snapshot) {
  //           if (!snapshot.hasData) {
  //             return const Text('');
  //           }
  //
  //           List<FoodTile> foodlist = [];
  //           for (var doc in snapshot.data!.docs) {
  //             foodlist
  //                 .add(FoodTile.fromDocument(doc, widget.user, selectedSchool));
  //           }
  //
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 10.0),
  //             child: Column(
  //               children: foodlist,
  //             ),
  //           );
  //         });
  //   }
  // }
  //
  // getbestsellers() {
  //   if (categorySelection == '01') {
  //     return StreamBuilder<QuerySnapshot>(
  //         stream: jointsRef
  //             .doc(selectedSchool)
  //             .collection('Joints')
  //             .orderBy('foodjoint_favourite_count', descending: true)
  //             .limit(4)
  //             .snapshots(),
  //         builder: (context, snapshot) {
  //           if (!snapshot.hasData) {
  //             return const Text('');
  //           }
  //
  //           List<HomeTile> foodlist = [];
  //           for (var doc in snapshot.data!.docs) {
  //             foodlist
  //                 .add(HomeTile.fromDocument(doc, widget.user, selectedSchool));
  //           }
  //
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 10.0),
  //             child: SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.3,
  //               child: ListView(
  //                 scrollDirection: Axis.horizontal,
  //                 children: foodlist,
  //               ),
  //             ),
  //           );
  //         });
  //   } else {
  //     return StreamBuilder<QuerySnapshot>(
  //         stream: jointsRef
  //             .doc(selectedSchool)
  //             .collection('Joints')
  //             .where('categoryid', isEqualTo: categorySelection)
  //             .orderBy('foodjoint_favourite_count', descending: true)
  //             .limit(4)
  //             .snapshots(),
  //         builder: (context, snapshot) {
  //           if (!snapshot.hasData) {
  //             return const Text('');
  //           }
  //
  //           List<HomeTile> foodlist = [];
  //           for (var doc in snapshot.data!.docs) {
  //             foodlist
  //                 .add(HomeTile.fromDocument(doc, widget.user, selectedSchool));
  //           }
  //
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 10.0),
  //             child: SizedBox(
  //               height: MediaQuery.of(context).size.height * 0.3,
  //               child: ListView(
  //                 scrollDirection: Axis.horizontal,
  //                 children: foodlist,
  //               ),
  //             ),
  //           );
  //         });
  //   }
  // }
  //
  // schoolList() async {
  //   QuerySnapshot snapshot = await schoolRef.get();
  //   List<String> schoollist = [];
  //   for (var doc in snapshot.docs) {
  //     SchoolModel schoolModel = SchoolModel.fromDocument(doc);
  //
  //     schoollist.add(schoolModel.schoolname);
  //   }
  //
  //   setState(() {
  //     this.schoollist = schoollist;
  //   });
  // }

  foodPageHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 45.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              padding: const EdgeInsets.only(top: 8),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: DropdownButton<dynamic>(
                      elevation: 0,
                      underline: const SizedBox(
                        height: 0,
                      ),
                      hint: Text(
                        ' Your Location',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      items: schoollist
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      isExpanded: true,
                      onChanged: (value) {
                        setState(() {
                          selectedSchool = value;
                        });
                      }),
                ),
                Text(
                  selectedSchool,
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  search() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 12,
      ),
      child: Center(
        child: SizedBox(
          height: 43,
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
              keyboardType: TextInputType.none,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Search(),
                    ));
              },
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(
                        color: kPrimary,
                      )),
                  focusColor: kPrimary,
                  prefixIcon: const Icon(
                    Icons.search,
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
    );
  }

  categorylist() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        left: 19.0, right: 19, top: 8, bottom: 8),
                    child: Text(
                      'All',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                  ))),
            ],
          ),
        ));
  }

  adsection() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 160,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: CarouselSlider(
          items: adslist,
          options: CarouselOptions(
              padEnds: false,
              autoPlay: true,
              enableInfiniteScroll: false,
              aspectRatio: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          foodPageHeader(),
          search(),
          // getcategories(),
          // adsection(),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20.0, left: 25, bottom: 0),
          //   child: Text('Best Sellers',
          //       style: GoogleFonts.manrope(
          //           fontWeight: FontWeight.w600, fontSize: 14)),
          // ),
          // getbestsellers(),
          // Padding(
          //   padding: const EdgeInsets.only(top: 0.0, left: 25, bottom: 0),
          //   child: Text('Restuarants Available',
          //       style: GoogleFonts.manrope(
          //           fontWeight: FontWeight.w600, fontSize: 14)),
          // ),
          // getjoints()
        ],
      )),
    );
  }
}

class HomeTile extends StatefulWidget {
  final String user;
  final String school;
  final String tilename;
  final int tileprice;
  final bool deliveryavailable;
  final bool pickupavailable;
  final String tileid;
  final String tiledistancetime;
  final String location;
  final String headerimage;
  final String logo;
  final dynamic rating;
  final bool lockshop;
  final List favourites;

  const HomeTile(
      {Key? key,
      required this.lockshop,
      required this.deliveryavailable,
      required this.pickupavailable,
      required this.logo,
      required this.rating,
      required this.location,
      required this.headerimage,
      required this.school,
      required this.user,
      required this.tilename,
      required this.tileid,
      required this.favourites,
      required this.tiledistancetime,
      required this.tileprice})
      : super(key: key);

  factory HomeTile.fromDocument(DocumentSnapshot doc, user, school) {
    return HomeTile(
        school: school,
        user: user,
        location: doc.get('foodjoint_location'),
        headerimage: doc.get('foodjoint_header'),
        deliveryavailable: doc.get('delivery_available'),
        pickupavailable: doc.get('pickup_available'),
        logo: doc.get('foodjoint_logo'),
        rating: doc.get('foodjoint_ratings'),
        tileid: doc.get('foodjoint_id'),
        favourites: doc.get('foodjoint_favourites'),
        tilename: doc.get("foodjoint_name"),
        lockshop: doc.get('lockshop'),
        tiledistancetime: doc.get('foodjoint_deliverytime'),
        tileprice: doc.get('foodjoint_price'));
  }

  @override
  State<HomeTile> createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  bool isliked = false;
  @override
  void initState() {
    super.initState();
    checkfavorites();
  }

  updatefavourites() {
    if (isliked == true) {
      widget.favourites.remove(widget.user);
      setState(() {
        isliked = !isliked;
      });
    } else {
      widget.favourites.add(widget.user);
      setState(() {
        isliked = !isliked;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Added to Favourites')));
    }

    jointsRef
        .doc(widget.school)
        .collection('Joints')
        .doc(widget.tileid)
        .update({'foodjoint_favourites': widget.favourites});
  }

  checkfavorites() {
    for (var element in widget.favourites) {
      if (element == widget.user) {
        setState(() {
          isliked = true;
        });
      } else {
        setState(() {
          isliked = false;
        });
      }
    }
  }

  showrating() {
    return Container(
      child: Row(
        children: [
          Image.asset('images/star.png'),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Text(
              widget.rating.toString(),
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }

  lockedtile() {
    return Padding(
      padding: const EdgeInsets.only(left: 19.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Currently Unavailable')));
                },
                child: Container(
                  width: 246,
                  height: 143,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    'Currently Closed',
                    style: GoogleFonts.manrope(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.tilename,
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('GHC ${widget.tileprice}',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: const Color(0xff8B8380))),
                    const SizedBox(
                      width: 7,
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 2,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(widget.tiledistancetime,
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: const Color(0xff8B8380)))
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  homeTile() {
    return Padding(
      padding: const EdgeInsets.only(left: 19.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Foodhome(
                          rating: widget.rating,
                          deliverytime: widget.tiledistancetime,
                          jointname: widget.tilename,
                          location: widget.location,
                          headerimage: widget.headerimage,
                          logo: widget.logo,
                          user: widget.user,
                          jointid: widget.tileid,
                          favourites: widget.favourites,
                          school: widget.school,
                        ),
                      ));
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: 246,
                      height: 143,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  widget.headerimage)),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    IconButton(
                        onPressed: () {
                          updatefavourites();
                        },
                        icon: Icon(
                          Icons.favorite_rounded,
                          color: isliked == false ? Colors.white : kPrimary,
                          size: 25,
                        ))
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            widget.tilename,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('GHC ${widget.tileprice}',
                                  overflow: TextOverflow.visible,
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: const Color(0xff8B8380))),
                              const SizedBox(
                                width: 7,
                              ),
                              const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 2,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(widget.tiledistancetime,
                                  overflow: TextOverflow.visible,
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                      color: const Color(0xff8B8380)))
                            ],
                          ),
                        )
                      ],
                    ),
                    Expanded(child: const SizedBox()),
                    showrating()
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.lockshop == true ? lockedtile() : homeTile();
  }
}

class CategoryTileModel {
  final String name;
  final String id;

  CategoryTileModel({
    required this.id,
    required this.name,
  });

  factory CategoryTileModel.fromDocument(DocumentSnapshot doc) {
    return CategoryTileModel(name: doc.get('name'), id: doc.get('id'));
  }
}
