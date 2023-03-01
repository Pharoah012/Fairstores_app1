import 'package:fairstores/constants.dart';
import 'package:fairstores/whatsappchat.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String details;
  final String title;

  const Details({
    Key? key,
    required this.details,
    required this.title
  }) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.title
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: widget.details
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                openwhatsapp(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Contact Us",
                      color: kPrimary,
                    ),
                    Icon(
                      Icons.whatsapp,
                      color: kPrimary,
                    )
                  ],
                ),
              )
            )
          ]
        ),
      ),
    );
  }
}
