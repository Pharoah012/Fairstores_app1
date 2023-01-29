import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fairstores/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryOnboarding extends StatefulWidget {
  const DeliveryOnboarding({Key? key}) : super(key: key);

  @override
  State<DeliveryOnboarding> createState() => _DeliveryOnboardingState();
}

class _DeliveryOnboardingState extends State<DeliveryOnboarding> {
  final CarouselController _controller = CarouselController();

  int _current = 0;
  List<Widget> imgList = [
    Image.asset(
      'images/deliveryimage1.png.png',
    ),
  ];

  sendpackage() {
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
        color: color,
        child: Text('Send Package',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white)),
      ),
    );
  }

  recievepackage() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 30),
      child: MaterialButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Coming Soon'),
          ));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: const BorderSide(color: Color(0xffE5E5E5))),
        elevation: 0,
        height: 56,
        minWidth: MediaQuery.of(context).size.width * 0.87,
        color: Colors.white,
        child: Text('Recieve Package',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black)),
      ),
    );
  }

// SLider with text info
  sliderInfo() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: CarouselSlider(
        carouselController: _controller,
        items: imgList,
        options: CarouselOptions(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Delivery',
            style: GoogleFonts.manrope(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 12,
                  ),
                ),
                Text(
                  'Back',
                  style: GoogleFonts.manrope(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        body: Column(children: [
          Image.asset(
            'images/deliveryimage1.png',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 33),
            child: Text('Send and Receive Packages with Fairstores',
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700, fontSize: 24)),
          ),
          Expanded(
            child: const SizedBox(),
          ),
          sendpackage(),
          recievepackage(),
          Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Text(
                'Coming Soon',
                style: GoogleFonts.manrope(
                    fontSize: 14, fontWeight: FontWeight.w500, color: color),
              )),
          Expanded(
            child: const SizedBox(),
          ),
        ]));
  }
}
