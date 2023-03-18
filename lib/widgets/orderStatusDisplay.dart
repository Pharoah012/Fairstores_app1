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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: kPrimary,
          child: Icon(
            Icons.check,
            color: kWhite,
            size: 16,
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


    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: kPrimary,
                  child: Icon(
                    Icons.check,
                    color: kWhite,
                    size: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      thickness: 2,
                      color: kPrimary,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 20,),
            Column(
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
            )
          ],
        ),
        SizedBox(height: 10,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: kPrimary,
              child: Icon(
                Icons.check,
                color: kWhite,
                size: 16,
              ),
            ),
            SizedBox(width: 20,),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "Order ${status == "delivered" ? "Delivered" : "Rejected"}",
                    color: kBlack,
                    isBold: true,
                  ),
                  CustomText(
                    text: "Your order was "
                      "${status == "delivered" ? "Delivered" : "Rejected"} "
                      "on $dateOfFeedback",
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
