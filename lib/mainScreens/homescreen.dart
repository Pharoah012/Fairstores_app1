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
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final currentScreenProvider = StateProvider.autoDispose<int>((ref) => 0);


class HomeScreen extends ConsumerStatefulWidget {
  final bool isSocialAuth;
  final String? authType;

  const HomeScreen({
    Key? key,
    this.isSocialAuth = false,
    this.authType
  }) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkUserInFirestore();
      ref.read(authProvider).storetokens();
    });

  }


  // Check if the user is using the app for the first time
  checkUserInFirestore() async {

    // Get the schools
    final schools = ref.watch(schoolsProvider);

    // Get the user model
    final user = ref.watch(userProvider);



    // check if any of the details are missing from the user's document
    if (
      user.username == null
      || user.email == null
      || user.school == null
    ){

      return showMaterialModalBottomSheet(
        enableDrag: false,
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          )),
        barrierColor: kPrimary,
        context: context,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Provide Extra Details',
                    fontSize: 20,
                    isMediumWeight: true,
                    color: kBlack,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomText(
                      text: 'Lets lead you right back to your page. Tap the button below',
                      fontSize: 14,
                      isMediumWeight: true,
                      isCenter: true,
                      color: kBrownText,
                    ),
                  ),
                  SizedBox(height: 30,),
                  Form(
                    key: _userDetailsFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        widget.isSocialAuth
                          ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10,),
                            CustomTextFormField(
                              labelText: 'Phone number',
                              controller: numberController,
                              validator: (value) {
                                if (!value!.startsWith('+')) {
                                  return 'Start with country code';
                                } else if (value.isEmpty) {
                                  return 'Type in phone number';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        )
                          : SizedBox.shrink(),
                        SizedBox(height: 10,),
                        schools.when(
                          data: (data) {
                            log(data.toString());

                            return CustomDropdown(
                                currentValue: selectedSchoolProvider,
                                items: data
                            );
                          },
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
                        // SizedBox(height: 10,),
                        // Spacer(),
                      ],
                    ),
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
                    user.username = nameController.text;
                    user.school = ref.read(selectedSchoolProvider);
                    user.signinmethod = "phone";

                    // check if the user is coming from socialAuth
                    if (widget.isSocialAuth){
                      user.number = numberController.text;
                      user.password = "";
                      user.signinmethod = widget.authType!;
                    }

                    try {

                      // update the details in firestore
                      user.updateUserDetails();
                      ref.invalidate(userProvider);


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
                  },
                )
              ]
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _currentScreen = ref.watch(currentScreenProvider);
    final _user = ref.watch(userProvider);
    final schools = ref.watch(schoolsProvider);

    schools.when(
      data: (data) => log("loaded schools"),
      error: (_, err) => log("Error loading school: ${err.toString()}"),
      loading: () => log("loading schools")
    );

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
