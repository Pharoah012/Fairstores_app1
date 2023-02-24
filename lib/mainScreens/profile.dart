import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/authentication/onboardingScreen.dart';
import 'package:fairstores/mainScreens/saveditems.dart';
import 'package:fairstores/mainScreens/securitymodel.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'details.dart';
import 'help.dart';
import 'notifications.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  UserModel model = UserModel(ismanager: false);
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;


  profileheader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0),
        child: Column(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              backgroundImage: AssetImage('images/profileimage.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 19.0),
              child: Text(model.name == null ? '' : model.name.toString(),
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            GestureDetector(
              onTap: () {
                showMaterialModalBottomSheet(
                    barrierColor: kPrimary,
                    context: context,
                    builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: editprofile()),
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(21),
                          topRight: Radius.circular(21)),
                    ));
              },
              child: Text('Edit Profile',
                  style: GoogleFonts.manrope(
                      color: const Color(0xff8B8380),
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
            )
          ],
        ),
      ),
    );
  }

  profilemenu() {
    return FutureBuilder<DocumentSnapshot>(
        future: securityRef.doc('Security_keys').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          SecurityModel securityModel =
              SecurityModel.fromDocument(snapshot.data!);
          return Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Notifications(
                            user: ref.read(authProvider).currentUser!.uid,
                          ),
                        ));
                  },
                  leading: Icon(
                    Icons.notifications,
                    color: kPrimary,
                  ),
                  title: Text('Notifications',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500, fontSize: 14)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SavedItems(
                              user: ref.read(authProvider).currentUser!.uid,
                              school: model.school.toString()),
                        ));
                  },
                  leading: Icon(
                    Icons.bookmark,
                    color: kPrimary,
                  ),
                  title: Text('Saved Items',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500, fontSize: 14)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                ),
                ListTile(
                  onTap: (() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => Help(
                                  securityModel: securityModel,
                                ))));
                  }),
                  leading: Icon(
                    Icons.settings,
                    color: kPrimary,
                  ),
                  title: Text('Help',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500, fontSize: 14)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                ),
                ListTile(
                  onTap: (() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => Details(
                                  details: securityModel.aboutus,
                                  title: 'About Us',
                                ))));
                  }),
                  leading: Icon(
                    Icons.info,
                    color: kPrimary,
                  ),
                  title: Text('About Us',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500, fontSize: 14)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    User? user = _auth.currentUser;

                    _auth.signOut().then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnboardingScreen(),
                        )));
                  },
                  leading: Icon(
                    Icons.logout,
                    color: kPrimary,
                  ),
                  title: Text('Logout',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500, fontSize: 14)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                  ),
                ),
              ],
            ),
          );
        });
  }

  footer() {
    return Column(
      children: [
        Container(
          color: const Color(0xffC3C3C3).withOpacity(0.2),
          height: 1,
          width: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text('App Version 1.0',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: const Color(0xffA0A0A0))),
        )
      ],
    );
  }

  editprofile() {
    return StreamBuilder<DocumentSnapshot>(
        stream: userRef.doc(ref.read(authProvider).currentUser!.uid,).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          UserModel model = UserModel.fromDocument(snapshot.data!);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, right: 20, left: 20, bottom: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel',
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                    Expanded(
                      child: const SizedBox(),
                    ),
                    GestureDetector(
                      onTap: () {
                        showeditdetails(context);
                      },
                      child: Text('Edit',
                          style: GoogleFonts.manrope(
                              color: kPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16)),
                    )
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  'Full Name',
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                trailing: Text(model.name.toString(),
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              ListTile(
                title: Text('Email',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                trailing: Text(model.email.toString(),
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              ListTile(
                title: Text('Phone Number',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                trailing: Text(model.number.toString(),
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              )
            ],
          );
        });
  }

  postDetailsToFirestore(String email, String phonenumber) {
    userRef.doc(ref.read(authProvider).currentUser!.uid,).update({'email': email, 'number': phonenumber});
  }

  showeditdetails(context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(21),
                      topRight: Radius.circular(21),
                      bottomLeft: Radius.circular(21),
                      bottomRight: Radius.circular(21))),
              title: Text('Edit your details',
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w600, fontSize: 20)),
              children: [
                SimpleDialogOption(
                  child: TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                        labelStyle: GoogleFonts.manrope(),
                        label: const Text('email')),
                  ),
                ),
                SimpleDialogOption(
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                        labelStyle: GoogleFonts.manrope(),
                        label: const Text('Phone number')),
                  ),
                ),
                SimpleDialogOption(
                    onPressed: () {
                      postDetailsToFirestore(
                          emailcontroller.text, phoneController.text);
                    },
                    child: Text(
                      'Edit',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    )),
                SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w500, fontSize: 16)))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            profileheader(),
            profilemenu(),
            Expanded(
              child: const SizedBox(),
            ),
            footer(),
            Expanded(
              child: const SizedBox(),
            )
          ],
        ));
  }
}
