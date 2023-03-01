import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/authentication/onboardingScreen.dart';
import 'package:fairstores/mainScreens/saveditems.dart';
import 'package:fairstores/mainScreens/securitymodel.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customSettingsListTile.dart';
import 'package:fairstores/widgets/customText.dart';
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

  profileheader() {
    UserModel user = ref.read(userProvider);

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
              child: CustomText(
                text: user.username ?? "",
                fontSize: 16,
                isMediumWeight: true,
              )
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
              child: CustomText(
                text: "Edit Profile",
                fontSize: 12,
              )
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

        SecurityModel securityModel = SecurityModel.fromDocument(snapshot.data!);
        return Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              CustomSettingsListTile(
                label: 'Notifications',
                icon: Icons.notifications,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notifications(),
                    )
                  );
                },
              ),
              CustomSettingsListTile(
                label: 'Saved Items',
                icon: Icons.bookmark,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedItems(
                            user: ref.read(authProvider).currentUser!.uid,
                            school: ref.read(userProvider).school!),
                      ));
                },
              ),
              CustomSettingsListTile(
                label: 'Help',
                icon: Icons.settings,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => Help(
                          securityModel: securityModel,
                        )
                        )
                    )
                  );
                },
              ),
              CustomSettingsListTile(
                label: 'About Us',
                icon: Icons.info,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => Details(
                          details: securityModel.aboutus,
                          title: 'About Us',
                        )
                        )
                    )
                  );
                }
              ),
              CustomSettingsListTile(
                label: 'Logout',
                icon: Icons.logout,
                onTap: () async {
                  ref.read(authProvider).logout().then((value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OnboardingScreen(),
                    )
                  ));
                },
              ),
            ],
          ),
        );
      }
    );
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
          child: CustomText(
            text: 'App Version 1.1',
            isMediumWeight: true,
          ),
        ),
      ],
    );
  }

  editprofile() {

    UserModel user = ref.read(userProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 16.0, right: 20, left: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CustomText(
                  text: 'Cancel',
                  isMediumWeight: true,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showeditdetails(context);
                },
                child: CustomText(
                  text: 'Edit',
                  isMediumWeight: true,
                  fontSize: 16,
                ),
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
          trailing: Text(user.username.toString(),
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600, fontSize: 14)),
        ),
        ListTile(
          title: Text('Email',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600, fontSize: 14)),
          trailing: Text(user.email.toString(),
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600, fontSize: 14)),
        ),
        ListTile(
          title: Text('Phone Number',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600, fontSize: 14)),
          trailing: Text(user.number.toString(),
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600, fontSize: 14)),
        )
      ],
    );
  }

  postDetailsToFirestore(String email, String phoneNumber) async {
    await ref.read(userProvider).updateProfileDetails(
        email: email,
        phoneNumber: phoneNumber
    );
  }

  showeditdetails(context) {
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                  ),
              ),
              title: CustomText(
                text: "Edit your details",
                fontSize: 20,
              ),
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
                    onPressed: () async  {
                      await postDetailsToFirestore(
                          emailcontroller.text, phoneController.text);
                    },
                    child: CustomText(
                      text: 'Edit',
                      fontSize: 16,
                      isMediumWeight: true
                    )
                ),
                SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: CustomText(
                        text: 'Close',
                        fontSize: 16,
                        isMediumWeight: true
                    ))
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
            SizedBox(height: 70,),
            footer(),
          ],
        ));
  }
}
