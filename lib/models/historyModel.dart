import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/models/jointModel.dart';

final historyRef = FirebaseFirestore.instance.collection('History');
final transactionsRef = FirebaseFirestore.instance.collection('ActiveOrders');

class HistoryModel{
  final String deliveryLocation;
  final String orderID;
  final List orderDetails;
  final String user;
  final String school;
  final String status;
  final String shopID;
  final dynamic total;
  final Timestamp orderTime;
  final String paymentType;
  final String instructions;
  JointModel? joint;
  final double tax;
  final double serviceCharge;
  final double deliverFee;
  final String phoneNumber;
  final Timestamp? feedbackTime;

  HistoryModel({
    required this.deliveryLocation,
    required this.orderID,
    required this.orderDetails,
    required this.user,
    required this.school,
    required this.status,
    required this.shopID,
    required this.total,
    required this.orderTime,
    required this.paymentType,
    required this.instructions,
    required this.tax,
    required this.serviceCharge,
    required this.deliverFee,
    required this.phoneNumber,
    required this.feedbackTime,
    this.joint

  });

  factory HistoryModel.fromDocument(DocumentSnapshot doc) {
    HistoryModel history = HistoryModel(
      user: doc.get("userid"),
      school: doc.get("school"),
      shopID: doc.get('shopid'),
      deliveryLocation: doc.get('deliverylocation'),
      orderDetails: doc.get('orderdetails'),
      orderID: doc.get('orderid'),
      status: doc.get('status'),
      orderTime: doc.get('timestamp'),
      total: doc.get('total'),
      instructions: doc.get("instructions"),
      paymentType: doc.get("paymentType"),
      tax: doc.get("tax"),
      deliverFee: doc.get("deliveryFee"),
      serviceCharge: doc.get("serviceCharge"),
      phoneNumber: doc.get("phoneNumber"),
      feedbackTime: doc.get("feedbackTime")
    );

    return history;

  }


  Map<String, dynamic> toJson() {
    return {
      "deliverylocation": this.deliveryLocation,
      "orderid": this.orderID,
      "orderdetails": this.orderDetails,
      "userid": this.user,
      "school": this.school,
      "status": this.status,
      "shopid": this.shopID,
      "total": this.total,
      "timestamp": this.orderTime,
      "paymentType": this.paymentType,
      "instructions": this.instructions,
      "serviceCharge": this.serviceCharge,
      "deliveryFee": this.deliverFee,
      "tax": this.tax,
      "phoneNumber": this.phoneNumber,
      "feedbackTime": this.feedbackTime
    };
  }

  Future<void> addItemToHistory() async {
    await transactionsRef.doc(orderID).set(toJson());
  }

  static Future<List<HistoryModel>> activeOrders({
    required String userID,
    required String school
  }) async {
    QuerySnapshot snapshot = await transactionsRef
        .where('userid', isEqualTo: userID,)
        .get();

    List<HistoryModel> activeOrders = snapshot.docs
        .map((doc) => HistoryModel.fromDocument(doc))
        .toList();

    for (HistoryModel history in activeOrders){
      // get the joint of each history item
      history.joint = await JointModel.getShop(
          school: history.school,
          shopID: history.shopID,
          userID: history.user
      );
    }

    return activeOrders;
  }

  static Future<List<HistoryModel>> history({
    required String userID,
    required String school
  }) async {
    QuerySnapshot snapshot = await historyRef
        .doc(userID)
        .collection('foodhistory')
        .get();

    List<HistoryModel> historyItems = snapshot.docs
        .map((doc) => HistoryModel.fromDocument(doc))
        .toList();

    for (HistoryModel history in historyItems){
      // get the joint of each history item
      history.joint = await JointModel.getShop(
          school: history.school,
          shopID: history.shopID,
          userID: history.user
      );
    }

    return historyItems;
  }
}