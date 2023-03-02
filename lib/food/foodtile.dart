import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodhome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodTile extends StatefulWidget {
  final String user;
  final String school;
  final String tilename;
  final int tileprice;
  final dynamic rating;
  final bool deliveryavailable;
  final bool pickupavailable;
  final String tileid;
  final String tiledistancetime;
  final String tilecategory;
  final List favourites;
  final String logo;
  final bool lockshop;
  final String location;
  final int favouritescount;
  final String headerimage;

  const FoodTile({
    Key? key,
    required this.rating,
    required this.deliveryavailable,
    required this.pickupavailable,
    required this.headerimage,
    required this.logo,
    required this.location,
    required this.lockshop,
    required this.favouritescount,
    required this.school,
    required this.tilecategory,
    required this.user,
    required this.tilename,
    required this.tileid,
    required this.favourites,
    required this.tiledistancetime,
    required this.tileprice
  }) : super(key: key);

  factory FoodTile.fromDocument(DocumentSnapshot doc, user, school) {
    return FoodTile(
        school: school,
        user: user,
        deliveryavailable: doc.get('delivery_available'),
        pickupavailable: doc.get('pickup_available'),
        rating: doc.get('foodjoint_ratings'),
        logo: doc.get('foodjoint_logo'),
        headerimage: doc.get('foodjoint_header'),
        location: doc.get('foodjoint_location'),
        lockshop: doc.get('lockshop'),
        favouritescount: doc.get('foodjoint_favourite_count'),
        tilecategory: doc.get('categoryid'),
        tileid: doc.get('foodjoint_id'),
        favourites: doc.get('foodjoint_favourites'),
        tilename: doc.get("foodjoint_name"),
        tiledistancetime: doc.get('foodjoint_deliverytime'),
        tileprice: doc.get('foodjoint_price'));
  }

  @override
  State<FoodTile> createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  bool isliked = false;
  int favoriteCount = 0;
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
        favoriteCount -= 1;
      });
    } else {
      widget.favourites.add(widget.user);
      setState(() {
        isliked = !isliked;
        favoriteCount += 1;
      });
    }

    jointsRef
        .doc(widget.school)
        .collection('Joints')
        .doc(widget.tileid)
        .update({
      'foodjoint_favourites': widget.favourites,
      'foodjoint_favourite_count': favoriteCount
    });
  }

  showrating() {
    return Row(
      children: [
        Image.asset('images/star.png'),
        Padding(
          padding: const EdgeInsets.only(left: 3.0),
          child: Text(
            ' ${widget.rating}',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        )
      ],
    );
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
      setState(() {
        favoriteCount += 1;
      });
    }
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
                  width: MediaQuery.of(context).size.width * 0.9,
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

  foodTile() {
    return Padding(
      padding: const EdgeInsets.only(left: 19.0, bottom: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => Foodhome(
                  //         rating: widget.rating,
                  //         deliverytime: widget.tiledistancetime,
                  //         jointname: widget.tilename,
                  //         location: widget.location,
                  //         headerImage: widget.headerimage,
                  //         logo: widget.logo,
                  //         user: widget.user,
                  //         jointid: widget.tileid,
                  //         favourites: widget.favourites,
                  //         school: widget.school,
                  //       ),
                  //     ));
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
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
                width: MediaQuery.of(context).size.width * 0.87,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          padding: const EdgeInsets.only(bottom: 5.0),
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
                    Expanded(child: SizedBox()),
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
    return widget.lockshop == true ? lockedtile() : foodTile();
  }
}
