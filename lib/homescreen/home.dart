import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/admin/admin.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/delivery/deliveryonboarding.dart';
import 'package:fairstores/events/eventshome.dart';
import 'package:fairstores/food/foodpage.dart';
import 'package:fairstores/homescreen/notifications.dart';
import 'package:fairstores/homescreen/search.dart';
import 'package:fairstores/main.dart';
import 'package:fairstores/products/productonboarding.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  final String user;
  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getschool();
    getmanager();
  }

  getmanager() async {
    DocumentSnapshot snapshot = await userref.doc(widget.user).get();
    UserModel model = UserModel.fromDocument(snapshot);
    setState(() {
      ismanager = model.ismanager;
    });
  }

  bool ismanager = false;
  UserModel model = UserModel(ismanager: false);

  getschool() async {
    DocumentSnapshot doc = await userref.doc(widget.user).get();
    UserModel model = UserModel.fromDocument(doc);
    setState(() {
      this.model = model;
    });
  }

  search() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Center(
        child: SizedBox(
          height: 43,
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Search(
                        addappbar: true,
                        user: widget.user,
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

  homeHeader() {
    return StreamBuilder<DocumentSnapshot>(
        stream: userref.doc(widget.user).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 60.0, left: 20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 23,
                    backgroundImage: AssetImage("images/profileimage.jpg"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          UserModel userModel = UserModel.fromDocument(snapshot.data!);
          return Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 23,
                  backgroundImage: AssetImage("images/profileimage.jpg"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                      userModel.name == null
                          ? const SizedBox()
                          : Text(
                              userModel.name.toString(),
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.black),
                            ),
                    ],
                  ),
                ),
                Expanded(child: const SizedBox()),
                Row(
                  children: [
                    ismanager == true
                        ? IconButton(
                            icon: const Icon(Icons.admin_panel_settings),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Admin(),
                                  ));
                            },
                          )
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    IconButton(
                      icon: const Icon(Icons.notifications_on_outlined),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Notifications(
                                user: widget.user,
                              ),
                            ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  restuarantsbutton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FoodPage(user: widget.user, school: model.school.toString()),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xffFEF6E9)),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.14,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text(
                'Restuarant',
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            Expanded(child: const SizedBox()),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Image.asset('images/restuarantlogo.png'),
            )
          ],
        ),
      ),
    );
  }

  deliverybutton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DeliveryOnboarding(),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xffFEEFEC)),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.27,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                      'Delivery',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 11.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset("images/deliverylogo.png"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  eventsbutton() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventsPage(
                        user: widget.user,
                        school: model.school.toString(),
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xffECF9EB)),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.27,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Text(
                        'FairEvents',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: const SizedBox(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 11.0, right: 13.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset("images/fairevents.png"),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  productsbutton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductOnboardingScreen(),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xffFEF6E9)),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.14,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22.0),
              child: Text(
                'Products',
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            Expanded(child: const SizedBox()),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Image.asset('images/producticon.png'),
            )
          ],
        ),
      ),
    );
  }

  homebuttons() {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: SizedBox(
        child: Center(
          child: Column(
            children: [
              restuarantsbutton(),
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [deliverybutton(), eventsbutton()],
                ),
              ),
              productsbutton()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          homeHeader(),
          search(),
          homebuttons(),
        ]),
      ),
    );
  }
}
