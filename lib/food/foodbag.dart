import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodcartmodel.dart';
import 'package:fairstores/food/foodcheckout.dart';
import 'package:fairstores/food/foodtile.dart';
import 'package:fairstores/mainScreens/securitymodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodBag extends StatefulWidget {
  final String shopid;
  final String user;
  final String schoolname;

  const FoodBag(
      {Key? key,
      required this.shopid,
      required this.schoolname,
      required this.user})
      : super(key: key);

  @override
  State<FoodBag> createState() => _FoodBagState();
}

class _FoodBagState extends State<FoodBag> {
  dynamic delivery = 0;
  String deliverytime = '';
  bool deliveryavailable = false;
  bool pickupavailable = false;
  double taxes = 0;
  double servicecharge = 0;
  @override
  void initState() {
    super.initState();
    getdeliveryprice();
    getservicecharge();
  }

  getservicecharge() async {
    DocumentSnapshot doc = await securityRef.doc('Security_keys').get();
    SecurityModel securityModel = SecurityModel.fromDocument(doc);
    setState(() {
      taxes = securityModel.taxfee.toDouble();
      servicecharge = securityModel.servicecharge;
    });
  }

  getdeliveryprice() async {
    DocumentSnapshot doc = await jointsRef
        .doc(widget.schoolname)
        .collection('Joints')
        .doc(widget.shopid)
        .get();
    FoodTile foodtile =
        FoodTile.fromDocument(doc, widget.user, widget.schoolname);
    print(foodtile.pickupavailable);
    setState(() {
      delivery = foodtile.tileprice.toDouble();
      deliverytime = foodtile.tiledistancetime;
      deliveryavailable = foodtile.deliveryavailable;
      pickupavailable = foodtile.pickupavailable;
    });
  }

  String page = 'delivery';
  List<bool> visible = [true, false];
  int count = 0;

  setpage() {
    if (page == 'delivery') {
      if (deliveryavailable == true) {
        return getcartitems();
      } else {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            const Text('Delivery Unavailable'),
          ],
        ));
      }
    } else if (page == 'pickup') {
      if (pickupavailable == true) {
        return getcartitems();
      } else {
        return Center(
            child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            const Text('PickUp Unavailable'),
          ],
        ));
      }
    }
  }

  bagheader() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xffF7F7F9),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          visible = [true, false];
                          page = 'delivery';
                        });
                      },
                      child: Stack(alignment: Alignment.center, children: [
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: visible[0],
                          child: Container(
                              height: 38,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              )),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Delivery',
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    color: page == 'delivery'
                                        ? kPrimary
                                        : Colors.black),
                              ),
                              deliveryavailable == true
                                  ? const SizedBox(
                                      width: 0,
                                      height: 0,
                                    )
                                  : Text(
                                      'Not Available',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                          color: page == 'pickup'
                                              ? kPrimary
                                              : Colors.black),
                                    ),
                            ],
                          ),
                        ),
                      ]))),
              Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0),
                  child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7F9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  visible = [false, true];
                                  page = 'pickup';
                                });
                                print(page);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Visibility(
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: visible[1],
                                    child: Container(
                                        height: 38,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Pick Up',
                                          style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12,
                                              color: page == 'pickup'
                                                  ? kPrimary
                                                  : Colors.black),
                                        ),
                                        pickupavailable == true
                                            ? const SizedBox(
                                                width: 0, height: 0)
                                            : Text(
                                                'Not Available',
                                                style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12,
                                                    color: page == 'pickup'
                                                        ? kPrimary
                                                        : Colors.black),
                                              ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ])))
            ])));
  }

  getcartitems() {
    return StreamBuilder<QuerySnapshot>(
        stream: foodCartRef
            .doc(widget.user)
            .collection('Orders')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          }

          List<FoodCartModel> foodcartlist = [];
          for (var doc in snapshot.data!.docs) {
            foodcartlist.add(FoodCartModel.fromDocument(doc, widget.user));
          }
          return Column(
            children: foodcartlist,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Your bag',
            style: GoogleFonts.manrope(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 12,
                  ),
                ),
                Text(
                  'Back',
                  style: GoogleFonts.manrope(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [bagheader(), setpage()],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: foodCartRef
                    .doc(widget.user)
                    .collection('Orders')
                    .where('status', isEqualTo: 'pending')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  List<FoodCartModel> foodcartlist = [];
                  dynamic subtotal = 0;
                  dynamic total = 0;
                  for (var doc in snapshot.data!.docs) {
                    FoodCartModel foodCartModel =
                        FoodCartModel.fromDocument(doc, widget.user);
                    subtotal = subtotal +
                        (foodCartModel.price * foodCartModel.quantity);
                    total = subtotal + delivery;
                    foodcartlist
                        .add(FoodCartModel.fromDocument(doc, widget.user));
                  }
                  return DraggableScrollableSheet(
                    initialChildSize: 0.40,
                    minChildSize: 0.1,
                    maxChildSize: 0.40,
                    builder: ((BuildContext context,
                            ScrollController scrollController) =>
                        Container(
                          decoration: BoxDecoration(
                              color: kPrimary,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(21),
                                  topRight: Radius.circular(21))),
                          child:
                              ListView(controller: scrollController, children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: Center(
                                child: Container(
                                  color: Colors.white,
                                  width: 40,
                                  height: 4,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 17),
                              child: Row(
                                children: [
                                  Text('Subtotal',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.white)),
                                  Expanded(child: const SizedBox()),
                                  Text('GHS $subtotal',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.white))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 16),
                              child: Row(
                                children: [
                                  Text('Taxes',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.white)),
                                  Expanded(child: const SizedBox()),
                                  Text('GHC $taxes',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.white))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 16),
                              child: Row(
                                children: [
                                  Text('Service Fee',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.white)),
                                  Expanded(child: const SizedBox()),
                                  Text('GHS ${total * servicecharge}',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.white))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 16),
                              child: Row(
                                children: [
                                  Text('Delivery',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.white)),
                                  Expanded(child: const SizedBox()),
                                  Text('GHS $delivery',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.white))
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 22.0),
                              child: Divider(
                                color: Colors.white,
                                height: 1.7,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 16),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (page == 'delivery' &&
                                          deliveryavailable == true) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FoodCheckout(
                                                userid: widget.user,
                                                shopid: widget.shopid,
                                                deliveryfee: delivery,
                                                taxes: taxes,
                                                total: total,
                                                school: widget.schoolname,
                                                servicecharge: servicecharge,
                                                deliverytime: deliverytime,
                                              ),
                                            ));
                                        print('available');
                                      } else if (page == 'pickup' &&
                                          pickupavailable == true) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FoodCheckout(
                                                userid: widget.user,
                                                shopid: widget.shopid,
                                                deliveryfee: delivery,
                                                taxes: taxes,
                                                total: total,
                                                school: widget.schoolname,
                                                servicecharge: servicecharge,
                                                deliverytime: deliverytime,
                                              ),
                                            ));
                                        print('pick available');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Select an available option')));
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(
                                            Icons.ads_click_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text('Checkout',
                                            style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: const SizedBox()),
                                  Text(
                                      'GHS ${total + taxes + (total * servicecharge)}',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.white))
                                ],
                              ),
                            )
                          ]),
                        )),
                  );
                })
          ],
        ));
  }
}
