import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/backend/confirmationModel.dart';
import 'package:fairstores/models/eventHistoryModel.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/backend/oayboxmodel.dart';
import 'package:fairstores/backend/payment_api.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/events/ticketsuccessful.dart';
import 'package:fairstores/models/schoolModel.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/splashscreen.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:uuid/uuid.dart';

class TicketPurchase extends ConsumerStatefulWidget {
  final bool eticketavailable;
  final bool physicalticketavailable;
  final int price;
  final String eventid;
  final String eventpic;
  final String eventname;

  const TicketPurchase(
      {Key? key,
      required this.eventpic,
      required this.price,
      required this.eventname,
      required this.eventid,
      required this.eticketavailable,
      required this.physicalticketavailable})
      : super(key: key);

  @override
  ConsumerState<TicketPurchase> createState() => _TicketPurchaseState();
}

class _TicketPurchaseState extends ConsumerState<TicketPurchase> {
  String page = 'fairticket';
  String pay = '';
  List<bool> visible = [true, false];
  FocusNode myFocusNode = FocusNode();
  List<String> schoollist = [];
  String? selectedValue;

  String orderid = const Uuid().v4();

  int quantity = 1;
  int val = 0;

  late UserModel userModel;

  String network = '';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late ConfirmationModel confirm;
  late Paybox paybox;
  List<bool> selected = [false, false, false, false];

