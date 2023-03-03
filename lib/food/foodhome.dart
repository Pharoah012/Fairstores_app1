import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/foodbag.dart';
import 'package:fairstores/food/foodcartmodel.dart';
import 'package:fairstores/food/foodsideoptions.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

class Foodhome extends ConsumerStatefulWidget {
  final JointModel joint;

  const Foodhome({
    Key? key,
    required this.joint,
  }) : super(key: key);

  @override
  ConsumerState<Foodhome> createState() => _FoodhomeState();
}

class _FoodhomeState extends ConsumerState<Foodhome> {
  bool isliked = false;
  int favoriteCount = 0;
  String optionpage = '01';
  JointMenuOption jointmenuoption = const JointMenuOption(id: '00', name: '00');

  int count = 1;
  jointLogo() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(
                widget.joint.headerImage,
              ))),
      width: MediaQuery.of(context).size.width,
      height: 200,
    );
  }

  jointHeader() {
    return ListTile(
        subtitle: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                widget.joint.location,
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          ],
        ),
        leading: CircleAvatar(
          backgroundColor: kPrimary,
          radius: 25,
          backgroundImage: NetworkImage(widget.joint.logo),
        ),
        title: Text(widget.joint.name,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            )));
  }

  jointdetails() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 13.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xffF7F7F9)),
            width: MediaQuery.of(context).size.width * 0.9,
            height: 108,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 15,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Rating ${widget.joint.rating}',
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.share_location,
                        size: 15,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          '1.4 kilometers',
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.delivery_dining,
                        size: 15,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Delivery in ${widget.joint.deliveryTime}',
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  jointMenuOptionTile() {
    return StreamBuilder<QuerySnapshot>(
        stream:
            menuRef.doc(widget.joint.jointID).collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          List<Widget> optionslist = [];
          for (var doc in snapshot.data!.docs) {
            JointMenuOption jointmenuoption = JointMenuOption.fromDocument(doc);
            optionslist.add(Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 10),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    optionpage = jointmenuoption.id;
                    this.jointmenuoption = jointmenuoption;
                  });
                },
                child: Column(
                  children: [
                    Text(jointmenuoption.name,
                        style: GoogleFonts.manrope(
                            color: optionpage == jointmenuoption.id
                                ? kPrimary
                                : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.6),
                      child: Container(
                          color: optionpage == jointmenuoption.id
                              ? kPrimary
                              : const Color(0xffF7F7F9),
                          height: 2,
                          width: 20),
                    )
                  ],
                ),
              ),
            ));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              color: const Color(0xffF7F7F9),
              width: MediaQuery.of(context).size.width,
              height: 52,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: ListView(
                    scrollDirection: Axis.horizontal, children: optionslist),
              ),
            ),
          );
        });
  }

  jointMenu() {
    return StreamBuilder<QuerySnapshot>(
        stream: menuRef
            .doc(widget.joint.jointID)
            .collection('categories')
            .doc(optionpage)
            .collection('options')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          List<OptionsTile> optionslist = [];
          for (var doc in snapshot.data!.docs) {
            optionslist.add(OptionsTile.fromDocument(doc, ref.read(userProvider).school!,
                widget.joint.jointID, optionpage, ref.read(userProvider).uid, jointmenuoption.name));
          }
          return Column(
            children: optionslist,
          );
        });
  }

  itemInCart() {
    return StreamBuilder<QuerySnapshot>(
        stream: foodCartRef
            .doc(ref.read(userProvider).uid)
            .collection('Orders')
            .where('shopid', isEqualTo: widget.joint.jointID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          List<Text> foodcartlist = [];
          itemplural() {
            String plural = 'Item';
            if (foodcartlist.length == 1) {
              plural = 'Item';
              return 'Item';
            } else if (foodcartlist.isEmpty) {
              return 0;
            } else {
              plural = 'Items';
              return plural;
            }
          }

          for (var doc in snapshot.data!.docs) {
            foodcartlist.add(const Text('available'));
          }
          return foodcartlist.isEmpty
              ? const SizedBox()
              : Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 18, bottom: 27),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff010F07).withOpacity(0.12),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 20), // changes position of shadow
                        ),
                      ],
                      color: kPrimary,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: MaterialButton(
                      onPressed: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodBag(
                                shopid: widget.joint.jointID,
                                user: ref.read(userProvider).uid,
                                schoolname: ref.read(userProvider).school!,
                              ),
                            ));
                      }),
                      child: Row(children: [
                        Image.asset('images/shoppingcart.png'),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'View Cart',
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.64)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(widget.joint.name,
                                    style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                        Expanded(child: const SizedBox()),
                        Text(
                          '${foodcartlist.length} ${itemplural()}',
                          style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )
                      ]),
                    ),
                  ),
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
        actions: [
          IconButton(
              onPressed: (){

              },
              icon: Icon(
                Icons.favorite_outline,
                color: isliked == true ? kPrimary : Colors.black,
              ))
        ],
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
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(children: [
              jointLogo(),
              jointHeader(),
              jointdetails(),
              jointMenuOptionTile(),
              jointMenu()
            ]),
          ),
          itemInCart()
        ],
      ),
    );
  }
}

