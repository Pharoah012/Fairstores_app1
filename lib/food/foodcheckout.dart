import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fairstores/backend/confirmationModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/historyModel.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/backend/oayboxmodel.dart';
import 'package:fairstores/backend/sendnotification.dart';
import 'package:fairstores/backend/tokenmodel.dart';
import 'package:fairstores/food/foodcartmodel.dart';
import 'package:fairstores/food/vieworder.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/backend/payment_api.dart';
import 'package:fairstores/models/schoolModel.dart';
import 'package:fairstores/splashscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class FoodCheckout extends StatefulWidget {
  final String shopid;
  final String userid;
  final double taxes;
  final dynamic total;
  final dynamic servicecharge;
  final dynamic deliveryfee;
  final String deliverytime;
  final String school;

  const FoodCheckout(
      {Key? key,
      required this.shopid,
      required this.school,
      required this.deliverytime,
      required this.deliveryfee,
      required this.servicecharge,
      required this.taxes,
      required this.total,
      required this.userid})
      : super(key: key);

  @override
  State<FoodCheckout> createState() => _FoodCheckoutState();
}

class _FoodCheckoutState extends State<FoodCheckout> {
  String page = 'checkout';
  List<bool> visible = [true, false];
  FocusNode myFocusNode = FocusNode();
  List<String> schoollist = [];
  String? selectedValue;
  int totalprice = 0;
  int val = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<bool> selected = [false, false, false, false];

  late ConfirmationModel confirm;
  late Paybox paybox;
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController instructioncontroller = TextEditingController();
  late UserModel userModel;
  String network = '';
  List<String> orderDetails = [];
  String orderID = const Uuid().v4();
  List<String> tokens = [];

  @override
  void initState() {
    super.initState();
    schoolList();
    getuserinfo();
    getmanagertokens();
  }

  getmanagertokens() async {
    QuerySnapshot snapshot =
        await userRef.where('ismanager', isEqualTo: true).get();
    List<String> tokens = [];
    snapshot.docs.forEach((element) async {
      UserModel model = UserModel.fromDocument(element);

      DocumentSnapshot doc = await tokensRef.doc(model.uid).get();
      TokenModel tokenModel = TokenModel.fromDocument(doc);
      tokens.add(tokenModel.devtoken.toString());
    });
    setState(() {
      this.tokens = tokens;
    });
  }

  getuserinfo() async {
    DocumentSnapshot doc = await userRef.doc(widget.userid).get();
    UserModel userModel = UserModel.fromDocument(doc);
    setState(() {
      this.userModel = userModel;
    });
  }

