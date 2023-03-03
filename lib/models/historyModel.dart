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
  final Timestamp timestamp;
  JointModel? joint;

  HistoryModel({
    required this.deliveryLocation,
    required this.orderID,
    required this.orderDetails,
    required this.user,
    required this.school,
    required this.status,
    required this.shopID,
    required this.total,
    required this.timestamp,
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
        timestamp: doc.get('timestamp'),
        total: doc.get('total')
    );

    // get the joint of the history object
    JointModel.getShop(
      school: history.school,
      shopID: history.shopID,
      userID: history.user
    ).then((value) {
      history.joint = value;
    });

    return history;

  }


  Map<String, dynamic> toJson() {
    return {
      "deliverylocation": this.deliveryLocation,
      "orderid": this.orderID,
      "orderDdtails": this.orderDetails,
      "userid": this.user,
      "school": this.school,
      "status": this.status,
      "shopid": this.shopID,
      "total": this.total,
      "timestamp": this.timestamp,
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

    List<HistoryModel> activeOrders = snapshot.docs
        .map((doc) => HistoryModel.fromDocument(doc))
        .toList();

    return activeOrders;
  }
}