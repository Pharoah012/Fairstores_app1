import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderStatusDisplay extends StatelessWidget {
  final String status;
  final Timestamp orderDate;
  final Timestamp? feedbackDate;

  const OrderStatusDisplay({
    Key? key,
    required this.status,
    required this.orderDate,
    required this.feedbackDate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateOfOrder = DateFormat("dd/MM/yyyy hh:mm a").format(
      DateTime.fromMillisecondsSinceEpoch(orderDate.millisecondsSinceEpoch)
    );

    switch (status){
      case "active":
        return showPlacedStatus(dateOfOrder);

      default:
        return showRejectedOrDelivered(status, dateOfOrder, feedbackDate);
    }
  }

  // display the tracker for when the order has been placed
  Widget showPlacedStatus(String orderDate){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: kPrimary,
          child: Icon(
            Icons.check,
            color: kWhite,
          ),
        ),
        SizedBox(width: 20,),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: "Order Placed",
                color: kBlack,
                isBold: true,
              ),
              CustomText(
                text: "Your order was placed on $orderDate"
              )
            ],
          ),
        )
      ],
    );
  }

  // display the tracker for when the order has been delivered or rejected
  Widget showRejectedOrDelivered(
    String status,
    String orderDate,
    Timestamp? feedbackDate
  ){

    String dateOfFeedback = DateFormat("dd/MM/yyyy hh:mm a").format(
        DateTime.fromMillisecondsSinceEpoch(feedbackDate!.millisecondsSinceEpoch)
    );


    return Row(
      children: [
        CircleAvatar(
          backgroundColor: kPrimary,
          child: Icon(
            Icons.check,
            color: kWhite,
          ),
        ),
        SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Order ${status == "delivered" ? "Delivered" : "Rejected"}",
              color: kBlack,
              isBold: true,
            ),
            Flexible(
              child: CustomText(
                text: "Your order was "
                  "${status == "delivered" ? "Delivered" : "Rejected"} "
                  "on $dateOfFeedback"
              ),
            )
          ],
        )
      ],
    );
  }
}
