import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderStatusDisplay extends StatelessWidget {
  final String status;
  final Timestamp orderDate;

  const OrderStatusDisplay({
    Key? key,
    required this.status,
    required this.orderDate
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String date = DateFormat("dd/mm/yyyy hh:mm").format(
      DateTime.fromMillisecondsSinceEpoch(orderDate.millisecondsSinceEpoch * 1000)
    );

    switch (status){
      case "pending":
        return showPlacedStatus(date);

      default:
        return showRejectedOrDelivered(status, date);
    }
  }

  // display the tracker for when the order has been placed
  Widget showPlacedStatus(String orderDate){
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
    );
  }

  // display the tracker for when the order has been delivered or rejected
  Widget showRejectedOrDelivered(String status, String orderDate){
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
                "on $orderDate"
            )
          ],
        )
      ],
    );
  }
}