class JointMenuOption {
  final String id;
  final String name;

  const JointMenuOption({required this.id, required this.name});

  factory JointMenuOption.fromDocument(DocumentSnapshot doc) {
    return JointMenuOption(id: doc.get('id'), name: doc.get('name'));
  }
}

class OptionsTile extends StatefulWidget {
  final String id;
  final String name;
  final int price;
  final String description;
  final bool hassides;
  final String school;
  final String shopid;
  final String categoryid;
  final String tileimage;
  final String userid;
  final String ordername;

  // ignore: use_key_in_widget_constructors
  const OptionsTile(
      {required this.hassides,
      required this.description,
      required this.shopid,
      required this.school,
      required this.ordername,
      required this.tileimage,
      required this.categoryid,
      required this.userid,
      required this.id,
      required this.price,
      required this.name});

  factory OptionsTile.fromDocument(
      DocumentSnapshot doc, school, shopid, categoryid, userid, ordername) {
    return OptionsTile(
        school: school,
        categoryid: categoryid,
        userid: userid,
        shopid: shopid,
        ordername: ordername,
        hassides: doc.get('hassides'),
        tileimage: doc.get('image'),
        description: doc.get('description'),
        price: doc.get('price'),
        id: doc.get('id'),
        name: doc.get('name'));
  }

  @override
  State<OptionsTile> createState() => _OptionsTileState();
}

class _OptionsTileState extends State<OptionsTile> {
  int count = 1;
  SideMenuCategoryOption sideoptions = const SideMenuCategoryOption();
  String orderid = const Uuid().v4();

  @override
  void initState() {
    super.initState();
    getoptions();
  }

