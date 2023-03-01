import 'package:fairstores/profileScreens/customercare.dart';
import 'package:fairstores/profileScreens/details.dart';
import 'package:fairstores/models/securityModel.dart';

import 'package:fairstores/webview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Help extends StatefulWidget {

  final SecurityModel securityModel;

  const Help({Key? key, required this.securityModel}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: const Icon(
              Icons.arrow_back,
              size: 15,
              color: Colors.black,
            )),
        centerTitle: true,
        title: Text(
          'Help',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text('All topics',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500, fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: ListTile(
            onTap: (() {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) =>  Details(details: widget.securityModel.aboutUs,title: 'About Us',))));
            }),
            title: Text('About FairStores',
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w500, fontSize: 14)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
            ),
          ),
        ),
        ListTile(
          onTap: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>  Details(details: widget.securityModel.vendorDetails,title: 'Vendors',))));
          }),
          title: Text('Vendors',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500, fontSize: 14)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ),
         ListTile(
          onTap: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>  Details(details: widget.securityModel.deliveryDetails,title: 'Delivery',))));
          }),
          title: Text('Delivery',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500, fontSize: 14)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ),
         ListTile(
          onTap: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>  Details(details: widget.securityModel.eventsDetails,title: 'FairEvents',))));
          }),
          title: Text('Events',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500, fontSize: 14)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ),
        ListTile(
          onTap: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => const CustomerCare())));
          }),
          title: Text('Customer Care',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500, fontSize: 14)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ),
        ListTile(
          onTap: (() {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) =>const WebViewExample(title: "Terms and Conditions", url: ''))));
          }),
          title: Text('Terms and Conditions',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500, fontSize: 14)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ),
        ListTile(
          onTap: (() {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => const WebViewExample(title: 'Privacy Policy',url: '',))));
          }),
          title: Text('Privacy Policy',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500, fontSize: 14)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ),
      ]),
    );
  }
}
