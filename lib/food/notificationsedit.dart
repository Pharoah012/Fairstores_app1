import 'package:fairstores/constants.dart';
import 'package:fairstores/main.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationEdit extends StatefulWidget {
  const NotificationEdit({Key? key}) : super(key: key);

  @override
  State<NotificationEdit> createState() => _NotificationEditState();
}

class _NotificationEditState extends State<NotificationEdit> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Notifications",),
      body: SwitchListTile(
        value: isSwitched,
        activeColor: kPrimary,
        onChanged: (bool value) {
          setState(() => isSwitched = value);
        },
        title: Text(
          'App Notifications',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text('Grab your meals nw on foodfair, Fully loaded',
            style:
                GoogleFonts.manrope(fontWeight: FontWeight.w400, fontSize: 10)),
      ),
    );
  }
}
