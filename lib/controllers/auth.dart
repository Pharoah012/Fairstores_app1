import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/providers/otpTimerProvider.dart';
import 'package:fairstores/widgets/customErrorWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:encrypt/encrypt.dart' as crypt;

enum SIGNINMETHOD {PHONE, GOOGLE, APPLE}

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
  Future<void> storetokens() async {
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    print(osUserID);
    tokensRef.doc(currentUser!.uid).set({'devtoken': osUserID});
  }

  // ------------------- USER DETAILS ---------------------

  // get the details of the current user
  Future<UserModel> getUser() async {
    return UserModel.fromDocument(await userRef.doc(currentUser!.uid).get());
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
  Future<Map<String, dynamic>> verfiyOTP({
    required String otp,
    required WidgetRef ref,
    bool isSignUp = false
  }) async {
    try {

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: ref.read(receivedVerificationIDProvider)!,
          smsCode: otp
      );

      return successReport(successObject: credential);

    }
    catch(exception) {
      log(exception.toString());
      return errorReport(errorMessage: "The OTP you entered is invalid.");
    }
  }

  //e This method sends the otp to the user and checks if the phone number is valid
  Future<void> sendOTPForVerification({
    required String phoneNumber,
    required WidgetRef ref
  }) async {


    // Only send the OTP if the number the user is trying to verify is different
    // OR the number is the same but the timer has expired
    if (ref.read(numberToVerify.notifier).state != phoneNumber
      || (ref.read(numberToVerify.notifier).state == phoneNumber
        && (ref.read(otpTimerProvider) == null
        || ref.read(otpTimerProvider.notifier).enabledResend)
      )
    ){

      // reset the timer if is it running before a new OTP is sent
      if (ref.read(otpTimerProvider) != null){
        ref.read(otpTimerProvider.notifier).stopTimer();
      }

      // Send the OTP
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {

          Fluttertoast.showToast(
            msg: "An error occurred while sending the OTP. "
            "Please try again later."
          );

          // // print(e);
          // if (e.code == 'invalid-phone-number') {
          //   Fluttertoast.showToast(
          //       timeInSecForIosWeb: 2,
          //       msg: "Oops Something went wrong please try again later");
          // }
        },
        forceResendingToken: ref.read(resendTokenProvider),
        codeSent: (String verificationID, int? resendToken) async {
          log("OTP");
          ref.read(resendTokenProvider.notifier).state = resendToken;
          ref.read(receivedVerificationIDProvider.notifier).state = verificationID;

          // set the current number that the OTP was sent to
          ref.read(numberToVerify.notifier).state = phoneNumber;

          ref.read(otpTimerProvider.notifier).startTimer();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }

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

      // check if the user exists
      UserModel userModel = await getUser();



      bool addUserDetailsToFirebase = await postUserDetailsToFirestore(
        phoneNumber: phoneNumber,
        password: password,
        signInMethod: SIGNINMETHOD.PHONE
      );

      if (!addUserDetailsToFirebase){
        return errorReport(
          errorMessage: "An error occurred while creating your account."
        );
      }



      return successReport(successObject: userModel);
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
  }

  Future<Map<String, dynamic>> isUserAMember({
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
    try {
      UserModel user = await getUser();

      return successReport(successObject: user);
    } on FirebaseAuthException catch (e) {
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
      else {
        return errorReport(
            errorMessage: "An error occurred while logging you in. Please try again later."
        );
      }
    }
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
    required SIGNINMETHOD signInMethod,
    String? phoneNumber,
    String? email,
    String? username,
    String? password,
  }) async {

    try {
      UserModel userModel = UserModel(ismanager: false);

      userModel.email = email ?? "";
      userModel.uid = currentUser!.uid;
      userModel.username = username ?? "";
      userModel.number = phoneNumber ?? "";
      userModel.password = password != null
        ? encryptPassword(password: password)
        : "";
      userModel.school = '';
      userModel.signinmethod = signInMethod.name;

      await userModel.createUser(userModel);

      return true;
    }
    catch(exception) {
      log(exception.toString());
      return false;
    }

  }

  // ---------------- SOCIAL AUTHENTICATION -----------------

  Future<Map<String, dynamic>> socialAuthentication({
    required String authMethod,
    bool isSignIn = true
  }) async {

    try{

      if (authMethod == "google"){

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

          final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
        }

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

        final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(oauthCredential);

      }

      // check if the user exists
      DocumentSnapshot user = await userRef.doc(_firebaseAuth.currentUser!.uid).get();

      // check if the user is signing up with existing credentials
      if (!isSignIn && user.exists){

        return errorReport(
            errorMessage: "An account with these credentials already exists."
        );

      }
      else if (!isSignIn){
        //check if the user is signing up with unique credentials
        await postUserDetailsToFirestore(
            signInMethod: authMethod == "google" ? SIGNINMETHOD.GOOGLE : SIGNINMETHOD.APPLE,
            email: currentUser!.email,
            username: currentUser!.displayName
        );

        return successReport(successObject: authMethod);
      }
      else if (isSignIn && !user.exists){
        //check if the user is signing up with unique credentials
        await postUserDetailsToFirestore(
            signInMethod: authMethod == "google" ? SIGNINMETHOD.GOOGLE : SIGNINMETHOD.APPLE,
            email: currentUser!.email ?? "",
            username: currentUser!.displayName ?? ""
        );

        // check if the user is signing in for the first time
        return successReport(successObject: authMethod);
      }
      else{
        // check if the user is signing in

        // get the user model
        UserModel user = await getUser();

        return successReport(successObject: user);
      }

    }
    on FirebaseAuthException catch (e) {
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
      else{
        return errorReport(
            errorMessage: "An error occurred during your authentication"
        );
      }
    }
    catch (exception){
      return errorReport(
          errorMessage: "An error occurred during your authentication"
      );
    }

  }

  // -------------- SIGN OUT FUNCTIONS -----------------
  // Future<void> _handleSignOut() => _googleSignIn.disconnect();
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

}