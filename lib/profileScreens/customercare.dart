import 'package:fairstores/whatsappchat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerCare extends StatefulWidget {
  const CustomerCare({Key? key}) : super(key: key);

  @override
  State<CustomerCare> createState() => _CustomerCareState();
}

class _CustomerCareState extends State<CustomerCare> {
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
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Customer Care',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w600, fontSize: 20)),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: ListTile(
              onTap: (() {
                openwhatsapp(context);
                // Navigator.push(context,
                //   MaterialPageRoute(builder: ((context) => const Help())));
              }),
              title: Text('Contact Us',
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500, fontSize: 14)),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
