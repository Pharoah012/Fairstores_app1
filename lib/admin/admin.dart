import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/main.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool orderavailable = false;

  var serverToken = "";

  upload(parentcontext) {
    showDialog(
        context: parentcontext,
        builder: (context) {
          return SimpleDialog(
              title: Center(
                  child: CustomText(
                    text: 'General Notifications',
                    isBold: true
                  )
               ),
              children: [
                const SimpleDialogOption(child: TextField()),
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Center(child: Text('Send Message Across')),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsRef = FirebaseFirestore.instance.collection('ActiveOrders');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        centerTitle: false,
        title: const Text('Fairstores Admin DashBoard'),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              upload(context);
            },
            title: const Text(
              'Send Notifications',
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: transactionsRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const ListTile(
                    title: Text(
                      'Fair Restuarants',
                      style: TextStyle(),
                    ),
                  );
                }
                return ListTile(
                  onTap: () {},
                  title: Text(
                    'Fair Restuarants',
                    style: TextStyle(color: kPrimary),
                  ),
                );
              }),
          const ListTile(
            title: Text('Fair Events'),
          ),
        ],
      ),
    );
  }
}
