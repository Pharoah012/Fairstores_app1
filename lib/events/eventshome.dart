import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/eventspage.dart';
import 'package:fairstores/mainScreens/search.dart';
import 'package:fairstores/models/schoolmodel.dart';
import 'package:fairstores/providers/schoolListProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customDropdown.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventsPage extends ConsumerStatefulWidget {

  const EventsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {

  pageLocationHeader() {
    CustomDropdown schoolsDropdown = ref.read(schoolDropdownProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 45.0, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              padding: const EdgeInsets.only(top: 8),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                schoolsDropdown,
                CustomText(
                  text: ref.read(schoolsDropdown.currentValue),
                  fontSize: 12,
                  isBold: true,
                )
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
        bottom: 20,
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
                      builder: (context) => Search(
                        addappbar: true,
                      ),
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
        backgroundColor: const Color(0xffF8F8FA),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              pageLocationHeader(),
              search(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 2),
                child: Text(
                  'Upcoming Events',
                  style: GoogleFonts.manrope(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: eventsRef.doc('All').collection('events').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      print('object');
                      return const SizedBox();
                    }

                    List<EventsPageModel> eventlist = [];
                    for (var doc in snapshot.data!.docs) {
                      eventlist.add(EventsPageModel.fromDocument(
                          doc, ref.read(schoolsDropdown.currentValue), user.uid));
                    }
                    return Center(
                        child: Column(
                      children: eventlist,
                    ));
                  }),
              StreamBuilder<QuerySnapshot>(
                  stream: eventsRef
                      .doc(ref.read(schoolsDropdown.currentValue))
                      .collection('events')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      print('object');
                      return const SizedBox();
                    }

                    List<EventsPageModel> eventlist = [];
                    for (var doc in snapshot.data!.docs) {
                      eventlist.add(EventsPageModel.fromDocument(
                          doc,
                          ref.read(schoolsDropdown.currentValue),
                          user.uid
                      ));
                    }
                    return Center(
                        child: Column(
                      children: eventlist,
                    ));
                  })
            ])));
  }
}

class EventsPageModel extends StatefulWidget {
  final String eventname;
  final String user;
  final String school;
  final String eventmonth;
  final String eventdescription;
  final String eventheaderimage;
  final String organizerimage;
  final Timestamp eventdate;
  final String eventid;
  final String organizername;
  final String timebegin;
  final String timeend;
  final List eventimages;

  final List favouriteslist;
  final int favouritescount;
  final String eventlocation;
  final String eventgps;
  final String eventdateday;
  final int eventprice;

  final bool lockevent;
  final bool eticket;
  final bool physicalticket;
  final bool issellingtickets;

  const EventsPageModel(
      {Key? key,
      required this.eventmonth,
      required this.eticket,
      required this.physicalticket,
      required this.eventdateday,
      required this.issellingtickets,
      required this.eventheaderimage,
      required this.user,
      required this.school,
      required this.lockevent,
      required this.eventprice,
      required this.eventdate,
      required this.eventdescription,
      required this.eventid,
      required this.eventimages,
      required this.eventname,
      required this.eventgps,
      required this.eventlocation,
      required this.favouritescount,
      required this.favouriteslist,
      required this.organizername,
      required this.organizerimage,
      required this.timebegin,
      required this.timeend})
      : super(key: key);

  factory EventsPageModel.fromDocument(DocumentSnapshot doc, school, user) {
    return EventsPageModel(
        user: user,
        school: school,
        issellingtickets: doc.get('issellingticket'),
        physicalticket: doc.get('physicalticket_available'),
        eticket: doc.get('eticket_available'),
        eventmonth: doc.get('eventmonth'),
        eventdateday: doc.get('eventdate_day'),
        eventheaderimage: doc.get('eventheaderimage'),
        organizerimage: doc.get('organizerimage'),
        lockevent: doc.get('lockevent'),
        eventprice: doc.get('eventprice'),
        eventdate: doc.get('eventdate'),
        eventdescription: doc.get('eventdescription'),
        eventid: doc.get('eventid'),
        eventimages: doc.get('eventimages'),
        eventname: doc.get('eventname'),
        eventgps: doc.get('eventgps'),
        eventlocation: doc.get('eventlocation'),
        favouritescount: doc.get('favourite_count'),
        favouriteslist: doc.get('favourites_list'),
        organizername: doc.get('organizername'),
        timebegin: doc.get('time_begin'),
        timeend: doc.get('time_end'));
  }

