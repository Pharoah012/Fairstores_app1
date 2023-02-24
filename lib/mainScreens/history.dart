import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/mainScreens/historyfooddetails.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/eventshome.dart';
import 'package:fairstores/food/foodpage.dart';
import 'package:fairstores/food/foodtile.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/eventHistoryTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class History extends ConsumerStatefulWidget {

  const History({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<History> createState() => _HistoryState();
}

class _HistoryState extends ConsumerState<History> {
  List<bool> isvisible = [true, false];
  dynamic delivery = 0;
  String deliverytime = '';
  double taxes = 0;
  double servicecharge = 0;

  @override
  void initState() {
    super.initState();
  }


  String page = 'food';

  historyBlank() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.12,
          ),
          Image.asset('images/blankhistory.png'),
          Padding(
            padding: const EdgeInsets.only(top: 21.0),
            child: Text(
              "No Orders Yet",
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700, fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 8, right: 8),
            child: Text(
              'When you place your first it will\n appear here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                  color: const Color(0xff8B8380),
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(100)
              ),
              height: 50,
              width: 140,
              child: MaterialButton(
                  onPressed: () {
                    if (page == 'food') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodPage(
                                user: ref.read(authProvider).currentUser!.uid,
                                school: ref.read(userProvider).school!,
                          ))
                      );
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventsPage(
                                user: ref.read(authProvider).currentUser!.uid,
                                school:ref.read(userProvider).school!,
                          ))
                    );
                    }
                  },
                  child: Center(
                      child: Text(
                    page == 'food' ? 'Find Food' : 'Find Event',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.white),
                  ))),
            ),
          ),
        ],
      ),
    );
  }

  pagedisplay(page) {
    if (page == 'food') {
      return Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: transactionsRef
                  .where('userid', isEqualTo: ref.read(authProvider).currentUser!.uid,)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                List<ActiveOrderTile> activeorders = [];

                for (var element in snapshot.data!.docs) {
                  activeorders.add(ActiveOrderTile.fromDocument(
                    element,
                    ref.read(authProvider).currentUser!.uid,
                      ref.read(userProvider).school
                  ));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    activeorders.isEmpty
                        ? const SizedBox(
                            height: 0,
                            width: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 10),
                            child: Text('Active Orders',
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                          ),
                    activeorders.isEmpty
                        ? const SizedBox(
                            height: 0,
                            width: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 10, right: 20),
                            child: SizedBox(
                              child: Column(children: activeorders),
                            ),
                          ),
                    StreamBuilder<QuerySnapshot>(
                        stream: historyRef
                            .doc(ref.read(authProvider).currentUser!.uid,)
                            .collection('foodhistory')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          List<HistoryTile> activeorders = [];

                          for (var element in snapshot.data!.docs) {
                            activeorders.add(
                              HistoryTile.fromDocument(
                                element,
                                ref.read(authProvider).currentUser!.uid,
                                ref.read(userProvider).school
                              )
                            );
                          }

                          return activeorders.isEmpty
                              ? historyBlank()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 28),
                                      child: Text(
                                        'History',
                                        style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Column(
                                      children: activeorders,
                                    )
                                  ],
                                );
                        }),
                  ],
                );
              }),
        ],
      );
    } else if (page == 'events') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: eventTicketsPurchaseRef
                    .where('userid', isEqualTo: ref.read(authProvider).currentUser!.uid,)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('');
                  }

                  List<EventHistoryTile> eventpurchaseslist = [];

                  for (var element in snapshot.data!.docs) {
                    eventpurchaseslist
                        .add(EventHistoryTile.fromDocument(element));
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10, bottom: 7),
                        child: Row(
                          children: [
                            eventpurchaseslist.isEmpty
                                ? const SizedBox(
                                    height: 0,
                                    width: 0,
                                  )
                                : Text('Pending Tickets',
                                    style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                          ],
                        ),
                      ),
                      Column(
                        children: eventpurchaseslist,
                      ),
                    ],
                  );
                }),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: eventhistoryRef
                  .doc(ref.read(authProvider).currentUser!.uid,)
                  .collection('history')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('');
                }

                List<ListTile> eventpurchaseslist = [];
                for (var element in snapshot.data!.docs) {
                  eventpurchaseslist.add(ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                    ),
                  ));
                }
                return eventpurchaseslist.isEmpty
                    ? historyBlank()
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 15),
                            child: Row(
                              children: [
                                Text('Tickets',
                                    style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ],
                            ),
                          ),
                          Column(
                            children: eventpurchaseslist,
                          )
                        ],
                      );
              }),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 51.0, left: 25),
            child: Text(
              'History',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700, fontSize: 22),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 12),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.62,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xfff25e37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isvisible = [true, false];
                            page = 'food';
                          });
                        },
                        child: Container(
                            height: 33.6,
                            width: 100,
                            decoration: BoxDecoration(
                              color: isvisible[0] == true
                                  ? kPrimary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                                child: Text(
                              'Food',
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: isvisible[0] == true
                                      ? Colors.white
                                      : Colors.black),
                            ))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 13.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isvisible = [false, true];
                            page = 'events';
                          });
                        },
                        child: Container(
                            height: 33.6,
                            width: 100,
                            decoration: BoxDecoration(
                              color: isvisible[1] == true
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
                                  color: isvisible[1] == true
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
          pagedisplay(page),
        ],
      )),
    );
  }
}

