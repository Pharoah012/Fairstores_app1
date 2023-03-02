import 'package:fairstores/constants.dart';
import 'package:fairstores/main.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductOnboardingScreen extends StatefulWidget {
  const ProductOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<ProductOnboardingScreen> createState() =>
      _ProductOnboardingScreenState();
}

class _ProductOnboardingScreenState extends State<ProductOnboardingScreen> {
  products() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: MaterialButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Coming Soon'),
          ));
        },
        elevation: 0,
        height: 56,
        minWidth: MediaQuery.of(context).size.width * 0.87,
        color: kPrimary,
        child: Text('Shop now',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Products"
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 55.0),
              child: Image.asset(
                'images/productonboard.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 33),
              child: Text('Buy and Sell Your Products on FairStores',
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700, fontSize: 24)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 33, top: 8),
              child: Text(
                  'FairStores provides you with a platform to sell your business products to a wide range of customers from different schools.',
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w400, fontSize: 14)),
            ),
            Expanded(
              child: SizedBox(),
            ),
            products(),
            Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 30),
                child: Text(
                  'Coming Soon',
                  style: GoogleFonts.manrope(
                      fontSize: 14, fontWeight: FontWeight.w500, color: kPrimary),
                )),
            Expanded(
              child: SizedBox(),
            ),
          ],
        ));
  }
}