  cartavailabiltypopup(parentcontext) {
    showDialog(
        barrierDismissible: false,
        context: parentcontext,
        builder: (context) {
          return AlertDialog(
              title: Center(
                  child: Text(
                'Cart',
                style: GoogleFonts.montserrat(
                    color: kPrimary, fontWeight: FontWeight.bold),
              )),
              actions: [
                Text(
                  'Your cart is currently being used by another joint. Do you want to clear it?',
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  onPressed: () async {
                    QuerySnapshot snapshot = await foodCartRef
                        .doc(widget.userid)
                        .collection('Orders')
                        .get();
                    for (var e in snapshot.docs) {
                      e.reference.delete();
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Center(
                      child: Text(
                    'Clear Cart',
                    style: TextStyle(color: kPrimary),
                  )),
                )
              ]);
        });
  }

  checkcartavailability() async {
    QuerySnapshot snapshot = await foodCartRef
        .doc(widget.userid)
        .collection('Orders')
        .where('shopid', isNotEqualTo: widget.shopid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      cartavailabiltypopup(context);
      return false;
    } else {}
    return true;
  }

  closeorder() async {
    //open order to be prepared
    DocumentSnapshot snapshot = await foodCartRef
        .doc(widget.userid)
        .collection('Orders')
        .doc(orderid)
        .get();
    FoodCartModel foodCartModel =
        FoodCartModel.fromDocument(snapshot, widget.userid);
    if (foodCartModel.status == '') {
      snapshot.reference.delete();
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  getoptions() async {
    DocumentSnapshot snapshot = await menuRef
        .doc(widget.shopid)
        .collection('categories')
        .doc(widget.categoryid)
        .collection('options')
        .doc(widget.id)
        .collection('sideoptions')
        .doc('01')
        .get();

    if (!snapshot.exists) {
    } else {
      setState(() {
        sideoptions = SideMenuCategoryOption.fromDocument(snapshot);
      });
    }
  }

  orderfood() {
    if (widget.hassides == false) {
      checkcartavailability();
      foodCartRef.doc(widget.userid).collection('Orders').doc(orderid).set({
        'cartid': 'cart${widget.userid}',
        'orderid': orderid,
        'shopid': widget.shopid,
        'sides': [],
        'ordername': widget.name,
        'isrequired': false,
        'total': widget.price,
        'status': '',
        'instructions': '',
        'image': widget.tileimage,
        'quantity': 1,
        'userid': widget.userid
      });
      showMaterialModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => SizedBox(
          height: 436,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 21.0,
                ),
                child: Stack(alignment: Alignment.topRight, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.tileimage,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: IconButton(
                      onPressed: () {
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
                          Icons.close_outlined,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                  widget.name,
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  widget.description,
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: const Color(0xff8B8380)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'GHS ${widget.price}',
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 56,
                        child: MaterialButton(
                            onPressed: null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side:
                                    const BorderSide(color: Color(0xffE7E4E4))),
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: foodCartRef
                                    .doc(widget.userid)
                                    .collection('Orders')
                                    .doc(orderid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.0),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: const Icon(Icons.remove,
                                                  size: 20,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Text(
                                            '1',
                                            style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: const Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ]);
                                  }

                                  FoodCartModel foodCartModel =
                                      FoodCartModel.fromDocument(
                                          snapshot.data!, widget.userid);
                                  int count = foodCartModel.quantity;

                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 0),
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (count == 1) {
                                                  } else {
                                                    count -= 1;
                                                    foodCartRef
                                                        .doc(widget.userid)
                                                        .collection('Orders')
                                                        .doc(orderid)
                                                        .update({
                                                      'quantity': count
                                                    });
                                                  }
                                                });
                                              },
                                              icon: const Icon(Icons.remove,
                                                  size: 20,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Text(
                                            '$count',
                                            style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0),
                                            child: IconButton(
                                              onPressed: () {
                                                count += 1;
                                                foodCartRef
                                                    .doc(widget.userid)
                                                    .collection('Orders')
                                                    .doc(orderid)
                                                    .update(
                                                        {'quantity': count});
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ]);
                                  });
                                }))),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 14.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(100)),
                        height: 56,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: MaterialButton(
                            onPressed: () {
                              foodCartRef
                                  .doc(widget.userid)
                                  .collection('Orders')
                                  .doc(orderid)
                                  .update({'status': 'pending'});
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FoodBag(
                                      shopid: widget.shopid,
                                      user: widget.userid,
                                      schoolname: widget.school,
                                    ),
                                  ));
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
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      );
    } else if (widget.hassides == true) {
      checkcartavailability();

      showBarModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.90,
            child: FoodOptions(
              userid: widget.userid,
              mealheader: widget.tileimage,
              mealdescription: widget.description,
              mealname: widget.name,
              mealid: widget.id,
              mealprice: widget.price,
              school: widget.school,
              shopid: widget.shopid,
              categoryid: widget.categoryid,
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 24),
      child: GestureDetector(
        onTap: (() {
          orderfood();
        }),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.tileimage,
                fit: BoxFit.cover,
                width: 76,
                height: 76,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name,
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(widget.description,
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w400, fontSize: 10)),
                    const SizedBox(
                      height: 2,
                    ),
                    Text("GHC ${widget.price.toDouble()}",
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600, fontSize: 10)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SideMenuCategoryOption {
  final String? id;
  final String? name;

  const SideMenuCategoryOption({this.id, this.name});

  factory SideMenuCategoryOption.fromDocument(DocumentSnapshot doc) {
    return SideMenuCategoryOption(id: doc.get('id'), name: doc.get('name'));
  }
}
