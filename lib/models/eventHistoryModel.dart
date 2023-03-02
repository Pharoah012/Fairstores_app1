import 'package:cloud_firestore/cloud_firestore.dart';

class EventHistoryModel{
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

  const EventHistoryModel({
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
    required this.timestamp
  });

  factory EventHistoryModel.fromDocument(DocumentSnapshot doc) {
    return EventHistoryModel(
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


}