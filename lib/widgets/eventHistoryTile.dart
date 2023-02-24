import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/events/eventhistory.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventHistoryTile extends StatefulWidget {
  final String orderid;
  final String orderdetails;
  final int quantity;
  final dynamic total;
  final Timestamp timestamp;
  final String deliverylocation;
  final String confirmationid;
  final String paymentStatus;
  final String eventimage;
  final String status;
  final String tickettype;
  final String eventid;

  const EventHistoryTile(
      {Key? key,
        required this.eventimage,
        required this.confirmationid,
        required this.eventid,
        required this.orderdetails,
        required this.orderid,
        required this.quantity,
        required this.total,
        required this.deliverylocation,
        required this.paymentStatus,
        required this.status,
        required this.tickettype,
        required this.timestamp})
      : super(key: key);

  factory EventHistoryTile.fromDocument(DocumentSnapshot doc) {
    return EventHistoryTile(
        confirmationid: doc.get('confirmationid'),
        eventimage: doc.get('eventimage'),
        orderdetails: doc.get('orderdetails'),
        eventid: doc.get('eventid'),
        orderid: doc.get('orderid'),
        quantity: doc.get('quantity'),
        total: doc.get('total'),
        deliverylocation: doc.get('deliverylocation'),
        paymentStatus: doc.get('paymentStatus'),
        status: doc.get('status'),
        tickettype: doc.get('tickettype'),
        timestamp: doc.get('timestamp'));
  }

  @override
  State<EventHistoryTile> createState() => _EventHistoryTileState();
}

class _EventHistoryTileState extends State<EventHistoryTile> {
  ticketnumber() {
    if (widget.quantity == 1) {
      return 'Ticket';
    } else {
      return 'Tickets';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => EventHistory(
                  orderdetails: widget.orderdetails,
                  orderid: widget.orderid,
                  tickettype: widget.tickettype,
                  timestamp: widget.timestamp,
                  total: widget.total,
                  status: widget.status,
                  paymentStatus: widget.paymentStatus,
                  confirmationid: widget.confirmationid,
                  deliverylocation: widget.deliverylocation,
                  eventimage: widget.eventimage,
                  eventid: widget.eventid,
                  quantity: widget.quantity,
                ))));
      }),
      title: Text(
        widget.orderdetails,
        style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'GHS ${widget.total}',
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(
          '${widget.quantity} ${ticketnumber()} ',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 10),
        ),
      ]),
      subtitle: Text(
        '${widget.timestamp.toDate().year}-${widget.timestamp.toDate().month}-${widget.timestamp.toDate().day}, ${widget.timestamp.toDate().hour}:${widget.timestamp.toDate().minute}',
        style: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 10),
      ),
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: CachedNetworkImageProvider(widget.eventimage),
      ),
    );
  }
}