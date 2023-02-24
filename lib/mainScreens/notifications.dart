import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/food/notificationsedit.dart';
import 'package:fairstores/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Notifications extends StatefulWidget {
  final String user;
  const Notifications({Key? key, required this.user}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    getnotifications();
  }

  getnotifications() async {
    print(widget.user);
    QuerySnapshot snapshot = await notificationsRef
        .doc(widget.user)
        .collection('Notifications')
        .get();
    List<NotificationModel> notifications = [];
    notifications =
        snapshot.docs.map((e) => NotificationModel.fromDocument(e)).toList();
    setState(() {
      this.notifications = notifications;
    });
  }

  footerbutton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: MaterialButton(
        onPressed: () async {
          QuerySnapshot snapshot = await notificationsRef
              .doc(widget.user)
              .collection('Notifications')
              .get();
          if (snapshot.docs.isNotEmpty) {
            for (var element in snapshot.docs) {
              element.reference.delete();
            }
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        elevation: 0,
        height: 56,
        minWidth: 335,
        color: kPrimary,
        child: Text('Clear All',
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const NotificationEdit()));
          //       },
          //       icon: const Icon(
          //         Icons.edit,
          //         size: 15,
          //         color: Color(0xff858585),
          //       ))
          // ],
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
            'Notifications',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView(children: notifications),
            ),
            footerbutton(),
          ]),
        ));
  }
}

class NotificationModel extends StatefulWidget {
  const NotificationModel({Key? key}) : super(key: key);

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    return NotificationModel();
  }

  @override
  _NotificationModelState createState() => _NotificationModelState();
}

class _NotificationModelState extends State<NotificationModel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xfff25e37).withOpacity(0.1),
              child: Icon(
                Icons.notifications_rounded,
                color: kPrimary,
              )),
          title: Text(
            'New Notification',
            style:
                GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text('Grab your meals now on foodfair, Fully loaded',
              style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w400, fontSize: 10)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 76.0, bottom: 10),
          child: Text('Today',
              style: GoogleFonts.manrope(
                  color: const Color(0xff8B8380),
                  fontWeight: FontWeight.w400,
                  fontSize: 10)),
        )
      ],
    );
  }
}
