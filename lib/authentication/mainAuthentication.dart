import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainAuthentication {

  static Future<PhoneAuthCredential> verifyForgotPass({
    required String verificationIDReceived,
    required String OTP
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived,
        smsCode: OTP
    );
    return credential;
  }

  //e This method sends the otp to the user and checks if the phone number is valid
  static Future<void> verify(auth, phoneController, verificationIDReceived) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneController,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth
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
        verificationIDReceived = verificationId;
        // otpCodeVisible = true
        // setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}