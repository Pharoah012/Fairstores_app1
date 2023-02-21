import 'package:fairstores/constants.dart';
import 'package:fairstores/main.dart';
import 'package:fairstores/whatsappchat.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Details extends StatefulWidget {
  final String details;

  final String title;
  const Details({Key? key, required this.details, required this.title})
      : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: const Icon(
              Icons.arrow_back,
              size: 15,
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.title,
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600, fontSize: 20)),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              " ${widget.details}",
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w400, fontSize: 14, height: 2),
            ),
          ),
          Expanded(child: SizedBox()),
          SizedBox(
            child: TextButton(
                onPressed: () {
                  openwhatsapp(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CustomText(
                        text: "Contact Us",
                        color: kPrimary,
                      ),
                      Expanded(child: SizedBox()),
                      Icon(
                        Icons.whatsapp,
                        color: kPrimary,
                      )
                    ],
                  ),
                )),
          )
        ]),
      ),
    );
  }
}
