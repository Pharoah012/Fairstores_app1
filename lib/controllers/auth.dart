import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/widgets/customErrorWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:encrypt/encrypt.dart' as crypt;

class Auth {

  // Instance variables
  final _firebaseAuth = FirebaseAuth.instance; //Firebase instance

  //Track authentication changes
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  //Getting Current user
  User? get currentUser => FirebaseAuth.instance.currentUser;

  // The error object to return when there is an error
  Map<String, dynamic> errorReport({required String errorMessage}){
    return {
      "type": "error",
      "object": CustomError(
        errorMessage: errorMessage,
        oneRemove: true,
      )
    };
  }

  // The success object to return when the function executed successfully
  Map<String, dynamic> successReport({required dynamic successObject}){
    return {
      "type": "success",
      "object": successObject
    };
  }

  // Update the notification token
  Future<dynamic> updatePushToken({userID, token}){
    CollectionReference users = FirebaseFirestore.instance.collection("users");

    return users.doc(userID).update({
      "pushToken": token
    })
        .then((value) => true)
        .catchError((error) => false);
  }

  // ---------------- MAIN AUTHENTICATION -----------------

  // This method encrypts the users password and returns the encrypted password

  String encryptPassword({required String password}) {
    final encrypter = Encrypter(Salsa20(crypt.Key.fromLength(32)));

    final encrypted = encrypter.encrypt(password, iv: crypt.IV.fromLength(8));

    return encrypted.base64;
  }

  // Veriry login password
  bool verifyLoginPassword({
    required String loginPassword,
    required String userPassword
  }) {
    final encrypter = Encrypter(Salsa20(crypt.Key.fromLength(32)));
    final encrypted = encrypter.encrypt(
        loginPassword,
        iv: crypt.IV.fromLength(8)
    );

    //Checks if the passwords match
    return encrypted.base64 == userPassword;
  }


  // This function verifies the OTP
  Map<String, dynamic> verfiyOTP({
    required String otp,
    required String receivedVerificationID
  }) {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: receivedVerificationID,
          smsCode: otp
      );

