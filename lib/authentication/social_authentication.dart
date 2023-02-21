import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialAuthentication{

  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', googleSignInURL]);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  googlesigninsilently() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => HomeScreen(
        //         signinmethod: 'GoogleAuth',
        //         userId: account.id,
        //         password: '',
        //         phonenumber: '',
        //       ),
        //     ));
      }
    });
    _googleSignIn.signInSilently();
  }



  postDetailsToFirestore(phoneController, pass) {
    User? user = _auth.currentUser;

    UserModel userModel = UserModel(ismanager: false);

    userModel.email = "";
    userModel.uid = user?.uid;
    userModel.name = "";
    userModel.number = phoneController;
    userModel.password = pass;
    userModel.school = '';
    userModel.signinmethod = '';

    userModel.createUser(user!);
    Fluttertoast.showToast(msg: "Account created successfully");
  }




}