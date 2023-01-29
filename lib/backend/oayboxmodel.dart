import 'package:cloud_firestore/cloud_firestore.dart';

class Paybox {
  String status;
  String message;
  String token;
  String time;
  String currency;
  num amount;
  num fee;
  String mode;
  String payment_processor;
  String transaction;
  String orderId;
  String payer_name;
  String payer_email;
  String payer_phone;
  String customer_id;

  Paybox(
      {required this.amount,
      required this.message,
      required this.token,
      required this.time,
      required this.currency,
      required this.orderId,
      required this.customer_id,
      required this.fee,
      required this.mode,
      required this.payer_email,
      required this.payer_name,
      required this.payer_phone,
      required this.payment_processor,
      required this.status,
      required this.transaction});

  factory Paybox.toMap(map) {
    // print(map["token"]);
    return Paybox(
        amount: map["amount"],
        message: map["message"],
        token: map["token"],
        time: map["timestamp"],
        currency: map["currency"],
        orderId: map["order_id"],
        customer_id: map["customer_id"],
        fee: map["fee"],
        mode: map["mode"],
        payer_email: map["payer_email"],
        payer_name: map["payer_name"],
        payer_phone: map["payer_phone"],
        payment_processor: map["payment_processor"],
        status: map["status"],
        transaction: map["transaction"]);
  }

  factory Paybox.withError(String error) {
    return Paybox(
        amount: 0,
        message: "",
        token: "",
        time: "",
        currency: "",
        orderId: "",
        customer_id: "",
        fee: 0,
        mode: "",
        payer_email: "",
        payer_name: "",
        payer_phone: "",
        payment_processor: "",
        status: "",
        transaction: "");
  }
}

// {
// "status": "Pending",
// "message": "Transaction initiated successfully.",
// "token": "Hu6frHGQnG",
// "timestamp": "2022-08-11T17:46:54.000000Z",
// "currency": "GHS",
// "amount": 1,n
// "fee": 0.019,
// "mode": "Mobile Money",
// "payment_processor": "MTN",
// "transaction": "Credit",
// "payload": "{'key':'data'}",
// "order_id": "123456",
// "environment": "Development",
// "callback_url": null,
// "redirect_url": null,
// "payer_name": "John Doe",
// "payer_email": "j.doe@paybox.com.co",
// "payer_phone": "+233",
// "customer_id": "c-12345"
// }
// {
// "status": "Success",
// "token": "Hu6frHGQnG",
// "timestamp": "2022-08-11T17:46:54.000000Z",
// "currency": "GHS",
// "amount": 1,
// "fee": 0.019,
// "mode": "MTN",
// "payload": null,
// "order_id": "123456",
// "payer_name": "John Doe",
// "payer_email": "j.doe@paybox.com.co",
// "payer_phone": "+233",
// "customer_id": "c-12345"
// }
