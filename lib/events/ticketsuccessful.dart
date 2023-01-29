import 'package:fairstores/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurchsaeSuccessful extends StatefulWidget {
  final String message;

  const PurchsaeSuccessful({Key? key, required this.message}) : super(key: key);

  @override
  State<PurchsaeSuccessful> createState() => _PurchsaeSuccessfulState();
}

class _PurchsaeSuccessfulState extends State<PurchsaeSuccessful> {
  purchasesuccessfulbutton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(100)),
        child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Text(
                'Go back home',
                style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: SizedBox()),
              Image.asset('images/successfultick.png'),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Text(
                  'Purchase Successful',
                  style: GoogleFonts.manrope(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Text(
                  widget.message,
                  style: GoogleFonts.manrope(
                      fontSize: 14, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(child: const SizedBox()),
              purchasesuccessfulbutton(),
              Padding(
                padding: const EdgeInsets.only(top: 11.0, bottom: 42),
                child: Text(
                  'You can track your order from the history tab',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