  receipt() {
    return FutureBuilder<QuerySnapshot>(
        future: foodCartRef
            .doc(widget.userid)
            .collection('Orders')
            .where('userid', isEqualTo: widget.userid)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          List<Widget> foodcartlist = [];
          List<String> orderdetails = [];
          for (var doc in snapshot.data!.docs) {
            List<Widget> foodsidelist = [];
            FoodCartModel foodCartModel =
                FoodCartModel.fromDocument(doc, widget.userid);
            foodsidelist = foodCartModel.sides
                .map((e) => Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 15),
                      child: Text(
                        '+ ${e?.toString()}',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.4)),
                      ),
                    ))
                .toList();
            orderdetails.add(
                '${foodCartModel.quantity}x ${foodCartModel.foodname} + ${foodCartModel.sides}');
            foodcartlist.add(Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 13, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${foodCartModel.quantity}x ${foodCartModel.foodname}',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        'GHS ${foodCartModel.price}',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: foodsidelist,
                  ),
                ],
              ),
            ));
          }

          this.orderDetails = orderdetails;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: foodcartlist,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Row(
                  children: [
                    Text('Delivery',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        )),
                    Expanded(child: const SizedBox()),
                    Text('GHS ${widget.deliveryfee}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 16),
                child: Row(
                  children: [
                    Text('Taxes',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        )),
                    Expanded(child: const SizedBox()),
                    Text('GHC ${widget.taxes}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 16),
                child: Row(
                  children: [
                    Text('Service Fee',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        )),
                    Expanded(child: SizedBox()),
                    Text('GHS ${widget.servicecharge * widget.total}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 16),
                child: Row(
                  children: [
                    Text('Total Price',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        )),
                    Expanded(child: const SizedBox()),
                    Text(
                        'GHS ${widget.total + widget.taxes + (widget.total * widget.servicecharge)}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 22.0),
                child: Divider(
                  color: Colors.white,
                  height: 1.7,
                ),
              ),
            ],
          );
        });
  }

  schoolList() async {
    QuerySnapshot snapshot = await schoolRef.get();
    List<String> schoollist = [];
    for (var doc in snapshot.docs) {
      SchoolModel schoolModel = SchoolModel.fromDocument(doc);
      schoollist.add(schoolModel.schoolname);
    }

    setState(() {
      this.schoollist = schoollist;
    });
  }

  checkout() {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  child: TextFormField(
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return 'Provide Phone Number';
                      }
                    }),
                    controller: phonecontroller,
                    focusNode: myFocusNode,
                    cursorColor: kPrimary,
                    decoration: InputDecoration(
                        focusColor: kPrimary,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: kPrimary,
                            )),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xffE5E5E5),
                          ),
                        ),
                        label: Text('Phone Number',
                            style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: myFocusNode.hasFocus
                                    ? kPrimary
                                    : const Color(0xff374151)))),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Text(
                'Delivery Address',
                style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                widget.school,
                style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff374151)),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 12),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 160,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: const SplashScreen()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 6),
                child: Icon(
                  Icons.timelapse,
                  size: 20,
                ),
              ),
              Text(
                widget.deliverytime,
                style: GoogleFonts.manrope(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 23),
          child: Row(
            children: [
              Text(
                'Delivery Instructions',
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 16),
          child: Row(
            children: [
              Text(
                'Let us know if you have specific things in mind',
                style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: const Color(0xff374151)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100)),
              child: TextField(
                controller: instructioncontroller,
                cursorColor: kPrimary,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(
                          color: kPrimary,
                        )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xffE7E4E4),
                        ),
                        borderRadius: BorderRadius.circular(100)),
                    label: Text(
                      'Leave a note for the kitchen',
                      style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff374151)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    )),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: const Color(0xffFBFBFC),
            child: Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                    ),
                    child: Text(
                      'Select Payment Method',
                      style: GoogleFonts.manrope(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ListTile(
          onTap: () {
            setState(() {
              selected = [true, false, false, false];
              network = 'Cash';
            });
          },
          leading: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                width: 20,
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            selected[0] == true ? Colors.grey : Colors.white),
                    color: selected[0] == true ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                width: 15,
                height: 15,
              ),
            ],
          ),
          title: Text(
            'Payment on Delivery',
            style:
                GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        ListTile(
          onTap: () {
            setState(() {
              selected = [false, true, false, false];
              network = 'Vodafone';
            });
          },
          leading: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                width: 20,
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            selected[1] == true ? Colors.grey : Colors.white),
                    color: selected[1] == true ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                width: 15,
                height: 15,
              ),
            ],
          ),
          title: Text(
            'Vodafone Mobile Money',
            style:
                GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        ListTile(
          onTap: () {
            setState(() {
              selected = [false, false, true, false];
              network = 'Mtn';
            });
          },
          leading: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                width: 20,
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            selected[2] == true ? Colors.grey : Colors.white),
                    color: selected[2] == true ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                width: 15,
                height: 15,
              ),
            ],
          ),
          title: Text(
            'MTN Mobile Money',
            style:
                GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        ListTile(
          onTap: () {
            setState(() {
              selected = [false, false, false, true];
              network = 'AirtelTigo';
            });
          },
          leading: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                width: 20,
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            selected[3] == true ? Colors.grey : Colors.white),
                    color: selected[3] == true ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(40)),
                width: 15,
                height: 15,
              ),
            ],
          ),
          title: Text(
            'AirtelTigo Money',
            style:
                GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        )
      ],
    );
  }

  //comeback
  payment(String network) async {
    final pay = Pay();
    final Paybox paybox;
    try {
      print(network);
      print(network);
      print(network);
      print(
          '${widget.total + widget.taxes + (widget.total * widget.servicecharge)}');
      paybox = (await pay.payMomo(
          network,
          '${widget.total + widget.taxes + (widget.total * widget.servicecharge)}',
          phonecontroller.text,
          userModel.email.toString(),
          widget.userid,
          userModel.username.toString()))!;

      setState(() {
        this.paybox = paybox;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  paymentdialog(parentcontext) {
    showDialog(
        context: parentcontext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Payment',
              style: GoogleFonts.montserrat(
                  color: kPrimary, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text('Payment is not complete. Do you want to advance?'),
              ),
              SimpleDialogOption(
                child: Text('Proceed'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  QuerySnapshot snapshot = await foodCartRef
                      .doc(widget.userid)
                      .collection('Orders')
                      .get();
                  for (var e in snapshot.docs) {
                    e.reference.delete();
                  }

                  HistoryModel history = HistoryModel(
                    deliveryLocation: widget.school,
                    orderID: orderID,
                    orderDetails: orderDetails,
                    user: widget.userid,
                    school: widget.school,
                    status: 'active',
                    shopID: widget.shopid,
                    total: widget.total,
                    timestamp: Timestamp.fromDate(DateTime.now())
                  );

                  await history.addItemToHistory();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewOrder(
                          userid: widget.userid,
                          total: widget.total,
                          orderid: orderID,
                          taxes: widget.taxes,
                          deliveryfee: widget.deliveryfee,
                          servicecharge: widget.servicecharge,
                        ),
                      ));
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 10,
                          channelKey: 'basic_channel',
                          title: 'Order Accepted',
                          body: 'Your Order is being Processed'));
                },
                child: Text('Close'),
              )
            ],
          );
        });
  }

  upload(parentcontext) {
    print(orderDetails);
    showDialog(
        context: parentcontext,
        builder: (context) {
          return SimpleDialog(
              title: Center(
                  child: Text(
                'Cash Payment',
                style: GoogleFonts.montserrat(
                    color: kPrimary, fontWeight: FontWeight.bold),
              )),
              children: [
                SimpleDialogOption(
                    child: Text(
                        'Your order will be processed. Please note that you cannot terminate this order after 30 mins of being placed. Thank you',
                        style: GoogleFonts.manrope())),
                SimpleDialogOption(
                  onPressed: () async {
                    transactionsRef.doc(orderID).set({
                      'orderid': orderID,
                      'shopid': widget.shopid,
                      'school': widget.school,
                      'orderdetails': orderDetails,
                      'total': widget.total,
                      'paymentStatus': 'Cash',
                      'status': 'active',
                      'deliverylocation': widget.school,
                      'instructions': instructioncontroller.text,
                      'userid': widget.userid,
                      'timestamp': DateTime.now()
                    });

                    Navigator.pop(context);
                    sendNotification(
                        tokens, 'An order has been placed', 'New Order');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewOrder(
                            userid: widget.userid,
                            orderid: orderID,
                            total: widget.total,
                            taxes: widget.taxes,
                            deliveryfee: widget.deliveryfee,
                            servicecharge: widget.servicecharge,
                          ),
                        ));
                    AwesomeNotifications().createNotification(
                        content: NotificationContent(
                            id: 10,
                            channelKey: 'basic_channel',
                            title: 'Order Accepted',
                            body: 'Your Order is being Processed'));
                  },
                  child: Center(
                      child: Text('Place Order',
                          style: GoogleFonts.manrope(
                              color: kPrimary, fontWeight: FontWeight.w500))),
                )
              ]);
        });
  }

  purchasebutton() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, bottom: 30, top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            color: kPrimary, borderRadius: BorderRadius.circular(100)),
        child: TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (network == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Select a Network')));
                } else if (network == 'Cash') {
                  upload(context);
                } else if (network == 'Mtn') {
                  payment('Mtn');
                  setState(() {
                    page = 'payment';
                  });
                } else if (network == 'Vodafone') {
                  payment('Vodafone');
                  setState(() {
                    page = 'payment';
                  });
                } else if (network == 'AirtelTigo') {
                  payment('AirtelTigo');
                  setState(() {
                    page = 'payment';
                  });
                }
              } else {
                Fluttertoast.showToast(msg: 'Check Details');
              }
              //     //  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const PurchsaeSuccessful(),));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                children: [
                  Text(
                    'Place Order',
                    style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Expanded(child: const SizedBox()),
                  Text(
                    'GHS ${widget.total + widget.taxes + (widget.total * widget.servicecharge)}',
                    style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  confirmationbutton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 5, top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            color: kPrimary, borderRadius: BorderRadius.circular(100)),
        child: TextButton(
            onPressed: () async {
              final con = confirmation();
              confirm = await con.confirmTrans(paybox);

              if (confirm.status == 'Failed') {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment Failed, Try again')));
              } else if (confirm.status == 'Pending') {
                //   paymentdialog(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Pop Up not initialized. Please Wait or Try again')));
              } else if (confirm.status == 'Success') {
                transactionsRef.doc(orderID).set({
                  'orderid': orderID,
                  'shopid': widget.shopid,
                  'school': widget.school,
                  'orderdetails': orderDetails,
                  'total': widget.total,
                  'paymentStatus': confirm.status,
                  'status': 'active',
                  'deliverylocation': widget.school,
                  'instructions': instructioncontroller.text,
                  'userid': widget.userid,
                  'timestamp': DateTime.now()
                });
                sendNotification(
                    tokens, 'An order has been placed', 'New Order');

                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewOrder(
                        userid: widget.userid,
                        orderid: orderID,
                        total: widget.total,
                        taxes: widget.taxes,
                        deliveryfee: widget.deliveryfee,
                        servicecharge: widget.servicecharge,
                      ),
                    ));
                AwesomeNotifications().createNotification(
                    content: NotificationContent(
                        id: 10,
                        channelKey: 'basic_channel',
                        title: 'Order Accepted',
                        body: 'Your Order is being Processed'));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Payment not initialized. Please wait')));
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Text(
                'Confirm Payment',
                style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            )),
      ),
    );
  }

  loadingpayment() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: const Text('s'),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Payment Verification',
            style: GoogleFonts.manrope(
                fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(child: const SizedBox()),
            CircularProgressIndicator(
              color: kPrimary,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text(
                'Kindly wait for the pop-up to make payment. If pop up does not show, please try again',
                style: GoogleFonts.manrope(),
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              onPressed: () {
                payment(network);
              },
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text('Try Again',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: kPrimary
                    )
                  )
              ),
            ),
            Text(
              'Click the button below once Payment has been made',
              style: GoogleFonts.manrope(),
            ),
            Expanded(child: const SizedBox()),
            confirmationbutton(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go Back',
                      style: GoogleFonts.manrope(fontSize: 16, color: kPrimary))),
            )
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return page == 'checkout'
        ? Scaffold(
            appBar: CustomAppBar(title: "Checkout"),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                    child: Column(
                  children: [
                    checkout(),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        color: const Color(0xffFBFBFC),
                        child: Center(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                ),
                                child: Text(
                                  'Receipts',
                                  style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    receipt(),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, top: 30, right: 16),
                      child: Text(
                        'Clicking Place Order will take you to a portal where payment can be copleted',
                        style: GoogleFonts.manrope(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                    purchasebutton()
                  ],
                )),
              ],
            ),
          )
        : loadingpayment();
  }
}
