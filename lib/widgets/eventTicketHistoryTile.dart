import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/events/eventHistoryDetails.dart';
import 'package:fairstores/models/eventHistoryModel.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventTicketHistoryTile extends StatefulWidget {
  final EventHistoryModel eventHistoryItem;

  const EventTicketHistoryTile({
    Key? key,
    required this.eventHistoryItem
  }) : super(key: key);

  @override
  State<EventTicketHistoryTile> createState() => _EventTicketHistoryTileState();
}

class _EventTicketHistoryTileState extends State<EventTicketHistoryTile> {

  ticketnumber() {
    if (widget.eventHistoryItem.quantity == 1) {
      return 'Ticket';
    } else {
      return 'Tickets';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventHistoryDetails(
              eventHistoryItem: widget.eventHistoryItem
            )
          )
        );
      },
      title: CustomText(
        text: widget.eventHistoryItem.orderdetails,
        isMediumWeight: true,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: 'GHS ${widget.eventHistoryItem.total}',
            isMediumWeight: true,
          ),
          CustomText(
            text: '${widget.eventHistoryItem.quantity} ${ticketnumber()}',
            isMediumWeight: true,
            fontSize: 10,
          )
        ]
      ),
      subtitle: CustomText(
        text: '${widget.eventHistoryItem.timestamp.toDate().year}'
            '-${widget.eventHistoryItem.timestamp.toDate().month}'
            '-${widget.eventHistoryItem.timestamp.toDate().day}, '
            '${widget.eventHistoryItem.timestamp.toDate().hour}'
            ':${widget.eventHistoryItem.timestamp.toDate().minute}',
        fontSize: 10,
        isMediumWeight: true,
      ),
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(
          widget.eventHistoryItem.eventimage
        ),
      ),
    );
  }
}