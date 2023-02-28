import 'dart:developer';

import 'package:fairstores/constants.dart';
import 'package:fairstores/mainScreens/history.dart';
import 'package:fairstores/mainScreens/home.dart';
import 'package:fairstores/mainScreens/profile.dart';
import 'package:fairstores/mainScreens/search.dart';
import 'package:fairstores/mainScreens/userInfoDetails.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/providers/authProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final currentScreenProvider = StateProvider.autoDispose<int>((ref) => 0);


class HomeScreen extends ConsumerStatefulWidget {
  final bool isSocialAuth;

  const HomeScreen({
    Key? key,
    this.isSocialAuth = false,
  }) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  List mainScreens = [
    Home(),
    Search(addappbar: false,),
    History(),
    Profile(),
  ];


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(authProvider).storetokens();

      UserModel user = ref.read(userProvider);
      log(user.school ?? "school");
      if (
          user.username == null || user.username!.isEmpty
          || user.email == null || user.email!.isEmpty
          || user.school == null || user.school!.isEmpty
        ) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => UserInfoDetails(
              isSocialAuth: widget.isSocialAuth,
            )
          ),
          (route) => false
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final _currentScreen = ref.watch(currentScreenProvider);
    final _user = ref.watch(userProvider);

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
            onTap: (value) => ref.read(currentScreenProvider.notifier).state = value,
          ),
        ));
  }
}
