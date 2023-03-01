import 'dart:developer';
import 'package:fairstores/admin/admin.dart';
import 'package:fairstores/mainScreens/notifications.dart';
import 'package:fairstores/mainScreens/search.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/delivery/deliveryonboarding.dart';
import 'package:fairstores/events/eventshome.dart';
import 'package:fairstores/food/foodpage.dart';
import 'package:fairstores/products/productonboarding.dart';
import 'package:fairstores/providers/schoolListProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/customHomeOption.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends ConsumerStatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {

  search() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Center(
        child: SizedBox(
          height: 43,
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextField(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Search(
                      addappbar: true,
                    ),
                  )
                );
              },
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(
                        color: kPrimary,
                      )),
                  focusColor: kPrimary,
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 14,
                  ),
                  labelText: 'Search FairStores app',
                  labelStyle: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: const Color(0xff8B8380)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xffE5E5E5),
                      ),
                      borderRadius: BorderRadius.circular(100)))),
        ),
      ),
    );
  }

  homeHeader() {
    UserModel user = ref.read(userProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage("images/profileimage.jpg"),
            ),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Welcome back,',
                  fontSize: 12,
                ),
                CustomText(
                  text: user.username!,
                  fontSize: 18,
                  isMediumWeight: true,
                  color: kBlack,
                )
              ],
            ),
          ],
        ),
        Row(
          children: [
            user.ismanager
              ? IconButton(
                icon: const Icon(Icons.admin_panel_settings),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Admin(),
                      ));
                },
            ) : SizedBox.shrink(),
            IconButton(
              icon: const Icon(Icons.notifications_on_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Notifications(),
                  )
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  homebuttons() {
    return Column(
      children: [
        SizedBox(height: 20,),
        CustomHomeOption(
            nextScreen: FoodPage(),
            image: Image.asset('images/restuarantlogo.png'),
            title: "Restaurants",
            color: const Color(0xffFEF6E9)
        ),
        SizedBox(height: 24,),
        Row(
          children: [
            Expanded(
              child: CustomHomeOption(
                  isVertical: true,
                  nextScreen: const DeliveryOnboarding(),
                  image: Image.asset("images/deliverylogo.png"),
                  title: "Delivery",
                  color: const Color(0xffFEEFEC)
              ),
            ),
            SizedBox(width: 21,),
            Expanded(
              child: CustomHomeOption(
                  isVertical: true,
                  nextScreen: EventsPage( ),
                  image: Image.asset("images/fairevents.png"),
                  title: "FairEvents",
                  color: const Color(0xffECF9EB)
              ),
            ),
          ],
        ),
        SizedBox(height: 24,),
        CustomHomeOption(
          nextScreen: const ProductOnboardingScreen(),
          image: Image.asset('images/producticon.png'),
          title: "Products",
          color: const Color(0xffFEF6E9)
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _user = ref.watch(userProvider);
    final schools = ref.watch(schoolsProvider);

    schools.when(
        data: (data) => log("loaded schools"),
        error: (_, err) => log("Error loading school: ${err.toString()}"),
        loading: () => log("loading schools")
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: (
          _user.email != null
          && _user.username != null
          && _user.school != null
          && _user.number != null
      ) ? SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              homeHeader(),
              search(),
              homebuttons(),
            ]
          ),
        ),
      ) : SizedBox.shrink(),
    );
  }
}
