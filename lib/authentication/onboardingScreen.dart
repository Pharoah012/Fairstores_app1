import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as crypt;
import 'package:encrypt/encrypt.dart';
import 'package:fairstores/authentication/mainAuthentication.dart';
import 'package:fairstores/widgets/onboardingWidget.dart';
import 'package:fairstores/models/onboarding_model.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/credentials.dart';
import 'package:fairstores/homescreen/homescreen.dart';
import 'package:fairstores/main.dart';
import 'package:fairstores/webview.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';



class OnboardingScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const OnboardingScreen();

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  GoogleSignInAccount? _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _signupformKey = GlobalKey<FormState>();
  String verificationIdRecieved = "";
  List<DropdownMenuItem> sides = [];
  final _loginformKey = GlobalKey<FormState>();
  final _userdetailsformkey = GlobalKey<FormState>();
  int _current = 0;
  dynamic pass = '';
  final key = crypt.Key.fromLength(32);
  final iv = crypt.IV.fromLength(8);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isloggedin = false;
  TextEditingController loginPhoneController = TextEditingController();
  TextEditingController forgotpassphonecontroller = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController conPassController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController loginotpController = TextEditingController();
  TextEditingController forgotpassotpcontroller = TextEditingController();
  final CarouselController _controller = CarouselController();
  String pincode = '';
  String loginverificationIdRecieved = "";
  String loginencryptedPass = "";
  String loginPass = "";
  final loginkey = crypt.Key.fromLength(32);
  final loginiv = crypt.IV.fromLength(8);



  @override
  void initState() {
    super.initState();
    // getOnboardingInfo();
    // googlesigninsilently();
    initPlatformState();

    getuser();
  }



  Future<void> updatePass() async {
    if (newPassController.text == conPassController.text) {
      encryptMyData(newPassController.text);

      QuerySnapshot snapshot = await userref
          .where('number', isEqualTo: forgotpassphonecontroller.text)
          .get();
      if (snapshot.docs.isNotEmpty) {
        for (var element in snapshot.docs) {
          element.reference.update({"password": pass}).then((value) => () {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password Updated')));
              });
        }
      }
    } else {
      Fluttertoast.showToast(msg: 'Passwords do not match');
    }
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
  }

  getuser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      signinmethod: 'AppleAuth',
                      userId: _auth.currentUser!.uid,
                      password: '',
                      phonenumber: '',
                    )));
      }
    });
  }

