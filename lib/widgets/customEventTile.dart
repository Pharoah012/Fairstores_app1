import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/eventspage.dart';
import 'package:fairstores/models/eventModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';


class CustomEventTile extends StatefulWidget {
  final EventModel event;

  const CustomEventTile({
    Key? key,
    required this.event
  }) : super(key: key);

  @override
  State<CustomEventTile> createState() => _CustomEventTileState();
}

class _CustomEventTileState extends State<CustomEventTile> {
  int eventgoers = 0;

  @override
  void initState() {
    super.initState();
    checkfavorites();
    geteventgoers();
    setState(() {
      favoritecount = widget.event.favouritescount;
    });
  }

  bool isliked = false;
  int favoritecount = 0;

  geteventgoers() async {
    QuerySnapshot snapshot = await eventTicketsPurchaseRef
        .doc(widget.event.eventid)
        .collection('Purchases')
        .where('status', isEqualTo: 'Active')
        .get();
    for (var element in snapshot.docs) {
      eventgoers = eventgoers + 1;
    }
  }

  updatefavourites() {
    if (isliked == true) {
      widget.event.favouriteslist.remove(widget.event.user);
      favoritecount -= 1;

      setState(() {
        isliked = !isliked;
      });
    } else {
      widget.event.favouriteslist.add(widget.event.user);
      favoritecount += 1;

      setState(() {
        isliked = !isliked;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Added to Favourites')));
    }

    eventsRef
        .doc('All')
        .collection('events')
        .doc(widget.event.eventid)
        .update({'favourites_list': widget.event.favouriteslist});
    eventsRef
        .doc('All')
        .collection('events')
        .doc(widget.event.eventid)
        .update({'favourite_count': favoritecount});
    eventsRef
        .doc(widget.event.school)
        .collection('events')
        .doc(widget.event.eventid)
        .update({'favourites_list': widget.event.favouriteslist});
    eventsRef
        .doc(widget.event.school)
        .collection('events')
        .doc(widget.event.eventid)
        .update({'favourite_count': favoritecount});
  }

  checkfavorites() {
    for (var element in widget.event.favouriteslist) {
      if (element == widget.event.user) {
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

  eventModelImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 9.0, right: 9, top: 9),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(children: [
            SizedBox(
                child: CachedNetworkImage(
                  imageUrl: widget.event.eventheaderimage,
                  height: 131,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.9,
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10, right: 10),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xffFFFFFF).withOpacity(0.2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8, left: 10, right: 10),
                      child: CustomText(
                        text: '${widget.event.eventdate
                            .toDate()
                            .day} ${widget.event.eventmonth}',
                        color: kWhite,
                        isMediumWeight: true,
                        fontSize: 10,
                      )
                    ),
                  ),
                  Expanded(child: const SizedBox()),
                  GestureDetector(
                    onTap: () {
                      updatefavourites();
                    },
                    child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xffFFFFFF).withOpacity(0.2),
                        ),
                        child: Icon(
                          Icons.bookmark,
                          size: 20,
                          color: isliked ? kPrimary : Colors.black,
                        )),
                  ),
                ],
              ),
            )
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.event.lockevent
        ? const SizedBox(
      height: 0,
      width: 0,
    )
        : Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                EventDetails(
                  event: widget.event
                ),
            )
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xffFFFFFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xffF9FAFB))),
          height: 255,
          width: MediaQuery
              .of(context)
              .size
              .width * 0.9,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                eventModelImage(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 14.0, left: 16, right: 50),
                  child: CustomText(
                    text: widget.event.eventname,
                    fontSize: 18,
                    isMediumWeight: true,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 14.0, left: 16, right: 50),
                  child: SizedBox(
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 32.0),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                        color: kPrimary,
                                        border:
                                        Border.all(color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(100)),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border:
                                        Border.all(color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(100)),
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        border:
                                        Border.all(color: Colors.white),
                                        borderRadius:
                                        BorderRadius.circular(100)),
                                  )),
                            ],
                          ),
                          CustomText(
                            text:  '+${5 + eventgoers.round()} going',
                            fontSize: 12,
                            color: kPurple,
                          )
                        ],
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 14.0, left: 16, right: 50),
                  child: SizedBox(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: kGrey,
                            size: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7.0),
                            child: CustomText(
                              text: widget.event.eventlocation,
                              fontSize: 13,
                              color: kGrey,
                            )
                          ),
                        ],
                      )),
                ),
              ]),
        ),
      ),
    );
  }
}