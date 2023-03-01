import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel{
  final String deliveryLocation;
  final String orderID;
  final List orderDetails;
  final String user;
  final String school;
  final String status;
  final String shopID;
  final dynamic total;
  final Timestamp timestamp;

  HistoryModel({
    required this.deliveryLocation,
    required this.orderID,
    required this.orderDetails,
    required this.user,
    required this.school,
    required this.status,
    required this.shopID,
    required this.total,
    required this.timestamp
  });

  factory HistoryModel.fromDocument(DocumentSnapshot doc, user, school) {
    return HistoryModel(
        user: user,
        school: school,
        shopID: doc.get('shopid'),
        deliveryLocation: doc.get('deliverylocation'),
        orderDetails: doc.get('orderdetails'),
        orderID: doc.get('orderid'),
        status: doc.get('status'),
        timestamp: doc.get('timestamp'),
        total: doc.get('total'));
  }
}