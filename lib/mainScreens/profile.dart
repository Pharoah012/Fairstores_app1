import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/authentication/onboardingScreen.dart';
import 'package:fairstores/profileScreens/saveditems.dart';
import 'package:fairstores/models/securityModel.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/securityKeysProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customErrorWidget.dart';
import 'package:fairstores/widgets/customLoader.dart';
import 'package:fairstores/widgets/customSettingsListTile.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../profileScreens/details.dart';
import '../profileScreens/help.dart';
import '../profileScreens/notifications.dart';

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
                        child: editProfile()),
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
                      builder: (context) => SavedItems()
                  )
              );
            },
          ),
          CustomSettingsListTile(
            label: 'Help',
            icon: Icons.settings,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Help()
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
                          details: ref.read(securityKeysProvider)!.aboutUs,
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
              ref.read(authProvider).logout().then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ), (route) => false)
              );
            },
          ),
        ],
      ),
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

  editProfile() {

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
                  showEditDetails(context);
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
          title: CustomText(
          text: "Full name",
          isMediumWeight: true
          ),
          trailing: CustomText(
              text:  ref.read(userProvider).username!,
              isMediumWeight: true
          )
        ),
        ListTile(
          title: CustomText(
            text: 'Email',
            isMediumWeight: true,
          ),
          trailing: CustomText(
              text:  ref.read(userProvider).email!,
              isMediumWeight: true
          ),
        ),
        ListTile(
          title: CustomText(
            text: 'Phone Number',
            isMediumWeight: true
          ),
          trailing: CustomText(
            text: ref.read(userProvider).number!,
            isMediumWeight: true
          )
        )
      ],
    );
  }

  showEditDetails(context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    // populate the fields with the existing data
    emailController.text = ref.read(userProvider).email!;
    phoneController.text = ref.read(userProvider).number!;

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
                    controller: emailController,
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
                      showDialog(
                        context: context,
                        builder: (context) => CustomLoader()
                      );

                      try{

                        await ref.read(userProvider).updateProfileDetails(
                            email: emailController.text,
                            phoneNumber: phoneController.text
                        );

                        // get updated info
                        UserModel userInfo = await ref.read(authProvider).getUser();

                        // refresh the user provider with the updated info
                        ref.read(userProvider.notifier).state = userInfo;

                        //remove the loader
                        Navigator.of(context).pop();

                        // remove the edit details dialog
                        Navigator.of(context).pop();

                      }
                      catch(exception){
                        log(exception.toString());
                        showDialog(
                            context: context,
                            builder: (context) => CustomError(
                              errorMessage: "An error occurred while updating your details"
                            )
                        );


                      }
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
    final auth = ref.watch(authProvider);
    final _securityKeys = ref.watch(securityKeysProvider);
    final user = ref.watch(userProvider);

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
