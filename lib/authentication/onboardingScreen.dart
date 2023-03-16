import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fairstores/mainScreens/homescreen.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/otpTimerProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customLoader.dart';
import 'package:fairstores/widgets/customErrorWidget.dart';
import 'package:fairstores/widgets/customOTPDrawer.dart';
import 'package:fairstores/widgets/customSocialAuthButton.dart';
import 'package:fairstores/widgets/onboardingWidget.dart';
import 'package:fairstores/models/onboarding_model.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/credentials.dart';
import 'package:fairstores/webview.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  // ignore: use_key_in_widget_constructors
  const OnboardingScreen();

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {

  final _signupformKey = GlobalKey<FormState>();
  final _loginformKey = GlobalKey<FormState>();
  GlobalKey<FormState> forgottenPasswordFormKey = GlobalKey<FormState>();
  int _current = 0;



  TextEditingController otpController = TextEditingController();
  final CarouselController _controller = CarouselController();


  List<OnboardingWidget> onboardinglist = List.generate(3, (index) => OnboardingWidget(
      onboardModel: OnboardingModel(
          onboardingText: "Onboard Text",
          onboardingHeader: "Onboard Header",
          onboardingImage: "images/productonboard.png",
          id: "1"
      )
  ));


// SLider with text info
  sliderInfo() {
    return CarouselSlider(
      carouselController: _controller,
      items: onboardinglist,
      options: CarouselOptions(
        autoPlayInterval: const Duration(seconds: 15),
        autoPlay: true,
        aspectRatio: 1.0,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        }
      ),
    );
  }