      return successReport(successObject: credential);
    }
    catch(exception) {
      return errorReport(errorMessage: "The OTP you entered is invalid.");
    }
  }

  //e This method sends the otp to the user and checks if the phone number is valid
  Future<void> sendOTPForVerification({
    required String phoneNumber,
    required String receivedVerificationID
  }) async {

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await _firebaseAuth
        //     .signInWithCredential(credential)
        //     .then((value) => {print("You are logged in successfully")});
      },
      verificationFailed: (FirebaseAuthException e) {
        // print(e);
        if (e.code == 'invalid-phone-number') {
          Fluttertoast.showToast(
              timeInSecForIosWeb: 2,
              msg: "Oops Something went wrong please try again later");
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        // TODO: WHEN OTP IS SENT
        // verificationIDReceived = verificationId;
        // otpCodeVisible = true
        // setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }


  // This  method check all the parameters are met then stores the user
  // information in the database else return an error
  Future<Map<String, dynamic>> signUp({
    required PhoneAuthCredential phoneAuthCredential,
    required String phoneNumber,
    required String password
  }) async {

    try {
      UserCredential user = await _firebaseAuth.signInWithCredential(
        phoneAuthCredential
      );

      bool addUserDetailsToFirebase = await postUserDetailsToFirestore(
        phoneNumber: phoneNumber,
        password: password
      );

      if (!addUserDetailsToFirebase){
        return errorReport(
          errorMessage: "An error occurred while creating your account."
        );
      }

      return successReport(successObject: user.user);
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return errorReport(
          errorMessage: "This account exists with different credentials"
        );
        // handle the error here
      }
      else if (e.code == 'invalid-credential') {
        // handle the error here
        return errorReport(
          errorMessage: "Your credentials are invalid"
        );
      }
      else{
        return errorReport(
            errorMessage: "An error occurred while signing up"
        );
      }
    }

    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => HomeScreen(
    //             signinmethod: 'PhoneAuth',
    //             userId: _auth.currentUser!.uid,
    //             password: encryptPassword(password: password),
    //             phonenumber: signUpPhoneController.text
    //         )
    //     )
    // )
  }

  Future<Map<String, dynamic>> getUser({
    required String phoneNumber
  }) async {

    QuerySnapshot user = await userRef
      .where('number', isEqualTo: phoneNumber)
      .get();

    if (user.size < 1){
      return errorReport(
        errorMessage: "There is no account associated with the given credentials."
      );
    }

    return successReport(successObject: UserModel.fromDocument(user.docs.first));
  }

  Future<Map<String, dynamic>> login({
    required PhoneAuthCredential credential,
  }) async {

    await _firebaseAuth.signInWithCredential(credential)
        .then((value) => successReport(successObject: value.user)
    ).catchError((e) => errorReport(
        errorMessage: "There is no account associated with the given credentials."
    ));

    return errorReport(errorMessage: "An error occurred while logging you in");
  }


  Future<Map<String, dynamic>> resetPassword({
    required String phoneNumber,
    required String newPassword,
    required String confirmPassword
  }) async {

    try{

      if (newPassword != confirmPassword) {
        // Fluttertoast.showToast(msg: 'Passwords do not match');
        return errorReport(errorMessage: "Passwords do not match");
      }

      String encryptedPassword = encryptPassword(password: newPassword);

      // check if there's an account that exists with the given phone number
      QuerySnapshot snapshot = await userRef.where(
          'number', isEqualTo: phoneNumber
      ).get();

      // update the user's password
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update({"password": encryptedPassword});
      }

      return successReport(successObject: true);

    }
    catch (exception){
      log(exception.toString());
      return errorReport(
        errorMessage: "An error occurred while resetting your password."
      );
    }
  }

  // add the user's credentials to the firebase database
  Future<bool> postUserDetailsToFirestore({
    required String phoneNumber,
    required String password
  }) async {

    try {
      UserModel userModel = UserModel(ismanager: false);

      userModel.email = "";
      userModel.uid = currentUser!.uid;
      userModel.name = "";
      userModel.number = phoneNumber;
      userModel.password = password;
      userModel.school = '';
      userModel.signinmethod = '';

      await userModel.createUser(userModel);

      return true;
    }
    catch(exception) {
      log(exception.toString());
      return false;
    }

  }

  // ---------------- SOCIAL AUTHENTICATION -----------------

  Future<Map<String, dynamic>> handleSignIn({required signInType}) async {

    try{

      if (signInType == "google"){

        // final GoogleSignIn _googleSignIn = GoogleSignIn(
        //     scopes: ['email', googleSignInURL]);

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
            await _firebaseAuth.signInWithCredential(credential);

            return successReport(successObject: userCredential.user);

            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => HomeScreen(
            //         signinmethod: 'GoogleAuth',
            //         userId: _auth.currentUser!.uid,
            //         phonenumber: '',
            //         password: '',
            //       ),
            //     ));
          } on FirebaseAuthException catch (e) {
            if (e.code == 'account-exists-with-different-credential') {
              return errorReport(
                  errorMessage: "This account exists with different credentials"
              );
              // handle the error here
            } else if (e.code == 'invalid-credential') {
              // handle the error here
              return errorReport(
                errorMessage: "Your credentials are invalid"
              );
            }
          } catch (e) {
            // handle the error here
            log(e.toString());
            return errorReport(
                errorMessage: "An error occurred while signing in with socials"
            );
          }
        }

        return errorReport(
          errorMessage: "An error during Google sign in"
        );

      }
      else {
        final credential = await SignInWithApple.getAppleIDCredential(scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ]);

        // ignore: avoid_print

        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode,
        );

        // If we got this far, a session based on the Apple ID credential has been created in your system,
        // and you can now set this as the app's session
        // ignore: avoid_print
        print("session");
        final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(oauthCredential);

        return successReport(successObject: authResult.user);

      }
    }

    catch (exception){
      return errorReport(
        errorMessage: "Error signing in with Apple"
      );
    }

  }

}