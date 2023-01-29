/**
 * This class models the response data gotten from the confirmation endpoint
 * */
class ConfirmationModel {
  String status;
  String token;
  String timestamp;
  num amount;
  num fee;
  String mode;
  String order_id;
  String payer_name;
  String payer_email;
  String customer_id;
  String currency;

  ConfirmationModel(
      {required this.status,
      required this.token,
      required this.timestamp,
      required this.amount,
      required this.fee,
      required this.mode,
      required this.order_id,
      required this.payer_name,
      required this.payer_email,
      required this.customer_id,
      required this.currency});

  factory ConfirmationModel.toMap(Map<String, dynamic> json) {
    return ConfirmationModel(
        status: json["status"],
        token: json["token"],
        timestamp: json["timestamp"],
        amount: json["amount"],
        fee: json["fee"],
        mode: json["mode"],
        order_id: json["order_id"],
        payer_name: json["beneficiary_name"],
        payer_email: json["beneficiary_email"],
        customer_id: json["customer_id"],
        currency: json["currency"]);
  }
}