// Slider indicator buttons
  sliderindicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: onboardinglist.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () {
            _controller.animateToPage(entry.key).then((value) => setState(() {
                  _current = entry.key;
                }));
          },
          child: Container(
            width: _current == entry.key ? 18.0 : 6.0,
            height: 4.0,
            margin:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(100),
                color: (Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xffC4C4C4)
                        : kPrimary)
                    .withOpacity(_current == entry.key ? 0.9 : 0.2)
            ),
          ),
        );
      }).toList());
  }

  // this function handles the OTP drawer
  otpDrawer({
    required String phoneNumber,
    required VoidCallback verificationLogic,
  }){
    showBarModalBottomSheet(
      context: context,
      builder: (context) => CustomOTPDrawer(
        phoneNumber: phoneNumber,
        verificationLogic: verificationLogic,
        otpController: otpController,
      )
    );
  }

  Widget loginForm({
    required TextEditingController phoneNumberController,
    required TextEditingController passwordController
  }) {

    final _auth = ref.watch(authProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 25),
      child: Form(
        key: _loginformKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextFormField(
              labelText: 'Phone number',
              controller: phoneNumberController,
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
            const SizedBox(height: 16,),
            CustomTextFormField(
              labelText: 'Password',
              controller: passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 16.0,),
            GestureDetector(
              onTap: () {
                TextEditingController forgotPassPhoneController = TextEditingController();

                showBarModalBottomSheet(
                  context: context,
                  builder: (context) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Forgot Password",
                            fontSize: 20,
                            isMediumWeight: true,
                            color: kBrownText,
                          ),
                          const SizedBox(height: 12.0,),
                          CustomText(
                            text: 'Enter your phone for the verification process. '
                                'We will send a 6 digit code to your number.',
                            color: kDarkGrey,
                          ),
                          SizedBox(height: 20,),
                          CustomTextFormField(
                            labelText: 'Phone number',
                            controller: forgotPassPhoneController,
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
                          SizedBox(height: 20,),
                          CustomButton(
                            onPressed: () async {

                              if (!forgottenPasswordFormKey.currentState!.validate()) {
                                return;
                              }

                              showDialog(
                                context: context,
                                builder: (context) => CustomLoader()
                              );

                              // send the OTP for verification
                              await _auth.sendOTPForVerification(
                                phoneNumber: forgotPassPhoneController.text,

                                ref: ref
                              );

                              // remove the loader
                              Navigator.of(context).pop();

                              otpDrawer(
                                phoneNumber: forgotPassPhoneController.text,
                                verificationLogic: () async {

                                  Map<String, dynamic> verifyOTP = await _auth.verfiyOTP(
                                      otp: otpController.text,
                                    ref: ref
                                  );

                                  // check if the user's input is valid
                                  if (verifyOTP['type'] == "error"){
                                    // clear the otp
                                    otpController.clear();

                                    showDialog(
                                      context: context,
                                      builder: (context) => verifyOTP['object']
                                    );
                                  }
                                  else {

                                    //close OTP drawer
                                    Navigator.of(context).pop();

                                    // clear the otp
                                    otpController.clear();

                                    showBarModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          TextEditingController newPasswordController = TextEditingController();
                                          TextEditingController confirmPasswordController = TextEditingController();

                                          return SizedBox(
                                            height: 371,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 20.0, left: 20),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                          padding: const EdgeInsets.only(bottom: 10.0),
                                                          child: CustomText(
                                                              text: "Reset Password",
                                                              color: kBrownText
                                                          )
                                                      ),
                                                      CustomText(
                                                        text: 'Set the new password for your account',
                                                        color: kLabelColor,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                CustomTextFormField(
                                                  labelText: "New Password",
                                                  isPassword: true,
                                                  controller: newPasswordController,
                                                ),
                                                CustomTextFormField(
                                                  controller: confirmPasswordController,
                                                  labelText: "Confirm Password",
                                                  isPassword: true,
                                                ),
                                                CustomButton(
                                                  onPressed: () async {

                                                    // show loader
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => CustomLoader()
                                                    );

                                                    // Attempt to reset the user's password
                                                    Map<String, dynamic> resetPassword = await _auth.resetPassword(
                                                      phoneNumber: forgotPassPhoneController.text,
                                                      newPassword: newPasswordController.text,
                                                      confirmPassword: confirmPasswordController.text
                                                    );

                                                    if (resetPassword['type'] == "error"){
                                                      Navigator.of(context).pop();

                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => resetPassword['object']
                                                      );
                                                    }
                                                    else{
                                                      Fluttertoast.showToast(msg: 'Your password has been sucessfully reset.');

                                                      // pop the loader and reset bottom modal sheets
                                                      Navigator.of(context).pop();
                                                      Navigator.of(context).pop();
                                                    }
                                                  },
                                                  text: "Continue"
                                                )
                                              ],
                                            ),
                                          );
                                        }
                                    );
                                  }
                                }
                              );
                            },
                            text: 'Send code',
                            isOrange: true
                          ),
                        ],
                      ),
                    ),
                  )
                );
              },
              child: CustomText(
                text: 'Forgot your password?',
                fontSize: 12,
                color: kLabelColor,
              )
            )
          ],
        )
      ),
    );
  }

  Widget signUpForm({
    required TextEditingController signUpPhoneController,
    required TextEditingController signUpPasswordController,

  }) {

    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 25),
      child: Form(
          key: _signupformKey,
          child: Column(
            children: [
              CustomTextFormField(
                labelText: 'Phone number',
                controller: signUpPhoneController,
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
              SizedBox(height: 12,),
              CustomTextFormField(
                labelText: 'Password',
                controller: signUpPasswordController,
                isPassword: true,
              )
            ],
          )
      ),
    );
  }

  showSignup() {
    TextEditingController signUpPhoneController = TextEditingController();
    TextEditingController signUpPasswordController = TextEditingController();
    final _auth = ref.watch(authProvider);

    showMaterialModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                children: [
                  CustomText(
                    text: 'Create your account',
                    color: kBrownText,
                    fontSize: 20,
                    isMediumWeight: true,
                  ),
                  SizedBox(height: 4,),
                  CustomText(
                    text: 'Create an account today. '
                        'Tap the button below and start engaging with a '
                        'variety of joints',
                    isCenter: true,
                    color: kDarkGrey,
                  ),
                  signUpForm(
                      signUpPasswordController: signUpPasswordController,
                      signUpPhoneController: signUpPhoneController
                  ),
                  CustomButton(
                    onPressed: () async {
                      if (!_signupformKey.currentState!.validate()) {
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (context) => CustomLoader()
                      );

                      // send OTP to verify the user's number
                      await _auth.sendOTPForVerification(
                        phoneNumber: signUpPhoneController.text,
                        ref: ref
                      );

                      // remove the loader
                      Navigator.of(context).pop();

                      // show OTP drawer
                      otpDrawer(
                          phoneNumber: signUpPhoneController.text,
                          verificationLogic: () async {

                            // verifiy the user's OTP input
                            Map<String, dynamic> verifyOTP = await _auth.verfiyOTP(
                              otp: otpController.text,
                              ref: ref
                            );

                            // check if the user's input is valid
                            if (verifyOTP['type'] == "error"){
                              // clear the otp
                              otpController.clear();

                              showDialog(
                                  context: context,
                                  builder: (context) => verifyOTP['object']
                              );
                            }
                            else {
                              // Remove OTP drawer
                              Navigator.of(context).pop();

                              // clear the otp
                              otpController.clear();

                              // show loader while sign up process is ongoing
                              showDialog(
                                context: context,
                                builder: (context) => CustomLoader()
                              );

                              // check if the user exists
                              Map<String, dynamic> getUser = await _auth
                                  .isUserAMember(
                                  phoneNumber: signUpPhoneController.text
                              );

                              // throw an error when the user does not exist
                              if (getUser['type'] != "error"){
                                log("message");
                                // remove the loader
                                Navigator.of(context).pop();

                                showDialog(
                                  context: context,
                                  builder: (context) => CustomError(
                                    errorMessage: "An account with these credentials already exists",
                                    oneRemove: true,
                                  )
                                );

                              }
                              else{
                                Map<String, dynamic> signUp = await _auth.signUp(
                                    phoneAuthCredential: verifyOTP['object'],
                                    phoneNumber: signUpPhoneController.text,
                                    password: signUpPasswordController.text
                                );

                                if (signUp['type'] == "error"){
                                  // remove the loader
                                  Navigator.of(context).pop();

                                  showDialog(
                                      context: context,
                                      builder: (context) => signUp['object']
                                  );


                                }
                                else{
                                  // TODO: SHOw ALERT DIALOG FOR CREATION SUCCESS
                                  // close the otp drawer and sign up screens
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();

                                  // redirect the user to login
                                  showLogin();
                                }
                              }
                            }
                          }
                      );
                    },
                    text: "Sign Up",
                    isOrange: true,
                  ),
                  SizedBox(height: 20,),
                  RichText(
                    text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Have an account? ',
                              style: GoogleFonts.manrope(
                                  color: const Color(0xff333333),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14
                              )
                          ),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                  showLogin();
                                },
                              text: 'Sign in',
                              style: GoogleFonts.manrope(
                                  color: kPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                              )
                          )
                        ]
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: kBrownText,
                        height: 0.8,
                        width: 140,
                      ),
                      CustomText(
                          text: "OR",
                          color: kBrownText,
                          isMediumWeight: true
                      ),
                      Container(
                        color: kBrownText,
                        height: 0.8,
                        width: 140,
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Builder(builder: (context){
                    if (Platform.isIOS){
                      return Column(
                        children: [
                          CustomSocialAuthButton(
                            isSignIn: false,
                            onPressed: () async {
                              Map<String, dynamic> signUp = await _auth.socialAuthentication(
                                  authMethod: "apple",
                                  isSignIn: false
                              );

                              if (signUp['type'] == "error"){
                                return showDialog(
                                    context: context,
                                    builder: (context) => signUp['object']
                                );
                              }

                              // check if the sign up object is an auth method
                              // meaning that the user does not have an account
                              if (signUp['object'] is String){
                                ref.read(userProvider.notifier).state = UserModel(
                                    ismanager: false,
                                    uid: ref.read(authProvider).currentUser!.uid,
                                    email: ref.read(authProvider).currentUser!.email,
                                    username: ref.read(authProvider).currentUser!.displayName
                                );
                              }
                              else{
                                // set the user provider to the user object that is returned
                                ref.read(userProvider.notifier).state = signUp['object'];
                              }

                              // redirect the user to homeScreen
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                        isSocialAuth: true,
                                      )
                                  ),
                                      (route)=> false
                              );

                            },
                          ),
                          SizedBox(height: 15,),
                        ],
                      );
                    }

                    return SizedBox.shrink();
                  }),
                  CustomSocialAuthButton(
                    isApple: false,
                    isSignIn: false,
                    onPressed: () async {

                      Map<String, dynamic> signUp = await _auth.socialAuthentication(
                        authMethod: "google",
                      );

                      if (signUp['type'] == "error"){
                        return showDialog(
                            context: context,
                            builder: (context) => signUp['object']
                        );
                      }

                      // check if the sign up object is an auth method
                      // meaning that the user does not have an account
                      if (signUp['object'] is String){
                        ref.read(userProvider.notifier).state = UserModel(
                            ismanager: false,
                            uid: ref.read(authProvider).currentUser!.uid,
                            email: ref.read(authProvider).currentUser!.email,
                            username: ref.read(authProvider).currentUser!.displayName
                        );
                      }
                      else{
                        // set the user provider to the user object that is returned
                        ref.read(userProvider.notifier).state = signUp['object'];
                      }

                      // redirect the user to homeScreen
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                isSocialAuth: true,
                              )
                          ),
                              (route)=> false
                      );
                    },
                  )
                ]
            ),
          ),
        );
      },
      barrierColor: kPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
        )
      )
    );
  }

  // Display the login form
  showLogin() {
    TextEditingController loginPhoneController = TextEditingController();
    TextEditingController loginPasswordController = TextEditingController();
    final _auth = ref.watch(authProvider);

    showMaterialModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
            CustomText(
              text: 'Login to your account',
              fontSize: 20,
              color: kBrownText,
              isMediumWeight: true,
            ),
            const SizedBox(height: 4.0,),
            CustomText(
              text: 'Lets lead you right back to your page. '
                  'Tap the button below',
              isCenter: true,
              color: kDarkGrey,
            ),
            loginForm(
              phoneNumberController: loginPhoneController,
              passwordController: loginPasswordController
            ),
            CustomButton(
              onPressed: () async {
                if (_loginformKey.currentState!.validate()) {

                  // show the loader
                  showDialog(
                    context: context,
                    builder: (context) => CustomLoader()
                  );

                  // check if the user exists
                  Map<String, dynamic> getUser = await _auth
                      .isUserAMember(phoneNumber: loginPhoneController.text);



                  // throw an error when the user does not exist
                  if (getUser['type'] == "error"){
                    // remove the loader
                    Navigator.of(context).pop();

                    showDialog(
                      context: context,
                      builder: (context) => getUser['object']
                    );


                  }
                  else{

                    // check the user's password input and target account
                    // password are equal
                    bool verifyPassword = _auth.verifyLoginPassword(
                      loginPassword: loginPasswordController.text,
                      userPassword: getUser['object'].password
                    );

                    if (!verifyPassword){
                      showDialog(
                        context: context,
                        builder: (context) => CustomError(
                          errorMessage: "There is no account associated "
                              "with the given credentials."
                        )
                      );
                    }

                    // Send the OTP
                    await _auth.sendOTPForVerification(
                      phoneNumber: loginPhoneController.text,
                      ref: ref
                    );

                    // remove the loader
                    Navigator.of(context, rootNavigator: true).pop();

                    // show OTP drawer for user to verify the OTP
                    // that was sent

                    otpDrawer(
                      phoneNumber: loginPhoneController.text,
                      verificationLogic: () async {

                        Map<String, dynamic> verifyOTP = await _auth.verfiyOTP(
                          otp: otpController.text,
                          ref: ref
                        );

                        // check if the user's input is valid
                        if (verifyOTP['type'] == "error"){
                          // clear the otp
                          otpController.clear();

                          showDialog(
                              context: context,
                              builder: (context) => verifyOTP['object']
                          );
                        }
                        else {
                          // clear the otp
                          otpController.clear();

                          Map<String, dynamic> login = await _auth.login(
                              credential: verifyOTP['object'],
                          );

                          if (login['type'] == "error"){
                            // remove the loader
                            Navigator.of(context).pop();

                            showDialog(
                                context: context,
                                builder: (context) => login['object']
                            );
                          }
                          else{
                            ref.read(userProvider.notifier).state = login['object'];

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()
                                ),
                                    (route)=> false
                            );
                          }

                        }
                      },

                    );

                  }
                }
              },
              text: "Log In",
              isOrange: true,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: GoogleFonts.manrope(
                        color: const Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontSize: 14
                      )
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                          showSignup();
                        },
                      text: 'Sign up',
                      style: GoogleFonts.manrope(
                          color: kPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                      )
                    )
                  ]
                  ),
                ),
              ],
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: kBrownText,
                  height: 0.8,
                  width: 140,
                ),
                CustomText(
                  text: "OR",
                  isMediumWeight: true,
                  color: kBrownText,
                ),
                Container(
                  color: kBrownText,
                  height: 0.8,
                  width: 140,
                ),
              ],
            ),
            SizedBox(height: 30,),
            Builder(builder: (context){
              if (Platform.isIOS){
                return Column(
                  children: [
                    CustomSocialAuthButton(
                      onPressed: () async {

                        Map<String, dynamic> signIn = await _auth.socialAuthentication(
                          authMethod: "apple",
                        );

                        if (signIn['type'] == "error"){
                          return showDialog(
                              context: context,
                              builder: (context) => signIn['object']
                          );
                        }

                        // check if the sign in object is an auth method
                        // meaning that the user does not have an account
                        if (signIn['object'] is String){
                          ref.read(userProvider.notifier).state = UserModel(
                              ismanager: false,
                              uid: ref.read(authProvider).currentUser!.uid,
                              email: ref.read(authProvider).currentUser!.email,
                              username: ref.read(authProvider).currentUser!.displayName
                          );
                        }
                        else{
                          // set the user provider to the user object that is returned
                          ref.read(userProvider.notifier).state = signIn['object'];
                        }

                        // redirect the user to homeScreen
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                  isSocialAuth: true,
                                )
                            ),
                                (route)=> false
                        );
                      },
                    ),
                    SizedBox(height: 15,),
                  ],
                );
              }

              return SizedBox.shrink();
            }),
            CustomSocialAuthButton(
              isApple: false,
              onPressed: () async {

                Map<String, dynamic> signIn = await _auth.socialAuthentication(
                  authMethod: "google",
                );

                if (signIn['type'] == "error"){
                  return showDialog(
                      context: context,
                      builder: (context) => signIn['object']
                  );
                }

                // check if the sign in object is an auth method
                // meaning that the user does not have an account
                if (signIn['object'] is String){
                  ref.read(userProvider.notifier).state = UserModel(
                      ismanager: false,
                      uid: ref.read(authProvider).currentUser!.uid,
                      email: ref.read(authProvider).currentUser!.email,
                      username: ref.read(authProvider).currentUser!.displayName
                  );
                }
                else{
                  // set the user provider to the user object that is returned
                  ref.read(userProvider.notifier).state = signIn['object'];
                }


                // redirect the user to homeScreen
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          isSocialAuth: true,
                        )
                    ),
                      (route)=> false
                );
              },
            )
          ]),
        ),
      ),
      barrierColor: kPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20)
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final _auth = ref.watch(authProvider);
    final duration = ref.watch(durationProvider);
    final _otpTimer = ref.watch(otpTimerProvider);
    final _minutes = ref.watch(minuteProvider);
    final _seconds = ref.watch(secondsProvider);
    final _resendToken = ref.watch(resendTokenProvider);
    final _receivedVerificationID = ref.watch(receivedVerificationIDProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(),
              sliderInfo(),
              sliderindicator(),
              Spacer(),
              CustomButton(
                onPressed: (){
                  showSignup();
                },
                text: 'Create an Account',
                isOrange: true,
              ),
              SizedBox(height: 8.0,),
              CustomButton(
                  onPressed: (){
                    showLogin();
                  },
                  text: 'Already have an account',
                  isOrange: false
              ),
              SizedBox(height: 20,),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'By logging or registering, you agree to our ',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: kBlack
                      )
                    ),
                    TextSpan(
                      text: 'Terms of Services ',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => WebViewExample(
                                    title: 'Terms and Conditions',
                                    url: termsAndConditions
                                )
                            )
                        ),
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: kPrimary
                      )
                    ),
                    TextSpan(
                      text: 'and ',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: kBlack)
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => WebViewExample(
                                    title: 'Privacy Policy',
                                    url: privacyPolicy
                                )
                            )
                        ),
                      text: 'Privacy Policy.',
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: kPrimary
                        )
                    )
                  ]
                )
              )
            ]
          ),
        ),
      ),
    );
  }
}