// This method encrypts the users password and returns the encrypted password

  void encryptMyData(passwordController) {
    final encrypter = Encrypter(Salsa20(key));

    final encrypted = encrypter.encrypt(passwordController, iv: iv);
    setState(() {
      pass = encrypted.base64;
    });
  }

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

  Future<User?> _handleSignIn({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        user = userCredential.user;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                signinmethod: 'GoogleAuth',
                userId: _auth.currentUser!.uid,
                phonenumber: '',
                password: '',
              ),
            ));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }

  Future<bool> loginencryptMyData(String password) async {
    final encrypter = Encrypter(Salsa20(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    //Checks if the passwords match
    if (encrypted.base64 != loginencryptedPass) {
      print("Password Incorrect");
      print("encrypt: ${encrypted.base64}");
      print('password:${loginencryptedPass}');

      return false;
    }
    print(encrypted.base64);

    print("Password correct");

    return true;
  }

  Future<String> getPass() async {
    final _userPass = await userref
        .where('signinmethod', isEqualTo: 'PhoneAuth')
        .where('number', isEqualTo: loginPhoneController.text)
        .get();

    for (var element in _userPass.docs) {
      UserModel model = UserModel.fromDocument(element);
      print('model: ${model.signinmethod}');
      setState(() {
        loginencryptedPass = model.password.toString();
      });
    }

    print('getpass: $loginencryptedPass');
    return loginPass;
  }

  //Future<void> _handleSignOut() => _googleSignIn.disconnect();

  // this button toggles the google api in firebase
  googleSignInButton() {
    GoogleSignInAccount? gUser = _currentUser;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width * 0.87,
        child: MaterialButton(
          onPressed: () {
            _handleSignIn(context: context);
          },
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xffE5E5E5)),
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 0,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/google.png'),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Sign in with Google',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  appleAuthButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 39.0),
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width * 0.87,
        child: MaterialButton(
          onPressed: () async {
            final credential =
                await SignInWithApple.getAppleIDCredential(scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ]);

            // ignore: avoid_print
            print(credential);

            final oauthCredential = OAuthProvider("apple.com").credential(
              idToken: credential.identityToken,
              accessToken: credential.authorizationCode,
            );

            // If we got this far, a session based on the Apple ID credential has been created in your system,
            // and you can now set this as the app's session
            // ignore: avoid_print
            print("session");
            final UserCredential authResult =
                await _auth.signInWithCredential(oauthCredential);
          },
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xffE5E5E5)),
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 0,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/applelogo.png'),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Sign in with Apple',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginForm() {

    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 25),
      child: Form(
        key: _loginformKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTextFormField(
              labelText: 'Phone number',
              controller: loginPhoneController,
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
              controller: loginPasswordController,
              isPassword: true,
            ),
            const SizedBox(height: 16.0,),
            GestureDetector(
              onTap: () {
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
                            color: kWhiteButtonTextColor,
                          ),
                          SizedBox(height: 20,),
                          CustomTextFormField(
                            labelText: 'Phone number',
                            controller: forgotpassphonecontroller,
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

                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              Navigator.pop(context);

                              await MainAuthentication.verify(
                                _auth,
                                forgotpassphonecontroller.text,
                                verificationIdRecieved
                              );

                              showBarModalBottomSheet(
                                context: context,
                                builder: (context) => SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomText(
                                        text: "OTP Verification",
                                        isMediumWeight: true,
                                        fontSize: 20,
                                        color: kBrownText,
                                      ),
                                      CustomText(
                                        text: 'Enter the 6 digits code sent to '
                                        'your phone number '
                                        '${forgotpassphonecontroller.text}',
                                        color: kWhiteButtonTextColor,
                                      ),
                                      SizedBox(height: 8,),
                                      CustomTextFormField(
                                        labelText: "",
                                        controller: forgotpassotpcontroller,
                                        isPassword: true,
                                      ),
                                      const SizedBox(height: 12,),
                                      CustomButton(
                                        onPressed: (){
                                          MainAuthentication.verifyForgotPass(
                                              OTP: forgotpassphonecontroller.text,
                                              verificationIDReceived: verificationIdRecieved
                                          ).then((value) =>
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
                                                          onPressed: (){
                                                            updatePass();
                                                          },
                                                          text: "Continue"
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            )
                                          );
                                        },
                                        text: "Continue"
                                      )
                                      ],
                                    ),
                                )
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

  // This  method check all the parameters are met then stores the user information in the database else return an error

  void signUp(
      TextEditingController phoneController,
      TextEditingController signUpPhoneController
      ) {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdRecieved, smsCode: phoneController.text);

    _auth.signInWithCredential(credential).then((value) => {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                  signinmethod: 'PhoneAuth',
                  userId: _auth.currentUser!.uid,
                  password: pass,
                  phonenumber: signUpPhoneController.text
              )
          )
      )
    });
  }

  showSignup() {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        TextEditingController signUpPhoneController = TextEditingController();
        TextEditingController signUpPasswordController = TextEditingController();

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
                    color: kWhiteButtonTextColor,
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

                      await MainAuthentication.verify(
                          _auth,
                          signUpPhoneController.text,
                          verificationIdRecieved
                      );

                      encryptMyData(signUpPasswordController.text);

                      showBarModalBottomSheet(
                        enableDrag: false,
                        isDismissible: false,
                        context: context,
                        builder: (context) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                  text: "OTP Verification",
                                  color: kBrownText,
                                  fontSize: 20,
                                  isMediumWeight: true
                              ),
                              SizedBox(height: 8.0,),
                              CustomText(
                                text: 'Enter the 6 digits code sent to '
                                    'your phone number '
                                    '${signUpPhoneController.text}',
                                color: kWhiteButtonTextColor,
                              ),
                              CustomTextFormField(
                                  labelText: "Continue",
                                  controller: otpController
                              ),
                              SizedBox(height: 8.0,),
                              CustomButton(
                                  onPressed: (){
                                    signUp(otpController, signUpPhoneController);
                                    Navigator.pop(context);
                                  },
                                  text: "Continue"
                              ),
                              SizedBox(height: 8.0,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CustomText(
                                  text: "Close",
                                  color: kBlack,
                                  isMediumWeight: true,
                                ),
                              ),
                            ],
                          ),
                        )
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
                //appleAuthButton(),
                //    googleSignInButton(),
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

  Future<void> login({required TextEditingController phoneNumberController}) async {
    if (await loginencryptMyData(loginPasswordController.text) == false) {
      print('wrong Password');
      Fluttertoast.showToast(
          msg: 'wrong password or phone number is already in use');
    } else {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationIdRecieved,
          smsCode: loginotpController.text);

      await _auth
          .signInWithCredential(credential)
          .then((value) => {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: ((context) => HomeScreen(
                    signinmethod: 'PhoneAuth',
                    userId: _auth.currentUser!.uid,
                    password: pass,
                    phonenumber: phoneNumberController.text
                )
                )
            )
        )
      })
      .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      }
      );
    }
  }

  // Display the login form
  showLogin() {
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
              color: kWhiteButtonTextColor,
            ),
            loginForm(),
            CustomButton(
              onPressed: () async {
                if (_loginformKey.currentState!.validate()) {
                  getPass().then(
                          (value) => loginencryptMyData(loginPasswordController.text));

                  await MainAuthentication.verify(
                    _auth,
                    loginPhoneController.text,
                    verificationIdRecieved
                  );

                  showBarModalBottomSheet(
                    enableDrag: false,
                    isDismissible: false,
                    context: context,
                    builder: (context) => SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              text: "OTP Verification",
                              fontSize: 20,
                              isMediumWeight: true,
                              color: kBrownText,
                            ),
                            SizedBox(height: 8,),
                            CustomText(
                              text: 'Enter the 6 digits code sent to your '
                                'phone number ${loginPhoneController.text}',
                              color: kWhiteButtonTextColor,
                            ),
                            SizedBox(height: 8,),
                            CustomTextFormField(
                              labelText: "",
                              controller: loginotpController
                            ),
                            SizedBox(height: 20,),
                            CustomButton(
                              onPressed: () async {
                                await login(
                                    phoneNumberController: loginPhoneController
                                );
                                Navigator.pop(context);
                              },
                              text: 'Continue',
                              isOrange: true,
                            ),
                            SizedBox(height: 8,),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: CustomText(
                                  text: "Close",
                                  color: kBlack,
                                  isMediumWeight: true,
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    )
                  );
                }
              },
              text: "Log In",
              isOrange: true
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
            // appleAuthButton(),
            // googleSignInButton(),
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
            )]
          ),
        ),
      ),
    );
  }
}
