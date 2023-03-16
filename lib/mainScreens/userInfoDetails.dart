import 'dart:developer';
import 'package:fairstores/constants.dart';
import 'package:fairstores/mainScreens/homescreen.dart';
import 'package:fairstores/providers/schoolListProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInfoDetails extends ConsumerStatefulWidget {
  final bool isSocialAuth;

  const UserInfoDetails({
    Key? key,
    this.isSocialAuth = false,
  }) : super(key: key);

  @override
  ConsumerState<UserInfoDetails> createState() => _UserInfoDetailsState();
}

class _UserInfoDetailsState extends ConsumerState<UserInfoDetails> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  GlobalKey<FormState> _userDetailsFormKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final schools = ref.watch(schoolsProvider);
    final schoolsDropdown = ref.watch(schoolDropdownProvider);

    schools.when(
        data: (data) => log("loaded schools"),
        error: (_, err) => log("Error loading school: ${err.toString()}"),
        loading: () => log("loading schools")
    );

    if (widget.isSocialAuth){
      emailController.text = user.email!;
      nameController.text = user.username!;
    }


    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: kPrimary,
                ),
                Positioned(
                    top: 150,
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(21),
                              topLeft: Radius.circular(21)
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10,),
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
                              SizedBox(height: 50,),
                              Form(
                                key: _userDetailsFormKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomTextFormField(
                                        labelText: "Full name",
                                        controller: nameController
                                    ),
                                    SizedBox(height: 20,),
                                    CustomTextFormField(
                                        labelText: 'Email',
                                        controller: emailController
                                    ),
                                    widget.isSocialAuth
                                        ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 20,),
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
                                    SizedBox(height: 20,),
                                    schoolsDropdown
                                    // SizedBox(height: 10,),
                                    // Spacer(),
                                  ],
                                ),
                              ),
                              Spacer(),
                              SafeArea(
                                child: CustomButton(
                                  isOrange: true,
                                  text: 'Continue',
                                  onPressed: () {

                                    if (!_userDetailsFormKey.currentState!.validate()
                                        || ref.read(schoolsDropdown.currentValue) == "-Select School-"
                                    ) {
                                      return;
                                    }

                                    // update the user model with the input details
                                    user.email = emailController.text;
                                    user.username = nameController.text;
                                    user.school = ref.read(selectedSchoolProvider);

                                    // check if the user is coming from socialAuth
                                    if (widget.isSocialAuth){
                                      user.number = numberController.text;
                                    }

                                    try {

                                      // update the details in firestore
                                      user.updateUserDetails();

                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text('Welcome to FairStores')
                                          )
                                      );

                                      // redirect to homesscreen
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                isSocialAuth: widget.isSocialAuth,
                                              )
                                          ),
                                              (route) => false
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
                                ),
                              )
                            ]
                        ),
                      ),
                    )
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
