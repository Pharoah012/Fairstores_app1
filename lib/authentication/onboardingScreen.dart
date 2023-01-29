import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as crypt;
import 'package:encrypt/encrypt.dart';
import 'package:fairstores/authentication/models.dart';
import 'package:fairstores/backend/model.dart';
import 'package:fairstores/homescreen/homescreen.dart';
import 'package:fairstores/main.dart';
import 'package:fairstores/webview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:new_version/new_version.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

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
  TextEditingController loginphonecontroller = TextEditingController();
  TextEditingController forgotpassphonecontroller = TextEditingController();
  TextEditingController signupphonecontroller = TextEditingController();
  TextEditingController signuppasswordController = TextEditingController();
  TextEditingController loginpasswordController = TextEditingController();
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
  static final String oneSignalAppId = "c51d520b-4cac-4079-a363-7531bb872f88";
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    getOnboardingInfo();
    googlesigninsilently();
    initPlatformState();

    getuser();
  }

  Future verifyForgotPass() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdRecieved,
        smsCode: forgotpassotpcontroller.text);
    return credential;
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
      } else {}
    });
  }

  googlesigninsilently() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                signinmethod: 'GoogleAuth',
                userId: account.id,
                password: '',
                phonenumber: '',
              ),
            ));
      }
    });
    _googleSignIn.signInSilently();
  }

  // This  method check all the parameters are met then stores the user information in the database else return an error

  void signUp(TextEditingController phoneController) {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdRecieved, smsCode: phoneController.text);

    _auth.signInWithCredential(credential).then((value) => {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: ((context) => HomeScreen(
                      signinmethod: 'PhoneAuth',
                      userId: _auth.currentUser!.uid,
                      password: pass,
                      phonenumber: signupphonecontroller.text))))
        });
  }

  postDetailsToFirestore(phoneController) {
    User? user = _auth.currentUser;

    Model userModel = Model(ismanager: false);

    userModel.email = "";
    userModel.uid = user?.uid;
    userModel.name = "";
    userModel.number = phoneController;
    userModel.password = pass;
    userModel.school = '';
    userModel.signinmethod = '';

    userref.doc(user?.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");
  }

  //e This method sends the otp to the user and checks if the phone number is valid

  void verify(phoneController) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneController,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth
            .signInWithCredential(credential)
            .then((value) => {print("You are logged in successfully")});
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
        if (e.code == 'invalid-phone-number') {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 2,
              msg: "Oops Something went wrong please try again later");
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        verificationIdRecieved = verificationId;
        // otpCodeVisible = true
        // setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

// This method encrypts the users password and returns the encrypted password

  void encryptMyData(passwordController) {
    final encrypter = Encrypter(Salsa20(key));

    final encrypted = encrypter.encrypt(passwordController, iv: iv);
    setState(() {
      pass = encrypted.base64;
    });
  }

// Query onboarding info from database
  void getOnboardingInfo() async {
    QuerySnapshot snapshot = await onboardingref
        .doc('Onboarding_info')
        .collection('information')
        .get();
    List<OnboardingModel> onboardinglist = [];
    onboardinglist =
        snapshot.docs.map((doc) => OnboardingModel.fromDocument(doc)).toList();

    setState(() {
      this.onboardinglist = onboardinglist;
    });
  }

  List<OnboardingModel> onboardinglist = [];

// SLider with text info
  sliderInfo() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 45.0,
      ),
      child: CarouselSlider(
        carouselController: _controller,
        items: onboardinglist,
        options: CarouselOptions(
            autoPlayInterval: const Duration(seconds: 15),
            autoPlay: true,
            aspectRatio: 0.9,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
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
                          : color)
                      .withOpacity(_current == entry.key ? 0.9 : 0.2)),
            ),
          );
        }).toList());
  }

  createAccountbutton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: MaterialButton(
        onPressed: () {
          showSignup();
        },
        elevation: 0,
        height: 56,
        minWidth: MediaQuery.of(context).size.width * 0.87,
        color: color,
        child: Text('Create an Account',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white)),
      ),
    );
  }

  haveAccountbutton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: MaterialButton(
        onPressed: () {
          showLogin();
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(color: Color(0xffE5E5E5))),
        elevation: 0,
        height: 56,
        minWidth: MediaQuery.of(context).size.width * 0.87,
        color: Colors.white,
        child: Text('Already have an account',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black)),
      ),
    );
  }

  signupbutton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12),
      child: MaterialButton(
        onPressed: () {
          if (_signupformKey.currentState!.validate()) {
            verify(signupphonecontroller.text);
            encryptMyData(signuppasswordController.text);

            showBarModalBottomSheet(
                enableDrag: false,
                isDismissible: false,
                context: context,
                builder: (context) => SizedBox(
                      height: 310,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text("OTP Verificaiton",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.manrope(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff180602))),
                                ),
                                Text(
                                    'Enter the 6 digits code sent to your phone number ${signupphonecontroller.text}',
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff8B8380))),
                              ],
                            ),
                          ),
                          Expanded(
                            child: const SizedBox(),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 56,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xffD1D5DB)))),

                              controller: otpController,

                              style: const TextStyle(
                                fontSize: 17,
                              ),

                              //  print("Completed: " + pin);
                            ),
                          ),
                          Expanded(
                            child: const SizedBox(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 2),
                            child: MaterialButton(
                              onPressed: () {
                                signUp(otpController);
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              elevation: 0,
                              height: 56,
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.87,
                              color: color,
                              child: Text('Continue',
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.white)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close',
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black)),
                            ),
                          ),
                          Expanded(
                            child: const SizedBox(),
                          )
                        ],
                      ),
                    ));
          }
          //verify(signupphonecontroller);
          else {}
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 0,
        height: 56,
        minWidth: MediaQuery.of(context).size.width * 0.87,
        color: color,
        child: Text('Sign up',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white)),
      ),
    );
  }

  loginbutton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12),
      child: MaterialButton(
        onPressed: () {
          if (_loginformKey.currentState!.validate()) {
            getPass().then(
                (value) => loginencryptMyData(loginpasswordController.text));
            verify(loginphonecontroller.text);

            showBarModalBottomSheet(
                enableDrag: false,
                isDismissible: false,
                context: context,
                builder: (context) => SizedBox(
                      height: 310,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text("OTP Verificaiton",
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.manrope(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff180602))),
                                ),
                                Text(
                                    'Enter the 6 digits code sent to your phone number ${loginphonecontroller.text}',
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xff8B8380))),
                              ],
                            ),
                          ),
                          Expanded(
                            child: const SizedBox(),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 56,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xffD1D5DB)))),

                              controller: loginotpController,

                              style: const TextStyle(
                                fontSize: 17,
                              ),

                              //  print("Completed: " + pin);
                            ),
                          ),
                          Expanded(
                            child: const SizedBox(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 2),
                            child: MaterialButton(
                              onPressed: () {
                                login();
                                Navigator.pop(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              elevation: 0,
                              height: 56,
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.87,
                              color: color,
                              child: Text('Continue',
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.white)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text('Close',
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black)),
                            ),
                          ),
                          Expanded(
                            child: const SizedBox(),
                          )
                        ],
                      ),
                    ));
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 0,
        height: 56,
        minWidth: MediaQuery.of(context).size.width * 0.87,
        color: color,
        child: Text('Log in',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white)),
      ),
    );
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
        .where('number', isEqualTo: loginphonecontroller.text)
        .get();

    for (var element in _userPass.docs) {
      Model model = Model.fromDocument(element);
      print('model: ${model.signinmethod}');
      setState(() {
        loginencryptedPass = model.password.toString();
      });
    }

    print('getpass: $loginencryptedPass');
    return loginPass;
  }

  void login() async {
    if (await loginencryptMyData(loginpasswordController.text) == false) {
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
                            phonenumber: signupphonecontroller.text))))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
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

  loginform() {
    bool _obscureText = true;

    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 25),
      child: Form(
          key: _loginformKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 20,
                  left: 20,
                ),
                child: SizedBox(
                  height: 56,
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: TextFormField(
                    validator: (value) {
                      if (!value!.startsWith('+')) {
                        return 'Start with country code';
                      } else if (value.isEmpty) {
                        return 'Type in phone number';
                      } else {
                        return null;
                      }
                    },
                    controller: loginphonecontroller,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: color,
                            )),
                        fillColor: color,
                        focusColor: color,
                        labelText: 'Phone number',
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
                  right: 20,
                  left: 20,
                ),
                child: SizedBox(
                  height: 56,
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Type in password';
                          } else {
                            return null;
                          }
                        },
                        controller: loginpasswordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: color,
                                )),
                            suffixIcon: GestureDetector(
                                child: Icon(
                                  Icons.visibility,
                                  color: _obscureText == true
                                      ? Colors.grey
                                      : color,
                                ),
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                }),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.manrope(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: const Color(0xff8B8380)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E5E5),
                                ),
                                borderRadius: BorderRadius.circular(10))));
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showBarModalBottomSheet(
                        context: context,
                        builder: (context) => SizedBox(
                              height: 310,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 51.0, left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text("Forgot Password",
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.manrope(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xff180602))),
                                        ),
                                        Text(
                                            'Enter your phone for the verification process. We willl send a 6 digit code to your number.',
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.manrope(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    const Color(0xff8B8380))),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: const SizedBox(),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.87,
                                    height: 50,
                                    child: Form(
                                      key: formKey,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (!value!.startsWith('+')) {
                                            return 'Start with country code';
                                          } else if (value.isEmpty) {
                                            return 'Type in phone number';
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: forgotpassphonecontroller,
                                        decoration: InputDecoration(
                                            labelText: 'Phone number',
                                            labelStyle: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: const Color(0xff8B8380)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide:
                                                    BorderSide(color: color),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color(0xffE4DFDF)),
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: const SizedBox(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 12),
                                    child: MaterialButton(
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          Navigator.pop(context);
                                          verify(
                                              forgotpassphonecontroller.text);
                                          showBarModalBottomSheet(
                                              context: context,
                                              builder: (context) => SizedBox(
                                                    height: 310,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 51.0,
                                                                  left: 20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            8.0),
                                                                child: Text(
                                                                    "OTP Verificaiton",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: GoogleFonts.manrope(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: const Color(
                                                                            0xff180602))),
                                                              ),
                                                              Text(
                                                                  'Enter the 6 digits code sent to your phone number ${forgotpassphonecontroller.text}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: GoogleFonts.manrope(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: const Color(
                                                                          0xff8B8380))),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                              const SizedBox(),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          height: 56,
                                                          child: TextField(
                                                            decoration: InputDecoration(
                                                                border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                            color:
                                                                                Color(0xffD1D5DB)))),

                                                            controller:
                                                                forgotpassotpcontroller,

                                                            style:
                                                                const TextStyle(
                                                              fontSize: 17,
                                                            ),

                                                            //  print("Completed: " + pin);
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                              const SizedBox(),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8.0,
                                                                  bottom: 12),
                                                          child: MaterialButton(
                                                            onPressed: () {
                                                              verifyForgotPass().then((value) =>
                                                                  showBarModalBottomSheet(
                                                                      context:
                                                                          context,
                                                                      builder: (context) =>
                                                                          SizedBox(
                                                                            height:
                                                                                371,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 20.0, left: 20),
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(bottom: 10.0),
                                                                                        child: Text("Reset Password", textAlign: TextAlign.start, style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xff180602))),
                                                                                      ),
                                                                                      Text('Set the new password for your account', textAlign: TextAlign.start, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xff8B8380))),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: const SizedBox(),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(bottom: 12.0),
                                                                                  child: SizedBox(
                                                                                    width: MediaQuery.of(context).size.width * 0.87,
                                                                                    height: 50,
                                                                                    child: TextField(
                                                                                      decoration: InputDecoration(labelText: 'New Password', labelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 14, color: const Color(0xff8B8380)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color), borderRadius: BorderRadius.circular(10)), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE4DFDF)), borderRadius: BorderRadius.circular(10))),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: MediaQuery.of(context).size.width * 0.87,
                                                                                  height: 50,
                                                                                  child: TextField(
                                                                                    decoration: InputDecoration(labelText: 'Confirm Password', labelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 14, color: const Color(0xff8B8380)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color), borderRadius: BorderRadius.circular(10)), enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffE4DFDF)), borderRadius: BorderRadius.circular(10))),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: const SizedBox(),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                                                                                  child: MaterialButton(
                                                                                    onPressed: () {
                                                                                      updatePass();
                                                                                    },
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(100),
                                                                                    ),
                                                                                    elevation: 0,
                                                                                    height: 56,
                                                                                    minWidth: MediaQuery.of(context).size.width * 0.87,
                                                                                    color: color,
                                                                                    child: Text('Continue', style: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white)),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: const SizedBox(),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )));
                                                            },
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                            ),
                                                            elevation: 0,
                                                            height: 56,
                                                            minWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.87,
                                                            color: color,
                                                            child: Text(
                                                                'Continue',
                                                                style: GoogleFonts.manrope(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white)),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                              const SizedBox(),
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                        } else {}
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      elevation: 0,
                                      height: 56,
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.87,
                                      color: color,
                                      child: Text('Send code',
                                          style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Expanded(
                                    child: const SizedBox(),
                                  )
                                ],
                              ),
                            ));
                  },
                  child: Text(
                    'Forgot your password?',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: const Color(0xff8B8380)),
                  ),
                ),
              )
            ],
          )),
    );
  }

  signupform() {
    bool _obscureText = true;

    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 25),
      child: Form(
          key: _signupformKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  right: 20,
                  left: 20,
                ),
                child: SizedBox(
                  height: 56,
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: TextFormField(
                    validator: (value) {
                      if (!value!.startsWith('+')) {
                        return 'Start with country code';
                      } else if (value.isEmpty) {
                        return 'Type in phone number';
                      } else {
                        return null;
                      }
                    },
                    controller: signupphonecontroller,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: color,
                            )),
                        focusColor: color,
                        labelText: 'Phone number',
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
                  right: 20,
                  left: 20,
                ),
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return SizedBox(
                    height: 56,
                    width: MediaQuery.of(context).size.width * 0.87,
                    child: TextFormField(
                        controller: signuppasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Type in password';
                          } else {
                            return null;
                          }
                        },
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: color,
                                )),
                            focusColor: color,
                            suffixIcon: GestureDetector(
                                child: Icon(Icons.visibility,
                                    color: _obscureText ? Colors.grey : color),
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                }),
                            labelText: 'Password',
                            labelStyle: GoogleFonts.manrope(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: const Color(0xff8B8380)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffE5E5E5),
                                ),
                                borderRadius: BorderRadius.circular(10)))),
                  );
                }),
              )
            ],
          )),
    );
  }

  showSignup() {
    showMaterialModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Text(
                        'Create your account',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: const Color(0xff180602)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4.0,
                      ),
                      child: Text(
                          'Create an account today. Tap the button below and start engaging with a variety of joints',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: const Color(0xff8B8380),
                          )),
                    )
                  ],
                ),
                signupform(),
                signupbutton(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: 'Have an account? ',
                            style: GoogleFonts.manrope(
                                color: const Color(0xff333333),
                                fontWeight: FontWeight.w400,
                                fontSize: 14)),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        showLogin();
                      },
                      child: Text('Sign in',
                          style: GoogleFonts.manrope(
                              color: color,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 41.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: const Color(0xffE7E4E4),
                        height: 0.8,
                        width: 140,
                      ),
                      Text('OR',
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: const Color(0xff8B8380).withOpacity(0.5))),
                      Container(
                        color: const Color(0xffE7E4E4),
                        height: 0.8,
                        width: 140,
                      ),
                    ],
                  ),
                ),
                //appleAuthButton(),
                //    googleSignInButton(),
                Expanded(child: const SizedBox()),
              ]),
            ),
        barrierColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))));
  }

  showLogin() {
    showMaterialModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Text(
                        'Login to your account',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: const Color(0xff180602)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4.0,
                        left: 8,
                        right: 8,
                      ),
                      child: Text(
                          'Lets lead you right back to your page. Tap the button below',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: const Color(0xff8B8380),
                          )),
                    )
                  ],
                ),
                loginform(),
                loginbutton(),
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
                                fontSize: 14)),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        showSignup();
                      },
                      child: Text('Sign up',
                          style: GoogleFonts.manrope(
                              color: color,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 41.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: const Color(0xffE7E4E4),
                        height: 0.8,
                        width: 140,
                      ),
                      Text('OR',
                          style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: const Color(0xff8B8380).withOpacity(0.5))),
                      Container(
                        color: const Color(0xffE7E4E4),
                        height: 0.8,
                        width: 140,
                      ),
                    ],
                  ),
                ),
                // appleAuthButton(),
                // googleSignInButton(),
                Expanded(child: const SizedBox()),
              ]),
            ),
        barrierColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        sliderInfo(),
        sliderindicator(),
        Expanded(
          child: const SizedBox(),
        ),
        createAccountbutton(),
        haveAccountbutton(),
        Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 14, right: 14),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: 'By logging or registering, you agree to our ',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black)),
                TextSpan(
                    onEnter: (event) => print('object'),
                    text: 'Terms of Services ',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const WebViewExample(
                              title: 'Terms and Conditions',
                              url:
                                  'https://app.enzuzo.com/policies/tos/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJDdXN0b21lcklEIjoxMDQ4OCwiQ3VzdG9tZXJOYW1lIjoiY3VzdC1IRk5mZHJGWCIsIkN1c3RvbWVyTG9nb1VSTCI6IiIsIlJvbGVzIjpbInJlZmVycmFsIl0sIlByb2R1Y3QiOiJlbnRlcnByaXNlIiwiaXNzIjoiRW56dXpvIEluYy4iLCJuYmYiOjE2NTQ3NjY4MzR9.79MRRO2i6_UIxhf3JK_UGqZMM8xb111xdvIrQUmFMsk'))),
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: color)),
                TextSpan(
                    text: 'and ',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black)),
                TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = (() => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const WebViewExample(
                              title: 'Privacy Policy',
                              url:
                                  'https://app.enzuzo.com/policies/privacy/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJDdXN0b21lcklEIjoxMDQ4OCwiQ3VzdG9tZXJOYW1lIjoiY3VzdC1IRk5mZHJGWCIsIkN1c3RvbWVyTG9nb1VSTCI6IiIsIlJvbGVzIjpbInJlZmVycmFsIl0sIlByb2R1Y3QiOiJlbnRlcnByaXNlIiwiaXNzIjoiRW56dXpvIEluYy4iLCJuYmYiOjE2NTQ3NjYzODN9.RiYyhC2hMqn6OdRk-3IYXF0laej-Eqg8L4V4yOK-xUY')))),
                    text: 'Privacy Policy.',
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: color))
              ])),
        ),
        Expanded(
          child: const SizedBox(),
        ),
      ]),
    );
  }
}
