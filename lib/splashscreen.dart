// this screen represents the splash and loading screen of the app

import 'package:fairstores/authentication/onboardingScreen.dart';
import 'package:fairstores/mainScreens/homescreen.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      Future.delayed(
        Duration(seconds: 3),
        () async {
          if (ref.read(authProvider).currentUser != null){
            ref.read(userProvider.notifier).state = await ref.read(authProvider).getUser();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      isSocialAuth: ref.read(userProvider).signinmethod != "PHONE",
                    )
                ),
                    (route) => false
            );
          }
          else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => OnboardingScreen()
                ),
                    (route) => false
            );
          }
        }
      );

    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xffE5E5E5),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: const [
              Color(0xffF25E37),
              Color(0xffF56C48),
            ])),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image.asset('images/logo.png'),
        ),
      ),
    );
  }
}