  TextEditingController cartcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    schoolList();
    getuserinfo();
  }

  getuserinfo() async {
    DocumentSnapshot doc = await userRef.doc(ref.read(userProvider).uid).get();
    UserModel userModel = UserModel.fromDocument(doc);
    setState(() {
      this.userModel = userModel;
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

  ticketpage(tickettype) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14, left: 20.0),
          child: Row(
            children: [
              Text(
                'Kindly input your details below',
                style: GoogleFonts.manrope(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 30),
          child: Row(
            children: [
              Text(
                'Tickets wil be delivered to you after purchase.',
                style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: const Color(0xff374151),
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 10),
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
                          hintText: '0202222224',
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    child: NumberInputWithIncrementDecrement(
                      initialValue: 1,
                      onIncrement: (val) {
                        setState(() {
                          quantity = val.toInt();
                        });
                        print(quantity);
                      },
                      onDecrement: (val) {
                        setState(() {
                          quantity = val.toInt();
                        });
                        print(quantity);
                      },
                      controller: cartcontroller,
                      numberFieldDecoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffE5E5E5))),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xffE5E5E5)))),
                      widgetContainerDecoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffE5E5E5))),
                      isInt: true,
                      min: 1,
                    ),
                  ),
                ),
              ],
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 10),
              child: Text(
                'Ticket Price: GHC ${widget.price * quantity}',
                style: GoogleFonts.manrope(
                    fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
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
                ref.read(userProvider).school!,
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
                '',
                style: GoogleFonts.manrope(
                    fontSize: 14, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 40),
              child: Text(
                'Select Payment Method',
                style: GoogleFonts.manrope(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        ListTile(
          onTap: () {
            setState(() {
              selected = [true, false, false, false];
              network = 'Cash';
            });
            print(network);
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
            'Cash Payment',
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
            print(network);
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
            print(network);
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
            print(network);
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

  ticketoption() {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xffF7F7F9),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          visible = [true, false];
                          page = 'fairticket';
                        });
                        print('object');
                      },
                      child: Stack(alignment: Alignment.center, children: [
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: visible[0],
                          child: Container(
                              height: 38,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              )),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'FairTicket',
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  color: page == 'fairticket'
                                      ? kPrimary
                                      : Colors.black),
                            ),
                            widget.eticketavailable == true
                                ? const SizedBox(
                                    width: 0,
                                    height: 0,
                                  )
                                : Text(
                                    'Not Available',
                                    style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: page == 'fairticket'
                                            ? kPrimary
                                            : Colors.black),
                                  ),
                          ],
                        ),
                      ]))),
              Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0),
                  child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7F9),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(children: [
                        Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  visible = [false, true];
                                  page = 'physicalticket';
                                });
                                print(page);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Visibility(
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: visible[1],
                                    child: Container(
                                        height: 38,
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        )),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Physical Ticket',
                                          style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12,
                                              color: page == 'physicalticket'
                                                  ? kPrimary
                                                  : Colors.black),
                                        ),
                                        widget.physicalticketavailable == true
                                            ? const SizedBox(
                                                width: 0,
                                                height: 0,
                                              )
                                            : Text(
                                                'Not Available',
                                                style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12,
                                                    color:
                                                        page == 'physicalticket'
                                                            ? kPrimary
                                                            : Colors.black),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ])))
            ])));
  }

  //comeback
  payment(String network) async {
    final pay = Pay();
    final Paybox paybox;
    try {
      paybox = (await pay.payMomo(
          network,
          '${widget.price * quantity}',
          phonecontroller.text,
          userModel.email.toString(),
          ref.read(userProvider).uid,
          userModel.username.toString()))!;

      setState(() {
        this.paybox = paybox;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error loading payment, Please try again');
    }
  }

  upload(parentcontext) {
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
                    if (page == 'fairticket') {
                      for (int i = 0; i < quantity; i++) {
                        EventHistoryModel event = EventHistoryModel(
                          eventimage: widget.eventpic,
                          confirmationid: "",
                          eventid: widget.eventid,
                          orderdetails: widget.eventname,
                          orderid: orderid,
                          quantity: 1,
                          total: widget.price,
                          deliverylocation: ref.read(userProvider).school!,
                          paymentStatus: 'Cash',
                          status: 'Pending',
                          tickettype: page,
                          timestamp: Timestamp.fromDate(DateTime.now()),
                          userID: ref.read(userProvider).uid,
                        );

                        await event.addItemToEventHistory();

                        setState(() {
                          orderid = const Uuid().v4();
                        });
                      }
                    } else {
                      eventTicketsPurchaseRef.doc(orderid).set({
                        'orderid': orderid,
                        'eventid': widget.eventid,
                        'tickettype': page,
                        'orderdetails': widget.eventname,
                        'eventimage': widget.eventpic,
                        'total': widget.price,
                        'confirmationid': '',
                        'paymentStatus': 'Cash',
                        'status': 'Pending',
                        'deliverylocation': ref.read(userProvider).school!,
                        'userid': ref.read(userProvider).uid,
                        'quantity': quantity,
                        'timestamp': DateTime.now()
                      });
                      setState(() {
                        orderid = const Uuid().v4();
                      });
                    }

                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PurchsaeSuccessful(
                            message: 'Thank you! Your order has been acceopted',
                          ),
                        ));
                    AwesomeNotifications().createNotification(
                        content: NotificationContent(
                            id: 10,
                            channelKey: 'basic_channel',
                            title: 'FairEvents',
                            body: 'Thank You for Purchasing from us'));
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
            onPressed: () {
              if (formKey.currentState!.validate()) {
                if (network == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Select a Network')));
                } else if (network == 'Cash') {
                  upload(context);
                } else if (network == 'Mtn') {
                  payment('Mtn');
                  setState(() {
                    pay = 'payment';
                  });
                } else if (network == 'Vodafone') {
                  payment('Vodafone');
                  setState(() {
                    pay = 'payment';
                  });
                } else if (network == 'AirtelTigo') {
                  payment('AirtelTigo');
                  setState(() {
                    pay = 'payment';
                  });
                }
              } else {
                Fluttertoast.showToast(msg: 'Check Details');
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                children: [
                  Text(
                    'Purchase Ticket',
                    style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Expanded(child: const SizedBox()),
                  Text(
                    'GHS ${widget.price * quantity}',
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
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, bottom: 30, top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            color: kPrimary, borderRadius: BorderRadius.circular(100)),
        child: TextButton(
            onPressed: () async {
              final con = confirmation();
              confirm = await con.confirmTrans(paybox);
              print(confirm);
              if (confirm.status == 'Failed') {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment Failed, Try again')));
              } else if (confirm.status == 'Pending') {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment Failed, Try again')));
              } else if (confirm.status == 'Success') {
                print(ref.read(userProvider).uid);
                if (page == 'fairticket') {
                  for (int i = 0; i < quantity; i++) {
                    eventTicketsPurchaseRef.doc(orderid).set({
                      'orderid': orderid,
                      'eventid': widget.eventid,
                      'tickettype': page,
                      'eventimage': widget.eventpic,
                      'orderdetails': widget.eventname,
                      'total': widget.price,
                      'paymentStatus': confirm.status,
                      'status': 'Pending',
                      'quantity': 1,
                      'confirmationid': '',
                      'deliverylocation': ref.read(userProvider).school!,
                      'userid': ref.read(userProvider).uid,
                      'timestamp': DateTime.now()
                    });
                    setState(() {
                      orderid = const Uuid().v4();
                    });
                  }
                } else {
                  eventTicketsPurchaseRef.doc(orderid).set({
                    'orderid': orderid,
                    'eventid': widget.eventid,
                    'tickettype': page,
                    'orderdetails': widget.eventname,
                    'eventimage': widget.eventpic,
                    'total': widget.price,
                    'confirmationid': '',
                    'paymentStatus': confirm.status,
                    'status': 'Pending',
                    'deliverylocation': ref.read(userProvider).school!,
                    'userid': ref.read(userProvider).uid,
                    'quantity': quantity,
                    'timestamp': DateTime.now()
                  });
                  setState(() {
                    orderid = const Uuid().v4();
                  });
                }

                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PurchsaeSuccessful(
                        message: 'Thank you! Your order has been acceopted',
                      ),
                    ));
                AwesomeNotifications().createNotification(
                    content: NotificationContent(
                        id: 10,
                        channelKey: 'basic_channel',
                        title: 'FairEvents',
                        body: 'Thank You for Purchasing from us'));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment Failed, Try again')));
              }

              print('confirm.status: ${confirm.status}');
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

  receipt() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25.0, bottom: 20),
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
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10, bottom: 20),
            child: Row(
              children: [
                Text(
                  '$quantity x ${widget.eventname}',
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Expanded(child: SizedBox()),
                Text(
                  'GHS ${widget.price * quantity}',
                  style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
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
            Expanded(child: SizedBox()),
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
            Expanded(child: SizedBox()),
            confirmationbutton(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go back)',
                    style: GoogleFonts.manrope(
                      fontSize: 16, color: kPrimary
                    )
                  )
              ),
            )
          ]),
        ),
      ),
    );
  }

  setpage() {
    if (page == 'fairticket' && widget.eticketavailable == true) {
      return Column(
        children: [ticketpage(page), receipt(), purchasebutton()],
      );
    } else if (page == 'physicalticket' &&
        widget.physicalticketavailable == true) {
      return Column(
        children: [ticketpage(page), receipt(), purchasebutton()],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.4,
          ),
          const Text('Choose Available Option')
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return pay == 'payment'
        ? loadingpayment()
        : Scaffold(
            appBar: CustomAppBar(title: "Purchase Ticket",),
            body: SingleChildScrollView(
                child: Column(
              children: [ticketoption(), setpage()],
            )));
  }
}
