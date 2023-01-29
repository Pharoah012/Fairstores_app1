import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventHistory extends StatefulWidget {
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

  const EventHistory(
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

  @override
  _EventHistoryState createState() => _EventHistoryState();
}

class _EventHistoryState extends State<EventHistory> {
  ticketheader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 10, right: 10),
          child: SizedBox(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: widget.eventimage,
              height: 131,
              width: MediaQuery.of(context).size.width * 0.9,
              fit: BoxFit.cover,
            ),
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 12),
          child: Text(
            widget.orderdetails,
            style:
                GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 6),
          child: Text(
            'Use your ticket ID to claim the pysical ticket',
            style:
                GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w400),
            overflow: TextOverflow.visible,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 18.0, left: 10, right: 10),
          child: Divider(),
        )
      ],
    );
  }

  ticketbody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 21),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: GoogleFonts.manrope(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.deliverylocation,
                    style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: GoogleFonts.manrope(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${widget.timestamp.toDate().day}-${widget.timestamp.toDate().month}-${widget.timestamp.toDate().year}',
                    style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: GoogleFonts.manrope(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${widget.timestamp.toDate().hour}:${widget.timestamp.toDate().minute}',
                    style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity Purchased',
                    style: GoogleFonts.manrope(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.quantity.toString(),
                    style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.245,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: GoogleFonts.manrope(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.status,
                    style: GoogleFonts.manrope(
                        color: const Color(0xff1F8B24),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cost',
                    style: GoogleFonts.manrope(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'GHS ${widget.total.toString()}',
                    style: GoogleFonts.manrope(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.43,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID',
                    style: GoogleFonts.manrope(
                        fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.confirmationid,
                    style: GoogleFonts.manrope(
                        color: const Color(0xff1F8B24),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
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

  ticket() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        width: MediaQuery.of(context).size.width,
        height: 614,
        child: Column(children: [ticketheader(), ticketbody()]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white12,
          elevation: 0,
          title: Text(
            'Purchase Details',
            style: GoogleFonts.manrope(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 12,
                  ),
                ),
                Text(
                  'Back',
                  style: GoogleFonts.manrope(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20),
                    child: Row(
                      children: [
                        Text('Ticket ID:${widget.orderid.substring(1, 12)}'),
                      ],
                    ),
                  ),
                  ticket()
                ],
              ),
            ],
          ),
        ));
  }
}
