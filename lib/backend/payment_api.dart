import 'dart:io';
import 'dart:convert';
import 'package:fairstores/backend/oayboxmodel.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';

import 'confirmationModel.dart';

/**
 * This class handles all things payment
 * To reduce the amount of external interaction this class has to engage in,
 * I made every detail needed by the api a paramenter that once pass it should work if no error is found
 *
 * To understand the format of the data being passed refer to the paybox documentation from the link below
 * https://documenter.getpostman.com/view/1500986/TWDcEZfV
 *
 * P.S you would have to create a  fairstore account with paybox and change the api key when about to deploy
 *
 * */

class OrderPayment {
  /**
   * This function enables the payment with card
   * */

  Future<dynamic> payCard({
    required String amount,
    required String fname,
    required String lname,
    required String cardNo,
    required String cardExp,
    required String cardCvc,
    required String cardCountry,
    required String cardAddress,
    required String cardState,
    required String cardZip,
    required String cardCity,
    required String cardEmail,
    required String uid,
    required String orderID
  }) async {
    try {

      String voucher = randomNumeric(6);
      var request =
          http.MultipartRequest('POST', Uri.parse('https://paybox.com.co/pay'));
      request.headers.addAll({
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer 0b0ac53e-ee3d-45cf-861b-0c103ad1c12c'
      });
      request.fields.addAll({
        'order_id': orderID,
        'currency': 'GHS',
        'amount': amount,
        'mode': 'Card',
        'card_first_name': fname,
        'card_last_name': lname,
        'card_number': cardNo,
        'card_expiry': cardExp,
        'card_cvc': cardCvc,
        'card_country': cardCountry,
        'card_address': cardAddress,
        'card_city': cardCity,
        'card_state': cardState,
        'card_zip': cardZip,
        'card_email': cardEmail,
        'voucher_code': voucher,
        'payload': '{"key":"data"}',
        'payerEmail': cardEmail,
        'customer_id': uid,
        'callback_url': ''
      });

      final response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.headers.toString());
        print(response.statusCode);
        print(await response.stream.bytesToString());
        print(await response.stream.toBytes());
        return Paybox.toMap(await response.stream.bytesToString());
      } else {
        print(response.statusCode.toString());

        return response.statusCode.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  /**
   * This function enables the payment with momo
   * */
  static Future<Paybox?> payMomo({
    required String network,
    required String amount,
    required String number,
    required String email,
    required String userID,
    required String name,
    required String orderID,
  }) async {

    String voucher = randomNumeric(6);

    // FirebaseAuth _auth = FirebaseAuth.instance;
    // String uid = _auth.currentUser!.uid;

    var request =
        http.MultipartRequest('POST', Uri.parse('https://paybox.com.co/pay'));
    request.headers.addAll({
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer 0b0ac53e-ee3d-45cf-861b-0c103ad1c12c'
    });

    request.fields.addAll({
      'order_id': orderID,
      'currency': 'GHS',
      'amount': amount,
      'mode': 'Mobile Money',
      'mobile_network': network,
      'voucher_code': voucher,
      'mobile_number': number,
      'payload': '{"key":"data"}',
      'payerName':
          name, //Pls I don know how you did the new database add the user name in this field
      'payerPhone':
          '+233', //Depend on the country the code can be changed. Since we are onlyinghan for now im making 233 default
      'payerEmail': email,
      'customer_id': userID,
      'callback_url': ''
    });

    http.StreamedResponse response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      //  print(response.headers.toString());

      return Paybox.toMap(jsonDecode(await response.stream.bytesToString()));
    } else {
      return Paybox.withError("error");
    }
  }

  /**
   * This function create the order Id*/
  String orderId() {
    return randomAlphaNumeric(10);
  }


  /**
   * This method confirms the trasaction but need the paybox model to get
   *  the trasaction token in other to make the get request
   *
   * */
  static Future<dynamic> confirmTrans(Paybox paybox) async {
    // var request = http.MultipartRequest(
    //     'GET', Uri.parse('https://paybox.com.co/transaction/${paybox.token}'));
    var request = await http.get(
      Uri.parse('https://paybox.com.co/transaction/${paybox.token}'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader:
        'Bearer 0b0ac53e-ee3d-45cf-861b-0c103ad1c12c',
      },
    );
    final response = jsonDecode(request.body);
    print('status code: ${response}');

    return ConfirmationModel.toMap(jsonDecode(request.body));
  }
}