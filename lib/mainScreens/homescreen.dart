import 'dart:developer';
import 'package:fairstores/constants.dart';
import 'package:fairstores/mainScreens/history.dart';
import 'package:fairstores/mainScreens/home.dart';
import 'package:fairstores/mainScreens/profile.dart';
import 'package:fairstores/mainScreens/search.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/schoolListProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customDropdown.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final currentScreenProvider = StateProvider.autoDispose<int>((ref) => 0);


class HomeScreen extends ConsumerStatefulWidget {

  const HomeScreen({Key? key,}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> _userDetailsFormKey = GlobalKey<FormState>();



  List mainScreens = [
    Home(),
    Search(addappbar: false,),
    History(),
    Profile(),
  ];


  @override
  void initState() {
    super.initState();
    checkUserInFirestore();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(authProvider).storetokens();
    });

  }


  // Check if the user is using the app for the first time
  checkUserInFirestore() async {

    // Get the user model
    final user = ref.read(userProvider);

    // Get the schools
    final schools = ref.watch(schoolsProvider);



    // check if any of the details are missing from the user's document
    if (
      user.name == null
      || user.email == null
      || user.school == null
    ){

      return showMaterialModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
        barrierColor: kPrimary,
        context: context,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
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
                key: _userDetailsFormKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      labelText: "Full name",
                      controller: nameController
                    ),
                    SizedBox(height: 10,),
                    CustomTextFormField(
                      labelText: 'Email',
                      controller: emailController
                    ),
                    SizedBox(height: 10,),
                    schools.when(
                      data: (data) => CustomDropdown(
                        currentValue: selectedSchoolProvider,
                        items: data
                      ),
                      error: (_, err){
                        log(err.toString());
                        return CustomDropdown(
                          currentValue: selectedSchoolProvider,
                          items: ["-Select School-"]
                        );
                      },
                      loading: () => CustomDropdown(
                        currentValue: selectedSchoolProvider,
                        items: ["-Select School-"]
                      )
                    ),
                    Spacer(),
                    CustomButton(
                      isOrange: true,
                      text: 'Continue',
                      onPressed: () {
                        if (!_userDetailsFormKey.currentState!.validate()) {
                          return;
                        }

                        // update the user model with the input details
                        user.email = emailController.text;
                        user.name = nameController.text;
                        user.school = ref.read(selectedSchoolProvider);

                        try {

                          // update the details in firestore
                          user.updateUserDetails();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Welcome to FairStores')
                              )
                          );

                        }
                        catch (exception) {
                          log(exception.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("An error occurred while updating your details")
                              )
                          );
                        }

                        //
                        //   await userRef
                        //       .where('number', isEqualTo: phonecontroller.text)
                        //       .get()
                        //       .then((value) {
                        //     if (value.docs.isEmpty) {
                        //       userRef.doc(_auth.currentUser?.uid).set({
                        //         'ismanager': false,
                        //         'number': widget.user.phoneNumber == ''
                        //             ? phonecontroller.text
                        //             : widget.user.phoneNumber,
                        //         'uid': widget.user.uid,
                        //         'username': nameController.text,
                        //         'school': ref.read(selectedSchoolProvider),
                        //         'timestamp': timestamp,
                        //         'password': "widget.user.password",
                        //         'email': emailController.text,
                        //         'signinmethod': "widget.user.signinmethod",
                        //       });
                        //       Navigator.pop(context);
                        //
                        //     } else {
                        //       Fluttertoast.showToast(
                        //           msg: 'Phone Number already in Use');
                        //     }
                        //   });
                        // } else {}
                      },

                    )
                  ],
                )
            ),
          ]
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreen = ref.watch(currentScreenProvider);
    final _user = ref.watch(userProvider);

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: mainScreens[_currentScreen],
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
            currentIndex: _currentScreen,
            onTap: (value) => ref.read(currentScreenProvider.notifier).state,
          ),
        ));
  }
}
