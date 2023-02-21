import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/homescreen/history.dart';
import 'package:fairstores/homescreen/home.dart';
import 'package:fairstores/homescreen/profile.dart';
import 'package:fairstores/homescreen/schoolmodel.dart';
import 'package:fairstores/homescreen/search.dart';
import 'package:fairstores/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  final String phonenumber;
  final String password;
  final String signinmethod;

  const HomeScreen(
      {Key? key,
      required this.userId,
      required this.signinmethod,
      required this.password,
      required this.phonenumber})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _auth = FirebaseAuth.instance;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  final _userdetailsformkey = GlobalKey<FormState>();
  List<String> schoollist = [];
  String? selectedValue;
  List list = [];
  bool ismanager = false;

  @override
  void initState() {
    list
      ..add(
        Home(
          user: widget.userId,
        ),
      )
      ..add(
        Search(
          addappbar: false,
          user: widget.userId,
        ),
      )
      ..add(
        History(
          user: widget.userId,
        ),
      )
      ..add(
        Profile(user: widget.userId),
      );
    super.initState();
    checkUserInFirestore();
    schoolList();
    storetokens();
  }

  storetokens() async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    print(osUserID);
    tokensref.doc(widget.userId).set({'devtoken': osUserID});
  }

  late FirebaseMessaging _messaging;

  schoolList() async {
    QuerySnapshot snapshot = await schoolref.get();
    List<String> schoollist = [];
    for (var doc in snapshot.docs) {
      SchoolModel schoolModel = SchoolModel.fromDocument(doc);

      schoollist.add(schoolModel.schoolname);
    }

    setState(() {
      this.schoollist = schoollist;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  checkUserInFirestore() async {
    DocumentSnapshot doc = await userref.doc(_auth.currentUser?.uid).get();

    if (doc.exists) {
    } else if (!doc.exists) {
      return showMaterialModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
        barrierColor: kPrimary,
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Text('Provide Extra Details',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, right: 30, bottom: 30, top: 5),
                child: Text(
                  'Lets lead you right back to your page. Tap the button below',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              Form(
                  key: _userdetailsformkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: SizedBox(
                          height: 56,
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: TextFormField(
                            controller: namecontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please type your name';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: kPrimary,
                                    )),
                                focusColor: kPrimary,
                                labelText: 'Full name',
                                labelStyle: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: const Color(0xff8B8380)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xffE5E5E5),
                                    ),
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: SizedBox(
                          height: 56,
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: TextFormField(
                              controller: emailcontroller,
                              validator: (value) {
                                if (value!.contains('@')) {
                                  return null;
                                } else {
                                  return 'Provide a valid Email';
                                }
                              },
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: kPrimary,
                                      )),
                                  focusColor: kPrimary,
                                  labelText: 'Email',
                                  labelStyle: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: const Color(0xff8B8380)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E5E5),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: SizedBox(
                          height: 56,
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: TextFormField(
                              controller: phonecontroller,
                              validator: (value) {
                                Future<QuerySnapshot> phone = userref
                                    .where('number',
                                        isEqualTo: phonecontroller.text)
                                    .get();

                                if (!value!.startsWith('+')) {
                                  return 'Please start number with country code';
                                } else if (value.isEmpty) {
                                  return 'Provide your number';
                                }
                              },
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: kPrimary,
                                      )),
                                  focusColor: kPrimary,
                                  labelText: 'Phone number',
                                  labelStyle: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: const Color(0xff8B8380)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E5E5),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                            right: 20,
                            left: 20,
                          ),
                          child: SizedBox(
                            height: 56,
                            width: MediaQuery.of(context).size.width * 0.87,
                            child: DropdownButtonFormField<String>(
                                validator: ((value) {
                                  if (value!.isEmpty) {
                                    return null;
                                  } else {
                                    return null;
                                  }
                                }),
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: kPrimary,
                                        )),
                                    focusColor: kPrimary,
                                    labelStyle: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: const Color(0xff8B8380)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xffE5E5E5),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                hint: const Text("Select School"),
                                items: schoollist.map((value) {
                                  return DropdownMenuItem<String>(
                                      child: Text(value), value: value);
                                }).toList(),
                                isExpanded: true,
                                onChanged: (value) {
                                  selectedValue = value;
                                }),
                          ))
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 38.0, bottom: 12),
                child: MaterialButton(
                  onPressed: () async {
                    if (_userdetailsformkey.currentState!.validate()) {
                      await userref
                          .where('number', isEqualTo: phonecontroller.text)
                          .get()
                          .then((value) {
                        if (value.docs.isEmpty) {
                          userref.doc(_auth.currentUser?.uid).set({
                            'ismanager': false,
                            'number': widget.phonenumber == ''
                                ? phonecontroller.text
                                : widget.phonenumber,
                            'uid': widget.userId,
                            'username': namecontroller.text,
                            'school': selectedValue,
                            'timestamp': timestamp,
                            'password': widget.password,
                            'email': emailcontroller.text,
                            'signinmethod': widget.signinmethod,
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Welcome to FairStores')));
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Phone Number already in Use');
                        }
                      });
                    } else {}
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 0,
                  height: 56,
                  minWidth: MediaQuery.of(context).size.width * 0.87,
                  color: kPrimary,
                  child: Text('Continue',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white)),
                ),
              ),
              Expanded(child: SizedBox())
            ]),
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: list[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedItemColor: kPrimary,
            unselectedItemColor: const Color(0xff898989),
            unselectedLabelStyle: GoogleFonts.manrope(),
            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.home_filled,
                  color: kPrimary,
                ),
                icon: const Icon(
                  Icons.home_filled,
                  color: Color(0xff898989),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.search,
                  color: kPrimary,
                ),
                icon: const Icon(
                  Icons.search,
                  color: Color(0xff898989),
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                  activeIcon: Icon(
                    Icons.bookmark,
                    color: kPrimary,
                  ),
                  icon: const Icon(
                    Icons.bookmark,
                    color: Color(0xff898989),
                  ),
                  label: 'History'),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.person,
                  color: kPrimary,
                ),
                icon: const Icon(
                  Icons.person,
                  color: Color(0xff898989),
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ));
  }
}