class ActiveOrderTile extends StatefulWidget {
  final String deliverylocation;
  final String instructions;
  final String orderid;
  final String shopid;
  final List orderdetails;
  final String user;
  final String school;
  final String paymentStatus;
  final String status;
  final dynamic total;
  final Timestamp timestamp;

  const ActiveOrderTile(
      {Key? key,
      required this.deliverylocation,
      required this.instructions,
      required this.school,
      required this.user,
      required this.orderdetails,
      required this.orderid,
      required this.paymentStatus,
      required this.shopid,
      required this.status,
      required this.timestamp,
      required this.total})
      : super(key: key);

  factory ActiveOrderTile.fromDocument(DocumentSnapshot doc, user, school) {
    return ActiveOrderTile(
        user: user,
        school: school,
        deliverylocation: doc.get('deliverylocation'),
        instructions: doc.get('instructions'),
        orderdetails: doc.get('orderdetails'),
        orderid: doc.get('orderid'),
        paymentStatus: doc.get('paymentStatus'),
        shopid: doc.get('shopid'),
        status: doc.get('status'),
        timestamp: doc.get('timestamp'),
        total: doc.get('total'));
  }

  @override
  State<ActiveOrderTile> createState() => _ActiveOrderTileState();
}

class _ActiveOrderTileState extends State<ActiveOrderTile> {
  FoodTile foodtile = const FoodTile(
      rating: 1,
      headerimage: '',
      logo: '',
      location: '',
      lockshop: false,
      favouritescount: 1,
      school: '',
      tilecategory: '',
      user: '',
      tilename: '',
      tileid: '',
      deliveryavailable: true,
      pickupavailable: true,
      favourites: [],
      tiledistancetime: '',
      tileprice: 0);
  @override
  void initState() {
    super.initState();
    getshop();
  }

  getshop() async {
    DocumentSnapshot doc = await jointsRef
        .doc(widget.school)
        .collection('Joints')
        .doc(widget.shopid)
        .get();
    FoodTile foodtile = FoodTile.fromDocument(doc, '', '');
    setState(() {
      this.foodtile = foodtile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: const Color(0xffE5E7EB))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          foodtile.headerimage,
                        )),
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodtile.tilename,
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  Text(
                    timeago.format(widget.timestamp.toDate()),
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w500, fontSize: 10),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryFoodDetail(
                                    orderdetails: widget.orderdetails,
                                    deliverylocation: widget.deliverylocation,
                                    status: widget.status,
                                    ordertotal: widget.total,
                                    foodTile: foodtile,
                                    school: widget.school,
                                    user: widget.user,
                                  ),
                                ));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.045,
                            decoration: BoxDecoration(
                                color: kPrimary,
                                borderRadius: BorderRadius.circular(100),
                                border:
                                    Border.all(color: const Color(0xffE7E4E4))),
                            child: Center(
                              child: Text('Order Details',
                                  style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryTile extends StatefulWidget {
  final String deliverylocation;
  final String orderid;
  final List orderdetails;
  final String user;
  final String school;
  final String status;
  final String shopid;
  final dynamic total;
  final Timestamp timestamp;

  const HistoryTile(
      {Key? key,
      required this.deliverylocation,
      required this.school,
      required this.shopid,
      required this.user,
      required this.orderdetails,
      required this.orderid,
      required this.status,
      required this.timestamp,
      required this.total})
      : super(key: key);

  factory HistoryTile.fromDocument(DocumentSnapshot doc, user, school) {
    return HistoryTile(
        user: user,
        school: school,
        shopid: doc.get('shopid'),
        deliverylocation: doc.get('deliverylocation'),
        orderdetails: doc.get('orderdetails'),
        orderid: doc.get('orderid'),
        status: doc.get('status'),
        timestamp: doc.get('timestamp'),
        total: doc.get('total'));
  }

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  @override
  void initState() {
    super.initState();
    getshop();
  }

  FoodTile foodtile = const FoodTile(
      rating: 1,
      headerimage: '',
      logo: '',
      location: '',
      lockshop: false,
      favouritescount: 1,
      school: '',
      tilecategory: '',
      user: '',
      tilename: '',
      tileid: '',
      deliveryavailable: true,
      pickupavailable: true,
      favourites: [],
      tiledistancetime: '',
      tileprice: 0);

  getshop() async {
    DocumentSnapshot doc = await jointsRef
        .doc(widget.school)
        .collection('Joints')
        .doc(widget.shopid)
        .get();
    FoodTile foodtile = FoodTile.fromDocument(doc, '', '');
    setState(() {
      this.foodtile = foodtile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryFoodDetail(
                orderdetails: widget.orderdetails,
                deliverylocation: widget.deliverylocation,
                status: widget.status,
                ordertotal: widget.total,
                foodTile: foodtile,
                school: widget.school,
                user: widget.user,
              ),
            ));
      },
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          foodtile.headerimage.toString(),
                        )),
                    borderRadius: BorderRadius.circular(12)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 11.0, top: 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      foodtile.tilename,
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Row(children: [
                      Text(
                        timeago.format(widget.timestamp.toDate()),
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w500, fontSize: 10),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const CircleAvatar(
                        radius: 1,
                        backgroundColor: Colors.black,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.status,
                        style: GoogleFonts.manrope(
                            color: widget.status == 'Success'
                                ? const Color(0xff1F8B24)
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 10),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text('GHS ${widget.total}',
                          style: GoogleFonts.manrope(
                              color: kPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
