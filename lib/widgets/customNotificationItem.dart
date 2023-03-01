import 'package:fairstores/constants.dart';
import 'package:fairstores/models/notificationModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class CustomNotifiicationItem extends StatelessWidget {
  final CustomNotificationModel notification;

  const CustomNotifiicationItem({
    Key? key,
    required this.notification
  }) : super(key: key);

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
          title: CustomText(
            text: 'New Notification',
            fontSize: 16,
            color: kBlack,
          ),
          subtitle: CustomText(
            text: 'Grab your meals now on foodfair, Fully loaded',
            fontSize: 12,
          )
        ),
        Padding(
          padding: const EdgeInsets.only(left: 76.0, bottom: 10),
          child: CustomText(
            text: 'Today',
            fontSize: 12,
            color: kLabelColor,
          )
        )
      ],
    );
  }
}
