import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/backend/confirmationModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/historyModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/models/menuItemOptionItemModel.dart';
import 'package:fairstores/models/userModel.dart';
import 'package:fairstores/backend/oayboxmodel.dart';
import 'package:fairstores/backend/sendnotification.dart';
import 'package:fairstores/backend/tokenmodel.dart';
import 'package:fairstores/food/foodcartmodel.dart';
import 'package:fairstores/food/vieworder.dart';
import 'package:fairstores/providers/cartInfoProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/backend/payment_api.dart';
import 'package:fairstores/models/schoolModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class FoodCheckout extends ConsumerStatefulWidget {
  final double taxes;
  final dynamic total;
  final dynamic serviceCharge;
  final JointModel joint;

  const FoodCheckout({
    Key? key,
    required this.serviceCharge,
    required this.taxes,
    required this.total,
    required this.joint
  })
      : super(key: key);

  @override
  ConsumerState<FoodCheckout> createState() => _FoodCheckoutState();
}

class _FoodCheckoutState extends ConsumerState<FoodCheckout> {
  String page = 'checkout';
  List<bool> visible = [true, false];
  FocusNode myFocusNode = FocusNode();
  List<String> schoollist = [];
  String? selectedValue;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<bool> selected = [false, false, false, false];

  late ConfirmationModel confirm;
  late Paybox paybox;
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController instructioncontroller = TextEditingController();
  String network = '';
  List<String> orderDetails = [];
  String orderID = const Uuid().v4();
  List<String> tokens = [];

