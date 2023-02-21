import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodbag.dart';
import 'package:fairstores/food/foodcartmodel.dart';
import 'package:fairstores/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class FoodOptions extends StatefulWidget {
  final String mealheader;
  final String mealname;
  final String mealdescription;
  final String mealid;
  final int mealprice;
  final String categoryid;
  final String school;
  final String shopid;
  final String userid;

  const FoodOptions(
      {Key? key,
      required this.mealid,
      required this.school,
      required this.shopid,
      required this.categoryid,
      required this.mealprice,
      required this.mealname,
      required this.userid,
      required this.mealheader,
      required this.mealdescription})
      : super(key: key);

  @override
  State<FoodOptions> createState() => _FoodOptionsState();
}

class _FoodOptionsState extends State<FoodOptions> {
  bool isrequired = false;
  bool selected = false;

  String orderid = const Uuid().v4();
  TextEditingController instructioncontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    openorder();
  }

  openorder() {
    //open order to be prepared
    foodcartref.doc(widget.userid).collection('Orders').doc(orderid).set({
      'cartid': 'cart${widget.userid}',
      'orderid': orderid,
      'shopid': widget.shopid,
      'sides': [],
      'ordername': widget.mealname,
      'isrequired': false,
      'total': widget.mealprice,
      'status': '',
      'instructions': '',
      'image': widget.mealheader,
      'quantity': 1,
      'userid': widget.userid
    });
  }

  closeorder() async {
    //open order to be prepared
    DocumentSnapshot snapshot = await foodcartref
        .doc(widget.userid)
        .collection('Orders')
        .doc(orderid)
        .get();
    FoodCartModel foodCartModel =
        FoodCartModel.fromDocument(snapshot, widget.userid);
    if (foodCartModel.status == '') {
      snapshot.reference.delete();
    } else {}
  }

  optionsheader() {
    return Padding(
      padding: const EdgeInsets.only(top: 23.0, left: 20, right: 20),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      widget.mealheader,
                    ))),
            width: MediaQuery.of(context).size.width,
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
                closeorder();
              },
              icon: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffE7E4E4)),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: const Icon(
                  Icons.close,
                  size: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  optionDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mealname,
            style:
                GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          Text(
            "GHC ${widget.mealprice}",
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: const Color(0xff8B8380)),
          ),
          Text(
            widget.mealdescription,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  sideOptionHeader() {
    // print(widget.shopid);
    // print(widget.categoryid);
    // print(widget.mealid);
    return StreamBuilder<QuerySnapshot>(
        stream: menuref
            .doc(widget.shopid)
            .collection('categories')
            .doc(widget.categoryid)
            .collection('options')
            .doc(widget.mealid)
            .collection('sideoptions')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          List<Column> optionslist = [];
          List maxitems = [];

          for (var doc in snapshot.data!.docs) {
            SideMenuOption jointmenucategory = SideMenuOption.fromDocument(doc);

            maxitems.add(jointmenucategory.maxitems);

            optionslist.add(Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: const Color(0xffF7F7F9),
                    child: Center(
                        child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            jointmenucategory.name,
                            style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        jointmenucategory.isrequired == true
                            ? Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      'Required',
                                      style: GoogleFonts.manrope(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  width: 63,
                                  height: 27,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: const Color(0xff8B8380)
                                          .withOpacity(0.1)),
                                ),
                              )
                            : const SizedBox()
                      ],
                    )),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: menuref
                        .doc(widget.shopid)
                        .collection('categories')
                        .doc(widget.categoryid)
                        .collection('options')
                        .doc(widget.mealid)
                        .collection('sideoptions')
                        .doc(jointmenucategory.id)
                        .collection('items')
                        .snapshots(),
                    // stream: sideoptions.doc(widget.shopid).collection('SideMenuOption').doc(widget.).snapshots(),
                    builder: ((context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }

                      List<Widget> sideMenuOptionlist = [];
                      for (var doc in snapshot.data!.docs) {
                        sideMenuOptionlist.add(SideOption.fromDocument(
                            doc,
                            widget.shopid,
                            orderid,
                            widget.userid,
                            jointmenucategory.isrequired,
                            jointmenucategory.index,
                            widget.mealprice));
                      }
                      return Column(
                        children: sideMenuOptionlist,
                      );
                    }))
              ],
            ));
          }

          foodcartref
              .doc(widget.userid)
              .collection('Orders')
              .doc(orderid)
              .update({'maxitems': maxitems});

          return Column(
            children: optionslist,
          );
        });
  }

  checkisrequired() async {
    DocumentSnapshot snapshot = await foodcartref
        .doc(widget.userid)
        .collection('Orders')
        .doc(orderid)
        .get();
    SideslistModel sideslistModel = SideslistModel.fromDocument(snapshot);

    if (sideslistModel.isrequired == false) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select required')));
    } else {
      Navigator.pop(context);
      foodcartref.doc(widget.userid).collection('Orders').doc(orderid).update({
        'status': 'pending',
        'instructions': instructioncontroller.text,
      });

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodBag(
                shopid: widget.shopid,
                user: widget.userid,
                schoolname: widget.school),
          ));
      setState(() {
        orderid = const Uuid().v4();
      });
    }
  }

  optionsbutton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
          ),
          child: Text(
            'Instructions',
            style:
                GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 16),
          child: Text(
            'Let us know if you have specific things in mind',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: const Color(0xff374151)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100)),
              child: TextField(
                controller: instructioncontroller,
                cursorColor: kPrimary,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: kPrimary,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffE7E4E4),
                        ),
                        borderRadius: BorderRadius.circular(100)),
                    label: Text(
                      'Leave a note for the kitchen',
                      style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff374151)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    )),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: kPrimary, borderRadius: BorderRadius.circular(100)),
                height: 56,
                width: MediaQuery.of(context).size.width * 0.9,
                child: MaterialButton(
                    onPressed: () {
                      checkisrequired();

                      // change to view bag button
                    },
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 6.0),
                          child: Icon(
                            Icons.shopping_bag,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        Text(
                          'Add to Bag',
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.white),
                        ),
                      ],
                    ))),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            optionsheader(),
            optionDetails(),
            sideOptionHeader(),
            optionsbutton()
          ])),
    );
  }
}

