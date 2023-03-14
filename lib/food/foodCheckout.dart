import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fairstores/backend/confirmationModel.dart';
import 'package:fairstores/constants.dart';
import 'package:fairstores/models/foodOrdersModel.dart';
import 'package:fairstores/models/historyModel.dart';
import 'package:fairstores/models/jointModel.dart';
import 'package:fairstores/models/menuItemOptionItemModel.dart';
import 'package:fairstores/backend/oayboxmodel.dart';
import 'package:fairstores/backend/sendnotification.dart';
import 'package:fairstores/food/vieworder.dart';
import 'package:fairstores/providers/cartInfoProvider.dart';
import 'package:fairstores/providers/managersTokensProvider.dart';
import 'package:fairstores/providers/userProvider.dart';
import 'package:fairstores/widgets/CustomAppBar.dart';
import 'package:fairstores/widgets/checkoutPaymentOption.dart';
import 'package:fairstores/widgets/customButton.dart';
import 'package:fairstores/widgets/customErrorWidget.dart';
import 'package:fairstores/widgets/customLoader.dart';
import 'package:fairstores/widgets/customText.dart';
import 'package:fairstores/widgets/customTextButton.dart';
import 'package:fairstores/widgets/customTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fairstores/backend/payment_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

final networkProvider = StateProvider.autoDispose<String?>((ref) => null);

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
  FocusNode myFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late ConfirmationModel confirm;
  late Paybox paybox;
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController instructioncontroller = TextEditingController();
  String orderID = const Uuid().v4();

  @override
  void initState() {
    super.initState();
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: ref.read(cartInfoProvider)
                                      .values.elementAt(index).foodName,
                                    fontSize: 16,
                                    color: kBlack,
                                  ),
                                  CustomText(
                                    text: "GHS ${ref.read(cartInfoProvider)
                                      .values.elementAt(index).price}",
                                    fontSize: 16,
                                    color: kBlack,
                                  )
                                ],
                              ),
                              Builder(
                                builder: (context){
                                  List<dynamic> sides = ref.read(cartInfoProvider).values.elementAt(index).sides;

                                  // check if the are sides and display them
                                  if (sides.isNotEmpty){
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          child: ListView.builder(
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
                                                      text: "GHS ${ref.read(cartInfoProvider)
                                                          .values.elementAt(index).price - side.price}",
                                                      fontSize: 12,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  return SizedBox.shrink();
                                }
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

  // schoolList() async {
  //   QuerySnapshot snapshot = await schoolRef.get();
  //   List<String> schoollist = [];
  //   for (var doc in snapshot.docs) {
  //     SchoolModel schoolModel = SchoolModel.fromDocument(doc);
  //     schoollist.add(schoolModel.schoolname);
  //   }
  //
  //   setState(() {
  //     this.schoollist = schoollist;
  //   });
  // }

  Widget checkout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              CheckoutPaymentOption(
                title: "Payment on Delivery",
                networkProvider: networkProvider
              ),
              CheckoutPaymentOption(
                  title: "Vodafone Mobile Money",
                  networkProvider: networkProvider
              ),
              CheckoutPaymentOption(
                  title: "MTN Mobile Money",
                  networkProvider: networkProvider
              ),
              CheckoutPaymentOption(
                  title: "AirtelTigo Money",
                  networkProvider: networkProvider
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: CustomTextFormField(
                    labelText: "Phone Number",
                    controller: phonecontroller,
                  )
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  //comeback
  Future<void> payment() async {
    final pay = Pay();
    final Paybox paybox;
    try {
      // print(network);
      print(
          '${widget.total + widget.taxes + (widget.total * widget.serviceCharge)}');

      // if (ref.read(networkProvider) != null){
      //   paybox = (await pay.payMomo(
      //     ref.read(networkProvider)!,
      //     '${widget.total + widget.taxes + (widget.total * widget.serviceCharge)}',
      //     phonecontroller.text,
      //     ref.read(userProvider).email!,
      //     ref.read(userProvider).uid,
      //     ref.read(userProvider).username!,
      //   ))!;
      //
      //   setState(() {
      //     this.paybox = paybox;
      //   });
      // }

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
          title: CustomText(
            text: 'Payment',
            isBold: true,
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

                try{
                  await FoodOrdersModel.clearCart(
                      userID: ref.read(userProvider).uid,
                      jointID: widget.joint.jointID
                  );

                  HistoryModel? uploadedOrder = await updateFirestoreWithPayment();

                  if (uploadedOrder == null){
                    return showDialog(
                        context: context,
                        builder: (_) => CustomError(
                            errorMessage: "We are unable to place your order. "
                                "Please try again later"
                        )
                    );
                  }

                  // send the user a success notification
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 10,
                          channelKey: 'basic_channel',
                          title: 'Order Accepted',
                          body: 'Your Order is being Processed'
                      )
                  );

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewOrder(
                          joint: widget.joint,
                          history: uploadedOrder,
                        ),
                      )
                  );
                }
                catch(exception){
                  log(exception.toString());
                  showDialog(
                    context: context,
                    builder: (_) => CustomError(
                      errorMessage: "We are unable to place your order. "
                      "Please try again later"
                    )
                  );
                }
              },
              child: CustomText(
                text: "Close"
              ),
            )
          ],
        );
      }
    );
  }

  // Store the user's order in firestore and alert the user that
  // their order has been placed
  Future<void> upload() {

    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Center(
            child: CustomText(
              text: 'Payment on Delivery',
              isBold: true,
              color: kPrimary,
            )
          ),
          children: [
            SimpleDialogOption(
              child: CustomText(
                text: "Your order will be processed. Please note that you "
                  "cannot terminate this order after 30 mins of being placed. "
                  "Thank you."
              )
            ),
            SimpleDialogOption(
              onPressed: () async {

                try{

                  // close this dialog
                  Navigator.of(context).pop();

                  // show the loader
                  showDialog(
                      context: context,
                      builder: (context) => CustomLoader()
                  );

                  HistoryModel? uploadedOrder = await updateFirestoreWithPayment();

                  if (uploadedOrder == null){
                    return showDialog(
                        context: context,
                        builder: (_) => CustomError(
                          errorMessage: "We are unable to place your order. "
                              "Please try again later",
                          oneRemove: true,
                        )
                    );
                  }

                  // get the IDs of the managers
                  // who should receive this order and alert them

                  sendNotification(
                    ref.read(managersTokensListProvider),
                    'An order has been placed',
                    'New Order'
                  );

                  // Alert the user of the successful placement of the order
                  AwesomeNotifications().createNotification(
                    content: NotificationContent(
                        id: 10,
                        channelKey: 'basic_channel',
                        title: 'Order Accepted',
                        body: 'Your Order is being Processed'
                    )
                  );

                  // redirect to show the user the order
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ViewOrder(
                        history: uploadedOrder,
                        joint: widget.joint,
                      ),
                    )
                  );

                }
                catch(exception){
                  log(exception.toString());
                  showDialog(
                  context: context,
                  builder: (context) => CustomError(
                    errorMessage: "An error occurred during checkout. "
                        "Please try again later.",
                    // oneRemove: true,
                  )
                  );
                }



              },
              child: Center(
                child: CustomText(
                  text: 'Place Order',
                  color: kPrimary,
                  isMediumWeight: true,
                )
              ),
            )
          ]
        );
      }
    );
  }

  Widget confirmationButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 5, top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
            color: kPrimary, borderRadius: BorderRadius.circular(100)),
        child: TextButton(
            onPressed: () async {



              try {
                ConfirmationModel con = await PaymentConfirmation.confirmTrans(paybox);

                // check if the the payment failed
                if (con.status == 'Failed') {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment Failed, Try again')
                    )
                  );

                } else if (con.status == 'Pending') {
                  // check if the payment is still pending
                  //   paymentdialog(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                            'Pop Up not initialized. Please Wait or Try again'
                          )
                      )
                  );

                } else if (con.status == 'Success') {
                  // check if the payment was successful and update the
                  // firestore with the receipt

                  HistoryModel? uploadedOrder = await updateFirestoreWithPayment();

                  if (uploadedOrder == null){
                    return showDialog(
                        context: context,
                        builder: (_) => CustomError(
                            errorMessage: "We are unable to place your order. "
                                "Please try again later"
                        )
                    );
                  }

                  // send the order to all the respective managers
                  sendNotification(
                    ref.read(managersTokensListProvider),
                    'An order has been placed',
                    'New Order'
                  );

                  // alert the user of a successful order
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 10,
                          channelKey: 'basic_channel',
                          title: 'Order Accepted',
                          body: 'Your Order is being Processed'
                      )
                  );

                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewOrder(
                          history: uploadedOrder,
                          joint: widget.joint,
                        ),
                      )
                  );

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Payment not initialized. Please wait')));
                }

              }
              catch(exception){
                log(exception.toString());
                showDialog(
                    context: context,
                    builder: (_) => CustomError(
                        errorMessage: "An error occurred while making "
                          "payment for your order."
                    )
                );

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

  Widget loadingPayment() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: const Text('s'),
          elevation: 0,
          backgroundColor: Colors.white,
          title: CustomText(
            text: 'Payment Verification',
            isBold: true,
            color: kBlack,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: const SizedBox()),
              CircularProgressIndicator(
                color: kPrimary,
              ),
              SizedBox(height: 14,),
              CustomText(
                text: 'Kindly wait for the pop-up to make payment. '
                  'If pop up does not show, please try again',
                isCenter: true,
              ),
              CustomTextButton(
                onPressed: ()=>payment(),
                title: 'Try Again',
                fontSize: 13,
              ),
              SizedBox(height: 10,),
              CustomText(
                text: 'Click the button below once Payment has been made',
              ),
              Spacer(),
              confirmationButton(),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: CustomTextButton(
                  onPressed: () => Navigator.pop(context),
                  title: 'Go Back',
                  fontSize: 16,
                )
              )
            ]
          ),
        ),
      ),
    );
  }

  Future<HistoryModel?> updateFirestoreWithPayment() async {
    try{

      // get the user's orders
      List<FoodOrdersModel> orders = ref.read(cartInfoProvider).values.toList();

      // iterate through the map and convert the objects to Maps or JSON
      List<Map<String, dynamic>> orderInfo = orders.map((object) => object.toJson()).toList();


      HistoryModel history = HistoryModel(
        deliveryLocation: ref.read(userProvider).school!,
        orderID: orderID,
        orderDetails: orderInfo,
        user: ref.read(userProvider).uid,
        school: ref.read(userProvider).school!,
        status: 'active',
        shopID: widget.joint.jointID,
        total: widget.total,
        orderTime: Timestamp.fromDate(DateTime.now()),
        instructions: instructioncontroller.text,
        paymentType: ref.read(networkProvider)!,
        tax: widget.taxes,
        serviceCharge: widget.serviceCharge,
        deliverFee: widget.joint.price.toDouble(),
        phoneNumber: phonecontroller.text,
        feedbackTime: null
      );

      // Add the order to History
      await history.addItemToHistory();

      return history;

    }
    catch(exception){
      log(exception.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartInfo = ref.watch(cartInfoProvider);
    final cart = ref.watch(cartProvider(widget.joint));
    final network = ref.watch(networkProvider);
    final managersTokens = ref.watch(managersTokensProvider);
    final managersTokensList = ref.watch(managersTokensListProvider);

    return Scaffold(
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

                        if (!formKey.currentState!.validate()){
                          return;
                        }

                        // check if the user hasn't selected a payment option
                        if (network == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Select a Network')
                              )
                          );
                        }
                        else if (network == "Payment on Delivery") {
                          //proceed to place the order
                          upload();
                        }
                        else{
                          // proceed to payment
                          payment();
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
    );
  }
}