  @override
  void initState() {
    super.initState();
    schoolList();
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

  Widget receipt() {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: CustomText(
            text: "Receipts",
            isMediumWeight: true,
            color: kBlack,
          ),
        ),
        Container(
          color: kWhite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ref.read(cartProvider(widget.joint)).when(
                  data: (data){
                    if (data.isEmpty){
                      return Center(
                        child: CustomText(
                          text: "There are no items in the cart"
                        ),
                      );
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ref.read(cartInfoProvider).values.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(
                                    text: ref.read(cartInfoProvider)
                                      .values.elementAt(index).foodName,
                                    fontSize: 16,
                                    color: kBlack,
                                  ),
                                  Builder(
                                    builder: (context){
                                      List<dynamic> sides = ref.read(cartInfoProvider).values.elementAt(index).sides;

                                      // check if the are sides and display them
                                      if (sides.isNotEmpty){
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListView.builder(
                                              itemCount: sides.length,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, sideIndex){
                                                MenuItemOptionItemModel side
                                                = MenuItemOptionItemModel.fromJson(sides[sideIndex]);

                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      CustomText(
                                                        text: "+ ${side.name}",
                                                        fontSize: 12,
                                                      ),
                                                      CustomText(
                                                        text: "+ ${side.price}",
                                                        fontSize: 12,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            ),
                                          ],
                                        );
                                      }

                                      return SizedBox.shrink();
                                    }
                                  )
                                ],
                              ),
                              CustomText(
                                text: "GHS ${ref.read(cartInfoProvider)
                                  .values.elementAt(index).price}",
                                fontSize: 16,
                                color: kBlack,
                              )
                            ],
                          ),
                        );
                      }
                    );
                  },
                  error: (_, err){
                    log(err.toString());
                    return Center(
                      child: CustomText(
                          text: "An error occurred while retrieving your orders"
                      ),
                    );
                  },
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      color: kPrimary,
                    ),
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Delivery Fee",
                      fontSize: 16,
                      color: kBlack,
                    ),
                    CustomText(
                      text: "GHS ${widget.joint.price.toString()}",
                      fontSize: 16,
                      color: kBlack,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Taxes",
                      fontSize: 16,
                      color: kBlack,
                    ),
                    CustomText(
                      text: "GHS ${widget.taxes}",
                      fontSize: 16,
                      color: kBlack,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Service Fee",
                      fontSize: 16,
                      color: kBlack,
                    ),
                    CustomText(
                      text: "GHS ${widget.serviceCharge}",
                      fontSize: 16,
                      color: kBlack,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Total Price",
                      fontSize: 18,
                      color: kBlack,
                      isBold: true
                    ),
                    CustomText(
                      text: "GHS ${widget.total}",
                      fontSize: 18,
                      color: kBlack,
                      isBold: true,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        )
      ],
    );
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

  Widget checkout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Form(
        //   key: formKey,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 20.0, right: 20),
        //     child: SizedBox(
        //       width: MediaQuery.of(context).size.width,
        //       height: 56,
        //       child: TextFormField(
        //         validator: ((value) {
        //           if (value!.isEmpty) {
        //             return 'Provide Phone Number';
        //           }
        //         }),
        //         controller: phonecontroller,
        //         focusNode: myFocusNode,
        //         cursorColor: kPrimary,
        //         decoration: InputDecoration(
        //             focusColor: kPrimary,
        //             focusedBorder: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(10),
        //                 borderSide: BorderSide(
        //                   color: kPrimary,
        //                 )),
        //             enabledBorder: OutlineInputBorder(
        //               borderRadius: BorderRadius.circular(10),
        //               borderSide: const BorderSide(
        //                 color: Color(0xffE5E5E5),
        //               ),
        //             ),
        //             label: Text('Phone Number',
        //                 style: GoogleFonts.manrope(
        //                     fontSize: 14,
        //                     fontWeight: FontWeight.w500,
        //                     color: myFocusNode.hasFocus
        //                         ? kPrimary
        //                         : const Color(0xff374151)))),
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          color: kWhite,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Delivery Address",
                          fontSize: 16,
                          isBold: true,
                          color: kBlack,
                        ),
                        CustomText(
                            text: ref.read(userProvider).school!
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: (){},
                        icon: Icon(
                            Icons.edit_outlined
                        )
                    )
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                          imageUrl: widget.joint.headerImage
                      )
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 20,
                    ),
                    SizedBox(width: 10,),
                    CustomText(
                      text: widget.joint.deliveryTime,
                      isMediumWeight: true,
                      color: kBlack,
                    )
                  ],
                ),
                SizedBox(height: 23,),
                CustomText(
                  text: 'Delivery Instructions',
                  fontSize: 16,
                  color: kBlack,
                  isBold: true,
                ),
                CustomText(
                    text: 'Let us know if you have specific things in mind'
                ),
                SizedBox(height: 16,),
                CustomTextFormField(
                    labelText: 'Leave a note for the kitchen',
                    controller: instructioncontroller
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: CustomText(
            text: "Select Payment Method",
            color: kBlack,
            isMediumWeight: true,
          ),
        ),
        Container(
          color: kWhite,
          child: Column(
            children: [

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
      print(
          '${widget.total + widget.taxes + (widget.total * widget.serviceCharge)}');
      paybox = (await pay.payMomo(
        network,
        '${widget.total + widget.taxes + (widget.total * widget.serviceCharge)}',
        phonecontroller.text,
        ref.read(userProvider).email!,
        ref.read(userProvider).uid,
        ref.read(userProvider).username!,
      ))!;

      setState(() {
        this.paybox = paybox;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  paymentDialog() {
    return showDialog(
        context: context,
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
                      .doc(ref.read(userProvider).uid)
                      .collection('Orders')
                      .get();
                  for (var e in snapshot.docs) {
                    e.reference.delete();
                  }

                  HistoryModel history = HistoryModel(
                    deliveryLocation: ref.read(userProvider).school!,
                    orderID: orderID,
                    orderDetails: orderDetails,
                    user: ref.read(userProvider).uid,
                    school: ref.read(userProvider).school!,
                    status: 'active',
                    shopID: widget.joint.jointID,
                    total: widget.total,
                    timestamp: Timestamp.fromDate(DateTime.now())
                  );

                  await history.addItemToHistory();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewOrder(
                          userid: ref.read(userProvider).uid,
                          total: widget.total,
                          orderid: orderID,
                          taxes: widget.taxes,
                          deliveryfee: widget.joint.price,
                          servicecharge: widget.serviceCharge,
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

  upload() {
    print(orderDetails);
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: Center(
                child: CustomText(
                  text: 'Cash Payment',
                  isBold: true,
                  color: kPrimary,
                )
              ),
              children: [
                SimpleDialogOption(
                    child: Text(
                        'Your order will be processed. Please note that you cannot terminate this order after 30 mins of being placed. Thank you',
                        style: GoogleFonts.manrope())),
                SimpleDialogOption(
                  onPressed: () async {
                    transactionsRef.doc(orderID).set({
                      'orderid': orderID,
                      'shopid': widget.joint.jointID,
                      'school': ref.read(userProvider).school,
                      'orderdetails': orderDetails,
                      'total': widget.total,
                      'paymentStatus': 'Cash',
                      'status': 'active',
                      'deliverylocation': ref.read(userProvider).school,
                      'instructions': instructioncontroller.text,
                      'userid': ref.read(userProvider).uid,
                      'timestamp': DateTime.now()
                    });

                    Navigator.pop(context);
                    sendNotification(
                        tokens, 'An order has been placed', 'New Order');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewOrder(
                            userid: ref.read(userProvider).uid,
                            orderid: orderID,
                            total: widget.total,
                            taxes: widget.taxes,
                            deliveryfee: widget.joint.price,
                            servicecharge: widget.serviceCharge,
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

  confirmationButton() {
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
                  'shopid': widget.joint.jointID,
                  'school': ref.read(userProvider).school,
                  'orderdetails': orderDetails,
                  'total': widget.total,
                  'paymentStatus': confirm.status,
                  'status': 'active',
                  'deliverylocation': ref.read(userProvider).school,
                  'instructions': instructioncontroller.text,
                  'userid': ref.read(userProvider).uid,
                  'timestamp': DateTime.now()
                });

                sendNotification(
                    tokens, 'An order has been placed', 'New Order');

                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewOrder(
                        userid: ref.read(userProvider).uid,
                        orderid: orderID,
                        total: widget.total,
                        taxes: widget.taxes,
                        deliveryfee: widget.joint.price,
                        servicecharge: widget.serviceCharge,
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
              child: CustomText(
                text: 'Confirm Payment',
                fontSize: 15,
                color: kWhite,
              ),
            )
        ),
      ),
    );
  }

  loadingPayment() {
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
                child: CustomText(
                  text: 'Try Again',
                  fontSize: 13,
                  color: kPrimary,
                )
              ),
            ),
            CustomText(
              text: 'Click the button below once Payment has been made',
            ),
            Expanded(child: const SizedBox()),
            confirmationButton(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: CustomText(
                  text: 'Go Back',
                  fontSize: 16,
                  color: kPrimary,
                )
              ),
            )
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartInfo = ref.watch(cartInfoProvider);
    final cart = ref.watch(cartProvider(widget.joint));

    return page == 'checkout'
        ? Scaffold(
          appBar: CustomAppBar(title: "Checkout"),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  checkout(),
                  receipt(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CustomText(
                          text: 'Clicking Place Order will take you to a portal '
                              'where payment can be completed',
                          color: kBlack,
                        ),
                        SizedBox(height: 20,),
                        CustomButton(
                          isOrange: true,
                          onPressed: (){
                            if (formKey.currentState!.validate()) {
                              if (network == '') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Select a Network')));
                              } else if (network == 'Cash') {
                                upload();
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "Place Order",
                                color: kWhite,
                                fontSize: 16,
                                isMediumWeight: true,
                              ),
                              CustomText(
                                text: "GHS ${widget.total}",
                                color: kWhite,
                                fontSize: 16,
                                isMediumWeight: true,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ),
          ),
        )
      : loadingPayment();
  }
}
