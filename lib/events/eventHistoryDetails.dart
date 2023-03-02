import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/eventHistoryModel.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';

class EventHistoryDetails extends StatefulWidget {
  final EventHistoryModel eventHistoryItem;

  const EventHistoryDetails({
    Key? key,
    required this.eventHistoryItem
  }) : super(key: key);

  @override
  _EventHistoryDetailsState createState() => _EventHistoryDetailsState();
}

class _EventHistoryDetailsState extends State<EventHistoryDetails> {

  Widget ticketHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: widget.eventHistoryItem.eventimage,
            height: 131,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          ),
          SizedBox(height: 12,),
          CustomText(
            text: widget.eventHistoryItem.orderdetails,
            fontSize: 16,
            isBold: true,
            overflow: TextOverflow.ellipsis
          ),
          CustomText(
            text: 'Use your ticket ID to claim the physical ticket',
            fontSize: 12,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: 18,),
          Divider()
        ],
      ),
    );
  }

  Widget ticketBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Location',
              fontSize: 12,
              isMediumWeight: true,
            ),
            CustomText(
              text: widget.eventHistoryItem.deliverylocation,
              isBold: true,
            )
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Date',
                  fontSize: 12,
                  isMediumWeight: true,
                ),
                CustomText(
                  text: '${widget.eventHistoryItem.timestamp.toDate().day}'
                    '-${widget.eventHistoryItem.timestamp.toDate().month}'
                    '-${widget.eventHistoryItem.timestamp.toDate().year}',
                  isBold: true,
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Time',
                  fontSize: 12,
                  isMediumWeight: true,
                ),
                CustomText(
                  text: '${widget.eventHistoryItem.timestamp.toDate().hour}:${widget.eventHistoryItem.timestamp.toDate().minute}',
                  isBold: true,
                )
              ],
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Quantity Purchased',
                  fontSize: 12,
                  isMediumWeight: true,
                ),
                CustomText(
                  text: widget.eventHistoryItem.quantity.toString(),
                  isBold: true,
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.245,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Status',
                  fontSize: 12,
                  isMediumWeight: true,
                ),
                CustomText(
                  text: widget.eventHistoryItem.status,
                  isBold: true,
                )
              ],
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Cost',
                  fontSize: 12,
                  isMediumWeight: true,
                ),
                CustomText(
                  text: 'GHS ${widget.eventHistoryItem.total.toString()}',
                  isBold: true,
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Order ID',
                  fontSize: 12,
                  isMediumWeight: true,
                ),
                CustomText(
                  text: widget.eventHistoryItem.confirmationid,
                  isBold: true,
                )
              ],
            ),
          ],
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final boxWidth = constraints.constrainWidth();
            const dashWidth = 10.0;
            const dashHeight = 1.0;
            final dashCount = (boxWidth / (2 * dashWidth)).floor();
            return Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 47),
              child: Flex(
                children: List.generate(dashCount, (_) {
                  return SizedBox(
                    width: dashWidth,
                    height: dashHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: const Color(0xff6B7280).withOpacity(0.2)),
                    ),
                  );
                }),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.horizontal,
              ),
            );
          },
        )
      ],
    );
  }

  Widget ticket() {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16)
      ),
      width: MediaQuery.of(context).size.width,
      height: 614,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ticketHeader(),
          SizedBox(height: 20,),
          ticketBody()
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Purchase Details",),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CustomText(
                    text: 'Ticket ID:${widget.eventHistoryItem.orderid.substring(1, 12)}'
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.content_copy_rounded,
                        size: 16,
                      ),
                      CustomText(
                        text: "Copy",
                        isMediumWeight: true,
                        fontSize: 12,
                        color: kGrey,
                      )
                    ],
                  )
                ],
              ),
              ticket()
            ],
          ),
        ),
      )
    );
  }
}