class SideMenuOption {
  final String id;
  final String name;
  final bool isrequired;
  final int maxitems;
  final int index;

  const SideMenuOption(
      {required this.id,
      required this.isrequired,
      required this.index,
      required this.maxitems,
      required this.name});

  factory SideMenuOption.fromDocument(DocumentSnapshot doc) {
    return SideMenuOption(
        maxitems: doc.get('maxitems'),
        index: doc.get('index'),
        id: doc.get('id'),
        isrequired: doc.get('isrequired'),
        name: doc.get('name'));
  }
}

class SideOption extends StatefulWidget {
  final String id;
  final String name;
  final int mealprice;
  final int price;
  final String shopid;
  final bool isrequired;
  final String orderid;
  final String userid;
  final int indexmaxitems;

  const SideOption(
      {required this.id,
      required this.shopid,
      required this.orderid,
      required this.indexmaxitems,
      required this.userid,
      required this.price,
      required this.mealprice,
      required this.isrequired,
      required this.name});

  factory SideOption.fromDocument(DocumentSnapshot doc, shopid, orderid, userid,
      isrequired, indexmaxitems, mealprice) {
    return SideOption(
        mealprice: mealprice,
        shopid: shopid,
        orderid: orderid,
        isrequired: isrequired,
        userid: userid,
        indexmaxitems: indexmaxitems,
        price: doc.get('price'),
        id: doc.get('id'),
        name: doc.get('name'));
  }

  @override
  State<SideOption> createState() => _SideOptionState();
}

class _SideOptionState extends State<SideOption> {
  bool selected = false;
  int indexmaxitems = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      indexmaxitems = widget.indexmaxitems;
    });

    // getsideslist();
  }

  checkisrequiredsatisfied(istrue) {
    if (widget.isrequired == true) {
      foodcartref
          .doc(widget.userid)
          .collection('Orders')
          .doc(widget.orderid)
          .update({'isrequired': istrue});
    } else {}
  }

  getsideamount(amount) {
    double totalprice = 0;
    totalprice = widget.price.toDouble() - amount;

    return totalprice;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: foodcartref
            .doc(widget.userid)
            .collection('Orders')
            .doc(widget.orderid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          List sidesselection = [];
          List maxitems = [];
          bool isrequired = false;
          dynamic total = 0;

          SideslistModel sideslistModel =
              SideslistModel.fromDocument(snapshot.data!);
          sidesselection = sideslistModel.sides;
          maxitems = sideslistModel.maxitems;
          isrequired = sideslistModel.isrequired;
          total = sideslistModel.total;

          firebaseprocesses() {
            if (selected == true) {
              setState(() {
                selected = !selected;
              });
              total = total - getsideamount(widget.mealprice);
              sidesselection.remove(widget.name);
              maxitems[indexmaxitems] = maxitems[indexmaxitems] + 1;
              checkisrequiredsatisfied(false);
              foodcartref
                  .doc(widget.userid)
                  .collection('Orders')
                  .doc(widget.orderid)
                  .update({'sides': sidesselection});
              foodcartref
                  .doc(widget.userid)
                  .collection('Orders')
                  .doc(widget.orderid)
                  .update({'maxitems': maxitems});
              foodcartref
                  .doc(widget.userid)
                  .collection('Orders')
                  .doc(widget.orderid)
                  .update({'total': total});
            } else if (selected == false) {
              if (maxitems[indexmaxitems] == 0) {
              } else {
                setState(() {
                  selected = !selected;
                });
                total = total + getsideamount(widget.mealprice);
                sidesselection.add(widget.name);
                checkisrequiredsatisfied(true);
                maxitems[indexmaxitems] = maxitems[indexmaxitems] - 1;

                foodcartref
                    .doc(widget.userid)
                    .collection('Orders')
                    .doc(widget.orderid)
                    .update({'sides': sidesselection});
                foodcartref
                    .doc(widget.userid)
                    .collection('Orders')
                    .doc(widget.orderid)
                    .update({'maxitems': maxitems});
                foodcartref
                    .doc(widget.userid)
                    .collection('Orders')
                    .doc(widget.orderid)
                    .update({'total': total});
              }
            } else {}
          }

          return ListTile(
            onTap: firebaseprocesses,
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '+GHC ${getsideamount(widget.mealprice)}',
                    style: GoogleFonts.montserrat(
                        fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                          width: 20,
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: selected == true
                                      ? Colors.grey
                                      : Colors.white),
                              color: selected == true
                                  ? Colors.green
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                          width: 15,
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              widget.name,
              style: GoogleFonts.manrope(
                  fontSize: 14, fontWeight: FontWeight.w600),
            ),
          );
        });
  }
}

class SideslistModel {
  final List sides;
  final bool isrequired;
  final List maxitems;
  final dynamic total;
  final String status;

  SideslistModel(
      {required this.sides,
      required this.status,
      required this.total,
      required this.maxitems,
      required this.isrequired});

  factory SideslistModel.fromDocument(DocumentSnapshot doc) {
    return SideslistModel(
        maxitems: doc.get('maxitems'),
        status: doc.get('status'),
        sides: doc.get('sides'),
        total: doc.get('total'),
        isrequired: doc.get('isrequired'));
  }
}