  @override
  State<EventsPageModel> createState() => _EventsPageModelState();
}

class _EventsPageModelState extends State<EventsPageModel> {
  int eventgoers = 0;
  @override
  void initState() {
    super.initState();
    checkfavorites();
    geteventgoers();
    setState(() {
      favoritecount = widget.favouritescount;
    });
  }

  bool isliked = false;
  int favoritecount = 0;

  geteventgoers() async {
    QuerySnapshot snapshot = await eventTicketsPurchaseRef
        .doc(widget.eventid)
        .collection('Purchases')
        .where('status', isEqualTo: 'Active')
        .get();
    for (var element in snapshot.docs) {
      eventgoers = eventgoers + 1;
    }
  }

  updatefavourites() {
    if (isliked == true) {
      widget.favouriteslist.remove(widget.user);
      favoritecount -= 1;

      setState(() {
        isliked = !isliked;
      });
    } else {
      widget.favouriteslist.add(widget.user);
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
        .doc(widget.eventid)
        .update({'favourites_list': widget.favouriteslist});
    eventsRef
        .doc('All')
        .collection('events')
        .doc(widget.eventid)
        .update({'favourite_count': favoritecount});
    eventsRef
        .doc(widget.school)
        .collection('events')
        .doc(widget.eventid)
        .update({'favourites_list': widget.favouriteslist});
    eventsRef
        .doc(widget.school)
        .collection('events')
        .doc(widget.eventid)
        .update({'favourite_count': favoritecount});
  }

  checkfavorites() {
    for (var element in widget.favouriteslist) {
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

  eventModelImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 9.0, right: 9, top: 9),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(children: [
            SizedBox(
                child: CachedNetworkImage(
              imageUrl: widget.eventheaderimage,
              height: 131,
              width: MediaQuery.of(context).size.width * 0.9,
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
                      child: Text(
                        '${widget.eventdate.toDate().day} ${widget.eventmonth}',
                        style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
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
    return widget.lockevent
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
                      builder: (context) => Event(
                        eventlocationdescription: widget.eventgps,
                        eventlocation: widget.eventlocation,
                        userid: widget.user,
                        issellingtickets: widget.issellingtickets,
                        eticket: widget.eticket,
                        school: widget.school,
                        eventid: widget.eventid,
                        physicalticket: widget.physicalticket,
                        eventdateday: widget.eventdateday,
                        eventprice: widget.eventprice,
                        images: widget.eventimages,
                        timebegin: widget.timebegin,
                        timeend: widget.timeend,
                        eventdate: widget.eventdate,
                        eventmonth: widget.eventmonth,
                        eventdescription: widget.eventdescription,
                        eventheaderimage: widget.eventheaderimage,
                        eventname: widget.eventname,
                        organizerimage: widget.organizerimage,
                        organizername: widget.organizername,
                      ),
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xffF9FAFB))),
                height: 255,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      eventModelImage(),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 14.0, left: 16, right: 50),
                        child: SizedBox(
                            child: Text(
                          widget.eventname,
                          maxLines: 1,
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        )),
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
                            Text(
                              '+${5 + eventgoers.round()} going',
                              style: GoogleFonts.manrope(
                                  color: const Color(0xff4B4EFC),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12),
                            ),
                          ],
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 14.0, left: 16, right: 50),
                        child: SizedBox(
                            child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xff6B7280),
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7.0),
                              child: Text(
                                widget.eventlocation,
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: const Color(0xff6B7280)),
                              ),
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
