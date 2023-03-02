import 'package:cloud_firestore/cloud_firestore.dart';


final eventTicketsPurchaseRef = FirebaseFirestore.instance.collection('EventsTicketPurchases');
final eventHistoryRef = FirebaseFirestore.instance.collection('Eventshistory');

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
  final String userID;

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
    required this.timestamp,
    required this.userID
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
      timestamp: doc.get('timestamp'),
      userID: doc.get("userid")
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "orderid": this.orderid,
      "orderdetails": this.orderdetails,
      "quantity": this.quantity,
      "total": this.total,
      "timestamp": this.timestamp,
      "deliverylocation": this.deliverylocation,
      "confirmationid": this.confirmationid,
      "paymentStatus": this.paymentStatus,
      "eventimage": this.eventimage,
      "status": this.status,
      "tickettype": this.tickettype,
      "eventid": this.eventid,
    };
  }

  Future<void> addItemToEventHistory() async {
    await eventTicketsPurchaseRef.doc(this.orderid).set(toJson());
  }

  static Future<List<EventHistoryModel>> getPendingEventTickets({
    required String userID
  }) async {
    QuerySnapshot snapshot = await eventTicketsPurchaseRef
      .where('userid', isEqualTo: userID,)
      .get();

    List<EventHistoryModel> eventTicketPurchases = snapshot.docs
        .map((doc) => EventHistoryModel.fromDocument(doc))
        .toList();

    return eventTicketPurchases;
  }

  static Future<List<EventHistoryModel>> getPurchasedEventTickets({
    required String userID
  }) async {
    QuerySnapshot snapshot = await eventHistoryRef
        .doc(userID)
        .collection('history')
        .get();

    List<EventHistoryModel> eventTicketPurchases = snapshot.docs
        .map((doc) => EventHistoryModel.fromDocument(doc))
        .toList();

    return eventTicketPurchases;
  }


}